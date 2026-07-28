# Atölye Yazılımı — Teknik Analiz ve Geliştirme Planı

> **Hazırlanma tarihi:** 28 Temmuz 2026
> **Kapsam:** `atolye_flutter` (Flutter Desktop admin — "DoTiKa Admin") + `AtolyeProjesi` (ASP.NET Core 8 backend — LeatherCare.Web)
> **Yöntem:** Yalnızca mevcut kod, `swagger_json` sözleşmesi ve proje yapısı incelenmiştir. Hiçbir dosya değiştirilmemiştir. Varsayım yapılan/doğrulanamayan noktalar açıkça **"Ek doğrulama gerekiyor"** olarak işaretlenmiştir.

---

# 1. Proje Genel Mimarisi

## 1.1 Proje Yapısı

```
AtolyeProje/
├── AtolyeProjesi/                  # Backend (ASP.NET Core 8)
│   ├── src/LeatherCare.Web/        # Tek proje: Controllers + Data (EF Core/PostgreSQL) + Services
│   ├── tests/LeatherCare.IntegrationTests/
│   ├── deploy/                     # Nginx, Docker Compose, systemd, yedekleme cron
│   └── doc/spec.md                 # Sistem spesifikasyonu
└── atolye_flutter/                 # Flutter Desktop admin (paket adı: leather_care_admin)
    ├── lib/
    │   ├── app/                    # Router, Shell, Splash, StartupController
    │   ├── core/                   # network, theme, services, di, utils, widgets
    │   └── features/<feature>/
    │       ├── data/               # repository + DTO (freezed/json_serializable)
    │       └── presentation/       # cubit + pages + widgets
    ├── swagger_json                # Backend OpenAPI sözleşmesi (LeatherCare.Web v1.0)
    └── windows/ macos/ web/        # ❗ android/ ve ios/ klasörleri YOK
```

**Domain notu:** Kullanıcı dilinde "Ürün" olarak geçen kavram, kodda **İş Emri (WorkOrder)** olarak modellenmiştir. "Ürün ekleme" = `POST /api/work-orders`. Ayrıca katalogda "sarf ürünleri" (ConsumableProduct) vardır; bu ikisi karıştırılmamalıdır.

## 1.2 Katmanlar

| Katman | Flutter | Backend |
|---|---|---|
| Sunum | `features/*/presentation` (Cubit + Page + Widget) | Razor (yalnızca `/t/{token}` takip sayfası) |
| Uygulama/İş | Cubit'ler (iş mantığının bir kısmı **sayfa State'lerinde**, bkz. §1.9) | Controller'lar (servis katmanı ince: `PricingService`, `SmsOutbox`, `MaintenanceService` vb.) |
| Veri | `I*Repository` arayüzü + Dio implementasyonu, freezed DTO'lar | EF Core `AppDbContext`, snake_case PostgreSQL 16 |
| Çapraz kesit | `core/network` (Dio + interceptor + ProblemDetails parser), `core/di` (get_it), `core/theme` | FluentValidation (auto-validation), Serilog, RateLimiter, ProblemDetails (`AppExceptionHandler`) |

## 1.3 State Management

- **flutter_bloc (Cubit)** — her feature'da sayfa kapsamlı `BlocProvider` (`create: (_) => XCubit(getIt<...>())..load()`).
- Global state yok; oturum durumu `AppStartupController` (ChangeNotifier) üzerinden `GoRouter.refreshListenable`'a bağlı.
- DI: `get_it` lazy singleton'ları (`core/di/injection.dart`) — tüm repository'ler tek `Dio` örneğini paylaşır.
- **Dikkat:** İş emri formu ve fiyat matrisi gibi ekranlarda form durumu Cubit'te değil, `StatefulWidget` içindeki `TextEditingController`/yerel alanlarda tutuluyor. Bu hibrit yaklaşım Sorun 4'ün doğrudan kaynağıdır (bkz. §2 Sorun 4).

## 1.4 API Akışı

1. `DioClient.create()` → `baseUrl = API_BASE_URL` (dart-define; varsayılan `https://dotikadbm.com`), 15 sn timeout'lar, JSON header'ları.
2. `AuthInterceptor.onRequest` → secure storage'dan token okur, `Authorization: Bearer` ekler (her istekte async storage okuması — bkz. §1.10 teknik borç).
3. Repository → `ApiEndpoints` sabitleri üzerinden çağrı; hata `ApiException.fromDioException` ile **RFC 7807 ProblemDetails**'e çözülür (`title`, `detail`, `errorCode`, `errors` → `fieldErrors`).
4. `AuthInterceptor.onError` → 401'de token silinir, `logoutStreamController` yayını → `AppStartupController.handleUnauthorized()` → router login'e yönlendirir.

Backend tarafında: tüm `/api` controller'ları `MapControllers().RequireAuthorization()` ile varsayılan korumalı; public uçlar `[AllowAnonymous]`. Rate limit: login 5/dk/IP, public takip 30/dk/IP. CORS bilinçli olarak yok (masaüstü istemci).

## 1.5 Authentication Akışı

- `POST /api/auth/login` → **30 günlük tek JWT** (refresh token YOK, spec §10.1 gereği bilinçli).
- Token `flutter_secure_storage`'da (`StorageKeys.authToken`).
- Açılış: `AppStartupController.initialize()` yalnızca **token'ın varlığına** bakar; sunucuda geçerliliğini doğrulamaz. Backend'de `GET /api/auth/me` mevcut ama **Flutter hiç kullanmıyor** — süresi dolmuş token'la açılan uygulama ilk API çağrısında 401 ile login'e düşer (kabul edilebilir ama açılışta `me` çağrısı UX'i iyileştirir).
- Tek kullanıcı modeli: rol yönetimi yok, tek ADMIN (seed: `AdminAccountService`). **Dashboard finans gizleme için sunucu tarafında rol/izin altyapısı yok** (Sorun 3'ü doğrudan etkiler).

## 1.6 Navigation Yapısı

- `go_router` 14.x, `buildAppRouter()` (`app/app_router.dart`): `/splash` → `/login` → `ShellRoute(AppShell)`.
- Shell rotaları: `/dashboard`, `/customers(/new|/:id)`, `/work-orders(/new|/:id)`, `/catalog`, `/social-media`, `/archive`.
- Redirect mantığı `AppStartupController` durumuna göre merkezi.
- **Tutarsızlık:** İş emri düzenleme, `work_order_detail_page.dart:492`'de `Navigator.of(context).push(MaterialPageRoute(...))` ile go_router'ı **bypass** ederek açılıyor. URL senkronu bozulur, geri tuşu davranışı diğer ekranlarla farklılaşır. Mobil geliştirmeden önce rota tabanlı hale getirilmesi önerilir.

## 1.7 Ortak Widget Yapısı ve Reusable Componentler

`core/widgets/`: `SkeletonBox`, `SkeletonListTile/SkeletonList`, `AppLogoMark`, `FeaturePlaceholderPage`, `VideoPreviewPlayer`.
Feature-lokal ortaklar: `WorkOrderStatusBadge`, `IysStatusBadge`, `SummaryCard`, `MediaSection`.
`core/utils/`: `CurrencyFormatter`, `PhoneNormalizer`, `ByteSizeFormatter`.

## 1.8 Kod Tekrarları

| Tekrar | Konumlar |
|---|---|
| `_flattenLevel3` + `_Level3Category` (kategori ağacını level-3 listeye düzleştirme) | `work_order_form_page.dart:21-42` ve `service_price_tab.dart:13-34` — birebir kopya |
| `_SkeletonCardBlock` / skeleton kart kalıpları | `dashboard_page.dart`, `work_order_detail_page.dart` (ve benzer varyantlar) |
| "boşsa null gönder" trim kalıbı (`text.trim().isEmpty ? null : text.trim()`) | `work_order_form_page.dart` içinde 10 kez (create + update blokları) |
| Ondalık parse `double.tryParse(text.replaceAll(',', '.'))` | İş emri formu (fiyat/kapora), teslim diyaloğu, fiyat matrisi — ortak `parseTrCurrency` yardımcı fonksiyonu yok |
| Tarih formatlama `DateFormat('dd.MM.yyyy...')` çağrıları | Detay sayfaları, listeler — ortak formatter yok |
| ProblemDetails hatasını SnackBar'a basma kalıbı | Neredeyse tüm sayfalarda elle tekrarlanıyor |

## 1.9 Ekran → Endpoint / Model / İş Mantığı Haritası

| Ekran | Endpoint(ler) | Gönderilen model | Alınan model | İş mantığı / Eksikler |
|---|---|---|---|---|
| **Login** | `POST /api/auth/login` | `LoginRequestDto` | `LoginResponseDto` (token, expiresAt) | Token secure storage'a yazılır. Eksik: açılışta `GET /api/auth/me` doğrulaması yok. |
| **Dashboard** | `GET /api/dashboard/summary` | — | `DashboardSummaryDto` (statü sayıları, günlük/aylık ciro, disk kullanımı, geciken hazır işler) | Ciro herkes tarafından görünür (Sorun 3). Manuel yenileme var, otomatik yenileme yok. |
| **Müşteri Arama** | `GET /api/customers?search&page&pageSize` | — | `PagedResponse<CustomerDto>` | Debounce'lu arama, sayfalama. |
| **Müşteri Formu** | `POST /api/customers`, `PUT /api/customers/{id}` | `Create/UpdateCustomerRequestDto` | `CreateCustomerResponseDto` / `CustomerDto` | Telefon normalizasyonu (`PhoneNormalizer`), İYS onay akışı. |
| **Müşteri Detay** | `GET /api/customers/{id}`, İYS: `POST .../iys/resend-code`, `POST .../iys/confirm` | `IysConfirmRequestDto` | `CustomerDetailDto` (+ iş emri listesi) | İYS doğrulama paneli. |
| **İş Emri Listesi** | `GET /api/work-orders?status&search&page&pageSize` | — | `PagedResponse<WorkOrderListItemDto>` | Statü filtresi query param'dan (`?status=READY` dashboard'dan gelir). |
| **İş Emri Formu** (Yeni/Düzenle) | `POST /api/work-orders`, `PUT /api/work-orders/{id}`; katalog: `GET /api/categories/tree`, `GET /api/categories/{id}/services`, `GET /api/consumable-groups`, `GET /api/consumable-products` | `CreateWorkOrderRequestDto` / `UpdateWorkOrderRequestDto` | `WorkOrderDto` | Önerilen fiyat = hizmet + sarf toplamı; kullanıcı elle ezebilir. **Sorun 1 & 2 bu ekranda** (tarih serileştirme). Form/`TextFormField` validator altyapısı kullanılmıyor; `fieldErrors` alan bazında forma yansıtılmıyor. |
| **İş Emri Detay** | `GET /api/work-orders/{id}`, `PATCH .../status`, `POST .../deliver`, `POST .../sms/resend` | `UpdateWorkOrderStatusRequestDto`, `DeliverWorkOrderRequestDto` | `WorkOrderDto` | Statü geçiş butonları duruma göre koşullu; READY'ye geçişte SMS onay diyaloğu; iptalde not. **"Barkod Oluştur" butonu için doğal yer burası.** |
| **Katalog — Kategori Ağacı** | `GET/POST/PUT/DELETE /api/categories*` | `Create/UpdateCategoryRequestDto` | `CategoryTreeDto`, `CategoryDto` | 3 seviyeli ağaç, level-3 = ürün türü. |
| **Katalog — Hizmet Türleri** | `GET/POST/PUT/DELETE /api/service-types*` | `Create/UpdateServiceTypeRequestDto` | `ServiceTypeDto` | |
| **Katalog — Fiyat Matrisi** | `GET /api/service-prices?categoryId`, `PUT /api/service-prices/bulk` | `BulkUpsertServicePricesRequestDto` | `ServicePriceDto[]` | **Sorun 4 bu ekranda** (TextField sıfırlanması). Kaydet = toplu upsert. |
| **Katalog — Sarf Malzemeler** | `GET/POST/PUT/DELETE /api/consumable-groups*`, `/api/consumable-products*` | ilgili request DTO'ları | `ConsumableGroupDto`, `ConsumableProductDto` | |
| **Medya (detay içinde)** | `POST .../media/request-upload` → **MinIO'ya doğrudan presigned PUT** → `POST .../media/confirm`, `GET .../media`, `DELETE /api/media/{id}` | `RequestMediaUploadRequestDto`, `ConfirmMediaUploadRequestDto` | `MediaFileDto` | API üzerinden dosya geçmez (Nginx API limiti 2 MB, medya subdomain 500 MB). Video format doğrulama + dönüştürme servisi var. |
| **Sosyal Medya** | `GET /api/social-media/items` | — | `PagedResponse<SocialMediaItemDto>` | Onaylı medyayı diske indirme. |
| **Arşiv** | `GET /api/archive/candidates`, `POST /api/archive/{id}/export`, `POST /api/archive/{id}/confirm` | `ArchiveConfirmRequestDto` | `ArchiveCandidateDto`, `ArchiveExportResponseDto` | İndir → SHA-256 bütünlük kontrolü (`ArchiveIntegrityChecker`) → onayla → sunucudan sil. |
| **Yedek (dashboard/section)** | `GET /api/admin/backups/latest` | — | dosya (download) | |

## 1.10 Teknik Borçlar

1. **Tarih serileştirme sözleşmesizliği (kritik):** Flutter DTO'larında `DateOnly` alanlar `DateTime` olarak modellenip `toIso8601String()` ile gönderiliyor → Sorun 1'in kökü. Ortak bir `DateOnlyConverter` (`@JsonKey(toJson/fromJson)`) yok.
2. **Alan bazlı hata gösterimi yok:** `ApiException.fieldErrors` parse ediliyor ama hiçbir form bunu alan altına yansıtmıyor; kullanıcı yalnızca genel "One or more validation errors occurred." benzeri mesaj görüyor. Sorun 1'in "neden anlaşılmıyor" kısmının nedeni.
3. **Form altyapısı kullanılmıyor:** İş emri formu `Form`/`GlobalKey<FormState>`/validator kullanmıyor; doğrulamalar `_submit` içinde imperative SnackBar'larla.
4. **go_router bypass'ı:** Düzenleme sayfası `Navigator.push` ile (bkz. §1.6).
5. **Her istekte secure storage okuması:** `AuthInterceptor.onRequest` token'ı her seferinde diskten okur; bellek içi cache yok (Windows'ta DPAPI çağrısı — ölçülebilir gecikme). Düşük öncelik.
6. **Yazdırma/barkod/kamera altyapısı sıfır:** `pubspec.yaml`'da printing, esc_pos, barcode, mobile_scanner, permission_handler türünde hiçbir paket yok; `lib/` altında "print/barcode" geçen tek satır kod yok (grep ile doğrulandı).
7. **Mobil platform iskeleti yok:** `android/`, `ios/` klasörleri mevcut değil; `media_kit` (video oynatıcı) masaüstü odaklı ağır bir bağımlılık — mobil derlemede boyut/uyumluluk gözden geçirilmeli.
8. **Tema tek (light):** `AppColors` sabit açık tema; `ThemeMode.dark` desteği yok (atölye/karanlık ortam UX'i için bkz. §5).
9. **"Desktop Shell" rozeti hard-coded** (`app_shell.dart:154`) — platform ayrımı geldiğinde dinamikleşmeli.
10. **freezed DTO'ları null alanları da gönderiyor** (`includeIfNull` kapatılmamış): `UpdateWorkOrderRequest`'te backend "null liste = dokunma" semantiği kullanıyor; Flutter `servicePriceIds`'i her zaman gönderdiği için sorun çıkmıyor ama sözleşme kırılganlığı var — bilinçli yönetilmeli.

---

# 2. Mevcut Sorunlar

## Sorun 1 — Ürün (iş emri) eklerken validation hatası

### Sorunun kaynağı — tespit edildi

Validation hatası **backend model binding** katmanında oluşuyor; FluentValidation'a veya form doğrulamasına gelmeden.

- Backend sözleşmesi: `CreateWorkOrderRequest.EstimatedDeliveryDate` tipi **`DateOnly?`** (`WorkOrdersController.cs:20`). Swagger'da da `"format": "date"` (yalnızca `yyyy-MM-dd` kabul eder).
- Flutter DTO'su: `estimatedDeliveryDate` tipi **`DateTime?`** ve üretilen JSON kodu tam zaman damgası basıyor:

```43:47:atolye_flutter/lib/features/work_order/data/dto/update_work_order_request_dto.g.dart
      'estimatedDeliveryDate':
          instance.estimatedDeliveryDate?.toIso8601String(),
      'servicePriceIds': instance.servicePriceIds,
      'consumables': instance.consumables,
```

`toIso8601String()` çıktısı `2026-07-28T00:00:00.000` biçimindedir. .NET'in `System.Text.Json` `DateOnly` dönüştürücüsü bu değeri **parse edemez** → istek gövdesi bağlanamaz → ASP.NET Core otomatik **400 ValidationProblemDetails** döner (`errors: { "$.estimatedDeliveryDate": [...] }`). Aynı kusur `CreateWorkOrderRequestDto` üretilen kodunda da birebir mevcut.

- **Nerede yapılıyor?** Backend (model binding). Frontend'de tarih için hiçbir doğrulama yok; DTO düzeyinde tip uyumsuzluğu var; form validation kullanılmıyor.
- **Hangi alan?** `estimatedDeliveryDate`.
- **Hangi durumda?** Formda **"Tahmini teslim tarihi" seçildiğinde**. Tarih seçilmezse alan `null` gider ve kayıt başarılı olur — hatanın "bazen oluyor" gibi görünmesinin nedeni budur. *(Ek doğrulama gerekiyor: canlı reprodüksiyonda hatanın yalnızca tarih seçiliyken oluştuğu teyit edilmeli; sunucu logunda `$.estimatedDeliveryDate` anahtarı görülmelidir.)*
- İkincil katkı: hata gövdesindeki `errors` haritası `ApiException.fieldErrors`'a çözülüyor ama form yalnızca `state.errorMessage`'ı (genel `title`) gösterdiği için kullanıcı hangi alanın hatalı olduğunu göremiyor.

### Etkilenenler

- **Ekranlar:** İş Emri Formu (hem "Yeni İş Emri" hem "Düzenle" modu — update DTO'sunda aynı serileştirme var).
- **API:** `POST /api/work-orders`, `PUT /api/work-orders/{id}`.
- **Modeller:** `CreateWorkOrderRequestDto`, `UpdateWorkOrderRequestDto` (Flutter); `CreateWorkOrderRequest`, `UpdateWorkOrderRequest` (backend — değişiklik gerekmez).

### Çözüm önerisi

Flutter tarafında düzeltilmeli (backend sözleşmesi doğru ve spec'e uygun):

1. Ortak bir dönüştürücü yazılır (örn. `core/utils/date_only_converter.dart`): `toJson: (d) => d == null ? null : '${yyyy}-${MM}-${dd}'`, `fromJson: DateTime.parse` (backend `yyyy-MM-dd` döndürdüğü için parse sorunsuz).
2. `CreateWorkOrderRequestDto.estimatedDeliveryDate` ve `UpdateWorkOrderRequestDto.estimatedDeliveryDate` alanlarına `@JsonKey` ile bağlanır; `build_runner` yeniden çalıştırılır.
3. Forma alan-bazlı hata gösterimi eklenir (`fieldErrors` → ilgili `TextField`'ın `errorText`'i) — aynı sınıf hataların bir daha "sessiz" kalmaması için.

### Olası yan etkiler

- Düşük risk: yalnızca giden JSON biçimi değişir; backend zaten `yyyy-MM-dd` bekliyor.
- `WorkOrderDto.estimatedDeliveryDate` okuma yönü etkilenmez (backend `yyyy-MM-dd` gönderiyor, `DateTime.parse` bunu kabul eder).
- Dikkat: `updatedAt` (date-time) alanına dokunulmamalı — o alan tam zaman damgası olarak doğru.

---

## Sorun 2 — "Açıklama" ve "Detay" alanları gerçekten opsiyonel mi?

**Gerçek durum: Her iki alan da uçtan uca tamamen opsiyoneldir.** Kanıt zinciri:

| Katman | Kanıt |
|---|---|
| Backend DTO | `CreateWorkOrderRequest`: `string? Description, string? ExistingDamages` (`WorkOrdersController.cs:19`) — nullable |
| Validation (FluentValidation) | `CreateWorkOrderRequestValidator` (`WorkOrdersController.cs:113-137`): Description/ExistingDamages için **hiçbir kural yok** (NotEmpty yok, MaxLength bile yok) |
| Veritabanı | `AppDbContext.cs` WorkOrder konfigürasyonu: `Brand(100)`, `Color(50)`, `Material(100)` MaxLength'li; **Description ve ExistingDamages sınırsız `text` ve nullable** — check constraint yok |
| Swagger | `CreateWorkOrderRequest.description` ve `.existingDamages`: `"type": "string", "nullable": true` |
| Flutter formu | `work_order_form_page.dart:405-410`: alan boşsa `null` gönderiliyor, doluysa `trim()`'lenmiş metin; zorunluluk kontrolü yok |
| API Request | freezed toJson null'ı açıkça gönderir (`"description": null`) — backend nullable kabul eder |

**Opsiyonelse neden hata oluşuyor?** Hata bu alanlardan **kaynaklanmıyor**. Sorun 1'deki `estimatedDeliveryDate` binding hatası 400 döndürüyor ve UI genel bir hata mesajı gösterdiği için kullanıcı hatayı yanlış alana (Açıklama/Detay) atfediyor. Alan-bazlı hata gösterimi eklendiğinde bu algı sorunu ortadan kalkar.

*Ek doğrulama gerekiyor:* "Detay" ifadesiyle kastedilen alanın `existingDamages` (formdaki "Mevcut Hasarlar") olduğu varsayıldı; formda başka "Detay" etiketi yok. Farklı bir alan kastediliyorsa reprodüksiyon adımı alınmalı.

---

## Sorun 3 — Dashboard'daki ciro bilgileri herkese görünüyor

### Sorunun kaynağı

- `GET /api/dashboard/summary` (`DashboardController.cs`) `DailyRevenue` ve `MonthlyRevenue`'yu her geçerli JWT'ye döner; backend'de **rol/izin ayrımı yok** (tek ADMIN kullanıcı, spec gereği).
- `dashboard_page.dart` "Finans" KPI grubu (satır 134-152) ve `RevenueSummaryCard` (satır 187-190) bu değerleri maskesiz basar.
- Pratikte sorun: atölyedeki ortak bilgisayarda uygulama açıkken **ekrana bakan herkes** ciroyu görür.

### Etkilenenler

- **Ekranlar:** Dashboard (Finans KPI grubu + `RevenueSummaryCard`). İkincil sızıntı yüzeyleri: İş Emri Detay/Listesi fiyat kolonları (kapsam kararı verilmeli — bu analizde yalnızca dashboard hedefleniyor).
- **API:** `GET /api/dashboard/summary` (değişiklik opsiyonel, aşağıda).
- **Modeller:** `DashboardSummaryDto` (değişmez), yeni bir "finans kilidi" servisi/state'i eklenir.

### Seçeneklerin karşılaştırması

| Yöntem | Avantaj | Dezavantaj |
|---|---|---|
| **PIN doğrulama (yerel, hash'li)** | Hızlı UX (4-6 hane); offline çalışır; `crypto` + `flutter_secure_storage` zaten bağımlılıkta, yeni paket gerekmez; mobilde de aynen çalışır | Sunucu şifresinden bağımsız ikinci bir sır; PIN belirleme/sıfırlama akışı gerekir; istemci tarafı olduğu için API seviyesinde koruma sağlamaz |
| **Uygulama (hesap) şifresi ile yeniden doğrulama** | Tek sır; sunucu doğrular (`POST /api/auth/login` mevcut haliyle kullanılabilir) | Login e-posta+şifre ister ve uygulama e-postayı saklamıyor (token'da `email` claim'i var — çözülebilir); rate limit 5/dk/IP kilidi yanlışlıkla tetiklenebilir; her açışta uzun şifre yazmak atölye UX'ine aykırı; offline çalışmaz |
| **Biyometrik doğrulama** | Mobilde (Feature 2) en hızlı ve güvenli seçenek | Windows masaüstünde Flutter `local_auth` desteği sınırlı/sorunlu (Windows Hello için `local_auth_windows` gerekir, cihazda donanım şart); yeni paket kuralı ihlali bu fazda; tek başına yeterli değil, PIN fallback şart |
| **Session bazlı açma (kilidi süreli açık tutma)** | Tek başına yöntem değil, tamamlayıcı: bir kez doğrula → N dakika açık kalsın; tıklama sayısını azaltır | Süre uzun tutulursa koruma anlamsızlaşır |

### Önerilen çözüm (birleşik)

**Varsayılan maskeli + yerel PIN + oturum süreli açık kalma:**

1. Finans kartları varsayılan olarak `••••` maskeli, üzerinde kilit ikonu/"Göster" aksiyonu.
2. İlk kullanım: PIN belirleme diyaloğu → `SHA-256(pin + salt)` secure storage'a. (`crypto` paketi mevcut — yeni paket eklenmez.)
3. "Göster" → PIN diyaloğu → doğruysa `finansUnlocked=true` (bellek içi, kalıcı değil) + örn. 5 dk zamanlayıcı veya sayfadan ayrılınca kilit.
4. Logout/uygulama yeniden başlatma → her zaman kilitli başlar.
5. Yanlış deneme sınırı (örn. 5 deneme → 1 dk bekleme) yerel olarak uygulanır.

**Dürüst güvenlik notu:** Bu istemci tarafı bir **görsel gizliliktir**; API'yi çağırabilen herkes (token'a sahip biri) ciroyu yine alabilir. Gerçek yetkilendirme istenirse backend değişikliği gerekir: `summary`'den finans alanlarını ayırıp `GET /api/dashboard/finance` gibi ikinci bir uca taşımak ve bu uca kısa ömürlü "yükseltilmiş" bir doğrulama şartı koymak. Tek-admin mimarisinde bu maliyet, kazanımına göre yüksektir; **Faz kapsamında istemci tarafı maskeleme yeterli ve önerilen çözümdür** (karar dokümante edilmeli).

### Olası yan etkiler

- Dashboard boş-veri kontrolü `_isEmpty()` ciro değerlerini kullanıyor (`dashboard_page.dart:41-49`) — maskeleme yalnızca **görselde** yapılmalı, DTO değeri değişmemeli.
- PIN unutulursa: "PIN'i sıfırla" = yeniden login zorunluluğu gibi ucuz bir kurtarma akışı tasarlanmalı.

---

## Sorun 4 — Price Matrix'te TextField sürekli sıfırlanıyor

### Sorunun kaynağı — tespit edildi (widget key + rebuild döngüsü)

```122:147:atolye_flutter/lib/features/catalog/presentation/widgets/service_price_tab.dart
                              trailing: SizedBox(
                                width: 140,
                                child: TextFormField(
                                  key: ValueKey(
                                    'price-${row.serviceTypeId}-${row.price}',
                                  ),
                                  initialValue: row.price.toStringAsFixed(2),
                                  ...
                                  onChanged: (value) {
                                    final parsed = double.tryParse(
                                      value.replaceAll(',', '.'),
                                    );
                                    if (parsed != null) {
                                      context
                                          .read<ServicePriceCubit>()
                                          .updateRowPrice(...)
```

Zincir şu şekilde işliyor:

1. Kullanıcı bir karakter yazar → `onChanged` → `ServicePriceCubit.updateRowPrice()` → `emit` ile **yeni state**.
2. `BlocConsumer` tüm listeyi yeniden build eder.
3. `TextFormField`'ın `key`'i **`row.price` değerini içeriyor** (`'price-${row.serviceTypeId}-${row.price}'`). Fiyat değiştiği için key değişir → Flutter eski `State`'i (dolayısıyla içteki `TextEditingController`'ı) **çöpe atar ve widget'ı sıfırdan kurar**.
4. Yeni widget `initialValue: row.price.toStringAsFixed(2)` ile doğar → yazılan metin `"12"` iken alan `"12.00"`a döner, **imleç başa/sona atlar**; kullanıcı deneyimi "sürekli sıfırlanıyor" olur.

Soruların tek tek cevabı:

- **Controller yeniden mi oluşturuluyor?** Evet — dolaylı olarak. Alan controller'sız (`initialValue`'lu) kullanılmış; key değişince `TextFormField`'ın kendi iç controller'ı yeniden yaratılıyor.
- **Widget rebuild mi oluyor?** Evet, ama asıl sorun rebuild değil; rebuild sırasında **key'in değişip state'in kaybolması**. Key `serviceTypeId`'yle sınırlı olsaydı rebuild zararsızdı.
- **Bloc state mi değişiyor?** Evet — her tuş vuruşunda `updateRowPrice` emit ediyor; tetikleyici bu.
- **TextEditingController yanlış mı kullanılmış?** Kullanılmamış; `initialValue` + değere bağlı key kombinasyonu antipattern.
- **Formatter problemi mi var?** İkincil bir kusur var: `toStringAsFixed(2)` her yeniden kuruluşta metni normalize ediyor; ayrıca `"12,"` gibi ara girdiler `double.tryParse` başarısız olduğu için state'e hiç yazılmıyor (virgüllü yazan kullanıcıda "Kaydet" eski değeri gönderebilir).
- **Focus problemi mi var?** Sonuç olarak evet (odak kaybı/imleç sıçraması), ama neden değil; key kaynaklı state kaybının belirtisi.

### Etkilenenler

- **Ekran:** Katalog → Fiyat Matrisi sekmesi (`ServicePriceTab`).
- **API:** `PUT /api/service-prices/bulk` — dolaylı etki: parse edilemeyen ara girdiler nedeniyle **kullanıcının gördüğü değerle gönderilen değer farklılaşabilir**.
- **Modeller:** `ServicePriceRow`, `ServicePriceState` (yapıları doğru; değişiklik minimal).

### Çözüm önerisi

1. Satırı kendi `TextEditingController` + `FocusNode`'unu yöneten bir `StatefulWidget`'a çıkar (`_PriceRowField`), `key: ValueKey(row.serviceTypeId)` — **fiyat key'den çıkarılır**.
2. Controller yalnızca `initState`'te ve kategori değişiminde (didUpdateWidget ile `servicePriceId/serviceTypeId` değişirse) doldurulur; her cubit emit'inde **alan yeniden yazılmaz**.
3. `onChanged`'de cubit güncellenmeye devam eder (kaydet butonu `state.rows`'u kullandığı için) ama parse edilemeyen girdi durumu görselleştirilir (errorText) veya kaydetmeden önce controller'lardan toplu senkron yapılır.
4. Alternatif/daha büyük refactor: `saveAll()` değerleri doğrudan controller haritasından okusun, cubit yalnızca yükleme/kaydetme durumunu tutsun. (Daha az emit → daha az rebuild.)
5. Virgül desteği için `FilteringTextInputFormatter` + tek noktalı ondalık izinli inputFormatter önerilir.

### Olası yan etkiler

- `saveAll()` senkronizasyonu: controller'a geçildiğinde cubit `rows`'u ile controller içerikleri arasında tutarlılık testi (widget test) eklenmeli — aksi halde eski hata "görünen ≠ gönderilen" biçiminde geri gelir.
- Checkbox (`isActive`) emit'leri liste rebuild'i tetiklemeye devam eder — controller'lı alanlar bundan artık etkilenmez.

---

## Sorun 5 — XPrinter XP-Q807K entegrasyonu

### Mevcut yazdırma altyapısı

**Yok.** Doğrulama:

- `pubspec.yaml`'da yazdırmayla ilgili hiçbir paket yok (`printing`, `pdf`, `esc_pos_*`, `flutter_usb_printer` vb. yok).
- `lib/` altında `print|barcode|escpos` desenlerinde tek eşleşme yok (case-insensitive grep — 0 sonuç).
- Backend'de de yazdırma/etiket ucu yok; en yakın kavram `TrackingUrl` (müşteri takip linki).

Yani "USB mi, Bluetooth mu, ESC/POS mu?" sorularının cevabı: **henüz hiçbiri; sıfırdan tasarlanacak.**

### XP-Q807K teknik profili ve entegrasyon gereksinimleri

XP-Q807K, Xprinter'ın **80 mm termal fiş yazıcısı** sınıfındandır: ESC/POS komut seti, 203 dpi, kesici (auto-cutter), tipik olarak USB + LAN (modele göre seri port) arabirimleri. *(Ek doğrulama gerekiyor: eldeki cihazın arabirim konfigürasyonu — USB-only mu, LAN'lı varyant mı — fiziksel olarak teyit edilmeli; entegrasyon mimarisini bu belirler.)*

Yazdırma yolu seçenekleri (Windows masaüstü istemciden):

| Yol | Açıklama | Değerlendirme |
|---|---|---|
| **A. Raw ESC/POS → Windows yazıcı kuyruğu (önerilen)** | Xprinter sürücüsü kurulur; uygulama ESC/POS byte dizisini `winspool` RAW datatype ile kuyruğa yazar (win32/FFI) | Sürücünün grafik işlemesine girmeden tam kontrol (barkod komutları, kesme, Türkçe kod sayfası); en hızlı çıktı |
| B. LAN varyantıysa TCP 9100'e doğrudan ESC/POS | Sürücüsüz, soket ile | En taşınabilir (mobilden de aynı kod!); yalnızca LAN'lı modelde mümkün |
| C. `printing` paketi ile PDF/görüntü olarak sürücüye basmak | Widget→PDF→sürücü | Kurulumu kolay ama termal yazıcıda yavaş, barkod netliği risk, kesme/Türkçe karakter kontrolü zayıf |

**Gereksinim listesi (A yolu için):**

1. ESC/POS byte üretimi: `esc_pos_utils_plus` benzeri bir paket veya küçük bir el yazımı komut katmanı (init `ESC @`, hizalama, çift genişlik, `GS k`/`GS ( k` barkod-QR, `GS V` kesme).
2. Türkçe karakter: kod sayfası **CP857** (`ESC t` ile seçim) + metnin CP857'ye transcode edilmesi; alternatif: metni bitmap'e çevirip raster basmak (yavaş).
3. Windows spooler erişimi: `win32` + `ffi` paketleriyle `OpenPrinter/StartDocPrinter(RAW)/WritePrinter` çağrıları; yazıcı adı ayarlardan seçilebilir olmalı.
4. Kağıt: 80 mm rulo → **yazdırılabilir alan 72 mm ≈ 576 nokta** (203 dpi). Tasarım bu genişliğe göre yapılmalı.
5. Hata yönetimi: yazıcı kapalı/kağıt bitti senaryolarında kuyruk hatasının kullanıcıya bildirimi; "test fişi bas" tanılama butonu.
6. Not: Bu fazın kuralları gereği **şimdi paket eklenmiyor**; yukarıdakiler Phase 5'in bağımlılık listesidir.

---

# 3. Yeni Feature Analizi

## Feature 1 — Desktop Barkod Oluşturma (Ürün/İş Emri fişi)

### Barkod formatı kararı

| Format | Uygunluk |
|---|---|
| **Code128 (önerilen)** | İş emri numarası `WO-2026-000123` **alfanümerik** (`WorkOrdersController.NextOrderNumberAsync`: `WO-{yıl}-{6 hane}`); Code128-B bunu doğrudan kodlar. 1D lazer/2D kamera tüm okuyucularla uyumlu. 16 karakterlik içerik 72 mm'ye rahat sığar. |
| QR | Takip URL'si gibi zengin içerik için ideal; ancak asıl amaç "okut → kaydı aç" ise içerikte URL değil kimlik olmalı. **İkincil olarak** fişe müşteri takip QR'ı (trackingUrl) eklenebilir. |
| EAN-13 | Uygun değil: yalnızca 12+1 rakam, sabit uzunluk; `WO-` öneki kodlanamaz. Perakende GTIN standardıdır, iş emri kimliği değildir. |

**Barkod içeriği önerisi:** `orderNumber` (insan-okur + tekil + backend'de `IsUnique` indeksli). Sayısal `id` daha kısa olurdu ama fiş üzerindeki yazıyla birebir aynı değerin kodlanması operasyonel hataları azaltır. Mobil okuma akışı §3.2'de bu değeri kullanır.

### Fiş bilgi alanları — veri modeli eşlemesi

| İstenen | Kaynak (WorkOrderResponse) | Durum |
|---|---|---|
| Barkod | `orderNumber` (Code128) | ✅ |
| Ürün Adı | `categoryPath` (örn. "Kadın > Ayakkabı > Sneakers") | ✅ |
| Ürün Kodu | `orderNumber` | ✅ |
| Seri No | — | ❌ **Modelde yok.** *Ek doğrulama gerekiyor:* seri no gerçekten isteniyorsa backend'e alan eklenmeli; istenmiyorsa fişten çıkarılmalı. |
| Marka | `brand` | ✅ (nullable — boşsa satır gizlenir) |
| Model | — | ❌ **Modelde yok** (en yakını `material`/`color`). Aynı karar Seri No ile birlikte verilmeli. |
| Müşteri | `customer.firstName + lastName` | ✅ |
| Telefon | `customer.phone` | ✅ — **KVKK notu:** fiş üründe/askıda duracaksa maskeleme (`0532 *** ** 67`) değerlendirilmeli |
| Arıza | `description` ve/veya `existingDamages` | ✅ (etiket "Açıklama/Mevcut Hasarlar") |
| Kabul Tarihi | `createdAt` | ✅ |
| Durum | `status` | ✅ (fiş basım anındaki durum — sonradan bayatlar, fişte "basım tarihi" de yer almalı) |
| Diğer | `estimatedDeliveryDate`, hizmet listesi, `price`/`prepaymentAmount`/`remainingAmount`, takip QR | ✅ opsiyonel bölge |

### Yazdırma düzeni (XP-Q807K, 80 mm)

- **Kağıt:** 80 mm termal rulo; **yazdırılabilir genişlik 72 mm (576 nokta @203 dpi)**; uzunluk içerik kadar + kesme.
- Önerilen şablon (yukarıdan aşağı): ① Atölye adı/logo (çift genişlik, ortalı) ② `orderNumber` büyük punto ③ **Code128** (yükseklik ~80-100 nokta, module ≥2 nokta, iki yanda ≥10 nokta sessiz bölge, altında insan-okur yazı) ④ müşteri + telefon ⑤ ürün bloğu (kategori/marka/renk/malzeme) ⑥ arıza/açıklama (sarmalı metin) ⑦ kabul tarihi + tahmini teslim + durum ⑧ (ops.) takip QR ⑨ kesme (`GS V 66`).
- İki kopya senaryosu (biri ürüne, biri müşteriye) parametre olmalı.
- **Buton yeri:** `work_order_detail_page.dart` başlık satırı (link kopyalama ikonu yanına "Barkod Oluştur / Fiş Bas"). Ayrıca iş emri oluşturma başarısında (form `context.go` sonrası detayda) otomatik sorma opsiyonu.

## Feature 2 — Mobil Uygulama (Dashboard + FAB barkod okuyucu)

### Platform ayrımı stratejisi (kullanıcının kısıtına göre)

Kullanıcı şartı: *masaüstünde pencere küçültülünce mobil moda geçilmesin.* Bu nedenle ayrım **ekran genişliğiyle DEĞİL, platformla** yapılmalı:

- `Platform.isAndroid || Platform.isIOS` → mobil kabuk (2 ekran); aksi halde mevcut `AppShell`.
- Mevcut `LayoutBuilder` kullanımları (örn. `dashboard_page.dart:154`, 900px breakpoint) **platform içi** responsive düzen için kalabilir; kabuk seçimi platform bazlı ayrı bir `MobileShell/AppShell` dallanmasıyla yapılmalı (örn. `app.dart` veya router shell'inde).
- **Ön koşul:** `android/` ve `ios/` iskeleti yok → `flutter create --platforms=android,ios .` gerekli. `media_kit*`, `window_manager`, `flutter_secure_storage` mobil derleme uyumluluğu gözden geçirilmeli (`window_manager` zaten `Platform.isWindows/isMacOS` guard'lı — `main.dart:34`; `media_kit` mobilde çalışır ama APK boyutunu büyütür, mobil kabukta video önizleme gerekmiyorsa koşullu kullanım değerlendirilmeli). *Ek doğrulama gerekiyor: minimum Android SDK / iOS sürüm hedefleri.*

### Mobil Dashboard

- Mevcut `DashboardCubit` + `GET /api/dashboard/summary` **aynen yeniden kullanılabilir** — API mobil için yeterli.
- Mobil için eksik/uyarlanacak noktalar:
  1. `DiskUsageCard` ve `OverdueReadyCard`'ın aksiyonları (`context.go(AppRoutes.archive)`, iş emri listesi) mobil kabukta **hedefsiz** — mobilde bu kartlar ya gizlenmeli ya salt-bilgi olmalı.
  2. Ciro kartları: Sorun 3'teki maskeleme mobilde de geçerli olmalı (ortak `FinanceLockService`).
  3. Pull-to-refresh (`RefreshIndicator`) eklenmeli; masaüstündeki "Yenile" butonu mobil UX'e uymaz.
  4. Kart grid'i tek kolona düşmeli (mevcut `Wrap` mantığı `minCardWidth=200` ile zaten daralıyor — büyük ölçüde hazır).

### FAB → Barkod okuma akışı (önerilen)

1. FAB (sağ alt, tek, büyük) → `permission_handler` ile kamera izni kontrolü.
   - İlk kez: sistem izin diyaloğu. Kalıcı red: ayarlara yönlendiren açıklayıcı ekran.
2. İzin OK → tam ekran tarayıcı (`mobile_scanner` önerilir: ML Kit/AVFoundation tabanlı, Code128 + QR destekli) + el feneri (torch) butonu + vizör çerçevesi.
3. Barkod değeri (`WO-2026-000123`) yakalanınca **titreşim + bip**, tarayıcı kapanır, yükleme göstergesi.
4. Ürün bilgisi çekme — mevcut API ile iki adım:
   `GET /api/work-orders?search={orderNumber}&pageSize=1` → `items[0].id` → `GET /api/work-orders/{id}`.
   (Arama `ILIKE %term%` ile `orderNumber` alanını kapsıyor — `WorkOrdersController.cs:246-250`; tam numara aramasında tekil sonuç pratikte garanti. Yine de **kesin eşleşme ucu** önerilir, bkz. §4.)
5. Sonuç yoksa: "Kayıt bulunamadı" + yeniden tara; ağ hatasında retry.
6. Başarıda → Mobil Ürün Detay ekranı (Feature 3). Detaydan geri → Dashboard; FAB ile döngü devam eder.

Toplam hedef: **okut → detay ≤ 2 sn, ≤ 2 dokunuş.**

## Feature 3 — Mobil Ürün Detayı (Read-only + Status değişimi)

### Gösterilecek / gizlenecek alanlar

| Göster (read-only) | Gizle / gösterme |
|---|---|
| `orderNumber` + `WorkOrderStatusBadge` (mevcut widget yeniden kullanılır) | `trackingUrl` kopyalama, medya yükleme paneli (masaüstü işi) |
| Müşteri adı + telefon (telefona `tel:` dokunarak arama — atölyede değerli) | SMS geçmişi/yeniden gönderme (admin masaüstü işi) |
| `categoryPath`, `brand`, `color`, `material` | Arşiv/sosyal medya aksiyonları |
| `description`, `existingDamages` (Arıza bloğu — atölyedeki asıl ihtiyaç) | **Fiyat bloğu**: Sorun 3 kararına paralel — ya tamamen gizle ya PIN arkasına al (önerilen: gizle; teslim mobilde yapılmayacaksa gereksiz) |
| `createdAt`, `estimatedDeliveryDate` | Düzenle butonu (mobilde düzenleme yok — şart) |
| Hizmet listesi (fiyatsız isim listesi) | Sarf malzeme fiyat kolonları |
| Durum geçmişi (kompakt timeline) | |

*Ek doğrulama gerekiyor:* Teslim (`DELIVERED`) ve tahsilat mobilden yapılacak mı? Backend'de teslim ayrı uç (`POST /{id}/deliver`, tutar ister) ve PATCH ile DELIVERED **409 döner** (`WorkOrdersController.cs:417-419`). Önerim: Faz kapsamında mobilde teslim YOK (tahsilat masaüstünde); aksi istenirse tutar girişli ayrı onay akışı tasarlanır.

### Status değiştirme UX'i — seçenek analizi

| Seçenek | Değerlendirme |
|---|---|
| Dropdown | ❌ Küçük hedef, geçiş matrisini (hangi durumdan hangisine izin var) ifade edemez |
| **BottomSheet (önerilen)** | ✅ Tek elle erişim, büyük butonlar, yalnızca **izinli geçişler** listelenir, iptal için not alanı gösterilebilir |
| Timeline | Geçmişi göstermek için ideal (read-only bölümde kullan), aksiyon aracı olarak değil |
| Chip | Mevcut durumu göstermek için (`WorkOrderStatusBadge`) ✅; seçim aracı olarak geçiş kurallarını taşıyamaz |
| Stepper | Akış doğrusal değil (READY→IN_PROGRESS geri dönüşü, her durumdan CANCELLED) — yanıltıcı olur |

**Önerilen akış:** Ekran altında sabit, tam genişlik **"Durumu Değiştir"** butonu → BottomSheet'te büyük kartlar halinde yalnızca geçerli hedefler (geçiş matrisi istemcide de kodlanır: RECEIVED→IN_PROGRESS; IN_PROGRESS→READY; READY→IN_PROGRESS; açık durumlar→CANCELLED). READY seçilirse masaüstündekiyle aynı **SMS uyarısı onayı**; CANCELLED seçilirse not alanı. Onay → `PATCH /api/work-orders/{id}/status` → başarıda badge + timeline güncellenir, hafif titreşim. 409 (`INVALID_STATUS_TRANSITION`, `ORDER_CLOSED`, `CONCURRENCY_CONFLICT`) durumunda kayıt otomatik yeniden yüklenip güncel durum gösterilmeli.

---

# 4. API Analizi

**Desktop'ın kullandığı tüm endpointler:** §1.9 tablosunda ekran bazında verildi. Özet küme: `auth/login`; `customers` CRUD + İYS; `categories` CRUD + tree + services; `service-types` CRUD; `service-prices` GET + bulk PUT; `consumable-groups`/`consumable-products` CRUD; `work-orders` CRUD + status + deliver + sms/resend; medya request-upload/confirm/list/delete (+ MinIO presigned PUT); `dashboard/summary`; `social-media/items`; `archive/*`; `admin/backups/latest`.

| Soru | Cevap |
|---|---|
| Dashboard hangi endpoint? | `GET /api/dashboard/summary` (tek uç; tüm KPI'lar tek DTO'da) |
| Status güncelleme? | `PATCH /api/work-orders/{id}/status` — gövde `{ newStatus, note? }`; DELIVERED bu uçtan **yasak** (409) |
| Teslim? | `POST /api/work-orders/{id}/deliver` — gövde `{ finalPaymentAmount }`; yalnızca READY'den |
| Barkod okutulunca? | Mevcutla: `GET /api/work-orders?search={orderNumber}&pageSize=1` → id → `GET /api/work-orders/{id}` |
| Ürün detay? | `GET /api/work-orders/{id}` → `WorkOrderResponse` |
| Status update (mobil)? | Aynı `PATCH .../status` — mobil için ek geliştirme gerekmez |

**Eksik endpointler / backend geliştirme ihtiyacı:**

1. **`GET /api/work-orders/by-number/{orderNumber}` (önerilen, küçük iş):** Barkod akışını tek istekle, kesin eşleşmeyle çözer. `search` ILIKE `%term%` kısmi eşleşme yaptığı için teorik olarak `WO-2026-00012` araması `...000120..129` kayıtlarını da döndürür; tam numara gönderildiğinde pratik risk düşük ama kesin uç temiz çözümdür. **Zorunlu değil — mevcut API ile feature çalışır.**
2. **Seri No / Model alanları (Feature 1 kararına bağlı):** `WorkOrder` entity + Create/Update DTO + migration + Flutter formu. Fiş bu alanları içerecekse backend geliştirmesi **gerekir**.
3. **Finans ayrıştırması (opsiyonel, Sorun 3):** `dashboard/summary`'den ciroyu ayırıp ayrı uca taşıma — yalnızca sunucu taraflı koruma istenirse.
4. Yazdırma için backend geliştirmesi **gerekmez** (fiş verisi `WorkOrderResponse`'ta tam; barkod istemcide üretilir).
5. `GET /api/auth/me` mevcut ve kullanılmıyor — açılış token doğrulaması için tüketilmesi önerilir (backend işi yok).

---

# 5. UI/UX Önerileri (Atölye Ortamı)

| Kriter | Öneri |
|---|---|
| Hızlı kullanım / min. tıklama | Mobil: FAB→tara→detay→durum = **3 dokunuş** hedefi. Masaüstü: detay sayfası aksiyon butonları zaten duruma-koşullu (iyi); fiş basma tek tık olmalı, yazıcı seçimi ayarlarda kalıcı. |
| Büyük butonlar / eldiven | Mobilde tüm dokunma hedefleri ≥ 56dp (Material minimumu 48dp'nin üstü); durum BottomSheet kartları tam genişlik, ~72dp; metin girişi mobilde neredeyse hiç istenmemeli (yalnızca iptal notu — o da opsiyonel). |
| Tek elle kullanım | Kritik aksiyonlar ekranın alt üçte birinde: FAB sağ alt, "Durumu Değiştir" alt sabit bar, BottomSheet doğal olarak alttan açılır. |
| Hızlı barkod okutma | Tarayıcı açılışı soğuk başlatmadan kaçınmalı (kamera controller'ı önceden ısıtma değerlendirilebilir); başarıda otomatik kapanış + titreşim; art arda okuma modu (detaydan "yeni tara" kısayolu). |
| Karanlık ortam uyumu | Mevcut tema **yalnızca açık** (`AppColors` sabitleri). Mobil kabuk için koyu tema (veya en azından tarayıcı ekranında koyu arayüz + torch) önerilir; `AppTheme`'in `ColorScheme` tabanlı dark varyantı orta vadeli iş. |
| Yüksek kontrast | Statü renkleri (badge) WCAG AA kontrast kontrolünden geçirilmeli; mobil detayda statü, renk + **ikon + metin** üçlüsüyle verilmeli (yalnız renge güvenme). |
| Fiş okunabilirliği | Termal fişte ≥ 24 nokta (≈3 mm) gövde yazısı, başlık çift yükseklik; barkod çevresinde sessiz bölge; fişler zamanla solar — kritik bilgiyi barkoda değil yazıya da koy. |

---

# 6. Risk Analizi

| Risk | Etki | Önlem/Çözüm |
|---|---|---|
| **API uyumsuzluğu** (tarih düzeltmesi vb.) | Create/Update kırılması | Sorun 1 düzeltmesi hem create hem update DTO'suna aynı anda uygulanmalı; `swagger_json` güncel sözleşme olarak testlere referans; entegrasyon smoke testi (gerçek backend'e karşı 1 create + 1 update). |
| **Yazıcı sürücü problemleri** | Fiş basılamıyor | RAW ESC/POS yolu sürücü grafik katmanını devre dışı bırakır; "test fişi" tanılama butonu; yazıcı adı ayarlanabilir; LAN varyantında 9100 fallback. Sürücüsüz makinelerde kurulum dokümanı (deploy/KURULUM.md'ye ek). |
| **Barkod standardı** | Okunamayan barkod | Code128-B, module ≥2 nokta, sessiz bölge ≥10 nokta, yükseklik ≥8 mm; farklı okuyucu/telefonla saha testi; insan-okur yedek metin her zaman basılır. |
| **Kamera izinleri** | Mobil akış tıkanır | Kalıcı red için ayarlara yönlendirme ekranı; izin akışı ilk kullanımda açıklamalı (pre-prompt); iOS `NSCameraUsageDescription` unutulmamalı. |
| **Offline senaryolar** | Uygulama tamamen online tasarlı (cache yok) | Faz kapsamında offline destek YOK kararı açıkça verilmeli; mobilde net "bağlantı yok" durum ekranı + retry; kritik akış (durum değişimi) kuyruğa alınmaz — çift kayıt riskinden kaçınmak için bilinçli. |
| **Network kesintileri** | Yarım kalan işlemler | Dio 15 sn timeout'ları mevcut; idempotan olmayan tek uç create — başarısızlıkta kullanıcıya "listeden kontrol et" yönlendirmesi; medya akışı zaten request/confirm iki fazlı (yarım yükleme PENDING kalır, `MaintenanceService` temizler). |
| **Aynı anda birden fazla cihaz** | Çakışan güncellemeler | Backend hazır: `UpdatedAt` concurrency token (PUT'ta 409 `CONCURRENCY_CONFLICT`), statü geçiş matrisi + `ORDER_CLOSED` (PATCH yarışında ikinci istek 409). İstemci tarafı eksik: 409 sonrası **otomatik yeniden yükleme** standardı tüm ekranlara yayılmalı (mobilde şart). |
| **Status çakışmaları** | Mobilde bayat ekrandan geçersiz geçiş | Geçiş matrisi istemcide de uygulanır (yanlış seçenek hiç gösterilmez) + 409'da detayı yeniden çek ve kullanıcıya güncel durumu göster. READY SMS'i backend'de idempotent (`smsOutbox.HasOrderReadyAsync`) — çift SMS riski yok. |
| **Performans** | Dashboard/list yavaşlığı | Sorgular indeksli ve sayfalı; asıl risk fiyat matrisinde her tuşta tüm liste rebuild'i (Sorun 4 çözümü bunu da giderir). Mobilde tarayıcı → detay geçişinde iki ardışık istek (search+detail) — by-number ucu ile teke iner. |
| **Güvenlik** | 30 günlük JWT'nin mobil cihazda taşınması; ciro görünürlüğü | Mobil cihaz kaybı senaryosu: token iptal mekanizması YOK (tek token, revocation listesi yok) — riski kabul et/dokümante et veya backend'e "logout-all/token version" eklemeyi orta vadeye al. Ciro: §Sorun 3 çözümü; fiş üzerindeki telefon için KVKK maskeleme kararı. Swagger prod'da `Swagger:Enabled` ile kapalı tutulmalı. |

---

# 7. Geliştirme Roadmap'i

> Her faz bağımsız bir feature branch olarak planlanmıştır; sıralama bağımlılıklara göredir.

### Phase 1 — Analiz *(bu doküman — tamamlandı)*
- **Yapılacaklar:** Bulguların ekiple doğrulanması; açık kararların kapatılması: (a) Seri No/Model alanları eklenecek mi, (b) mobilde teslim var mı, (c) XP-Q807K arabirim varyantı (USB/LAN), (d) ciro korumasında istemci-maskeleme yeterli mi.
- **Bağımlılık:** —  **Etki:** Sonraki tüm fazların kapsamı.  **Dikkat:** "Ek doğrulama gerekiyor" işaretli 5 madde kapanmadan Phase 5-7 başlamamalı.

### Phase 2 — Validation Fix (Sorun 1 + 2)
- **Yapılacaklar:** `DateOnlyConverter` + iki DTO'ya uygulanması + build_runner; formda `fieldErrors`'ın alan altına yansıtılması; create/update manuel + widget testi (tarihli/tarihsiz).
- **Bağımlılık:** Yok — hemen başlanabilir.  **Etki:** İş emri açma akışındaki üretim hatası kapanır; küçük, izole değişiklik.
- **Dikkat:** `updatedAt` serileştirmesine dokunma; edit modunda da regresyon testi yap; okuma yönü (`WorkOrderDto`) etkilenmemeli.

### Phase 3 — Price Matrix Fix (Sorun 4)
- **Yapılacaklar:** `_PriceRowField` StatefulWidget (controller + sabit key); cubit senkron stratejisi; virgül/ondalık input formatter; "görünen değer == gönderilen değer" widget testi.
- **Bağımlılık:** Yok.  **Etki:** Katalog fiyat girişi kullanılabilir hale gelir (şu an ~300 kombinasyonluk toplu giriş fiilen yapılamıyor).
- **Dikkat:** `saveAll()`'un `hasExistingPrice || isActive` filtresi korunmalı; kategori değişiminde controller'ların tazelenmesi.

### Phase 4 — Dashboard Security (Sorun 3)
- **Yapılacaklar:** `FinanceLockService` (PIN belirleme/doğrulama/oturum kilidi, hash + salt secure storage); Finans kartlarının maskeli varyantı; deneme sınırı; PIN sıfırlama akışı.
- **Bağımlılık:** Yok (Feature 2'de mobilde yeniden kullanılacağı için mobil kabuktan ÖNCE bitmesi ideal).  **Etki:** Dashboard + (karar verilirse) detay fiyat bloğu.
- **Dikkat:** Maskeleme yalnız görsel; `_isEmpty()` mantığı bozulmamalı; "istemci tarafı koruma" sınırı README/karar kaydına yazılmalı.

### Phase 5 — Desktop Barcode Printing (Sorun 5 + Feature 1)
- **Yapılacaklar:** ESC/POS komut katmanı + Windows RAW spooler servisi (`win32`/`ffi`); fiş şablonu (§3.1 düzeni); detay sayfasına "Barkod Oluştur" butonu; yazıcı seçimi/ayarlar; test fişi; CP857 Türkçe doğrulaması; gerçek cihazda saha testi.
- **Bağımlılık:** Phase 1 kararları (Seri No/Model → gerekiyorsa önce backend alanları + migration); yeni paketler bu fazda eklenir (`win32`, `ffi`, gerekirse `esc_pos_utils_plus`, barkod üretimi ESC/POS native komutla — ek paketa gerek kalmayabilir).
- **Dikkat:** Fişteki telefon maskeleme kararı; barkod içeriği `orderNumber` standardı Phase 6 ile **sözleşmedir** — sonradan değişmemeli.

### Phase 6 — Mobile Barcode Scanner (Feature 2)
- **Yapılacaklar:** `flutter create --platforms=android,ios`; platform-bazlı kabuk dallanması (`Platform.isAndroid/isIOS`) — pencere boyutuna göre ASLA; mobil Dashboard uyarlaması (pull-to-refresh, kart sadeleştirme, Phase 4 kilidi); FAB + `permission_handler` + `mobile_scanner`; orderNumber → detay çözümlemesi; (önerilir) backend `by-number` ucu.
- **Bağımlılık:** Phase 4 (finans kilidi ortak), Phase 5 (barkod içerik sözleşmesi). `media_kit`'in mobil derlemeye etkisi bu fazın başında çözülmeli.
- **Dikkat:** iOS kamera izin metinleri; Android `minSdk`; APK boyutu; tarayıcı ekranında torch + titreşim.

### Phase 7 — Mobile Status Update Screen (Feature 3)
- **Yapılacaklar:** Read-only mobil detay (alan listesi §3.3); durum geçmişi timeline'ı; "Durumu Değiştir" BottomSheet (geçiş matrisi + READY SMS onayı + iptal notu); 409'da otomatik yenileme; `tel:` ile arama.
- **Bağımlılık:** Phase 6 (tarayıcı bu ekrana açılır).  **Etki:** `PATCH /status` — backend değişikliği yok.
- **Dikkat:** Teslim kapsam kararı (Phase 1); fiyat bloğu gizleme; Düzenle yolunun mobilde hiç var olmaması.

### Phase 8 — Testing
- **Yapılacaklar:** Widget testleri (price matrix senkronu, form date serileştirme, PIN kilidi); entegrasyon smoke (login→create→status→deliver, gerçek backend/staging); barkod uçtan uca test (masaüstünde bas → mobille okut → detay açılıyor mu); backend `LeatherCare.IntegrationTests`'e by-number ucu testleri (eklendiyse).
- **Bağımlılık:** Phase 2-7.  **Dikkat:** Fiziksel test matrisi: XP-Q807K + en az 2 farklı Android cihaz + (varsa) iOS.

### Phase 9 — Bug Fix / Sertleştirme
- **Yapılacaklar:** Saha geri bildirimi; 409-yenileme standardının tüm ekranlara yayılması; go_router bypass düzeltmesi (§1.6); `auth/me` açılış doğrulaması; teknik borç listesinden (§1.10) düşük riskli kalemler.
- **Dikkat:** Bu fazda yeni feature alınmamalı; kapsam donmalı.

### Phase 10 — Release
- **Yapılacaklar:** Sürümleme (`pubspec` version bump); Windows dağıtımı + yazıcı kurulum dokümanı; Android APK/AAB imzalama (keystore süreci) ve dağıtım kanalı kararı (Play Store / yandan yükleme); prod `API_BASE_URL` dart-define doğrulaması; `Swagger:Enabled=false` kontrolü; rollback planı (masaüstü eski sürüm arşivi).
- **Dikkat:** Mobil + masaüstü aynı backend'i paylaşır — backend değişiklikleri (varsa by-number, Seri No) istemcilerden ÖNCE deploy edilmeli; eski masaüstü sürümleri yeni alanlardan etkilenmemeli (additive değişiklik prensibi).

---

## Ek: "Ek doğrulama gerekiyor" listesi (toplu)

1. Sorun 1 reprodüksiyonu: hata yalnızca tahmini teslim tarihi **seçiliyken** mi oluşuyor? (Sunucu logunda `$.estimatedDeliveryDate` beklenir.)
2. "Detay" alanının `existingDamages` olduğu varsayımı.
3. XP-Q807K'nin eldeki varyantının arabirimi (USB-only / LAN / seri).
4. Fişte Seri No ve Model isteniyor mu → backend alan ekleme kararı.
5. Mobilde teslim + tahsilat kapsam dışı mı?
6. Mobil minimum OS hedefleri (Android minSdk / iOS sürümü) ve dağıtım kanalı.
