# Deri Ürün Bakım/Onarım Takip Sistemi — Flutter Desktop Geliştirici Dokümantasyonu

> **Bu dokümanın amacı:** Backend kaynak kodunu hiç görmeden, yalnızca bu dokümanı kullanarak
> masaüstü (Flutter Desktop) admin uygulamasının TAMAMINI geliştirebilmenizi sağlamaktır.
> Backend ekibi tarafından geliştirilen sistemin istemci sözleşmesi (API contract) budur.

---

# 0. Sistem Genel Bakış ve API Standartları

## 0.1 Sistemin Tanımı

Sistem, bir deri ürün bakım/onarım atölyesinin operasyonunu yönetir:

- **Backend (Web API):** ASP.NET Core 8 · PostgreSQL 16 · MinIO (S3 uyumlu nesne depolama) · Nginx · NETGSM (SMS + İYS entegrasyonu). Backend ekibi tarafından geliştirilir ve işletilir.
- **Müşteri takip sayfası (`/t/{token}`):** SMS ile müşteriye giden linkin açtığı, backend içindeki tek Razor sayfası. **Bunu SİZ geliştirmezsiniz** — backend'in parçasıdır. Ancak sizin uygulamanızın yaptığı işlemler bu sayfayı etkiler (medya yükleme, durum değişikliği vb.), o yüzden davranışı bu dokümanda anlatılmıştır.
- **Masaüstü admin uygulaması (Flutter Desktop):** **SİZİN geliştireceğiniz uygulama.** API'yi JWT ile tüketen bir istemcidir. Tarayıcı olmadığı için CORS gerekmez ve backend'de CORS hiç eklenmemiştir.

**Faz 1 kapsamı DIŞINDA olanlar (uygulamada yer VERMEYİN):**
- Roller (tek ADMIN kullanıcı vardır, rol yönetimi ekranı yok)
- Usta ataması
- Teslim eden personel seçimi
- WhatsApp bildirimi
- Tamir/onarım hizmetleri (firma kararı ile sistemde YOKTUR — sadece Bakım, Boya, Bakım ve Boya gibi hizmetler vardır)
- QR ile teslim
- Video sıkıştırma / thumbnail üretimi
- Şifre sıfırlama e-postası (e-posta altyapısı yok)

## 0.2 Temel URL'ler ve Ortam

| Ne | Değer |
|---|---|
| API taban adresi | `https://domain.com/api/...` (kesin domain firma tarafından belirlenecek) |
| Müşteri takip sayfası | `https://domain.com/t/{token}` |
| Medya (MinIO presigned URL'leri) | `https://media.domain.com/...` |

- **Takip linki (`TrackingUrl`) her zaman backend'in `App:PublicBaseUrl` konfigürasyonundan üretilir** ve API response'larında hazır string olarak döner (`{base}/t/{token}`). İstemci link üretmez, dönen `trackingUrl` alanını olduğu gibi kullanır/gösterir.
- Nginx `client_max_body_size` API tarafında **2 MB**'tır. Bu bilinçlidir: **hiçbir medya dosyası API'den geçmez**; dosyalar presigned URL ile doğrudan `media.domain.com` (MinIO) adresine PUT edilir. Medya alt alan adında limit **500 MB**'tır. Yani API'ye asla dosya içeriği POST etmeyin.

## 0.3 Kimlik Doğrulama Standardı

- Login dışındaki tüm `/api/*` endpoint'leri (public takip endpoint'leri hariç) **JWT Bearer token** ister: `Authorization: Bearer {token}`.
- Token **tek ve uzun ömürlüdür: 30 gün**. Refresh token / rotation YOKTUR. `POST /api/auth/refresh` endpoint'i YOKTUR. Token süresi dolunca API 401 döner; uygulama kullanıcıyı yeniden login ekranına götürür. Bu basitlik bilinçli bir karardır (tek admin, tek istemci).
- JWT claim'leri: `sub` (user id), `email`, `role`. Clock skew 30 sn (default).

## 0.4 Hata Formatı (tüm ekranlarda ortak)

Backend, hataları **RFC 7807 `ProblemDetails`** formatında döner:

```json
{
  "type": "...",
  "title": "...",
  "status": 409,
  "detail": "Türkçe okunabilir hata mesajı",
  "errorCode": "INVALID_STATUS_TRANSITION"
}
```

- Validasyon hataları `ValidationProblemDetails` formatındadır: `errors` alanında **alan adı → mesaj listesi** map'i bulunur. Formlarda alan bazlı hata göstermek için bunu parse edin.
- İş kuralı ihlalleri **409** veya **422** döner; `detail` alanında Türkçe okunabilir mesaj, `errorCode` extension alanında makine tarafından okunabilir kod bulunur.

**Bilinen `errorCode` değerleri ve istemci davranışı (altın kural #3):**

| errorCode | Anlamı | İstemcinin yapması gereken |
|---|---|---|
| `DUPLICATE_PHONE` | Telefon başka müşteride kayıtlı | Create'te body'de dönen mevcut müşteriyle akışa devam et |
| `CODE_EXPIRED` | İYS kodunun süresi dolmuş | "Kodu yeniden gönder" öner |
| `CODE_LOCKED` | 3 yanlış deneme, kod kilitlendi | "Kodu yeniden gönder" öner |
| `NO_ACTIVE_CODE` | Aktif doğrulama kodu yok | "Kodu yeniden gönder" öner |
| `IYS_PENDING_CONFIRMATION` | SUBMITTED durumda resend denendi | "İYS teyidi bekleniyor" bilgisi göster |
| `ALREADY_CONSENTED` | APPROVED durumda resend denendi | "Onay zaten alınmış" bilgisi göster |
| `ORDER_CLOSED` | DELIVERED/CANCELLED iş emrinde değişiklik denendi | Ekranı salt-okunur görünüme çevir |
| `INVALID_STATUS_TRANSITION` | Geçersiz durum geçişi | İş emri listesini/detayını yenile (başka cihaz değiştirmiş olabilir) |
| `SERVICE_CATEGORY_MISMATCH` | Seçilen hizmet fiyatı başka ürün türüne ait | Katalog cache'ini yenile |
| `INVALID_CATALOG_ITEM` | Pasif/mevcut olmayan hizmet fiyatı veya sarf ürünü | Katalog cache'ini yenile |
| `INVALID_CATEGORY_LEVEL` | İş emrinde level=3 olmayan kategori gönderildi | Kategori seçimini düzelt (yalnızca ürün türü seçilebilir) |

## 0.5 Tarih/Saat ve Para Standartları

- DB ve API'de tüm zamanlar **UTC ISO 8601** formatındadır: `2026-07-13T14:30:00Z`. `DateOnly` alanlar `yyyy-MM-dd` formatındadır.
- **Türkiye saatine çevirme İSTEMCİNİN (sizin) işinizdir.** Ekranda tarih gösterirken UTC'den `Europe/Istanbul`'a çevirin. (Backend'in tek istisnası NETGSM'e giden İYS `consentDate` alanıdır, o backend içinde halledilir, sizi ilgilendirmez.)
- Para: **`decimal`**, tek para birimi **TRY**. Currency kolonu/alanı YOKTUR (bilinçli varsayım). JSON'da para **sayı** olarak gelir/gider (string değil). Gösterimde 2 hane, yuvarlama `MidpointRounding.AwayFromZero` mantığıyla (Dart'ta: yarımlar sıfırdan uzağa yuvarlanır).

## 0.6 Sayfalama Standardı

- Tüm listelerde: `page` (1 tabanlı, default 1), `pageSize` (default 20, **max 100**).
- Response zarfı her listede aynıdır:

```json
{ "items": [...], "page": 1, "pageSize": 20, "totalCount": 137 }
```

- Sıralama: tüm listeler `created_at DESC` sabittir. **Parametrik sıralama Faz 1'de YOKTUR** — tablolarınıza sıralanabilir kolon başlığı koymayın veya sadece istemci tarafında sıralayın.

## 0.7 Telefon Normalizasyonu ve Arama

- Backend tüm telefonları kayıtta **E.164**'e çevirir: `05XXXXXXXXX`, `5XXXXXXXXX`, `+905XXXXXXXXX`, `905XXXXXXXXX` girişlerinin hepsi kabul edilir ve `+905XXXXXXXXX` olarak saklanır.
- TR mobil olmayan numara **400** döner ("geçerli bir cep telefonu giriniz"). Formlarınızda da aynı ön kontrolü yapmanız önerilir (ama sunucu son sözü söyler).
- `search` parametresi davranışı: telefon araması normalizasyon sonrası **tam eşleşme + sondan-içerir** (`LIKE '%' || digits`); isim/marka araması `ILIKE '%term%'`. Türkçe İ/i farkı tolere edilir (mükemmellik hedeflenmez) — kullanıcı "bulamadım" derse büyük/küçük harf değiştirmesini önerin.

## 0.8 Genel API Davranış Kuralları

- **Silme yok:** Hiçbir kaynakta hard delete yoktur. Müşteri silme ve iş emri silme endpoint'i **bilinçli olarak tanımlanmamıştır** — uygulamanıza "Sil" butonu koymayın. Tek istisna: `media_files` fiziksel nesnesi (hatalı yükleme silme ve arşiv akışı).
- **Idempotency-Key yok (Faz 1):** Çift tıklama koruması **masaüstü istemcinin (sizin) sorumluluğunuzdur** — istek atılırken butonu disable edin. Bu, dokümante edilmiş bir istemci sözleşmesi maddesidir.
- **Optimistic concurrency:** `work_orders.updated_at` EF Core concurrency token'ıdır. Eşzamanlı iki güncellemede ikincisi **409** alır; istemci güncel veriyi çekip (GET detay) işlemi tekrar denemelidir.
- Public endpoint'lere IP bazlı rate limit uygulanır (detaylar ilgili feature'da).

## 0.9 Medya Format Sözleşmesi (İSTEMCİ SORUMLULUĞU — kritik)

Backend'in kabul ettiği formatlar **KESİN LİSTE**dir:

- **Foto:** `image/jpeg`, `image/png`. **HEIC REDDEDİLİR** (tarayıcılar render edemez). **Masaüstü uygulaması HEIC dosyayı yüklemeden önce JPEG'e çevirmekle yükümlüdür** — bu istemci sözleşmesine yazılmış bir maddedir.
- **Video:** YALNIZCA `video/mp4` (H.264). **`.mov`/HEVC REDDEDİLİR** (Chrome/Android oynatamaz). **İstemci MOV/HEVC dosyayı MP4'e çevirmekle yükümlüdür.**
- Boyut limitleri: video ≤ **500 MB**, foto ≤ **25 MB**. İş emri başına max **20 medya**.

> Not: `request-upload` aşamasında sunucu mime whitelist'i `video/mp4, video/quicktime, image/jpeg, image/png, image/heic` üzerinden kontrol eder; ancak §10.6'daki kesin karar gereği HEIC ve MOV pratikte REDDEDİLİR. Güvenli davranış: istemciden yalnızca `image/jpeg`, `image/png`, `video/mp4` gönderin; diğer her şeyi lokalde dönüştürün.

## 0.10 Deployment'ın İstemciyi Etkileyen Yönleri

- API, Nginx arkasında `https://domain.com` üzerinden sunulur (Let's Encrypt SSL). Sertifika sorunlarında (süresi dolmuş SSL) tüm istekler başarısız olur; istemci TLS hatasını "sunucuya ulaşılamıyor" olarak ele almalıdır.
- PostgreSQL ve MinIO dışarıya kapalıdır (yalnızca localhost) — istemci hiçbir zaman doğrudan DB'ye/MinIO yönetimine bağlanmaz. MinIO'ya erişim YALNIZCA uygulamanın ürettiği presigned URL'lerledir (PUT 10 dk, GET 15 dk, arşiv GET 2 saat ömürlü).
- Sunucu saati NTP ile senkron tutulur; istemci makinenin saati çok kayıksa presigned URL'ler "henüz geçerli değil / süresi dolmuş" hatası verebilir — kullanıcının bilgisayar saatini kontrol etmesini öneren bir hata mesajı hazırlayın.
- UFW: sunucuda yalnızca 22, 80, 443 portları açıktır. İstemci yalnızca 443 (HTTPS) kullanır.
- NETGSM ve MinIO anahtarları sunucu ortam değişkenlerindedir; istemcinin bunlara erişimi ve ihtiyacı yoktur.
- Admin şifresi unutulursa: e-posta altyapısı olmadığı için sunucuda SSH ile CLI komutu çalıştırılır: `dotnet LeatherCare.Web.dll reset-admin-password <email>` — yeni geçici şifre üretir. **Uygulamanıza "şifremi unuttum" ekranı KOYMAYIN**; login ekranına "Şifrenizi unuttuysanız sistem yöneticinizle iletişime geçin" notu yeterlidir.
- İlk admin kullanıcısı, backend ilk açılışta `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD` ortam değişkenlerinden, yalnızca `users` tablosu boşsa otomatik oluşturulur. Uygulamada "kayıt ol" ekranı YOKTUR.

## 0.11 Backend Arka Plan Servisleri (istemcinin bilmesi gerekenler)

Backend'de **tek** arka plan servisi (`MaintenanceHostedService`) üç zamanlanmış görevi yürütür. İstemci bunları TETİKLEMEZ, ama etkilerini ekranda gösterir:

1. **SMS gönderimi (outbox):** SMS'ler hiçbir zaman API isteği içinde gönderilmez; iş kuralı tetiklendiğinde `sms_logs` tablosuna `QUEUED` satır yazılır (iş verisiyle aynı transaction'da). Görev 5 saniyede bir, turda en fazla 10 QUEUED SMS'i `created_at` sırasıyla NETGSM'e gönderir; satır `SENT` (provider_msg_id=bulkid) veya `FAILED` (error_message) olur. NETGSM çağrısı: timeout 10 sn; ağ hatası/5xx'te 30 sn sonra 1 kez otomatik tekrar; ikinci başarısızlık = FAILED (admin `sms/resend` ile manuel dener).
2. **İYS teyidi:** 15 dakikada bir, `SUBMITTED` durumundaki müşteriler refid ile NETGSM `iys/search`'te sorgulanır → `APPROVED` veya `REJECTED`. 7 günden eski SUBMITTED kayıt otomatik `REJECTED` yapılır + warning log (İYS'de kaybolmuş demektir, admin süreci yeniden başlatır).
3. **Medya temizliği:** Günde 1 kez (03:00 TR), 24 saatten eski `upload_status = PENDING` medya satırları ve MinIO'daki yarım nesneler silinir.

**Frontend'in üç altın kuralı:**
1. **SMS, İYS teyidi ve temizlik tamamen backend'indir** — frontend yalnızca durumu gösterir, hiçbir zamanlamayı beklemez.
2. **Kategori ağacı bir kez çekilir, cache'lenir**; yalnızca katalog ekranında değişiklik yapılınca yenilenir.
3. **Tüm hatalar ProblemDetails + `errorCode`** — ekran dallanmaları koda göre yazılır (bkz. §0.4 tablosu).

## 0.12 Önerilen Genel Flutter Mimarisi

- **State management:** Riverpod (önerilen) veya Bloc. Tüm API çağrıları repository katmanında toplanır; ekranlar yalnızca state izler.
- **HTTP istemcisi:** `dio` — interceptor ile: (a) her isteğe `Authorization: Bearer` ekleme, (b) 401 yakalayınca login ekranına yönlendirme, (c) ProblemDetails parse edip tipli `ApiException(errorCode, detail, fieldErrors)` fırlatma.
- **Token saklama:** `flutter_secure_storage` (macOS Keychain / Windows Credential Manager). 30 gün geçerli olduğu için uygulama açılışında saklanan token varsa login atlanır; ilk korumalı istekte 401 gelirse login'e düşülür.
- **Model üretimi:** `freezed` + `json_serializable` ile bu dokümandaki tüm DTO'lar birebir modellenir. JSON alan adları camelCase gelir (`firstName`, `iysConsentStatus` ...).
- **Ortak liste zarfı:** `PagedResponse<T> { items, page, pageSize, totalCount }` generic modeli.
- **Navigasyon:** `go_router` veya masaüstüne uygun kalıcı sol menü (NavigationRail) + içerik alanı. Önerilen ana bölümler: Dashboard · Müşteri Karşılama (kabul sihirbazı) · İş Emirleri · Müşteriler · Katalog · Sosyal Medya · Arşiv & Yedek.

---

# 1. Feature: Kimlik Doğrulama (Auth)

## Amaç

Masaüstü admin uygulamasının API'ye erişebilmesi için tek admin kullanıcısının e-posta + şifre ile giriş yapıp 30 gün geçerli bir JWT alması. Faz 1'de rol yönetimi yoktur; sistemdeki tek rol `ADMIN`'dir ve tüm korumalı endpoint'ler bu token ile çağrılır.

## İşleyiş Akışı

1. Kullanıcı uygulamayı açar. Uygulama, güvenli depoda saklı token var mı bakar.
   - Token varsa doğrudan ana ekrana geçilir; ilk korumalı istekte 401 dönerse token silinir ve login ekranı gösterilir.
   - Token yoksa login ekranı gösterilir.
2. Kullanıcı e-posta ve şifresini girer, "Giriş" butonuna basar.
3. Uygulama `POST /api/auth/login` çağırır.
4. 200 dönerse `token` güvenli depoya yazılır; ana ekrana (Dashboard) geçilir.
5. Açılışta bir kez, paralel olarak şu çağrılar yapılır (Faz 0 açılış sözleşmesi):
   - `GET /api/dashboard/summary` → panel kartları
   - `GET /api/categories/tree` → kategori ağacı cache'lenir (ürün kabulünde beklenmesin diye)
   - `GET /api/work-orders?status=IN_PROGRESS` → aktif işler listesi
6. Token süresi dolunca (30 gün) herhangi bir istek 401 döner → uygulama kullanıcıyı yeniden login'e götürür; yeniden login yeni token verir.

## UI Gereksinimleri

- **Login sayfası:**
  - E-posta input (klavye tipi email, boş bırakılamaz)
  - Şifre input (gizli, göster/gizle ikonu)
  - "Giriş Yap" butonu — istek sürerken disable + spinner (çift tıklama koruması istemci sorumluluğudur)
  - Hata mesajı alanı: 401'de "E-posta veya şifre hatalı"; 429'da "Çok fazla deneme yaptınız, 1 dakika bekleyin"
  - "Şifrenizi unuttuysanız sistem yöneticinizle iletişime geçin" bilgi notu (şifre sıfırlama ekranı YOK — sunucuda SSH ile CLI komutu çalıştırılır)
- **Oturum düşme davranışı:** Herhangi bir ekranda 401 alınırsa global bir "Oturum süreniz doldu, lütfen tekrar giriş yapın" diyaloğu ve login'e yönlendirme.

## İş Kuralları

- JWT **tek, uzun ömürlü access token — 30 gün**. Refresh token / rotation YOK. `POST /api/auth/refresh` endpoint'i yoktur. Süresi dolunca yeniden login yeterlidir. Çok kullanıcı gelirse (Faz 2) refresh eklenecektir.
- Şifre hash'i backend'de ASP.NET Core Identity `PasswordHasher` (PBKDF2) iledir (istemciyi etkilemez; şifre düz metin olarak HTTPS üzerinden login body'sinde gönderilir).
- **Login rate limit:** IP başına dakikada **5 deneme**; aşımda **429**. Hesap kilitleme YOKTUR (tek admin kendini kilitlemesin diye bilinçli karar).
- İlk admin: backend açılışında `SEED_ADMIN_EMAIL` / `SEED_ADMIN_PASSWORD` ortam değişkenlerinden, yalnızca `users` tablosu boşsa oluşturulur. Tablo doluyken ikinci admin oluşturulmaz.
- JWT secret sunucuda `JWT_SIGNING_KEY` ortam değişkenindedir (min 64 byte random) — istemciyi ilgilendirmez.
- JWT claim'leri: `sub` (user id), `email`, `role`. Clock skew 30 sn.

## Veritabanı Modelleri

### `users`

Sistemdeki kullanıcıları tutar. Faz 1'de yalnızca tek ADMIN vardır. İş emirlerinde `created_by_user_id` ve durum loglarında `changed_by_user_id` bu tabloya FK'dır — yani "kim yaptı" bilgisinin kaynağıdır. Bu yüzden vardır: ileride roller eklendiğinde (Faz 2) tablo genişletilebilir.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | Kullanıcı kimliği |
| `full_name` | VARCHAR(150) NOT NULL | Ad soyad |
| `email` | VARCHAR(255) NOT NULL UNIQUE | Giriş e-postası |
| `password_hash` | TEXT NOT NULL | PBKDF2 hash |
| `role` | VARCHAR(20) NOT NULL DEFAULT 'ADMIN' | Faz 1'de hep ADMIN |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | Pasifleştirme bayrağı |
| `created_at` | TIMESTAMPTZ NOT NULL DEFAULT now() | Oluşturma zamanı |

## DTO'lar

### Request DTO'ları

**Login isteği** (dokümanda ayrı bir record tanımı verilmemiştir; sözleşme şudur):

```json
POST /api/auth/login
{ "email": "admin@firma.com", "password": "..." }
```

- Amaç: Admin'in kimlik bilgileriyle token alması.
- `email`: kayıtlı admin e-postası. `password`: düz metin şifre (HTTPS ile korunur).
- Kullanıldığı endpoint: `POST /api/auth/login`.

### Response DTO'ları

**Login yanıtı:**

```json
{ "token": "eyJhbGciOi..." }
```

- Amaç: 30 gün geçerli JWT'yi istemciye vermek.
- `token`: her isteğin `Authorization: Bearer {token}` başlığında gönderilir.
- Kullanıldığı endpoint: `POST /api/auth/login`.

## API Endpointleri

### `POST /api/auth/login`

- **HTTP Method:** POST
- **Endpoint:** `/api/auth/login`
- **Authentication:** Gerekmez (tek auth'suz admin endpoint'i budur)
- **Amaç:** Admin girişi → JWT üretimi.
- **Request DTO:** `{ email, password }`
- **Response DTO:** `{ token }` (30 gün geçerli)
- **Validation:** email ve password zorunlu.
- **Başarılı senaryo:** 200 + token. Token ile korumalı endpoint'ler 200 döner.
- **Hata senaryoları:**
  - 401 — yanlış e-posta/şifre
  - 429 — aynı IP'den dakikada 6. ve sonraki denemeler (rate limit)
- **Tetiklenen iş kuralları:** IP bazlı login rate limit sayacı.
- **Yan etkiler:** Yok (SMS/log tetiklenmez; standart istek logu hariç).

## Flutter Geliştirme Notları

- **Sayfa yapısı:** Tek `LoginPage`; başarılı girişte `Shell` (NavigationRail + içerik) yapısına geçiş.
- **State:** `authProvider` — durumlar: `unauthenticated`, `authenticating`, `authenticated(token)`, `sessionExpired`.
- **API çağrı sırası:** login → token'ı secure storage'a yaz → paralel açılış çağrıları (dashboard, categories/tree, work-orders?status=IN_PROGRESS).
- **Hata yönetimi:** 401 → alan üstü genel hata; 429 → geri sayımlı uyarı (60 sn). Dio interceptor'da global 401 → `sessionExpired`.
- **Form yönetimi:** `Form` + `TextFormField`; submit sırasında buton disable (Idempotency-Key olmadığı için çift istek koruması sizde).
- **Cache:** Token dışında bir şey saklamayın; kullanıcı bilgisi token claim'lerinden (email) okunabilir.

## Notlar

- CORS backend'de **hiç yoktur** — Flutter Desktop native HTTP kullandığı için sorun olmaz; ancak uygulamayı Flutter **Web**'e derlerseniz API çağrıları CORS'a takılır. Bu proje **Desktop** hedeflidir.
- Login isteğinde de HTTPS zorunludur; sertifika pinning gerekli görülmemiştir.
- Backend istek loglarında method, path, status ve süre tutulur; body loglanmaz. Telefonlar backend loglarında açık yazılır (iç sistem kararı) — istemciyi etkilemez.

---

# 2. Feature: Müşteri Yönetimi + İYS Onay Süreci

## Amaç

Atölyeye ürün bırakan müşterilerin kaydını tutmak, telefon/isimle aramak, güncellemek ve her müşteri için **İYS (İleti Yönetim Sistemi) ticari SMS onayı** toplamak.

Kritik ayrım: İYS izni, müşteriye giden **durum bilgilendirme SMS'leri için DEĞİL**, ilerideki **TİCARİ kampanya SMS'leri** için toplanır. Bilgilendirme SMS'leri (doğrulama kodu, "ürününüz alındı", "ürününüz hazır") mevzuat gereği onay gerektirmez ve İYS onayı olmayan müşteriye de gider. İYS süreci hiçbir ana akışı bloklamaz — kod doğrulanmamış (PENDING) müşteri için iş emri açılabilir, medya yüklenebilir, tüm durum SMS'leri normal gider.

İYS onay kodunu **backend üretir ve backend doğrular**; NETGSM yalnızca kodu SMS ile taşır ve doğrulama sonrası izni `iys/add` ile İYS'ye yükler.

## İşleyiş Akışı

### Müşteri karşılama (kabul sihirbazının 1. fazı)

1. Admin, müşteri karşılama ekranında telefon numarasını arama kutusuna yazar.
2. Uygulama `GET /api/customers?search=05321234567` çağırır.
   - **items dolu:** Müşteri kartı + geçmiş iş emirleri gösterilir → ürün kaydı fazına geçilir.
   - **items boş:** Hızlı kayıt formu açılır.
3. Admin formu doldurur (ad, soyad, telefon zorunlu; e-posta, adres opsiyonel), "Kaydet" der.
4. Uygulama `POST /api/customers` çağırır.
   - 201: `{ customer (iysConsentStatus=PENDING), iysCodeExpiresAt }` döner. **Kayıt oluşur oluşmaz backend otomatik olarak 4 haneli İYS kodunu üretir (hash + 5 dk expiry ile DB'ye yazar) ve NETGSM SMS kuyruğuna ekler (filter=0).** Frontend SMS için HİÇBİR ŞEY yapmaz.
   - 409 `DUPLICATE_PHONE`: body'de mevcut müşterinin `CustomerResponse`'u döner → uygulama doğrudan o müşteriyle devam eder (kullanıcıya "Bu numara zaten kayıtlı: Ayşe Yılmaz — bu müşteriyle devam ediliyor" bildirimi).
5. Ekranda kod giriş kutusu + `iysCodeExpiresAt`'e göre geri sayım gösterilir.
6. Müşterinin telefonuna kod gelir; müşteri kodu sözlü söyler; admin kutuya girer.
7. Uygulama `POST /api/customers/{id}/iys/confirm { code }` çağırır.
   - 200: `{ iysConsentStatus: "SUBMITTED" }` — backend NETGSM `iys/add` çağrısını yapmıştır; SUBMITTED→APPROVED geçişini arka plan görevi halleder, **istemci BEKLEMEZ**, akışa devam eder.
   - 400 `CODE_EXPIRED` / `CODE_LOCKED` / `NO_ACTIVE_CODE`: "Kodu yeniden gönder" önerilir.
8. Kod gelmediyse/süresi dolduysa admin "Kodu yeniden gönder" butonuna basar → `POST /api/customers/{id}/iys/resend-code` (rate limitli: 60 sn'de 1, günde max 5).
9. Müşteri onay vermek istemiyorsa **"ATLA" butonu** vardır — akış bloklanmaz, müşteri PENDING kalır, ürün kaydına geçilir.

### İYS'nin arka plandaki devamı (istemci tetiklemez, sadece gösterir)

1. `confirm` başarılı olunca backend NETGSM `iys/add` çağırır: `{ type: "MESAJ", source: "HS_MESAJ", recipient: "+905XX...", status: "ONAY", consentDate: (Türkiye saatiyle "yyyy-MM-dd HH:mm:ss"), recipientType: "BIREYSEL", refid: "cust-{customerId}-{unixtime}" }` → müşteri `SUBMITTED`, `iys_reference_id` = refid.
2. İYS'ye yükleme asenkron başarısız olabilir; webhook YOKTUR. Backend'in arka plan görevi 15 dakikada bir SUBMITTED müşterileri refid ile `iys/search`'te sorgular:
   - `resultstatus=success` → `APPROVED` + `iys_consent_at` dolar
   - failure → `REJECTED` + errcode/errmsg loglanır
   - 7 gün SUBMITTED kalan kayıt otomatik `REJECTED` + warning log (İYS'de kaybolmuş demektir, admin süreci yeniden başlatır: resend-code REJECTED'da tekrar çalışır).
3. İstemci, müşteri detayını her açtığında güncel `iysConsentStatus`'u görür; ayrıca müşteri e-Devlet/0800 üzerinden reddedebilir ve bizim kayıtlar bunu anlık bilmez — kesin güvence, ticari SMS gönderiminde NETGSM'in kendi İYS filtresidir (`filter=11`); bizdeki durum yalnızca hedef listesi seçiminde kullanılır.

### Müşteri güncelleme

1. Admin müşteri detayında "Düzenle" der, formu değiştirir, kaydeder → `PUT /api/customers/{id}`.
2. `PUT` **tam replace** semantiğidir: `email`/`address` null gönderilirse alan DB'de TEMİZLENİR. Ad/soyad/telefon her zaman zorunludur.
3. **Telefon değişirse zincirleme etkiler (backend otomatik yapar):**
   - `iys_consent_status` PENDING'e döner; aktif doğrulama kodları geçersiz olur; yeni numaraya otomatik yeni kod SMS'i gider (kayıt akışıyla aynı yol). UI yeniden kod giriş ekranını göstermelidir.
   - Müşterinin **AÇIK** (DELIVERED/CANCELLED olmayan) iş emirlerinin `tracking_token`'ları yeniden üretilir — yanlış numaraya gitmiş eski linkler anında ölür. Kapalı iş emirlerinin token'ı değişmez.
   - Açık iş emirleri için yeni linkli `ORDER_RECEIVED` SMS'i tekrar kuyruğa girer (bu senaryoda SMS idempotency'si bilinçli olarak baypas edilir).
4. Telefon başka müşteride kayıtlıysa → 409 `DUPLICATE_PHONE`.

## UI Gereksinimleri

- **Müşteri arama / karşılama ekranı:**
  - Büyük arama kutusu (telefon veya isim; debounce ~400 ms)
  - Sonuç listesi/tablosu: Ad Soyad, Telefon, İYS durumu rozeti, kayıt tarihi; satıra tıklayınca detay
  - Sonuç boşsa "Müşteri bulunamadı — Yeni Kayıt" butonu
  - Sayfalama (`page`, `pageSize` — default 20, max 100)
- **Yeni müşteri formu (modal veya sağ panel):**
  - Ad (zorunlu), Soyad (zorunlu), Telefon (zorunlu — maske: `05XX XXX XX XX`; kabul edilen girişler: `05XXXXXXXXX`, `5XXXXXXXXX`, `+905XXXXXXXXX`, `905XXXXXXXXX`), E-posta (opsiyonel, format kontrolü), Adres (opsiyonel, çok satırlı)
  - "Kaydet" butonu — istek sürerken disable
  - Validation mesajları: alan bazlı (400 `ValidationProblemDetails`'ten); telefon için "geçerli bir cep telefonu giriniz"
  - 409 `DUPLICATE_PHONE` durumunda bilgi bandı: "Bu numara kayıtlı — mevcut müşteriyle devam ediliyor"
- **İYS kod doğrulama paneli (kayıttan hemen sonra veya müşteri detayında):**
  - 4 haneli kod girişi (tek karakterlik 4 kutu veya tek input)
  - `iysCodeExpiresAt`'e göre geri sayım sayacı (5 dk)
  - "Doğrula" butonu; kalan deneme uyarısı (3 hak)
  - "Kodu yeniden gönder" butonu — 60 sn cooldown göstergesi; günde max 5 bilgisi
  - "Atla" butonu (İYS süreci akışı bloklamaz)
  - Hata mesajları: `CODE_EXPIRED` → "Kodun süresi doldu, yeniden gönderin"; `CODE_LOCKED` → "3 kez yanlış girildi, yeniden kod isteyin"; `NO_ACTIVE_CODE` → "Aktif kod yok, yeniden gönderin"; `IYS_PENDING_CONFIRMATION` → "İYS teyidi bekleniyor"; `ALREADY_CONSENTED` → "Onay zaten alınmış"
  - Başarı mesajı: "Kod doğrulandı, İYS'ye iletildi (teyit bekleniyor)"
- **Müşteri detay sayfası:**
  - Kişi bilgileri kartı + "Düzenle" butonu
  - İYS durumu rozeti: PENDING (gri), SUBMITTED (sarı — "teyit bekleniyor"), APPROVED (yeşil), REJECTED (kırmızı) + `iysConsentAt` tarihi
  - REJECTED/PENDING'de "Kodu yeniden gönder" aksiyonu
  - Geçmiş iş emirleri tablosu (GET `/api/customers/{id}` detayı ile gelir): iş emri no, ürün, durum, fiyat, tarih
- **Müşteri düzenleme formu:** Yeni kayıt formuyla aynı alanlar; telefon değişikliğinde onay diyaloğu: "Telefon değiştirilirse İYS onayı sıfırlanır, açık iş emirlerinin takip linkleri yenilenir ve müşteriye yeni SMS gönderilir. Devam edilsin mi?"
- **Loading:** arama ve form gönderiminde spinner; success snackbar'ları ("Müşteri kaydedildi", "Kod gönderildi").

## İş Kuralları

- **SMS sınıflandırması (kritik):** İki tür SMS var ve İYS ile ilişkileri farklı:
  - **Bilgilendirme SMS'leri** (`IYS_VERIFICATION_CODE`, `ORDER_RECEIVED`, `ORDER_READY`): verilen hizmete ilişkin durum bildirimleridir, mevzuat gereği onay aranmaz. NETGSM'e `filter=0` ile gönderilir, İYS kontrolü yapılmaz. **İYS onayı olmayan müşteriye de gider** — akış hiçbir zaman İYS'ye takılmaz. Şart: içerik gerçekten bilgilendirme olmalıdır (durum + takip linki; kampanya/promosyon ASLA eklenmez, yoksa ticari sayılır).
  - **Ticari SMS'ler** (`CAMPAIGN` — ileride): `filter=11` (bireysel) ile gönderilir ve yalnızca `iys_consent_status = APPROVED` müşterilere gider. İYS izni tam olarak bunun için şimdiden toplanır ve saklanır.
- **İYS onay akışı (adım adım):**
  1. `POST /api/customers` ile kayıt oluşur oluşmaz (aynı transaction sonrası) sistem otomatik 4 haneli kod üretir, DB'ye hash + 5 dk expiry yazar.
  2. Kod NETGSM SMS API'siyle gönderilir (filter=0, bilgilendirme).
  3. Müşteri kodu sözlü söyler → Admin girer → backend DB'den doğrular (max 3 deneme).
  4. Doğruysa NETGSM `iys/add` çağrılır → `iys_consent_status = SUBMITTED`, `iys_reference_id` = refid.
  5. Sonuç teyidi: arka plan görevi refid ile `iys/search` sorgular (webhook YOK — tek mekanizma) → success → APPROVED + `iys_consent_at`; failure → REJECTED + errcode/errmsg loglanır.
- **İYS asla bloklamaz:** `iys_consent_status = PENDING` müşteri için iş emri açılabilir, medya yüklenebilir, tüm durum SMS'leri (filter=0) normal gider. Kod ne zaman doğrulanırsa o zaman İYS'ye yüklenir; süreç tamamen paraleldir.
- **Kod yaşam döngüsü (tam kurallar):**
  - Aktif kod = doğrulanmamış + süresi geçmemiş en SON kod.
  - `resend-code` yeni kod üretir ve **önceki tüm aktif kodları geçersiz kılar** (expires_at = now).
  - `confirm`: yanlış kod → `attempt_count++`; 3. yanlıştan sonra kod geçersiz (400 `CODE_LOCKED`, resend gerekir). Süresi dolmuş kod → 400 `CODE_EXPIRED`. Aktif kod hiç yok → 400 `NO_ACTIVE_CODE`.
  - `resend-code` yalnızca `iys_consent_status ∈ {PENDING, REJECTED}` iken çalışır; SUBMITTED'da 409 `IYS_PENDING_CONFIRMATION` (teyit bekleniyor), APPROVED'da 409 `ALREADY_CONSENTED`.
  - `resend-code` rate limitlidir: **60 saniyede 1, günde max 5**.
  - Müşteri telefonu değişince: `iys_consent_status = PENDING`'e döner, aktif kodlar geçersiz olur, yeni numaraya otomatik yeni kod gider (kayıt akışıyla aynı yol).
- **Duplicate telefon:** `POST /api/customers` mevcut numarayla çağrılırsa 500 değil **409 Conflict + mevcut müşterinin `CustomerResponse`'u** döner; istemci doğrudan o müşteriyle devam eder. `PUT`'ta da telefon başka müşterideyse 409 `DUPLICATE_PHONE` (ama PUT mevcut müşteri body'si döndürmez). Unique ihlali DB'den yakalanır (23505) — "önce SELECT et" race'ine güvenilmez.
- **Telefon düzeltmesi = token yenileme:** Telefon güncellenince o müşterinin AÇIK (DELIVERED/CANCELLED olmayan) iş emirlerinin `tracking_token`'ları yeniden üretilir — yanlış numaraya gitmiş eski linkler anında ölür. Yeni numaraya güncel linkle ORDER_RECEIVED SMS'i tekrar gönderilir (idempotency bu senaryoda baypas edilir).
- **PUT tam replace:** `email`/`address` null gelirse alan TEMİZLENİR; first/last/phone her zaman zorunlu.
- **Telefon normalizasyonu:** Tüm girişler E.164 `+905XXXXXXXXX` olarak saklanır; TR mobil dışı numara 400.
- **İYS ret her an gelebilir:** Müşteri e-Devlet/0800 üzerinden reddedebilir; kayıtlar bunu anlık bilmez. Ticari SMS'te `filter=11` kullanılır — İYS kontrolünü NETGSM gönderim anında kendisi yapar ve reddetmiş aboneye iletmez; bizdeki `iys_consent_status` yalnızca hedef listesi seçiminde kullanılır.
- **7 gün kuralı:** 7 gün SUBMITTED kalan kayıt arka plan görevince REJECTED'a çekilir + warning log.
- Müşteri silme endpoint'i YOKTUR (bilinçli karar).

## Veritabanı Modelleri

### `customers`

Müşteri ana kaydı. İş emirleri (`work_orders.customer_id`) ve SMS logları (`sms_logs.customer_id`) buna bağlanır. İYS onay durumunu ve referansını da bu tablo taşır — ayrı tablo yerine müşteri üstünde tutulması, "bu müşteriye ticari SMS atılabilir mi" sorusunun tek sorguda cevaplanması içindir.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | Müşteri kimliği |
| `first_name` | VARCHAR(100) NOT NULL | Ad |
| `last_name` | VARCHAR(100) NOT NULL | Soyad |
| `phone` | VARCHAR(20) NOT NULL UNIQUE | `+90` formatına normalize edilmiş telefon |
| `email` | VARCHAR(255) NULL | E-posta |
| `address` | TEXT NULL | Adres |
| `iys_consent_status` | VARCHAR(20) NOT NULL DEFAULT 'PENDING' | PENDING: onay süreci başlamadı / kod doğrulanmadı · SUBMITTED: kod doğrulandı, iys/add çağrıldı, İYS teyidi bekleniyor · APPROVED: İYS teyidi geldi (iys/search) → ticari SMS gönderilebilir · REJECTED: İYS reddetti veya müşteri ret verdi |
| `iys_consent_at` | TIMESTAMPTZ NULL | APPROVED olduğu an |
| `iys_reference_id` | VARCHAR(100) NULL | iys/add'e gönderilen refid (`cust-{customerId}-{unixtime}`) |
| `created_at` / `updated_at` | TIMESTAMPTZ NOT NULL | Zaman damgaları |

İndeksler: `idx_customers_phone (phone)`, `idx_customers_name (first_name, last_name)` — arama performansı için.

### `customer_verification_codes`

İYS onay kodlarını tutar. **Kod backend'de üretilir ve doğrulanır; NETGSM sadece SMS'i taşır** — bu tablo o yüzden vardır: kodun sahibi biziz, düz metin tutulmaz (hash), deneme sayısı ve süre burada denetlenir.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `customer_id` | BIGINT NOT NULL FK → customers | Kodun ait olduğu müşteri |
| `code_hash` | TEXT NOT NULL | 4 haneli kodun hash'i (düz metin tutulmaz) |
| `expires_at` | TIMESTAMPTZ NOT NULL | Üretimden +5 dk |
| `attempt_count` | SMALLINT NOT NULL DEFAULT 0 | Max 3 deneme |
| `verified_at` | TIMESTAMPTZ NULL | Doğrulanınca dolar |
| `created_at` | TIMESTAMPTZ NOT NULL | |

İndeks: `idx_cvc_customer (customer_id)`. İlişki: bir müşterinin birden çok kod kaydı olabilir (her resend yeni satır); aktif olan, doğrulanmamış + süresi geçmemiş en SON koddur.

## DTO'lar

### Request DTO'ları

```csharp
public record CreateCustomerRequest(
    string FirstName, string LastName, string Phone,
    string? Email, string? Address);
```
- **Amaç:** Yeni müşteri kaydı.
- **Property'ler:** `FirstName`/`LastName` zorunlu ad-soyad; `Phone` zorunlu, 4 formattan biri kabul, E.164'e normalize edilir; `Email`/`Address` opsiyonel.
- **Endpoint:** `POST /api/customers`.

```csharp
public record UpdateCustomerRequest(
    string FirstName, string LastName, string Phone,
    string? Email, string? Address);
```
- **Amaç:** Müşteri güncelleme (tam replace).
- **Property'ler:** Create ile aynı; `Email`/`Address` null gelirse alan DB'de temizlenir.
- **Endpoint:** `PUT /api/customers/{id}`.

```csharp
public record IysConfirmRequest(string Code);
```
- **Amaç:** Müşterinin sözlü söylediği 4 haneli kodun doğrulanması.
- **Property:** `Code` — 4 haneli kod.
- **Endpoint:** `POST /api/customers/{id}/iys/confirm`.

### Response DTO'ları

```csharp
public record CustomerResponse(
    long Id, string FirstName, string LastName, string Phone,
    string? Email, string? Address,
    string IysConsentStatus, DateTime? IysConsentAt, DateTime CreatedAt);
```
- **Amaç:** Müşteri verisinin standart gösterimi.
- **Alanlar:** `Phone` normalize `+905...` gelir; `IysConsentStatus` ∈ {PENDING, SUBMITTED, APPROVED, REJECTED}; `IysConsentAt` APPROVED anı (UTC).
- **Endpoint'ler:** `GET /api/customers` (liste elemanı), `GET /api/customers/{id}`, `PUT /api/customers/{id}`, 409 DUPLICATE_PHONE body'si; ayrıca `WorkOrderResponse.Customer` içinde gömülü.

```csharp
public record CreateCustomerResponse(
    CustomerResponse Customer,
    DateTime IysCodeExpiresAt);
```
- **Amaç:** Kayıt yanıtı — kod otomatik gönderildiği için expiry bilgisi de döner; UI geri sayım gösterebilir.
- **Endpoint:** `POST /api/customers` (201).

```csharp
public record IysResendCodeResponse(long CustomerId, DateTime ExpiresAt);
```
- **Amaç:** Yeniden gönderilen kodun yeni geçerlilik süresini bildirmek (geri sayım için).
- **Endpoint:** `POST /api/customers/{id}/iys/resend-code`.

```csharp
public record IysConfirmResponse(
    string IysConsentStatus,    // SUBMITTED (iys/add çağrıldı, teyit bekleniyor)
    string? IysReferenceId);    // iys/add'e gönderilen refid
```
- **Amaç:** Kod doğrulama sonucu.
- **Endpoint:** `POST /api/customers/{id}/iys/confirm`.

`GET /api/customers/{id}` detay yanıtı, `CustomerResponse` + o müşterinin geçmiş iş emirlerini içerir (iş emri liste kalemleri — `WorkOrderListItemResponse` yapısında; bkz. İş Emri feature'ı).

## API Endpointleri

### `POST /api/customers`

- **Method/Endpoint:** POST `/api/customers`
- **Auth:** Evet (JWT)
- **Amaç:** Müşteri kaydı. Kayıt anında **otomatik**: 4 haneli İYS kodu üretilir (hash + 5 dk expiry) ve NETGSM SMS kuyruğuna eklenir (filter=0).
- **Request DTO:** `CreateCustomerRequest`
- **Response DTO:** `CreateCustomerResponse` (201)
- **Validation:** ad, soyad, telefon zorunlu; telefon TR mobil format (aksi 400); e-posta varsa format.
- **Başarılı senaryo:** 201; DB'de telefon `+905...` normalize; response'ta `iysCodeExpiresAt` dolu; `sms_logs`'ta `IYS_VERIFICATION_CODE` QUEUED satırı oluşmuş olur.
- **Hata senaryoları:** 400 (validasyon / geçersiz telefon), 409 `DUPLICATE_PHONE` (+ body'de mevcut müşteri `CustomerResponse`).
- **Tetiklenen iş kuralları:** kod üretimi + hash'leme + 5 dk expiry; duplicate telefon DB unique'inden yakalanır.
- **Yan etkiler:** `IYS_VERIFICATION_CODE` SMS'i kuyruğa yazılır (outbox); `customer_verification_codes` satırı oluşur.

### `GET /api/customers?search=&page=&pageSize=`

- **Method/Endpoint:** GET `/api/customers`
- **Auth:** Evet
- **Amaç:** Telefon/isim ile müşteri arama + sayfalı liste.
- **Request:** query — `search` (telefon: normalize + tam eşleşme + sondan-içerir; isim: ILIKE '%term%'), `page` (default 1), `pageSize` (default 20, max 100).
- **Response:** `{ items: CustomerResponse[], page, pageSize, totalCount }`, `created_at DESC`.
- **Başarılı senaryo:** 200; eşleşme yoksa boş `items`.
- **Hata senaryoları:** 401 (token yok/geçersiz).
- **Yan etkiler:** Yok.

### `GET /api/customers/{id}`

- **Method/Endpoint:** GET `/api/customers/{id}`
- **Auth:** Evet
- **Amaç:** Müşteri detayı + geçmiş iş emirleri.
- **Response:** `CustomerResponse` + iş emri geçmişi listesi.
- **Hata senaryoları:** 404 (yok), 401.
- **Yan etkiler:** Yok.

### `PUT /api/customers/{id}`

- **Method/Endpoint:** PUT `/api/customers/{id}`
- **Auth:** Evet
- **Amaç:** Müşteri güncelleme (tam replace). **Telefon değişirse İYS süreci sıfırlanır → yeni kod otomatik gider.**
- **Request DTO:** `UpdateCustomerRequest`
- **Response DTO:** `CustomerResponse`
- **Validation:** ad/soyad/telefon zorunlu; telefon TR mobil; `email`/`address` null = alanı temizle.
- **Başarılı senaryo:** 200 + güncel müşteri.
- **Hata senaryoları:** 400 (validasyon), 404, 409 `DUPLICATE_PHONE` (telefon başka müşteride).
- **Tetiklenen iş kuralları (telefon değiştiyse):** (a) `iys_consent_status` → PENDING, (b) eski aktif kodlar geçersiz, (c) yeni koda ait QUEUED SMS oluşur, (d) müşterinin AÇIK iş emirlerinin `tracking_token`'ları yeniden üretilir (kapalıların değişmez), (e) açık iş emirleri için yeni linkli ORDER_RECEIVED SMS'i kuyruğa girer (idempotency baypas).
- **Yan etkiler:** yukarıdaki SMS kuyruklamaları; `updated_at` güncellenir.

### `POST /api/customers/{id}/iys/resend-code`

- **Method/Endpoint:** POST `/api/customers/{id}/iys/resend-code`
- **Auth:** Evet
- **Amaç:** Kodu YENİDEN göndermek (SMS gelmedi / süresi doldu). Yeni kod üretir, **önceki tüm aktif kodları geçersiz kılar**.
- **Request:** body yok.
- **Response DTO:** `IysResendCodeResponse` (yeni `ExpiresAt` ile geri sayım tazelenir).
- **Validation/kısıtlar:** rate limit **60 sn'de 1, günde max 5**; yalnızca `iys_consent_status ∈ {PENDING, REJECTED}`.
- **Başarılı senaryo:** 200 + yeni expiry.
- **Hata senaryoları:** 409 `IYS_PENDING_CONFIRMATION` (SUBMITTED iken), 409 `ALREADY_CONSENTED` (APPROVED iken), 429 (rate limit), 404.
- **Yan etkiler:** yeni `customer_verification_codes` satırı; `IYS_VERIFICATION_CODE` SMS kuyruğa.

### `POST /api/customers/{id}/iys/confirm`

- **Method/Endpoint:** POST `/api/customers/{id}/iys/confirm`
- **Auth:** Evet
- **Amaç:** Kodu DB'den doğrulamak (max 3 deneme) → başarılıysa NETGSM `iys/add` çağrısı → status=SUBMITTED.
- **Request DTO:** `IysConfirmRequest { Code }`
- **Response DTO:** `IysConfirmResponse { IysConsentStatus: "SUBMITTED", IysReferenceId }`
- **Validation:** aktif kod olmalı; kod eşleşmeli; deneme ≤ 3; süre dolmamış olmalı.
- **Başarılı senaryo:** 200; `iys/add` çağrılmıştır (source=HS_MESAJ, recipientType=BIREYSEL, consentDate Türkiye saatiyle); müşteri SUBMITTED, refid kaydedilir. APPROVED teyidini arka plan halleder — istemci beklemez.
- **Hata senaryoları:** 400 `CODE_EXPIRED` (süre dolmuş), 400 `CODE_LOCKED` (3. yanlış deneme sonrası — doğru kod bile artık reddedilir, resend gerekir), 400 `NO_ACTIVE_CODE` (aktif kod yok), 400 (yanlış kod, deneme sayacı artar), 404.
- **Tetiklenen iş kuralları:** attempt_count yönetimi; İYS'ye yükleme.
- **Yan etkiler:** NETGSM `iys/add` HTTP çağrısı; `iys_reference_id` yazılır; dönen `uid` ham olarak loglanır (ayrı kolon yok, refid bizim anahtarımızdır).

## Flutter Geliştirme Notları

- **Sayfa yapısı:** `CustomersPage` (arama + tablo) → `CustomerDetailPage` (bilgi kartı + İYS paneli + geçmiş işler). Karşılama sihirbazında müşteri adımı aynı widget'ları modal/step içinde yeniden kullanır.
- **State:** `customerSearchProvider(query, page)` (family), `customerDetailProvider(id)`. Kod doğrulama paneli kendi küçük state'ini tutar (kalan süre, cooldown).
- **Geri sayım:** `iysCodeExpiresAt` (UTC) ile lokal saat farkından `Timer.periodic` sayacı; süre bitince "Doğrula" disable, "Yeniden gönder" öne çıkar. Resend cooldown'u (60 sn) client-side da uygulayın; 429 gelirse sayacı sunucu cevabına göre tazeleyin.
- **DUPLICATE_PHONE akışı:** dio interceptor'ında 409 + `DUPLICATE_PHONE` özel işlenir — response body'deki `CustomerResponse` parse edilip akışa "mevcut müşteri" olarak enjekte edilir. Bu, karşılama sihirbazının kırılmaması için kritiktir.
- **Telefon input:** maske + normalize önizleme; gönderirken maskesiz gönderin (backend normalize eder).
- **Liste yenileme:** `confirm`/`resend` sonrası müşteri detayını yeniden çekin (İYS rozetini tazelemek için). SUBMITTED→APPROVED geçişi arka planda 15 dk'ya kadar sürebilir; ekranda "teyit bekleniyor" rozetiyle bırakın, POLL ETMEYİN (kullanıcı detayı tekrar açınca güncellenir).
- **Cache:** Müşteri listesi cache'lenmez (arama odaklı); detay ekranı her açılışta taze çekilir.

## Notlar

- İYS/SMS'in çalışması için firma ön koşulları (backend tarafı, bilgi amaçlı): firmanın İYS'ye hizmet sağlayıcı kaydı + brandCode, NETGSM iş ortağı yetkilendirmesi, NETGSM API erişimi (kullanıcı/şifre + appkey, VDS IP whitelist), onaylı SMS başlığı (msgheader). Bunlar yoksa test ortamında SMS'ler FAILED düşer — istemci bu durumu SMS durum rozetlerinde gösterebilmelidir.
- İYS kod SMS şablonu (backend config): `"{code} kodu ile İYS onayınızı tamamlayabilirsiniz. {firma}"` — kesin metin firmadan gelecek, yalnızca backend config değişir; istemciyi etkilemez.
- `iys/add` çağrısında `consentDate` **Türkiye saatiyle** (`Europe/Istanbul`, `yyyy-MM-dd HH:mm:ss`) gönderilir — UTC gönderilirse izin 3 saat geçmişe düşer. Bu tamamen backend işidir; burada bilinçli tasarım kararı olarak not edilmiştir.
- Doğrulama kodunun kendisi hiçbir response'ta dönmez (yalnızca müşterinin telefonuna gider); admin kodu müşteriden sözlü alır.

---

# 3. Feature: Katalog Yönetimi (Kategori Ağacı + Hizmet Türleri + Fiyat Matrisi + Sarf Malzemeler)

## Amaç

Fiyatlandırmanın temelini oluşturan katalog verisini yönetmek. Fiyatlandırma modeli (Hizmetler.pdf'e göre — **kesin model**) 4 seviyeli seçim akışıdır:

```
Ana Kategori → Ürün Grubu → Ürün Türü → Hizmet Türü → Fiyat otomatik gelir
Kadın       → Ayakkabı    → Sneakers  → Bakım ve Boya → 1.250 TL
```

- Hizmet türleri (Bakım, Boya, Bakım ve Boya) **koda sabit yazılmaz** — admin CRUD'lu bir tablodur.
- Aynı hizmetin fiyatı ürün türüne göre değişir → fiyat, **(ürün türü × hizmet) matrisidir** (Sneakers Boya ≠ Deri Mont Boya).
- **Tamir/onarım hizmeti sistemde YOKTUR** (firma kararı) — katalogda böyle bir hizmet tanımlanmaz.
- **Sarf malzemeler** (kremler, boyalar, fırçalar...) hizmet DEĞİLDİR: adet × satış fiyatı ile iş emrine satır olarak eklenen ürünlerdir.
- Kategori ağacının tamamı (Hizmetler.pdf) ilk migration'da seed edilir; admin sonradan ekleyip pasifleştirebilir.

Bu feature, hem katalog yönetim ekranlarını (admin CRUD) hem de ürün kabulündeki seçim ekranlarının veri kaynağını kapsar.

## İşleyiş Akışı

### Ürün kabulünde kullanım (okuma tarafı)

1. Uygulama açılışında `GET /api/categories/tree` bir kez çağrılır ve **cache'lenir** (kabul sırasında beklenmesin diye). Cache yalnızca katalog ekranında değişiklik yapılırsa yenilenir.
2. Ürün kabulünde admin cache'ten 3 adımda seçer: Ana Kategori (level 1) → Ürün Grubu (level 2) → Ürün Türü (level 3).
3. Ürün türü seçilince `GET /api/categories/{level3Id}/services` çağrılır → o ürün türünün **fiyatı girilmiş + aktif** hizmetleri fiyatlarıyla döner. Hizmet tıklanınca **fiyat otomatik ekrana gelir** (PDF'in 5. adımı).
4. Fiyat girilmemiş (matris satırı olmayan) kombinasyon listede **hiç görünmez**.
5. (Varsa) sarf malzeme satırları eklenir: `GET /api/consumable-products?groupId=&brand=` ile ürün seçilir, adet girilir.

### Katalog yönetimi (yazma tarafı)

1. **Kategori ekleme:** `POST /api/categories` — yeni kategori parent'ın level+1'i olur; level 3'ü aşamaz (400).
2. **Kategori güncelleme:** `PUT /api/categories/{id}` — ad/sıra/aktiflik. **Pasifleştirme alt ağacı da GİZLER (soft)** — level 2 pasifleşirse altındaki tüm level 3 türler tree'den düşer ve onlarla yeni iş emri açılamaz (400); mevcut iş emirleri etkilenmez.
3. **Hizmet türü CRUD:** `GET/POST/PUT /api/service-types`.
4. **Fiyat matrisi:** `GET /api/service-prices?categoryId=` ile satırlar listelenir; `PUT /api/service-prices/bulk` ile toplu upsert yapılır (~300 kombinasyonun tek istekte girilmesi için). Aynı (kategori, hizmet) ikinci kez gönderilirse fiyat GÜNCELLENİR (insert değil).
5. **Sarf malzeme:** grup CRUD (`/api/consumable-groups`), ürün CRUD (`/api/consumable-products`). Aynı ürün farklı markayla farklı fiyatta yaşayabilir.
6. Katalogda herhangi bir değişiklik yapıldığında istemci kategori ağacı cache'ini yeniler.

## UI Gereksinimleri

- **Katalog ana sayfası** — sekmeler: Kategoriler · Hizmet Türleri · Fiyat Matrisi · Sarf Malzemeler.
- **Kategoriler sekmesi:**
  - 3 seviyeli ağaç görünümü (TreeView / genişletilebilir liste); pasifler soluk + "pasif" rozeti; `includeInactive` toggle'ı
  - "Yeni kategori" butonu (seçili düğümün altına ekler; level 3 düğüm seçiliyken disable — level 3'ün altına eklenemez)
  - Düzenleme modalı: Ad (zorunlu), Sıra (`sortOrder`), Aktif toggle
  - Pasifleştirme onay diyaloğu: "Bu kategori pasifleştirilirse altındaki tüm alt kategoriler de gizlenir ve bunlarla yeni iş emri açılamaz. Mevcut iş emirleri etkilenmez. Devam edilsin mi?"
  - Kök seviyeye aynı adla ikinci kategori → 409 hata mesajı
- **Hizmet Türleri sekmesi:**
  - Tablo: Ad, Sıra, Aktif; "Yeni hizmet türü" butonu; düzenleme modalı (Ad zorunlu + unique, Sıra, Aktif)
  - Bilgi notu: "Tamir/onarım hizmeti firma kararıyla sisteme eklenmez."
- **Fiyat Matrisi sekmesi:**
  - Ürün türü (level 3) filtresi (kategori ağacından seçim) — `GET /api/service-prices?categoryId=`
  - Matris/tablo: satırlar ürün türü, kolonlar hizmet türleri, hücreler fiyat (boş hücre = fiyat girilmemiş = istemcide LİSTELENMEZ uyarısı)
  - Hücre içi düzenleme + "Tümünü kaydet" → `PUT /api/service-prices/bulk` (toplu upsert; Excel'den yapıştırma desteği önerilir — ~300 kombinasyon ilk kurulumda girilecek)
  - Fiyat ≥ 0 validasyonu; satır bazlı aktif/pasif
- **Sarf Malzemeler sekmesi:**
  - Grup listesi (Bakım Ürünleri, Boya Ürünleri, Temizlik, Uygulama) + "Yeni grup"
  - Ürün tablosu: Grup, Marka (boş olabilir — "markasız/dökme"), Ad, Görünen Ad (DisplayName), Satış Fiyatı, Aktif; grup ve marka filtreleri
  - Ürün formu: Grup (dropdown, zorunlu), Marka (opsiyonel), Ad (zorunlu), Satış Fiyatı (≥ 0, zorunlu), Aktif toggle
  - Not: Seed'den gelen ürünler `sale_price=0, is_active=false` ile yüklüdür — admin fiyat girip aktifleştirmeden kabul ekranında görünmezler; bu durumu listede "fiyat girilmedi" rozetiyle gösterin
  - Unique ihlalleri: aynı (grup, marka, ad) veya markasız aynı (grup, ad) ikinci kez → 409/400 hata mesajı
- Ortak: loading göstergeleri, kaydetme başarı snackbar'ları, ProblemDetails alan hataları.

## İş Kuralları

- **Kategori seviyeleri:** `level ∈ {1,2,3}` — 1 = Ana Kategori (Kadın, Erkek, Çocuk, Koltuk ve Mobilya), 2 = Ürün Grubu (Ayakkabı, Çanta, Giyim, Ev Koltuğu...), 3 = Ürün Türü (Sneakers, Topuklu, Deri Mont, Tekli Koltuk...).
- Uygulama kuralı: level=1 → `parent_id` NULL; level=2/3 → parent'ın level'ı bir eksik olmalı. Yeni kategori parent'ın level+1'i olur; **level 3'ü aşamaz → 400**.
- `UNIQUE (parent_id, name)`; kök isimlerde NULL-unique açığı için ayrıca partial unique index: kök seviyede aynı ad iki kez olamaz (→ 409).
- **Pasifleştirme soft'tur ve alt ağacı gizler:** ürün grubu (level 2) pasifleştirilirse tree'de altındaki tüm türler görünmez; o türlerle YENİ iş emri açılamaz (400) ama mevcut iş emirleri etkilenmez.
- **Hizmet türleri dinamiktir** (admin CRUD); ad UNIQUE. Seed: 'Bakım', 'Boya', 'Bakım ve Boya'. Tamir/onarım EKLENMEZ (firma kararı).
- **Fiyat matrisi:** `service_prices` yalnızca **level=3** kategorilere bağlanır; `UNIQUE (category_id, service_type_id)`; `price >= 0`. Seed BOŞ başlar. **Fiyat girilmemiş (satırı olmayan) kombinasyon istemcide LİSTELENMEZ.** Bulk upsert'te aynı (kategori, hizmet) tekrar gelirse fiyat güncellenir.
- `GET /api/categories/{id}/services` yalnızca **is_active + fiyatı girilmiş** hizmetleri döner.
- **Sarf malzeme:** hizmet değildir; adetle satılır. `UNIQUE (group_id, brand, name)`; markasız (brand NULL) aynı ürün iki kez girilemesin diye partial unique index `(group_id, name) WHERE brand IS NULL`. `sale_price >= 0`.
- Aynı ürün farklı markayla farklı fiyatta yaşayabilir: (Bakım Ürünleri, Saphir, Deri Bakım Kremi) → 400 TL; (Bakım Ürünleri, Collonil, Deri Bakım Kremi) → 250 TL.
- `DisplayName` türetilmiş alandır: brand null değilse `"Saphir Deri Bakım Kremi"` (marka + ad), null ise `"Deri Bakım Kremi"`.
- **Seed içerikleri:** Kategori ağacı = Hizmetler.pdf'teki TÜM ağaç (4 ana kategori, ~20 grup, ~100 ürün türü) ilk migration'da aynen yüklenir. Sarf: 4 grup + ~30 ürün, `brand=NULL, sale_price=0, is_active=FALSE` ile yüklenir (PDF markasız verdi); markalı varyantları admin ekler; admin fiyat girip aktifleştirir.
- Katalogda **silme yoktur** — yalnızca pasifleştirme.
- İş emrine hizmetin **adı ve o günkü fiyatı snapshot'lanır**; sonraki fiyat/ad değişiklikleri eski iş emirlerini ASLA etkilemez (detay İş Emri feature'ında).

## Veritabanı Modelleri

### `categories`

3 seviyeli kategori ağacı (Ana Kategori → Ürün Grubu → Ürün Türü). Kaynak: Hizmetler.pdf. Bu tablo vardır çünkü fiyatlandırma ürün türüne bağlıdır ve firma katalog ağacını kendisi yönetmek ister (koda gömülü olamaz).

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | SMALLSERIAL PK | |
| `parent_id` | SMALLINT NULL FK → categories | Üst düğüm; level 1'de NULL |
| `name` | VARCHAR(100) NOT NULL | Kategori adı |
| `level` | SMALLINT NOT NULL CHECK (1,2,3) | 1=Ana Kategori, 2=Ürün Grubu, 3=Ürün Türü |
| `sort_order` | SMALLINT NOT NULL DEFAULT 0 | Görüntüleme sırası |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | Soft pasifleştirme |

Kısıtlar: `UNIQUE (parent_id, name)` + kökler için `uq_categories_root_name (name) WHERE parent_id IS NULL`. İlişki: kendi kendine hiyerarşi; `service_prices` ve `work_orders` level 3 düğümlere bağlanır.

### `service_types`

Hizmet türleri (Bakım, Boya, Bakım ve Boya). Sabit enum yerine tablo olması firma kararıdır — admin CRUD ile yenisi eklenebilir/pasifleştirilebilir. Seed: 'Bakım', 'Boya', 'Bakım ve Boya'; tamir/onarım eklenmez.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | SMALLSERIAL PK | |
| `name` | VARCHAR(100) NOT NULL UNIQUE | Hizmet adı |
| `sort_order` | SMALLINT NOT NULL DEFAULT 0 | Sıra |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | |

### `service_prices`

Fiyat matrisi: (ürün türü level=3) × (hizmet türü) → TL fiyat. Bu tablo vardır çünkü aynı hizmetin fiyatı ürün türüne göre değişir; fiyat tek boyutlu liste olamaz.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | SERIAL PK | İş emrinde `ServicePriceIds` olarak referans verilen kimlik |
| `category_id` | SMALLINT NOT NULL FK → categories | **YALNIZCA level=3** |
| `service_type_id` | SMALLINT NOT NULL FK → service_types | |
| `price` | NUMERIC(12,2) NOT NULL CHECK (>= 0) | TL fiyat |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | |
| `updated_at` | TIMESTAMPTZ NOT NULL | |

Kısıt: `UNIQUE (category_id, service_type_id)`. Seed boş başlar; toplu giriş için bulk endpoint vardır.

### `consumable_groups`

Sarf malzeme grupları (Bakım Ürünleri, Boya Ürünleri, Temizlik, Uygulama). Ürünleri sınıflandırmak ve kabul ekranında gruplu seçim sunmak için vardır.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | SMALLSERIAL PK | |
| `name` | VARCHAR(100) NOT NULL UNIQUE | Grup adı |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | |

### `consumable_products`

Adetle satılan sarf ürünleri (kremler, spreyler, fırçalar...). Hizmet değildir; iş emrine adet × satış fiyatı ile satır olarak eklenir. Marka ayrımı, aynı ürünün farklı marka/fiyatla yaşayabilmesi içindir.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | SERIAL PK | |
| `group_id` | SMALLINT NOT NULL FK → consumable_groups | |
| `brand` | VARCHAR(100) NULL | Saphir, Collonil... NULL = markasız/dökme |
| `name` | VARCHAR(150) NOT NULL | Deri Bakım Kremi, Su Geçirmezlik Spreyi... |
| `sale_price` | NUMERIC(12,2) NOT NULL CHECK (>= 0) | Birim satış fiyatı |
| `is_active` | BOOLEAN NOT NULL DEFAULT TRUE | |
| `updated_at` | TIMESTAMPTZ NOT NULL | |

Kısıtlar: `UNIQUE (group_id, brand, name)` + markasızlar için `uq_consumable_no_brand (group_id, name) WHERE brand IS NULL`.

## DTO'lar

### Request DTO'ları

```csharp
public record CreateCategoryRequest(short? ParentId, string Name, short SortOrder);
```
- **Amaç:** Yeni kategori. `ParentId` null → level 1 kök; dolu → parent'ın level+1'i olur (3'ü aşamaz).
- **Endpoint:** `POST /api/categories`.

```csharp
public record UpdateCategoryRequest(string Name, short SortOrder, bool IsActive);
```
- **Amaç:** Kategori ad/sıra/aktiflik güncelleme. `IsActive=false` alt ağacı da gizler.
- **Endpoint:** `PUT /api/categories/{id}`.

```csharp
public record CreateServiceTypeRequest(string Name, short SortOrder);
public record UpdateServiceTypeRequest(string Name, short SortOrder, bool IsActive);
```
- **Amaç:** Hizmet türü CRUD. `Name` unique.
- **Endpoint'ler:** `POST /api/service-types`, `PUT /api/service-types/{id}`.

```csharp
public record UpsertServicePriceRequest(short CategoryId, short ServiceTypeId, decimal Price, bool IsActive);
public record BulkUpsertServicePricesRequest(IReadOnlyList<UpsertServicePriceRequest> Items);
```
- **Amaç:** Fiyat matrisi toplu girişi/güncellemesi. `CategoryId` level=3 olmalı; `Price >= 0`. Aynı (CategoryId, ServiceTypeId) mevcutsa güncellenir (upsert).
- **Endpoint:** `PUT /api/service-prices/bulk`.

```csharp
public record CreateConsumableGroupRequest(string Name);
```
- **Amaç:** Yeni sarf grubu. — **Endpoint:** `POST /api/consumable-groups`.

```csharp
public record CreateConsumableProductRequest(short GroupId, string? Brand, string Name, decimal SalePrice);
public record UpdateConsumableProductRequest(string? Brand, string Name, decimal SalePrice, bool IsActive);
```
- **Amaç:** Sarf ürünü ekleme/güncelleme. `Brand` opsiyonel (NULL = markasız); `SalePrice >= 0`.
- **Endpoint'ler:** `POST /api/consumable-products`, `PUT /api/consumable-products/{id}`.

### Response DTO'ları

```csharp
public record CategoryResponse(short Id, short? ParentId, string Name,
    short Level, short SortOrder, bool IsActive);
```
- **Amaç:** Tek kategori gösterimi. — **Endpoint'ler:** `POST /api/categories`, `PUT /api/categories/{id}`.

```csharp
public record CategoryTreeResponse(
    short Id, string Name, short Level, bool IsActive,
    IReadOnlyList<CategoryTreeResponse> Children);
```
- **Amaç:** Tüm ağacı tek istekte vermek (masaüstü 3 adımlı seçim ekranı için). Recursive yapı: her düğüm `Children` listesi taşır.
- **Endpoint:** `GET /api/categories/tree`.

```csharp
public record ServiceTypeResponse(short Id, string Name, short SortOrder, bool IsActive);
```
- **Endpoint'ler:** `GET/POST/PUT /api/service-types`.

```csharp
public record ServicePriceResponse(int Id, short CategoryId, string CategoryPath,
    short ServiceTypeId, string ServiceName, decimal Price, bool IsActive);
```
- **Amaç:** Fiyat matrisi satırı; `CategoryPath` okunur yol ("Kadın > Ayakkabı > Sneakers Ayakkabı"), `ServiceName` hizmet adı.
- **Endpoint'ler:** `GET /api/service-prices`, `PUT /api/service-prices/bulk`.

```csharp
public record CategoryServicesResponse(
    short CategoryId, string CategoryPath,
    IReadOnlyList<ServicePriceOption> Services);
public record ServicePriceOption(int ServicePriceId, string ServiceName, decimal Price);
```
- **Amaç:** Ürün kabulünün 4-5. adımı — seçilen ürün türünün fiyatlı hizmetleri. **Yalnızca is_active + fiyatı girilmiş olanlar** döner. `ServicePriceId`, iş emri oluştururken `ServicePriceIds` listesine konulan değerdir.
- **Endpoint:** `GET /api/categories/{id}/services`.

```csharp
public record ConsumableGroupResponse(short Id, string Name, bool IsActive);
```
- **Endpoint'ler:** `GET/POST/PUT /api/consumable-groups`.

```csharp
public record ConsumableProductResponse(int Id, short GroupId, string GroupName,
    string? Brand, string Name, string DisplayName, decimal SalePrice, bool IsActive);
```
- **Amaç:** Sarf ürünü gösterimi. `DisplayName` = brand varsa "Saphir Deri Bakım Kremi", yoksa "Deri Bakım Kremi".
- **Endpoint'ler:** `GET/POST/PUT /api/consumable-products`.

## API Endpointleri

### `GET /api/categories/tree?includeInactive=false`

- **Auth:** Evet — **Amaç:** Tüm ağaç tek istekte (masaüstü 3 adımlı seçim ekranı).
- **Request:** query `includeInactive` (default false — pasif düğümler ve alt ağaçları gelmez; katalog yönetim ekranı `true` ile çağırır).
- **Response:** `CategoryTreeResponse[]` (kökler; her biri recursive `Children` ile).
- **Başarılı:** 200. — **Hata:** 401.
- **Yan etki:** Yok. İstemci bu yanıtı cache'ler.

### `POST /api/categories`

- **Auth:** Evet — **Amaç:** Yeni kategori.
- **Request DTO:** `CreateCategoryRequest` — **Response DTO:** `CategoryResponse`.
- **Validation:** ad zorunlu; parent'ın level+1'i olur; **level 3'ü aşamaz → 400**; aynı parent altında aynı ad → 409; kök seviyede aynı ad → 409.
- **Yan etki:** Yok (istemci cache'ini yenilemeli).

### `PUT /api/categories/{id}`

- **Auth:** Evet — **Amaç:** Ad/sıra/aktiflik güncelleme.
- **Request DTO:** `UpdateCategoryRequest` — **Response DTO:** `CategoryResponse`.
- **İş kuralı:** **Pasifleştirme alt ağacı da GİZLER (soft).** Pasif türlerle yeni iş emri açılamaz; mevcut iş emirleri (path snapshot sayesinde) etkilenmez.
- **Hata:** 400 (validasyon), 404, 409 (ad çakışması).

### `GET /api/service-types` · `POST /api/service-types` · `PUT /api/service-types/{id}`

- **Auth:** Evet — **Amaç:** Hizmet türlerinin listelenmesi/eklenmesi/güncellenmesi (Bakım, Boya, ...).
- **DTO'lar:** `CreateServiceTypeRequest` / `UpdateServiceTypeRequest` → `ServiceTypeResponse`.
- **Validation:** `Name` zorunlu + unique (çakışma → 409).
- **Yan etki:** Pasifleştirilen hizmet türünün matris satırları kabul ekranında görünmez olur; eski iş emirleri snapshot sayesinde etkilenmez.

### `GET /api/service-prices?categoryId=`

- **Auth:** Evet — **Amaç:** Fiyat matrisi satırlarını (filtreli) listelemek.
- **Response:** `ServicePriceResponse[]`.

### `PUT /api/service-prices/bulk`

- **Auth:** Evet — **Amaç:** Toplu fiyat upsert — ~300 kombinasyonun tek istekte girilmesi için.
- **Request DTO:** `BulkUpsertServicePricesRequest`.
- **Validation:** her satırda `CategoryId` level=3 olmalı, `Price >= 0`.
- **Davranış:** Aynı (kategori, hizmet) ikinci kez gönderilirse fiyat GÜNCELLENİR (insert değil) — idempotent upsert. 300 satır tek istekte yazılabilir.
- **Hata:** 400 (validasyon), 401.

### `GET /api/categories/{id}/services`

- **Auth:** Evet — **Amaç:** **Ürün kabulünün 4-5. adımı:** o ürün türünün fiyatı girilmiş + aktif hizmetleri (fiyatlarıyla).
- **Response DTO:** `CategoryServicesResponse`.
- **İş kuralı:** Fiyatı girilmemiş kombinasyon listede YOKTUR; pasif hizmet/pasif satır dönmez.
- **Hata:** 404 (kategori yok), 401.

### `GET /api/consumable-groups` · `POST /api/consumable-groups` · `PUT /api/consumable-groups/{id}`

- **Auth:** Evet — **Amaç:** Sarf malzeme grupları CRUD.
- **DTO'lar:** `CreateConsumableGroupRequest` → `ConsumableGroupResponse`.
- **Validation:** ad zorunlu + unique.

### `GET /api/consumable-products?groupId=&brand=` · `POST /api/consumable-products` · `PUT /api/consumable-products/{id}`

- **Auth:** Evet — **Amaç:** Sarf ürünleri (marka? + ad + satış fiyatı + aktiflik) listeleme/ekleme/güncelleme; `groupId` ve `brand` query filtreleri.
- **DTO'lar:** `CreateConsumableProductRequest` / `UpdateConsumableProductRequest` → `ConsumableProductResponse`.
- **Validation:** grup + ad zorunlu; `SalePrice >= 0`; unique (grup, marka, ad); markasızda unique (grup, ad).
- **Hata:** 400/409 (unique ihlali), 404.

## Flutter Geliştirme Notları

- **Cache stratejisi (altın kural #2):** `GET /api/categories/tree` açılışta bir kez çekilip memory'de (ve istenirse diske) cache'lenir. Cache'i invalidate eden olaylar: (a) katalog ekranında herhangi bir başarılı yazma, (b) iş emri oluşturmada `INVALID_CATALOG_ITEM` / `SERVICE_CATEGORY_MISMATCH` / `INVALID_CATEGORY_LEVEL` hatası alınması (başka cihaz katalogu değiştirmiş olabilir).
- **Seçim widget'ı:** kabul sihirbazında 3 kademeli cascade (üç `DropdownButton` veya üç kolonlu liste). Level 3 seçilince `categories/{id}/services` çağrısı; sonuç geldiğinde hizmetler checkbox/chip listesi olarak, her biri fiyat etiketiyle gösterilir.
- **Fiyat matrisi ekranı:** `DataTable` yerine hücre-düzenlenebilir bir grid (ör. `PlutoGrid`) önerilir; değişen hücreler birikir, "Kaydet" tek `bulk` isteği atar. Excel yapıştırma (TSV parse) ilk kurulumdaki ~300 fiyat girişini ciddi hızlandırır.
- **State:** `catalogProvider` (tree cache), `servicePricesProvider(categoryId)`, `consumableProductsProvider(groupId, brand)`.
- **Sarf ürün seçim UX'i:** kabul ekranında grup → ürün → adet (`quantity >= 1`) satır ekleme; `DisplayName` gösterilir; satır toplamı = adet × `salePrice` anlık hesaplanır.
- **Hata yönetimi:** 409 unique çakışmalarını alan altı mesaja çevirin ("Bu ad zaten mevcut").

## Notlar

- Seed sonrası beklenen durum (backend kabul testleriyle garanti edilir): `/categories/tree` → 4 ana kategori (Kadın, Erkek, Çocuk, Koltuk ve Mobilya), altlarında Hizmetler.pdf'teki gruplar/türler; `service-types` = Bakım, Boya, Bakım ve Boya.
- Fiyatlar seed'de BOŞtur. Firma fiyat listesini Excel verirse bulk endpoint ile toplu import edilir; vermezse admin panelinden (sizin fiyat matrisi ekranınızdan) tek tek girilir. **Fiyat girilmeden kabul ekranında hizmet görünmez** — ilk kurulumda bu ekran kritik yoldadır.
- Kategori/hizmet adları sonradan değişse bile eski iş emirleri `category_path_snapshot` ve hizmet ad/fiyat snapshot'ları sayesinde o günkü haliyle görünmeye devam eder.
- Sarf malzeme satışı Faz 1'de **yalnızca iş emrine bağlıdır** — ürün bırakmadan sadece krem almaya gelen müşteri için bağımsız satış fişi (mini POS) YOKTUR; bu firmaya sorulmuş açık bir konudur, Faz 1 kapsamına alınmamıştır. Uygulamada bağımsız satış ekranı yapmayın.
- Fiyat hesabı backend'de tek noktadadır (`PricingService.CalculateSuggestedPrice()`); istemcideki anlık toplam yalnızca ön izlemedir, bağlayıcı olan sunucunun döndürdüğü `suggestedPrice`'tır.

---

# 4. Feature: İş Emri Yönetimi (Oluşturma, Listeleme, Güncelleme, Durum Makinesi, Teslim)

## Amaç

Atölyeye bırakılan her ürün için bir **iş emri** açmak, yaşam döngüsünü (RECEIVED → IN_PROGRESS → READY → DELIVERED, gerektiğinde CANCELLED) yönetmek, fiyat/ödeme bilgilerini tutmak ve müşteriye SMS ile giden takip linkinin kaynağı olmak. Aynı müşteri aynı anda birden çok ürün bırakırsa **her ürün ayrı iş emri + ayrı SMS/link** olur (Faz 1 kararı; 5 ürün = 5 SMS maliyeti — firma bilgilendirilmiştir; "tek SMS'te birleşik link" Faz 2 adayıdır).

## İşleyiş Akışı

### İş emri oluşturma (kabul sihirbazının 2. fazı — müşteri seçildikten sonra)

1. Cache'teki kategori ağacından Ana Kategori → Ürün Grubu → Ürün Türü seçilir (ör. Kadın → Ayakkabı → Sneakers).
2. `GET /api/categories/{level3Id}/services` → hizmetler fiyatlarıyla listelenir; admin hizmeti tıklar, **fiyat otomatik ekrana gelir**. Birden çok hizmet seçilebilir; tipik 1 adet; **boş da bırakılabilir** (özel/tarifesiz iş).
3. (Varsa) sarf malzeme satırları eklenir (ürün + adet).
4. Ekranda önerilen toplam gösterilir = seçili hizmet fiyatları + sarf satır toplamları. Admin **nihai fiyatı elle değiştirebilir**; ön ödeme varsa girer.
5. Ürün detayları doldurulur: marka, renk, malzeme, açıklama, mevcut hasarlar, tahmini teslim tarihi (hepsi opsiyonel).
6. `POST /api/work-orders` çağrılır → 201: `{ orderNumber, suggestedPrice, price, remainingAmount, trackingUrl, status: "RECEIVED", ... }`.
   - Backend `order_number` (WO-2026-000123) ve `tracking_token` (43 karakter) otomatik üretir; seçilen hizmetlerin **adı + o günkü fiyatı** snapshot'lanır; toplam `suggested_price` olur; `category_path_snapshot` "L1 > L2 > L3" yazılır; status log'a `NULL → RECEIVED` ilk kaydı düşülür.
   - **DİKKAT: SMS bu anda GİTMEZ** — video/foto bekleniyor (link boş sayfaya açılmasın diye). SMS #1'i ilk BEFORE medyanın confirm'i tetikler (bkz. Medya feature'ı).
7. Medya yükleme fazına geçilir (Medya feature'ı). Karşılama toplamı ~6-8 istektir.

### Atölye süreci (günler sonra)

1. İş başlayınca: `PATCH /api/work-orders/{id}/status { newStatus: "IN_PROGRESS" }`.
2. İş bitince AFTER medyası yüklenir (Medya feature'ındaki 3'lü dans ile).
3. `PATCH /api/work-orders/{id}/status { newStatus: "READY" }` → backend **ORDER_READY SMS'ini (SMS #2)** kuyruklar; frontend SMS'e dokunmaz. Müşteri linkte artık öncesi + sonrası medyayı görür.
4. Kusur fark edilirse `READY → IN_PROGRESS` geri dönüşü yapılabilir; düzeltme sonrası tekrar READY olduğunda **SMS #2 idempotency sayesinde tekrar gitmez**.

### Teslim

1. Müşteri gelir; `GET /api/work-orders?search=0532...` ile iş bulunur; detayda **kalan tutar** (`remainingAmount = price - (prepaymentAmount ?? 0)`) görünür.
2. `POST /api/work-orders/{id}/deliver { finalPaymentAmount }` → 200, status DELIVERED, `delivered_at` dolar, ciro artar; **iş kapanır ama silinmez**.
3. DELIVERED/CANCELLED son duraktır; kapalı işte her değişiklik denemesi 409 `ORDER_CLOSED` döner → ekran salt-okunur moda geçer.

### İptal

- Her açık durumdan CANCELLED'a gidilebilir: `PATCH .../status { newStatus: "CANCELLED", note: "iptal nedeni" }` — `Note` önerilir; iptal nedeni status log'a yazılır. Bitmemiş ürünü geri isteyen müşteri senaryosu = CANCELLED + note.

### Güncelleme

1. Açık işte (RECEIVED / IN_PROGRESS / READY) "Düzenle" ile `PUT /api/work-orders/{id}` çağrılır.
2. `ServicePriceIds`/`Consumables` gönderilirse mevcut snapshot satırları SİLİNİR, yenileri **kataloğun O ANKİ ad+fiyatlarıyla** yeniden snapshot'lanır, `suggested_price` yeniden hesaplanır; `price` istekte ne geldiyse odur (yeniden hesaplanmaz).
3. Fiyat değiştiyse status log'a iz düşülür: `note = "Fiyat: 500 → 750"` (status alanları aynı kalır).
4. Eşzamanlı iki güncellemede ikincisi 409 alır (optimistic concurrency) → istemci detayı yeniden çekip tekrar dener.

## UI Gereksinimleri

- **İş emri listesi sayfası:**
  - Tablo kolonları (`WorkOrderListItemResponse`): İş Emri No, Müşteri Adı, Telefon, Ürün (CategoryPath), Marka, Durum rozeti, Fiyat, Kalan Tutar, Tahmini Teslim, Kayıt Tarihi
  - Durum filtresi (dropdown/segment: Tümü, Teslim Alındı, İşlemde, Hazır, Teslim Edildi, İptal)
  - Arama kutusu — arar: iş emri no (ILIKE), müşteri ad+soyad (ILIKE), telefon (normalize + sondan-içerir), marka (ILIKE); `status` filtresiyle AND'lenir
  - Sayfalama; sıralama sabit `created_at DESC`
  - Satır tıklama → detay
- **İş emri oluşturma sihirbazı (müşteri adımından sonra):**
  - Adım A — Ürün türü: 3 kademeli kategori seçimi (cache'ten); yalnızca level 3 seçilebilir durumda "İleri" aktifleşir
  - Adım B — Hizmetler: fiyat etiketli çoklu seçim listesi (boş bırakılabilir — "tarifesiz iş" bilgisi); sarf malzeme satır ekleme (grup → ürün → adet spinner, min 1); önerilen toplam canlı gösterim
  - Adım C — Detaylar: Marka, Renk, Malzeme (text), Açıklama, Mevcut Hasarlar (çok satırlı), Tahmini Teslim Tarihi (DatePicker, opsiyonel)
  - Adım D — Fiyat & Ödeme: Önerilen Fiyat (salt-okunur), Nihai Fiyat (elle değiştirilebilir, ≥ 0; 0 girilirse "garanti/jest işi" bilgi notu), "Ön ödeme alındı" checkbox → işaretlenince Ön Ödeme Tutarı alanı (zorunlu, 0 ≤ tutar ≤ nihai fiyat), Kalan Tutar (canlı hesap)
  - "Kaydet" — istek sürerken disable; başarıda `orderNumber` + `trackingUrl` gösterilir ve medya yükleme adımına geçilir
  - Validation mesajları: `INVALID_CATEGORY_LEVEL`, `SERVICE_CATEGORY_MISMATCH`, `INVALID_CATALOG_ITEM` hatalarında "Katalog güncellendi, seçiminizi yenileyin" + cache yenileme
- **İş emri detay sayfası:**
  - Üst bant: İş Emri No, durum rozeti, oluşturma tarihi, `trackingUrl` (kopyala butonu)
  - Müşteri kartı (gömülü `CustomerResponse`; müşteri detayına link)
  - Ürün bilgileri: CategoryPath (snapshot), marka, renk, malzeme, açıklama, mevcut hasarlar, tahmini teslim
  - Hizmetler tablosu: Ad (snapshot), Fiyat (snapshot); Sarf tablosu: Ürün adı (snapshot), Adet, Birim Fiyat (snapshot), Satır Toplamı
  - Fiyat kartı: Önerilen, Nihai, Ön Ödeme, **Kalan Tutar**, (teslim edildiyse) Teslim Ödemesi + teslim tarihi
  - Medya galerisi: BEFORE / AFTER / DETAIL sekmeleri; foto önizleme + video oynatıcı (ViewUrl 15 dk ömürlü — süresi geçmişse galeriyi yenile)
  - Durum geçmişi zaman çizelgesi (`StatusHistory`): eski→yeni durum, not, kim, ne zaman (fiyat değişiklik notları da burada görünür)
  - Son SMS durumları (iş emri detayı `sms_logs` içerir): tip, durum (QUEUED/SENT/FAILED), hata mesajı; **FAILED SMS için "SMS'i tekrar gönder" butonu**
  - Aksiyon butonları duruma göre: RECEIVED → "İşleme Al"; IN_PROGRESS → "Hazır Olarak İşaretle"; READY → "Teslim Et" + "İşleme Geri Al"; açık her durum → "İptal Et" (not alanlı confirmation dialog), "Düzenle"; DELIVERED/CANCELLED → tüm aksiyonlar gizli/disable (salt-okunur)
- **Teslim modalı:** Kalan tutar gösterimi, Teslim Ödemesi input (≥ 0; kalan tutara eşitlik ZORLANMAZ — bilgi notu: "Girilen tutar kaydedilir, ödeme politikası firma sorumluluğundadır"), onay butonu
- **Durum değiştirme confirmation dialogları:** özellikle CANCELLED için zorunlu görünümlü not alanı; READY için "Müşteriye 'ürününüz hazır' SMS'i gidecek" uyarısı
- **Hata durumları:** 409 `INVALID_STATUS_TRANSITION` → "Kayıt başka yerden güncellendi, liste yenileniyor"; 409 (concurrency) → "Kayıt değişmiş, güncel hali yükleniyor" + form yeniden doldurma

## İş Kuralları

- **Numara üretimi:** `order_number` = PostgreSQL global sequence (`work_order_seq`) + format `WO-{yıl}-{seq:D6}` (örn. WO-2026-000123). Yıl bilgilendirme amaçlıdır, **sequence yıl başında SIFIRLANMAZ** (basitlik). `nextval` ile üretilir — race condition imkânsız.
- **tracking_token:** 32 byte `RandomNumberGenerator` → Base64Url (**43 karakter**). UNIQUE ihlalinde (teorik) 1 kez yeniden üretilir.
- **Fiyat:** `suggested_price = SUM(work_order_services.price_snapshot) + SUM(work_order_consumables.quantity × unit_price_snapshot)`. `price` bundan bağımsız, elle girilir. Hizmet satırına **ad + fiyat o günkü haliyle snapshot'lanır** (firma şartı: "İş emrine hizmet adı ve o tarihteki fiyat ayrıca kaydedilmelidir"); katalogdaki sonraki fiyat/ad değişikliği eski iş emirlerini ASLA etkilemez.
- **Sıfır fiyat serbest:** `price = 0` geçerlidir (garanti kapsamında yeniden işlem / jest). Validator `>= 0` kontrol eder; ayrıca `prepayment_amount <= price` DB constraint'i vardır.
- **Ön ödeme kuralı:** `has_prepayment = false` ise `prepayment_amount` NULL olmalı; `true` ise `prepayment_amount` zorunlu (FluentValidation), `0 ≤ prepayment_amount ≤ price`. `prepayment_amount > price` → 400 (DB constraint'e düşmeden validator yakalar).
- **Oluşturma validasyonları:**
  - `CategoryId` **level=3 olmak zorunda** (level 1/2 → 400 `INVALID_CATEGORY_LEVEL`); pasif kategori veya pasif ÜST kategori → 400.
  - `category_path_snapshot` oluşturma anında "L1 > L2 > L3" olarak yazılır.
  - `ServicePriceIds` **boş liste olabilir** (özel/tarifesiz iş): hizmet satırı yok, `suggested_price` yalnızca sarf kalemlerinden (o da yoksa 0), fiyat tamamen elle.
  - Seçilen `service_price` kaydı seçilen `CategoryId`'ye ait olmalı — başka ürün türünün fiyatı → 400 `SERVICE_CATEGORY_MISMATCH`.
  - Pasif hizmet fiyatı, pasif sarf ürünü veya mevcut olmayan ID → 400 `INVALID_CATALOG_ITEM`. Katalog, iş emri açılırken başka cihazdan düzenlenmiş olabilir — bu yüzden sunucu son kontrolü yapar.
  - `Consumables[].Quantity >= 1`.
  - Oluşturma anında `work_order_status_logs`'a ilk kayıt: `old_status = NULL, new_status = RECEIVED`.
- **Durum geçiş matrisi (TAM):**

| Mevcut → Hedef | Sonuç |
|---|---|
| RECEIVED → IN_PROGRESS | ✅ |
| IN_PROGRESS → READY | ✅ (SMS #2 kuyruklanır, idempotent) |
| READY → IN_PROGRESS | ✅ (geri dönüş — kusur fark edildi senaryosu) |
| READY → DELIVERED | ❌ PATCH ile DEĞİL — yalnızca `/deliver` endpoint'i ile |
| herhangi (açık) → CANCELLED | ✅ (`Note` önerilir) |
| aynı → aynı | ❌ 409 `INVALID_STATUS_TRANSITION` |
| RECEIVED → READY (atlama) | ❌ 409 |
| DELIVERED/CANCELLED → herhangi | ❌ 409 `ORDER_CLOSED` |

- Geçersiz geçiş → 409. İkinci kez READY olunduğunda SMS #2 idempotency sayesinde tekrar gitmez.
- **`/deliver` kuralları:** yalnızca status **READY** iken çalışır (aksi 409). `final_payment_amount >= 0` tek validasyondur; **kalan tutara eşitlik KONTROL EDİLMEZ** (girilen kaydedilir — ödeme politikası firma sorumluluğudur; borçlu teslim konusu firmaya sorulmuştur).
- **`PUT /api/work-orders/{id}` tam davranış:**
  - Yalnızca status **RECEIVED / IN_PROGRESS / READY** iken çağrılabilir; DELIVERED/CANCELLED'da 409 `ORDER_CLOSED`.
  - Güncellenebilir alanlar: ürün bilgileri (brand, color, material, description, existing_damages), estimated_delivery_date, **price**, has_prepayment + prepayment_amount, **ServicePriceIds**, **Consumables**.
  - `ServicePriceIds`/`Consumables` gönderildiğinde: mevcut satırlar SİLİNİR, yenileri kataloğun O ANKİ ad+fiyatlarıyla snapshot'lanır, `suggested_price` yeniden hesaplanır. `price` istekte ne geldiyse odur (yeniden hesaplanmaz).
  - `customer_id`, `category_id`, `category_path_snapshot`, `order_number`, `tracking_token` **güncellenemez** — ürün türü yanlış girildiyse çözüm: iptal + yeni iş emri.
  - Fiyat değişiklikleri iz bırakır: eski `price` ≠ yeni `price` ise status log'a `note = "Fiyat: 500 → 750"` satırı yazılır (old=new=mevcut status).
- **Optimistic concurrency:** `updated_at` concurrency token; eşzamanlı iki PUT'ta ikincisi (bayat `updated_at`) 409 alır ve güncel veriyi çekip tekrar dener.
- **SMS resend:** İş emri detayı son SMS durumlarını içerir. FAILED SMS için `POST /api/work-orders/{id}/sms/resend` ile admin manuel tekrar gönderir (aynı `sms_type`; idempotency bu endpoint'te **bilinçli olarak devre dışıdır**). NETGSM, 1 saat içinde aynı numaraya aynı içerikli SMS'i "mükerrer" olarak engeller — resend bu hatayı yakalar ve admin'e "aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi" şeklinde net döner (sessiz başarısızlık YOK).
- **Telefon değişikliği etkisi:** müşterinin telefonu güncellenirse bu müşterinin AÇIK iş emirlerinin token'ları yenilenir ve yeni linkli ORDER_RECEIVED SMS'i gider (Müşteri feature'ında detaylı).
- Aynı müşteri aynı anda birden çok ürün: her ürün ayrı iş emri + ayrı SMS/link (Faz 1 kararı).
- İş emri silme endpoint'i YOKTUR; kapalı işler sistemde kalır.

## Veritabanı Modelleri

### `work_orders`

Sistemin merkez tablosu — bir ürünün kabulden teslime tüm yaşam döngüsü. Müşteriye (`customer_id`), ürün türüne (`category_id`, level=3) ve oluşturan kullanıcıya (`created_by_user_id`) bağlıdır; medya, durum logları, hizmet/sarf satırları ve SMS logları buna bağlanır.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `order_number` | VARCHAR(20) NOT NULL UNIQUE | `WO-2026-000123` formatı |
| `customer_id` | BIGINT NOT NULL FK → customers | |
| `category_id` | SMALLINT NOT NULL FK → categories | level=3 ürün türü |
| `category_path_snapshot` | VARCHAR(310) NOT NULL | "Kadın > Ayakkabı > Sneakers Ayakkabı" — kategori sonradan yeniden adlandırılsa bile eski iş emri o günkü haliyle görünür |
| `brand` / `color` / `material` | VARCHAR NULL | Ürün nitelikleri |
| `description` / `existing_damages` | TEXT NULL | Açıklama / mevcut hasarlar |
| `estimated_delivery_date` | DATE NULL | Tahmini teslim |
| `suggested_price` | NUMERIC(12,2) NOT NULL DEFAULT 0 | Hizmet + sarf toplamı (sunucu hesaplar) |
| `price` | NUMERIC(12,2) NOT NULL CHECK (>= 0) | Nihai fiyat; 0 = garanti/jest işi |
| `has_prepayment` | BOOLEAN NOT NULL DEFAULT FALSE | |
| `prepayment_amount` | NUMERIC(12,2) NULL | CHECK: has_prepayment=false → NULL; true → 0 ≤ tutar ≤ price |
| `status` | VARCHAR(20) NOT NULL DEFAULT 'RECEIVED' | RECEIVED · IN_PROGRESS · READY · DELIVERED · CANCELLED |
| `tracking_token` | VARCHAR(64) NOT NULL UNIQUE | 32 byte random, Base64Url (43 karakter) |
| `social_media_consent` | BOOLEAN NOT NULL DEFAULT FALSE | MÜŞTERİ public sayfadan set eder |
| `social_media_consent_at` | TIMESTAMPTZ NULL | Son toggle anı |
| `delivered_at` | TIMESTAMPTZ NULL | Teslim anı |
| `final_payment_amount` | NUMERIC(12,2) NULL | Teslimde alınan tutar |
| `created_by_user_id` | BIGINT NOT NULL FK → users | |
| `created_at` / `updated_at` | TIMESTAMPTZ NOT NULL | `updated_at` aynı zamanda concurrency token |

İndeksler: `idx_wo_customer (customer_id)`, `idx_wo_status (status)`, `idx_wo_token (tracking_token)`.

### `work_order_services`

İş emrinde seçilen HİZMETLER — ad + fiyat **o günkü haliyle kopyalanır** (firma şartı). Bu tablo vardır çünkü katalogdaki değişiklikler geçmiş iş emirlerini etkilememelidir; iş emri, satış anındaki gerçeği saklar.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `work_order_id` | BIGINT NOT NULL FK → work_orders ON DELETE CASCADE | |
| `service_price_id` | INT NULL FK → service_prices | Referans — katalogdan silinse de satır durur |
| `service_name_snapshot` | VARCHAR(100) NOT NULL | "Bakım ve Boya" (o günkü ad) |
| `price_snapshot` | NUMERIC(12,2) NOT NULL | O günkü fiyat |

Kısıt: `UNIQUE (work_order_id, service_price_id)` — aynı hizmet aynı işe iki kez eklenemez.

### `work_order_consumables`

İş emrine eklenen SARF MALZEME satışları (adet × birim fiyat). Ürün adı (DisplayName: marka + ad) ve birim fiyat satış anındaki haliyle snapshot'lanır.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `work_order_id` | BIGINT NOT NULL FK → work_orders ON DELETE CASCADE | |
| `consumable_product_id` | INT NOT NULL FK → consumable_products | |
| `product_name_snapshot` | VARCHAR(260) NOT NULL | DisplayName snapshot: "Saphir Deri Bakım Kremi" |
| `quantity` | SMALLINT NOT NULL CHECK (>= 1) | Adet |
| `unit_price_snapshot` | NUMERIC(12,2) NOT NULL | Satış anındaki birim fiyat |

Kısıt: `UNIQUE (work_order_id, consumable_product_id)`.

### `work_order_status_logs`

Durum değişiklik geçmişi. Her geçiş (ilk RECEIVED dahil) buraya yazılır; **iptal nedeni** ve **fiyat değişikliği notları** ("Fiyat: 500 → 750") da bu tabloda taşınır. Dashboard'ın `readyWaitingOverdueCount` ve arşivin "90+ gün" hesabı bu loga dayanır — bu yüzden vardır: denetim izi + zamana bağlı iş kuralları.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `work_order_id` | BIGINT NOT NULL FK → work_orders | |
| `old_status` | VARCHAR(20) NULL | İlk kayıtta NULL |
| `new_status` | VARCHAR(20) NOT NULL | |
| `note` | TEXT NULL | Özellikle İPTAL nedeni; fiyat değişiklik izi |
| `changed_by_user_id` | BIGINT NOT NULL FK → users | |
| `changed_at` | TIMESTAMPTZ NOT NULL | |

İndeks: `idx_wsl_wo (work_order_id)`.

## DTO'lar

### Request DTO'ları

```csharp
public record CreateWorkOrderRequest(
    long CustomerId,
    short CategoryId,                       // LEVEL=3 ürün türü (Sneakers, Deri Mont...)
    string? Brand, string? Color, string? Material,
    string? Description, string? ExistingDamages,
    DateOnly? EstimatedDeliveryDate,
    IReadOnlyList<int> ServicePriceIds,     // seçilen hizmet(ler) — tipik 1 adet, boş olabilir
    IReadOnlyList<ConsumableLine> Consumables,  // satılan sarf malzemeler (boş olabilir)
    decimal Price,                          // nihai fiyat (öneriyi elle ezebilir)
    bool HasPrepayment,
    decimal? PrepaymentAmount);             // HasPrepayment=true ise zorunlu (FluentValidation)

public record ConsumableLine(int ConsumableProductId, short Quantity);
```
- **Amaç:** Yeni iş emri. `ServicePriceIds` = katalogdan gelen `servicePriceId` değerleri; `Consumables` = ürün id + adet (≥1). `EstimatedDeliveryDate` `yyyy-MM-dd` formatında.
- **Endpoint:** `POST /api/work-orders`.

- **`PUT /api/work-orders/{id}` isteği:** Create ile aynı alan seti kullanılır, ancak `CustomerId` ve `CategoryId` **değiştirilemez** (gönderilse de yok sayılmaz — güncellenemez alan listesindedir; güvenli davranış: değiştirmeden aynı değerleri göndermek). Güncellenebilirler: brand, color, material, description, existing_damages, estimatedDeliveryDate, price, hasPrepayment + prepaymentAmount, servicePriceIds, consumables.

```csharp
public record UpdateWorkOrderStatusRequest(string NewStatus, string? Note);  // Note: iptal nedeni vb.
```
- **Amaç:** Durum geçişi. `NewStatus` ∈ {IN_PROGRESS, READY, CANCELLED} (DELIVERED buradan YAPILAMAZ). `Note` opsiyonel, CANCELLED'da önerilir.
- **Endpoint:** `PATCH /api/work-orders/{id}/status`.

```csharp
public record DeliverWorkOrderRequest(decimal FinalPaymentAmount);
```
- **Amaç:** Teslim işlemi. `FinalPaymentAmount >= 0`; kalan tutara eşitlik zorlanmaz.
- **Endpoint:** `POST /api/work-orders/{id}/deliver`.

### Response DTO'ları

```csharp
public record WorkOrderResponse(
    long Id, string OrderNumber,
    CustomerResponse Customer,
    short CategoryId,
    string CategoryPath,                    // snapshot: "Kadın > Ayakkabı > Sneakers Ayakkabı"
    string? Brand, string? Color, string? Material,
    string? Description, string? ExistingDamages,
    DateOnly? EstimatedDeliveryDate,
    IReadOnlyList<WorkOrderServiceItem> Services,
    IReadOnlyList<WorkOrderConsumableItem> Consumables,
    decimal SuggestedPrice,
    decimal Price,
    bool HasPrepayment, decimal? PrepaymentAmount,
    decimal RemainingAmount,                // Price - (PrepaymentAmount ?? 0)
    string Status,
    bool SocialMediaConsent,
    string TrackingUrl,
    DateTime? DeliveredAt, decimal? FinalPaymentAmount,
    IReadOnlyList<MediaFileResponse> Media,
    IReadOnlyList<StatusLogResponse> StatusHistory,
    DateTime CreatedAt);

public record WorkOrderServiceItem(int? ServicePriceId, string ServiceName, decimal PriceSnapshot);
public record WorkOrderConsumableItem(int ConsumableProductId, string ProductName,
    short Quantity, decimal UnitPriceSnapshot, decimal LineTotal);
```
- **Amaç:** İş emrinin tam detayı — medya ve durum geçmişi dahil. `RemainingAmount` sunucuda hesaplanır. `TrackingUrl` hazır tam link (`{PublicBaseUrl}/t/{token}`). Detay ayrıca son SMS durumlarını içerir (`sms_logs` — tip, durum, hata mesajı; resend butonu için).
- **Endpoint'ler:** `POST /api/work-orders` (201), `GET /api/work-orders/{id}`, `PUT /api/work-orders/{id}`, `PATCH .../status`, `POST .../deliver`.

```csharp
public record WorkOrderListItemResponse(
    long Id, string OrderNumber,
    string CustomerFullName, string CustomerPhone,
    string CategoryPath, string? Brand,
    string Status, decimal Price, decimal RemainingAmount,
    DateOnly? EstimatedDeliveryDate, DateTime CreatedAt);
```
- **Amaç:** Liste satırı (hafif DTO — medya/log içermez).
- **Endpoint:** `GET /api/work-orders` (`items` elemanı); müşteri detayındaki geçmiş işler de bu yapıdadır.

```csharp
public record StatusLogResponse(
    string? OldStatus, string NewStatus, string ChangedBy, DateTime ChangedAt);
```
- **Amaç:** Durum geçmişi kalemi; `ChangedBy` kullanıcı adı. (Not alanı log kayıtlarında taşınır; fiyat değişiklik notları da bu geçmişte görünür.)
- **Endpoint:** `WorkOrderResponse.StatusHistory` içinde.

## API Endpointleri

### `POST /api/work-orders`

- **Auth:** Evet — **Amaç:** İş emri oluşturma. `order_number` + `tracking_token` otomatik; seçilen hizmetlerin fiyatları snapshot'lanır, toplamı `suggested_price` olur.
- **Request DTO:** `CreateWorkOrderRequest` — **Response DTO:** `WorkOrderResponse` (201).
- **Validation:** `CategoryId` level=3 + aktif (üst kategoriler dahil); `ServicePriceIds` o kategoriye ait + aktif; sarf ürünleri aktif + mevcut; `Quantity >= 1`; `Price >= 0`; ön ödeme kuralları.
- **Başarılı senaryo:** 201; `orderNumber` `WO-{yıl}-` ile başlar; `trackingToken` 43 karakter; status log'da NULL→RECEIVED; `suggestedPrice` = hizmet + sarf toplamı.
- **Hata senaryoları:** 400 `INVALID_CATEGORY_LEVEL` · 400 `SERVICE_CATEGORY_MISMATCH` · 400 `INVALID_CATALOG_ITEM` (pasif/yok hizmet-sarf) · 400 (ön ödeme kuralları: `hasPrepayment=true, prepaymentAmount=null`; `prepaymentAmount > price`) · 404 (müşteri yok).
- **Tetiklenen iş kuralları:** snapshot'lama; `suggested_price` hesabı; path snapshot; ilk status log.
- **Yan etkiler:** **SMS GİTMEZ** (SMS #1'i ilk BEFORE medya confirm'i tetikler).

### `GET /api/work-orders?status=&search=&page=&pageSize=`

- **Auth:** Evet — **Amaç:** İş emri listesi. `search`: telefon, müşteri adı, iş emri no, marka; `status` filtresiyle AND'lenir.
- **Response:** `{ items: WorkOrderListItemResponse[], page, pageSize, totalCount }`, `created_at DESC`.
- **Hata:** 401.

### `GET /api/work-orders/{id}`

- **Auth:** Evet — **Amaç:** Detay (medya + durum logu + son SMS durumları dahil).
- **Response DTO:** `WorkOrderResponse`.
- **Hata:** 404, 401.
- **Not:** Medya `ViewUrl`'leri 15 dk ömürlü signed URL'dir — detay her açılışta taze üretilir.

### `PUT /api/work-orders/{id}`

- **Auth:** Evet — **Amaç:** Güncelleme (fiyat dahil).
- **Request:** Create alanları (customer/category hariç) — **Response DTO:** `WorkOrderResponse`.
- **Validation:** Create ile aynı katalog/ön ödeme kuralları; yalnızca RECEIVED/IN_PROGRESS/READY.
- **Başarılı:** 200; hizmet/sarf listeleri gönderildiyse snapshot'lar yenilenir (GÜNCEL katalog ad+fiyatıyla), `suggestedPrice` yeniden hesaplanır; fiyat değiştiyse log'a "Fiyat: X → Y" notu.
- **Hata:** 409 `ORDER_CLOSED` (DELIVERED/CANCELLED) · 409 (optimistic concurrency — bayat `updated_at`) · 400 (katalog/validasyon).

### `PATCH /api/work-orders/{id}/status`

- **Auth:** Evet — **Amaç:** Durum değişikliği → log yazılır. `READY` olunca **SMS #2 (ORDER_READY)** kuyruklanır.
- **Request DTO:** `UpdateWorkOrderStatusRequest` — **Response DTO:** `WorkOrderResponse` (güncel durum).
- **Validation:** geçiş matrisi (yukarıda); DELIVERED bu endpoint'ten YAPILAMAZ.
- **Başarılı:** 200; log satırı (+ not) yazılır.
- **Hata:** 409 `INVALID_STATUS_TRANSITION` (geçersiz geçiş, aynı→aynı, atlama) · 409 `ORDER_CLOSED`.
- **Yan etkiler:** READY'de ORDER_READY SMS'i kuyruğa (idempotent — `sms_logs`'ta ORDER_READY zaten varsa tekrar kuyruklanmaz); READY→IN_PROGRESS dönüşünde takip sayfasından AFTER medya geçici olarak kaybolur (tanımlı davranış).

### `POST /api/work-orders/{id}/deliver`

- **Auth:** Evet — **Amaç:** Teslim: `final_payment_amount` + `delivered_at` yazılır; status → DELIVERED.
- **Request DTO:** `DeliverWorkOrderRequest` — **Response DTO:** `WorkOrderResponse`.
- **Validation:** yalnızca READY'de çalışır; `finalPaymentAmount >= 0` (kalan tutar eşitliği kontrol edilmez).
- **Başarılı:** 200; `deliveredAt` dolar; dashboard `deliveredTodayCount` ve ciro artar; iş kapanır ama silinmez.
- **Hata:** 409 (READY değilken), 404.
- **Yan etkiler:** status log satırı; SMS gitmez.

### `POST /api/work-orders/{id}/sms/resend`

- **Auth:** Evet — **Amaç:** FAILED kalan son SMS'i tekrar göndermek (aynı `sms_type`; **idempotency bilinçli devre dışı**).
- **Request:** body yok — **Response:** 200 (SMS yeniden kuyruklanır).
- **Hata/özel durum:** NETGSM "mükerrer" filtresi (1 saat içinde aynı numaraya aynı içerik) — endpoint bu hatayı yakalar ve anlaşılır mesaj döner: "aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi". Sessiz başarısızlık YOK.
- **Yan etki:** `sms_logs`'a yeni QUEUED satır.

## Flutter Geliştirme Notları

- **Sayfa yapısı:** `WorkOrdersPage` (filtre + arama + tablo) → `WorkOrderDetailPage`; kabul sihirbazı ayrı route (`/intake`) — müşteri adımı + ürün adımı + medya adımı tek `Stepper`/`PageView`.
- **State:** `workOrderListProvider(status, search, page)`, `workOrderDetailProvider(id)`. Durum değiştiren her aksiyon sonrası hem detayı hem listeyi invalidate edin.
- **API çağrı sırası (kabul):** müşteri hazır → (cache) kategori seçimi → `categories/{id}/services` → `POST /work-orders` → medya 3'lü dansı. Sihirbaz adımları arasında geri dönüş yerel state'te tutulur; `POST` yalnızca son adımda atılır.
- **Fiyat önizleme:** istemci `suggested = Σ seçili hizmet fiyatları + Σ (adet × birim fiyat)` hesabını canlı gösterir ama 201 yanıtındaki `suggestedPrice`'ı esas alır.
- **Form yönetimi:** ön ödeme checkbox'ı → tutar alanının görünürlüğü/zorunluluğu; `0 ≤ prepayment ≤ price` client-side doğrulama; para girişleri için `TextInputFormatter` (2 hane, virgül/nokta toleransı).
- **Durum aksiyonları:** buton görünürlüğü status'e göre türetilir (yukarıdaki matrisin UI karşılığı). `READY → Teslim Et` butonu PATCH değil `/deliver` modalını açar.
- **Concurrency 409'u:** PUT 409 dönerse otomatik olarak detayı yeniden çekip formu güncel verilerle doldurun ve kullanıcıya "kayıt değişmişti, güncellendi — kontrol edip tekrar kaydedin" deyin.
- **Liste yenileme:** durum değişikliği/teslim/iptal sonrası listeyi yenileyin; ayrıca `INVALID_STATUS_TRANSITION` alınca da yenileyin (başka cihaz değiştirmiş olabilir).
- **Çift tıklama:** tüm mutasyon butonları istek sürerken disable (Idempotency-Key olmadığından bu sizin sorumluluğunuz).
- **trackingUrl:** detayda "linki kopyala" aksiyonu; linki uygulama içinde üretmeyin, response'takini kullanın.

## Notlar

- Tahmini teslim tarihinin nasıl belirleneceği (elle mi, otomatik gün hesabı mı) firmaya sorulmuş açık bir konudur; Faz 1'de admin elle girer (opsiyonel alan).
- İptal durumunda ön ödeme iadesi politikası (tam iade / kesinti / iade yok) firmaya sorulmuştur; Faz 1'de yalnızca not alanı vardır — uygulamada iade hesabı yapmayın, iptal notuna yazılmasını sağlayın.
- İade takibi olmadığı için iptaller ciroyu düzeltmez (bilinçli Faz 1 sınırı — dashboard formüllerinde görülür).
- CANCELLED işin takip sayfası 404 DEĞİLDİR — "İptal Edildi" durumuyla render edilir; medya görünür kalır, sosyal medya toggle'ı pasiftir (consent denemesi 409).
- Kabul testlerinden doğrulanmış örnek: "Kadın > Ayakkabı > Sneakers" + "Bakım ve Boya" (1.250 TL) + 2 × Deri Bakım Kremi (150 TL) → `suggestedPrice = 1.550`.
- Katalogda hizmet fiyatı VE adı değiştirilse bile ESKİ iş emrinin snapshot ad/fiyatı ve `suggestedPrice`'ı DEĞİŞMEZ (firma şartının birebir test edildiği senaryo). PUT ile hizmet listesi değiştirilirse yeni satırlar GÜNCEL katalog değerleriyle yazılır.

---

# 5. Feature: Medya Yönetimi (Presigned Upload, Görüntüleme, Silme)

## Amaç

İş emrine ait öncesi/sonrası/detay foto ve videolarını yönetmek. Dosyalar **API'den geçmez**: istemci backend'den presigned PUT URL alır, dosyayı **doğrudan MinIO'ya** (media.domain.com) yükler, sonra backend'e "confirm" der. Bu tasarım büyük videoların (500 MB'a kadar) API sunucusuna yük bindirmemesi içindir. İlk BEFORE medyanın confirm'i, müşteriye giden ORDER_RECEIVED SMS'ini (SMS #1) tetikler — link boş sayfaya açılmasın diye SMS medya beklenmeden GÖNDERİLMEZ.

## İşleyiş Akışı

### Yükleme — her dosya için "3'lü dans"

1. `POST /api/work-orders/{id}/media/request-upload { mediaType, stage, fileName, mimeType, sizeBytes }`
   → 200 `{ mediaFileId, uploadUrl (presigned PUT), expiresAt }`. DB'de `media_files` satırı `PENDING` oluşur. Presigned PUT URL **10 dakika** geçerlidir.
2. İstemci dosyayı **DOĞRUDAN** `uploadUrl`'e HTTP PUT eder (HttpClient/dio + stream; API'ye uğramaz; **progress bar bu adımda** gösterilir).
3. `POST /api/work-orders/{id}/media/confirm { mediaFileId }`
   → Backend MinIO'ya `StatObject` atar; gerçek boyut, ETag, Content-Type alınır. İstemcinin beyan ettiği boyutla uyuşmazsa veya nesne yoksa **400** + kayıt FAILED/PENDING kalır. Uyuşursa `upload_status = UPLOADED`; `size_bytes` ve `etag` **MinIO'dan gelen değerlerle** yazılır (istemci beyanına güvenilmez).
4. Eğer bu, iş emrinin **ilk BEFORE** medyasının confirm'i ise backend **ORDER_RECEIVED SMS'ini (SMS #1)** kuyruklar — istemcinin SMS için ayrıca bir şey yapması gerekmez. İkinci BEFORE confirm'de SMS tekrar kuyruklanmaz (idempotent — `sms_logs`'ta ORDER_RECEIVED var mı kontrolü).
5. Medya, iş emri oluşturulduktan **istenildiği kadar sonra** eklenebilir: video o an çekilemiyorsa iş emri medyasız kaydedilir; video ne zaman yüklenirse SMS o zaman gider (2 gün sonra bile).

### Görüntüleme

- `GET /api/work-orders/{id}/media` → her medya için kısa ömürlü (**15 dk**) signed GET `ViewUrl` listesi. İş emri detayı (`WorkOrderResponse.Media`) da aynı yapıyı içerir. Süresi geçen URL için listeyi yeniden çekmek yeterlidir.

### Silme (hatalı yükleme)

- `DELETE /api/media/{id}` → MinIO nesnesi + DB satırı **birlikte** silinir (sistemdeki hard delete'in tek istisnası). Yalnızca arşivlenmemiş medya + iş emri açıkken. SMS zaten gittiyse tekrar gönderilmez; takip sayfası geçici olarak medyasız kalır (kabul edilebilir) — doğru medya yüklenince sayfa kendiliğinden düzelir (link aynıdır).

### Arka plan temizliği (istemci tetiklemez)

- 24 saatten eski `upload_status = PENDING` kayıtlar (yarım kalmış upload'lar) günlük job ile (03:00 TR) MinIO'daki yarım nesneyle birlikte silinir. 23 saatlik PENDING silinmez.

## UI Gereksinimleri

- **Medya yükleme paneli (kabul sihirbazının son adımı + iş emri detayında):**
  - Stage seçimi: BEFORE / AFTER / DETAIL (kabulde default BEFORE; READY öncesi AFTER yüklemesi serbesttir)
  - Dosya seçici (çoklu seçim): foto (jpg/png) + video (mp4) filtresi
  - **Format dönüştürme uyarıları:** HEIC seçilirse otomatik JPEG'e çevir (veya kullanıcıya çevirip yükleneceğini bildir); MOV/HEVC seçilirse MP4'e çevir — dönüştürme istemci sözleşmesi gereğidir
  - Boyut ön kontrolü: video > 500 MB veya foto > 25 MB ise yerelde reddet ("Dosya çok büyük" mesajı) — sunucu da reddeder ama kullanıcıyı upload'a başlatmadan uyarmak daha iyi
  - Her dosya için ayrı ilerleme çubuğu (PUT aşaması) + durum ikonu (bekliyor / yükleniyor / doğrulanıyor / tamam / hata)
  - Hata durumunda "Tekrar dene" (yeni request-upload'dan başlayarak)
  - İş emri başına 20 medya limiti göstergesi ("14/20")
  - İlk BEFORE confirm sonrası bilgi: "Müşteriye takip linki SMS ile gönderildi"
- **Medya galerisi (iş emri detayında):**
  - BEFORE / AFTER / DETAIL sekmeleri; foto grid + tıklayınca büyük önizleme; video için oynatıcı
  - URL süresi dolmuşsa (görsel yüklenemedi) otomatik `GET .../media` ile yenileme
  - Her öğede "Sil" (yalnızca iş emri açıkken) — confirmation dialog: "Bu medya kalıcı olarak silinecek. SMS zaten gönderildiyse tekrar gönderilmez. Emin misiniz?"
- **Kapalı işte:** yükleme ve silme aksiyonları gizli/disable (`ORDER_CLOSED`).

## İş Kuralları

- **Format sözleşmesi (KESİN LİSTE):** Foto `image/jpeg`, `image/png` (HEIC REDDEDİLİR — tarayıcılar render edemez; istemci JPEG'e çevirir). Video **yalnızca** `video/mp4` H.264 (`.mov`/HEVC REDDEDİLİR — Chrome/Android oynatamaz; istemci MP4'e çevirir). Not: `request-upload` mime whitelist'i teknik olarak `video/mp4, video/quicktime, image/jpeg, image/png, image/heic` içerir, ancak kesin format kararı gereği istemci yalnızca jpeg/png/mp4 göndermelidir.
- **Limitler:** video ≤ **500 MB**, foto ≤ **25 MB**; iş emri başına max **20 medya** (21. → 400). Uymayan istek presigned URL alamaz (400).
- **request-upload durumu kısıtı:** yalnızca status DELIVERED/CANCELLED **değilken** çağrılabilir (409 `ORDER_CLOSED`). Teslimden önce AFTER medya yüklenebilir (READY'deyken); teslimden sonra yüklenemez.
- **Confirm doğrulaması sunucudan:** confirm'de sunucu MinIO `StatObject` ile gerçek boyut/ETag/Content-Type alır; istemci beyanıyla uyuşmazsa veya nesne yoksa 400 (satır PENDING kalır). `size_bytes` ve `etag` MinIO'dan yazılır.
- **ETag'in amacı:** MinIO ETag (MD5) confirm anında `media_files.etag`'e kaydedilir; arşiv indirmede bütünlük doğrulaması için kullanılır (Arşiv feature'ı) — boyut karşılaştırması tek başına yeterli sayılmaz.
- **SMS #1 tetikleyicisi:** iş emrinin İLK BEFORE medyası confirm edildiğinde (link açılınca boş sayfa görünmesin diye). Medya, iş emrinden istenildiği kadar sonra eklenebilir; SMS medya yüklendiğinde gider. Aynı iş emri için tekrar tetiklenmez (idempotent).
- **storage_key düzeni:** `wo/{workOrderId}/{stage}/{mediaFileId}.{ext}` (stage küçük harf: before/after/detail). `storage_key` ASLA public URL değildir; erişim yalnızca signed URL ile.
- **Presigned URL süreleri:** PUT **10 dk**, izleme GET **15 dk**, arşiv GET **2 saat**.
- **DELETE kuralları:** yalnızca arşivlenmemiş medya + iş emri açıkken; MinIO nesnesi + DB satırı birlikte gider (hard delete'in tek istisnası). SMS'ten sonra silinirse takip sayfası geçici medyasız kalır — kabul edilebilir; SMS tekrar gönderilmez.
- **Yarım upload temizliği:** 24 saatten eski PENDING kayıtlar günlük job ile silinir.
- **Takip sayfası görünürlüğü:** AFTER medya public sayfada yalnızca status READY/DELIVERED iken görünür; READY→IN_PROGRESS dönüşünde geçici kaybolur, yeniden READY olunca döner — bug değil, tanımlı davranış.
- **Link paylaşımı bilinçli risk:** takip linkinin paylaşılması engellenemez; koruma, medya URL'lerinin 15 dk ömürlü olmasıdır — sayfa dışına kopyalanan video linki kısa sürede ölür.

## Veritabanı Modelleri

### `media_files`

İş emri medya kayıtları. Fiziksel dosya MinIO'dadır; bu tablo meta veriyi ve yükleme durumunu tutar. `PENDING → UPLOADED` yaşam döngüsü, presigned upload'un iki aşamalı (request + confirm) olmasındandır: satır önce niyet olarak açılır, dosya MinIO'ya varınca doğrulanıp kesinleşir.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | `mediaFileId` |
| `work_order_id` | BIGINT NOT NULL FK → work_orders | |
| `media_type` | VARCHAR(10) NOT NULL | PHOTO · VIDEO |
| `stage` | VARCHAR(10) NOT NULL | BEFORE · AFTER · DETAIL |
| `storage_key` | TEXT NOT NULL | MinIO key (`wo/{id}/{stage}/{mediaId}.{ext}`), ASLA public URL; arşivlenince NULL'a çekilir |
| `mime_type` | VARCHAR(100) NOT NULL | |
| `size_bytes` | BIGINT NOT NULL | Confirm'de MinIO'dan yazılır |
| `etag` | VARCHAR(64) NULL | MinIO ETag (MD5) — confirm anında kaydedilir; arşiv indirmede bütünlük doğrulaması için |
| `upload_status` | VARCHAR(20) NOT NULL DEFAULT 'PENDING' | PENDING · UPLOADED · FAILED |
| `is_archived` | BOOLEAN NOT NULL DEFAULT FALSE | Arşiv feature'ı ile eklenen kolon |
| `archived_at` | TIMESTAMPTZ NULL | Arşivlenme anı |
| `created_at` | TIMESTAMPTZ NOT NULL | |

İndeks: `idx_media_wo (work_order_id, stage)`.

## DTO'lar

### Request DTO'ları

```csharp
public record RequestMediaUploadRequest(
    string MediaType,   // PHOTO | VIDEO
    string Stage,       // BEFORE | AFTER | DETAIL
    string FileName, string MimeType, long SizeBytes);
```
- **Amaç:** Presigned PUT URL istemek. `MimeType` whitelist'te olmalı; `SizeBytes` limit içinde olmalı (ve confirm'de MinIO gerçeğiyle karşılaştırılacak beyandır).
- **Endpoint:** `POST /api/work-orders/{id}/media/request-upload`.

```csharp
public record ConfirmMediaUploadRequest(long MediaFileId);
```
- **Amaç:** PUT tamamlandıktan sonra sunucu doğrulamasını tetiklemek.
- **Endpoint:** `POST /api/work-orders/{id}/media/confirm`.

### Response DTO'ları

```csharp
public record RequestMediaUploadResponse(
    long MediaFileId, string UploadUrl, DateTime ExpiresAt);  // presigned PUT
```
- **Amaç:** Yükleme hedefi. `UploadUrl` 10 dk geçerli; `ExpiresAt` geçtiyse yeni request-upload gerekir.
- **Endpoint:** `POST .../media/request-upload`.

```csharp
public record MediaFileResponse(
    long Id, string MediaType, string Stage,
    string ViewUrl,     // kısa ömürlü signed GET URL (15 dk)
    DateTime CreatedAt);
```
- **Amaç:** Görüntülenebilir medya kalemi.
- **Endpoint'ler:** `GET /api/work-orders/{id}/media`; `WorkOrderResponse.Media` içinde.

## API Endpointleri

### `POST /api/work-orders/{id}/media/request-upload`

- **Auth:** Evet — **Amaç:** Presigned PUT URL üretimi (video API'den geçmez).
- **Request DTO:** `RequestMediaUploadRequest` — **Response DTO:** `RequestMediaUploadResponse`.
- **Validation:** mime whitelist; boyut limiti (video ≤ 500 MB, foto ≤ 25 MB); iş emri başına max 20 medya; iş emri açık olmalı.
- **Başarılı:** 200; `media_files` satırı PENDING.
- **Hata:** 400 (HEIC/MOV/limit aşımı/21. medya — her biri ayrı 400) · 409 `ORDER_CLOSED` (DELIVERED/CANCELLED işe) · 404.
- **Yan etki:** PENDING DB satırı (24 saat confirm edilmezse günlük job siler).

### `POST /api/work-orders/{id}/media/confirm`

- **Auth:** Evet — **Amaç:** Yüklemeyi doğrulamak: `upload_status = UPLOADED`. **İlk BEFORE medya onayında SMS #1 tetiklenir.**
- **Request DTO:** `ConfirmMediaUploadRequest` — **Response:** 200.
- **Validation:** MinIO `StatObject` — nesne var mı, boyut beyanla uyuşuyor mu; uymazsa 400, satır PENDING kalır.
- **Başarılı:** 200; `size_bytes`/`etag` MinIO değerleriyle yazılır.
- **Hata:** 400 (nesne yok / boyut uyuşmazlığı), 404.
- **Yan etkiler:** ilk BEFORE confirm'de `ORDER_RECEIVED` SMS'i kuyruğa (takip linkiyle); sonrakiler tetiklemez (idempotent).

### `GET /api/work-orders/{id}/media`

- **Auth:** Evet — **Amaç:** Signed görüntüleme URL'leri (15 dk).
- **Response:** `MediaFileResponse[]`.
- **Hata:** 404, 401.

### `DELETE /api/media/{id}`

- **Auth:** Evet — **Amaç:** Hatalı yüklemeyi silmek.
- **Kısıtlar:** yalnızca arşivlenmemiş medya + iş emri açıkken.
- **Başarılı:** MinIO nesnesi + DB satırı birlikte silinir.
- **Hata:** 409 (kapalı iş / arşivlenmiş medya), 404.
- **Yan etkiler:** SMS zaten gittiyse tekrar gönderilmez; takip sayfası ilgili medya olmadan render olur.

## Flutter Geliştirme Notları

- **Dosya yükleme akışı:** her dosya için sıralı üçlü: `request-upload` → dio `put(uploadUrl, data: file.openRead(), options: Options(headers: {'Content-Type': mimeType, 'Content-Length': size}))` → `confirm`. Çoklu dosyada sınırlı paralellik (2-3 eşzamanlı) önerilir.
- **Progress:** PUT aşamasında `onSendProgress` ile dosya bazlı ilerleme; confirm kısa sürer, "doğrulanıyor" spinner'ı yeterli.
- **10 dk kuralı:** 500 MB video yavaş bağlantıda 10 dk'yı aşabilir — PUT 403 (expired) dönerse akışı `request-upload`'dan otomatik yeniden başlatın (eski PENDING satırı gece temizlenir, sorun değildir).
- **HEIC → JPEG:** macOS/Windows'ta `image` paketi veya platform kanalı; **MOV/HEVC → MP4:** `ffmpeg_kit_flutter` ya da sisteme kurulu ffmpeg'i `Process.run` ile çağırma (desktop'ta en pratik yol). Dönüştürme sırasında ayrı bir "dönüştürülüyor" durumu gösterin.
- **Boyut beyanı:** `sizeBytes` alanına **dönüştürme SONRASI** dosyanın gerçek boyutunu yazın — confirm'de MinIO gerçeğiyle karşılaştırılır, uyuşmazlık 400 döndürür.
- **Video oynatma:** desktop'ta `media_kit` önerilir (`video_player` desktop desteği sınırlı). URL 15 dk ömürlü — oynatıcı açılmadan hemen önce taze liste çekmek en sağlamı.
- **Hata yönetimi:** PUT ağ hatası → aynı `uploadUrl` süresi içindeyse tekrar dene; süresi geçtiyse yeni request-upload. Confirm 400 → dosyayı yeniden yükle (baştan üçlü).
- **State:** `UploadTask` kuyruğu (dosya, stage, durum, progress) — sihirbaz kapansa da devam eden upload'ları gösterecek global bir upload yöneticisi düşünün.

## Notlar

- Nginx: API sunucusunda `client_max_body_size 2m` — yanlışlıkla dosyayı API'ye POST ederseniz 413 alırsınız; medya alt alan adında limit 500 MB ve `proxy_request_buffering off` (büyük upload'larda diske buffer'lanmaz).
- MinIO bucket private'tır (`leathercare-media`); erişim yalnızca presigned URL'lerle.
- İstemci makinenin saati kayıksa presigned URL'ler geçersiz görünebilir — hata mesajlarında "bilgisayar saatinizi kontrol edin" önerisi bulundurun.
- Video sıkıştırma/thumbnail üretimi (ffmpeg worker) Faz 2+ konusudur; Faz 1'de yüklenen dosya olduğu gibi saklanır.
- Beklenen hacim: günde ~10 ürün × öncesi+sonrası video ≈ ayda ~50 GB — disk yönetimi Arşiv feature'ı ile yapılır.

---

# 6. Feature: SMS Bildirimleri (Outbox, Durum İzleme, Yeniden Gönderim)

## Amaç

Müşteriye üç tür bilgilendirme SMS'i göndermek ve bunların durumunu admin'e görünür kılmak:

1. **`IYS_VERIFICATION_CODE`** — müşteri kaydında otomatik giden 4 haneli İYS onay kodu.
2. **`ORDER_RECEIVED` (SMS #1)** — ilk BEFORE medya confirm'inde giden "ürününüz teslim alınmıştır" + takip linki.
3. **`ORDER_READY` (SMS #2)** — status READY olduğunda giden "ürününüz hazırdır" + takip linki.

(`CAMPAIGN` tipi ticari SMS ileride eklenecektir; Faz 1'de gönderilmez ama şema hazırdır.)

İstemci hiçbir SMS'i doğrudan göndermez ve tetiklemez (tek istisna: FAILED SMS'in manuel resend'i). SMS'ler backend'de **outbox deseni** ile asenkron gönderilir.

## İşleyiş Akışı

1. Bir iş kuralı SMS'i tetiklediğinde (kayıt, ilk BEFORE confirm, READY geçişi) backend `sms_logs` tablosuna **QUEUED** satır yazar — iş verisiyle **aynı transaction'da**. İstek bu noktada döner; **gönderim ASLA request içinde yapılmaz** (NETGSM yavaşlığı/çökmesi API isteklerini bekletmesin diye).
2. `MaintenanceHostedService` içindeki SMS görevi **5 saniyede bir** QUEUED satırları çeker (turda en fazla **10** adet, `ORDER BY created_at`), NETGSM'e gönderir (`POST https://api.netgsm.com.tr/sms/rest/v2/send`, HTTP Basic Auth, timeout 10 sn).
3. Sonuç: satır **SENT** (`provider_msg_id` = NETGSM bulkid) veya ağ hatası/5xx'te **30 sn sonra 1 otomatik tekrar**; ikinci başarısızlık = **FAILED** (`error_message` dolu). Bir satırın hatası döngüyü durdurmaz — diğer QUEUED'lar gönderilmeye devam eder.
4. Admin, iş emri detayında son SMS durumlarını görür (QUEUED / SENT / FAILED + hata mesajı).
5. FAILED için admin "SMS'i tekrar gönder" der → `POST /api/work-orders/{id}/sms/resend` → SMS aynı `sms_type` ile yeniden kuyruklanır. NETGSM 1 saat içinde aynı numaraya aynı içeriği "mükerrer" diye engellerse endpoint bunu yakalayıp net mesaj döner.

## UI Gereksinimleri

- **İş emri detayında SMS durum kartı:**
  - Satırlar: SMS tipi (Türkçe etiket: "Onay Kodu", "Teslim Alındı Bildirimi", "Hazır Bildirimi"), durum rozeti (QUEUED sarı "kuyrukta", SENT yeşil "gönderildi" + gönderim zamanı, FAILED kırmızı "başarısız" + hata mesajı tooltip)
  - FAILED satırda "Tekrar Gönder" butonu → confirmation dialog ("SMS yeniden gönderilecek")
  - Resend'de NETGSM mükerrer engeli dönerse bilgi diyaloğu: "Aynı mesaj 1 saat içinde tekrar gönderilemez (NETGSM engeli). Daha sonra deneyin."
- QUEUED durumu genelde saniyeler içinde SENT olur; detay ekranını yenileme butonu yeterlidir (poll gerekmez).

## İş Kuralları

- **SMS sınıflandırması:** Bilgilendirme SMS'leri (`IYS_VERIFICATION_CODE`, `ORDER_RECEIVED`, `ORDER_READY`) `filter=0` ile gider, İYS kontrolü yapılmaz, İYS onayı olmayan müşteriye de gider. Şart: içerik gerçekten bilgilendirme olmalı (durum + takip linki; kampanya/promosyon ASLA eklenmez, yoksa ticari sayılır). Ticari SMS'ler (`CAMPAIGN`, ileride) `filter=11` (bireysel) ile ve yalnızca APPROVED müşterilere gider; kesin güvence NETGSM'in gönderim anındaki İYS filtresidir. (`filter=12` = ticari/tacir — şemada tanımlı, Faz 1'de kullanılmaz.)
- **SMS #1 tetikleyicisi:** iş emrinin ilk BEFORE medyası confirm edildiğinde; idempotent (`sms_logs`'ta ORDER_RECEIVED var mı kontrolü). Medya günler sonra yüklenirse SMS o zaman gider.
- **SMS #2 tetikleyicisi:** status READY'ye çekildiğinde; aynı şekilde idempotent (ikinci kez READY'de tekrar gitmez).
- **İdempotency baypasları (bilinçli):** (a) `sms/resend` endpoint'i — admin manuel tekrar gönderebilsin diye; (b) telefon değişikliğinde açık iş emirlerine yeni linkli ORDER_RECEIVED — yeni numara güncel linki alsın diye.
- **Outbox:** gönderim asla request içinde değil; QUEUED satır iş verisiyle aynı transaction'da; görev 5 sn'de bir, turda max 10, `created_at` sırasıyla (25 SMS kuyruktaysa tek turda 10 işlenir).
- **NETGSM çağrı sözleşmesi:** `POST https://api.netgsm.com.tr/sms/rest/v2/send`, HTTP Basic Auth, timeout 10 sn; ağ hatası/5xx'te 30 sn sonra 1 otomatik tekrar; ikincisi de başarısızsa FAILED.
- **NETGSM mükerrer filtresi:** 1 saat içinde aynı numaraya aynı içerik engellenir; resend bu hatayı yakalayıp anlaşılır döner — sessiz başarısızlık YOK.
- **Şablonlar** backend config'te (`appsettings`), placeholder'lı: `IysCode`: `"{code} kodu ile İYS onayınızı tamamlayabilirsiniz. {firma}"` · `OrderReceived`: `"Sayın {ad} {soyad}, ürününüz teslim alınmıştır. Takip: {link}"` · `OrderReady`: `"Ürününüz hazırdır. Son halini görmek için: {link}"`. Kesin metinler firmadan gelince yalnızca config değişir.
- **Encoding:** `encoding=TR` (Türkçe karakterli) — firma aksini istemedikçe. `msgheader` config'ten (`Sms:Header`, firmanın onaylı başlığı).
- **SMS linki kısa tutulur:** `domain.com/t/{token}` — token 43 karakter; SMS karakter bütçesi gözetilir.
- SMS başarısızlığı görünür olmalı: iş emri detayı son SMS durumlarını içerir.

## Veritabanı Modelleri

### `sms_logs`

Gönderilen/gönderilecek tüm SMS'lerin kaydı. Hem outbox kuyruğu (QUEUED satırlar) hem denetim izi hem de idempotency kontrolünün ("bu işe ORDER_RECEIVED gitti mi?") kaynağıdır — bu üç görev için vardır.

| Kolon | Tip | Açıklama |
|---|---|---|
| `id` | BIGSERIAL PK | |
| `customer_id` | BIGINT NULL FK → customers | |
| `work_order_id` | BIGINT NULL FK → work_orders | Kod SMS'inde NULL olabilir |
| `sms_type` | VARCHAR(30) NOT NULL | IYS_VERIFICATION_CODE · ORDER_RECEIVED · ORDER_READY · CAMPAIGN (ileride) |
| `iys_filter` | VARCHAR(2) NOT NULL DEFAULT '0' | NETGSM filter: 0 = bilgilendirme (İYS kontrolsüz) · 11 = ticari/bireysel · 12 = ticari/tacir (İYS kontrollü) |
| `phone` | VARCHAR(20) NOT NULL | |
| `message_body` | TEXT NOT NULL | Gönderilen tam metin |
| `provider_msg_id` | VARCHAR(100) NULL | NETGSM bulkid |
| `status` | VARCHAR(20) NOT NULL DEFAULT 'QUEUED' | QUEUED · SENT · FAILED |
| `error_message` | TEXT NULL | FAILED nedeninin metni |
| `sent_at` | TIMESTAMPTZ NULL | |
| `created_at` | TIMESTAMPTZ NOT NULL | Kuyruk sırası bu alana göredir |

## DTO'lar

SMS feature'ının kendine özel public DTO'su yoktur; SMS durumları iş emri detayının içinde döner (tip, durum, hata mesajı, zaman). `POST /api/work-orders/{id}/sms/resend` body'siz çağrılır ve 200/hata mesajı döner.

## API Endpointleri

### `POST /api/work-orders/{id}/sms/resend`

- **Auth:** Evet — **Amaç:** FAILED kalan son SMS'i tekrar göndermek (aynı `sms_type`; idempotency bilinçli devre dışı).
- **Request:** yok — **Response:** 200.
- **Başarılı:** SMS yeniden QUEUED; arka plan görevi gönderir.
- **Hata:** NETGSM mükerrer engeli → anlaşılır mesaj ("aynı mesaj 1 saat içinde tekrar gönderilemez, NETGSM engelledi"); 404.
- **Yan etki:** yeni `sms_logs` satırı.

(SMS'leri kuyruklayan diğer endpoint'ler kendi feature'larında anlatıldı: `POST /api/customers` ve `resend-code` → IYS_VERIFICATION_CODE; `media/confirm` → ORDER_RECEIVED; `PATCH .../status READY` → ORDER_READY; `PUT /api/customers/{id}` telefon değişikliği → açık işlere ORDER_RECEIVED.)

## Flutter Geliştirme Notları

- SMS durumlarını iş emri detay modelinin parçası olarak modelleyin (`SmsLogItem { type, status, errorMessage, sentAt }`).
- Türkçe tip etiketleri sabit map: `IYS_VERIFICATION_CODE → "Onay Kodu"`, `ORDER_RECEIVED → "Teslim Alındı Bildirimi"`, `ORDER_READY → "Hazır Bildirimi"`.
- Resend butonu istek sürerken disable; başarıda detayı yenileyin (yeni QUEUED satır görünsün).
- QUEUED → SENT geçişi için polling KURMAYIN; kullanıcı yenilediğinde güncellenir (altın kural #1: zamanlamalar backend'indir).

## Notlar

- SMS içerikleri backend log dosyasına ayrıca yazılmaz — `sms_logs` tablosunda zaten tam hali vardır.
- SMS metinlerinin kesin halleri ve Türkçe karakter kullanımı (karakter bütçesi/ücret etkisi) firmaya sorulmuş açık konudur; şablon değişimi yalnızca backend config'idir, istemciyi etkilemez.
- NETGSM hesabı/İYS yetkilendirmesi tamamlanmadan SMS'ler FAILED düşer — geliştirme/test ortamında bu durumu normal karşılayın ve UI'ın FAILED gösterimini bu sayede test edin.

---

# 7. Feature: Public Takip Sayfası ve Sosyal Medya İzni (Müşteri Tarafı)

## Amaç

Müşterinin, SMS'teki `domain.com/t/{token}` linkinden ürününün durumunu, öncesi/sonrası görsellerini görebilmesi ve **sosyal medyada paylaşım iznini kendisinin** verip geri alabilmesi.

**Önemli:** Takip sayfasının kendisi (`/t/{token}`) backend içindeki Razor sayfasıdır ve **Flutter geliştiricisi tarafından yapılmaz**. Ancak bu bölümdeki public API sözleşmesi ve davranışlar bilinmelidir, çünkü: (a) admin uygulamasındaki işlemler bu sayfayı doğrudan etkiler, (b) `trackingUrl` admin uygulamasında gösterilir/kopyalanır, (c) sosyal medya izni (`socialMediaConsent`) admin tarafındaki Sosyal Medya ekranının veri kaynağıdır.

## İşleyiş Akışı

1. Müşteri SMS'teki linke tıklar → `GET /t/{token}` — sayfa sunucu tarafında render edilir (JS fetch'e bile gerek yok), login yok, sade ve mobil önceliklidir (müşteri %95 telefondan açar).
2. Token geçersizse: nötr "Kayıt bulunamadı" sayfası (404) — token'ın doğru mu yanlış mı olduğu belli edilmez.
3. Geçerliyse sayfada gösterilir: iş emri no, ürün türü, marka, renk; durum adım çubuğu (`Teslim Alındı → İşlemde → Hazır → Teslim Edildi`); tahmini teslim tarihi; **öncesi** foto/video (signed URL, `<video controls playsinline>`); **sonrası** foto/video **yalnızca READY veya DELIVERED ise**; "Sosyal medyada paylaşılmasına izin veriyorum" toggle butonu.
4. Signed URL'ler 15 dk ömürlü olduğundan sayfa her açılışta taze URL üretir — müşteri linki günler sonra açsa da çalışır, ama sayfa dışına kopyalanan URL kısa sürede ölür.
5. Müşteri izin butonuna tıklar → sayfadaki tek JS satırı: `PUT /api/public/tracking/{token}/social-media-consent { consent: true|false }` — tıklayınca ON, tekrar tıklayınca OFF; **istediği kadar değiştirebilir**. Her değişiklikte `social_media_consent_at` güncellenir.
6. İzin veren işlerin öncesi/sonrası içerikleri, admin uygulamasındaki Sosyal Medya ekranında (`GET /api/social-media/items`) listelenir; müşteri toggle'ı kapatınca listeden düşer.

## UI Gereksinimleri

(Sayfa backend'indir; burada admin uygulamasını ilgilendiren kısımlar:)

- İş emri detayında `trackingUrl` gösterimi + "kopyala" butonu; isteğe bağlı QR üretimi (müşteriye telefonda okutmak için — istemci tarafı kolaylığı, backend gerektirmez).
- Admin, müşterinin izin durumunu iş emri detayında rozet olarak görür (`socialMediaConsent` alanı) — admin bu izni DEĞİŞTİREMEZ (izni yalnızca müşteri public sayfadan verir/geri alır); uygulamaya izin değiştirme butonu koymayın.

## İş Kuralları

- **Sınırlı veri:** Public endpoint fiyat, ödeme, log ve iç bilgileri ASLA döndürmez — JSON'da alan adı bile geçmez.
- **AFTER medya görünürlüğü anlık statüye bağlıdır:** yalnızca READY/DELIVERED'da dolu; READY→IN_PROGRESS geri dönüşünde geçici kaybolur (tanımlı davranış).
- **Consent toggle kuralı:** token geçerli + status CANCELLED değilse toggle edilebilir; her değişiklikte `social_media_consent_at` güncellenir. CANCELLED işte toggle → 409, buton sayfada pasiftir.
- **İptal edilen işin sayfası:** 404 değil, "İptal Edildi" durumuyla render edilir; medya görünür kalır, toggle pasif.
- **Arşivlenmiş işin sayfası:** medya yerine "Görseller arşivlenmiştir" gösterilir; signed URL üretilmez.
- **Geçersiz/bulunamayan token:** 404 + nötr sayfa — token'ın var olup olmadığı ayırt edilemez.
- **Rate limit:** IP başına dakikada **30** sayfa/tracking isteği; consent toggle için IP başına dakikada **5**. Aşımda 429.
- **Durum etiketleri (TR):** RECEIVED→"Teslim Alındı", IN_PROGRESS→"İşlemde", READY→"Hazır", DELIVERED→"Teslim Edildi", CANCELLED→"İptal Edildi". (Admin uygulamasında da aynı etiketleri kullanın — tutarlılık.)
- **OpenGraph:** yalnızca jenerik başlık ("Ürün Takip") + firma adı; ürün fotoğrafı OG'ye KONMAZ (WhatsApp önizlemesinde ürün görselinin sızmaması için).
- **Cache:** sayfa `Cache-Control: no-store` (signed URL'ler her açılışta taze).
- **Link paylaşımı bilinçli risk:** engellenemez; koruma 15 dk'lık signed URL ömrüdür.
- İzin sonradan kapatılırsa o ana kadar paylaşılmış gönderiler firmanın sorumluluğundadır (teknik olarak yalnızca listeden düşer) — izin metni ve bu beklenti firmayla yazılı netleştirilecektir.

## Veritabanı Modelleri

Ayrı tablo yoktur; `work_orders.tracking_token`, `social_media_consent`, `social_media_consent_at` alanları kullanılır (İş Emri feature'ındaki tablo). Token UNIQUE'tir ve `idx_wo_token` indeksi ile aranır.

## DTO'lar

### Request DTO'ları

```csharp
public record SetSocialMediaConsentRequest(bool Consent);
```
- **Amaç:** Müşterinin izin butonu (true=ON, false=OFF).
- **Endpoint:** `PUT /api/public/tracking/{token}/social-media-consent`.

### Response DTO'ları

```csharp
public record PublicTrackingResponse(
    string OrderNumber,
    string ProductType, string? Brand, string? Color,
    string Status,                       // Türkçe etikete map'lenmiş
    DateOnly? EstimatedDeliveryDate,
    bool SocialMediaConsent,             // buton on/off durumu
    IReadOnlyList<PublicMediaItem> BeforeMedia,
    IReadOnlyList<PublicMediaItem> AfterMedia);  // sadece READY/DELIVERED ise dolu
// Fiyat, ödeme, log, iç bilgiler ASLA dönmez.

public record PublicMediaItem(string MediaType, string ViewUrl);
```
- **Amaç:** Takip sayfası verisi — bilinçli olarak SINIRLI.
- **Endpoint:** `GET /api/public/tracking/{token}`.

```csharp
public record SetSocialMediaConsentResponse(bool SocialMediaConsent);
```
- **Amaç:** Toggle sonrası güncel durum.
- **Endpoint:** `PUT /api/public/tracking/{token}/social-media-consent`.

## API Endpointleri

### `GET /api/public/tracking/{token}`

- **Auth:** **YOK** — token yeterli; IP bazlı rate limit (dakikada 30).
- **Amaç:** Takip sayfası verisi (sınırlı DTO).
- **Response DTO:** `PublicTrackingResponse` (`Status` Türkçe etiket olarak).
- **Başarılı:** 200; CANCELLED işte de 200 ("İptal Edildi" ile).
- **Hata:** 404 (geçersiz token — nötr), 429 (rate limit).
- **Yan etki:** medya için taze signed URL üretimi.

### `PUT /api/public/tracking/{token}/social-media-consent`

- **Auth:** **YOK** — token yeterli; IP bazlı rate limit (dakikada 5).
- **Amaç:** Müşterinin izin toggle'ı — true=ON, false=OFF, istediği kadar değiştirebilir.
- **Request DTO:** `SetSocialMediaConsentRequest` — **Response DTO:** `SetSocialMediaConsentResponse`.
- **Başarılı:** 200; `social_media_consent_at` güncellenir.
- **Hata:** 409 (CANCELLED işte), 404 (geçersiz token), 429.

## Flutter Geliştirme Notları

- Bu sayfayı YAPMAYIN — backend'in Razor sayfasıdır. Admin uygulamasında yalnızca `trackingUrl` gösterimi/kopyalaması ve `socialMediaConsent` rozetinin okunması vardır.
- Test ederken takip linkini masaüstü tarayıcısında açarak medya yükleme/durum değişikliği etkilerini uçtan uca doğrulayabilirsiniz.

## Notlar

- `tracking_token`: 32 byte `RandomNumberGenerator` → Base64Url, 43 karakter; UNIQUE ihlalinde 1 kez yeniden üretilir.
- Sosyal medya izin metni firmadan gelecektir (açık soru); sayfadaki metin backend'de güncellenir.
- Telefon değişikliğinde açık işlerin token'ları yenilendiği için eski linkler ölür — müşteri "linkim açılmıyor" derse bunun olası nedeni budur; admin detaydan güncel `trackingUrl`'i kopyalayıp iletebilir.

---

# 8. Feature: Dashboard (Panel)

## Amaç

Admin'in uygulama açılışında atölyenin anlık durumunu görmesi: durum sayıları, bugünkü kabul/teslim, günlük/aylık ciro, 7+ gündür READY bekleyen ürün sayısı ve medya disk kullanımı.

## İşleyiş Akışı

1. Uygulama açılışında (login sonrası paralel çağrıların biri) `GET /api/dashboard/summary` çağrılır.
2. Kartlar gösterilir; kullanıcı yenile butonuyla veya sayfaya her dönüşte tazelenir.
3. `readyWaitingOverdueCount > 0` ise uyarı kartı: 7+ gündür READY bekleyen işler — hem alınmayan ürünü hem DELIVERED'a çekilmesi unutulan kaydı yakalar; tıklanınca `GET /api/work-orders?status=READY` listesine gidilir.
4. `diskUsageBytes` belirli eşiği (örn. %70) aşınca admin'e arşivleme zamanının geldiği gösterilir → Arşiv ekranına yönlendirme. VDS diski bu döngüyle sabit kalır.

## UI Gereksinimleri

- **Kart ızgarası:** Teslim Alınan (`receivedCount`), İşlemde (`inProgressCount`), Hazır (`readyCount`), Bugün Alınan (`receivedTodayCount`), Bugün Teslim (`deliveredTodayCount`), Günlük Ciro (`dailyRevenue` ₺), Aylık Ciro (`monthlyRevenue` ₺)
- **Uyarı kartı:** "7+ gündür teslim bekleyen: N" (`readyWaitingOverdueCount`) — N>0 iken vurgulu renk; tıklanınca READY filtresiyle iş emri listesi
- **Disk kartı:** `diskUsageBytes` insan-okur formatta (GB); eşik aşımında "Arşivleme önerilir" uyarısı + Arşiv ekranı linki
- Yenile butonu + son güncelleme zamanı; para gösterimi 2 hane TRY

## İş Kuralları (hesap formülleri — sunucu hesaplar, istemci yalnızca gösterir)

- **"Bugün" tanımı:** **Europe/Istanbul gününe göre** (UTC değil!) — sorgu, TR gününün UTC aralığına çevrilerek yapılır. TR saatiyle 23:30'da (UTC 20:30) oluşturulan iş emri BUGÜNÜN sayısına yazılır.
- `receivedTodayCount` = bugün oluşturulan iş emirleri (CANCELLED dahil değil).
- `deliveredTodayCount` = `delivered_at` bugün olanlar.
- `dailyRevenue` = (bugün oluşturulan iş emirlerinin `prepayment_amount` toplamı) + (bugün teslim edilenlerin `final_payment_amount` toplamı). **İade takibi olmadığı için iptaller ciroyu düzeltmez** (bilinçli Faz 1 sınırı).
- `monthlyRevenue` = aynı formülün TR takvim ayı versiyonu.
- `readyWaitingOverdueCount` = status READY ve READY'ye geçiş logu 7+ gün önce olanlar (8 günlük girer, 6 günlük girmez).
- `diskUsageBytes` = arşivlenmemiş `media_files.size_bytes` toplamı (MinIO'ya sorulmaz); arşivleme sonrası azalır.

## Veritabanı Modelleri

Ayrı tablo yoktur; `work_orders`, `work_order_status_logs` ve `media_files` üzerinden hesaplanır.

## DTO'lar

### Response DTO'ları

```csharp
public record DashboardSummaryResponse(
    int ReceivedCount, int InProgressCount, int ReadyCount,
    int ReceivedTodayCount, int DeliveredTodayCount,
    decimal DailyRevenue, decimal MonthlyRevenue);
```
- **Amaç:** Panel sayıları + ciro. Ek alanlar: `readyWaitingOverdueCount` (7+ gündür READY) ve `diskUsageBytes` (arşivlenmemiş medya toplamı) response'a eklenmiştir (köşe senaryo kararları ile).
- **Endpoint:** `GET /api/dashboard/summary`.

## API Endpointleri

### `GET /api/dashboard/summary`

- **Auth:** Evet — **Amaç:** Panel sayıları + ciro + gecikme/disk metrikleri.
- **Response DTO:** `DashboardSummaryResponse` (+ `readyWaitingOverdueCount`, `diskUsageBytes`).
- **Hata:** 401.
- **Yan etki:** Yok.

## Flutter Geliştirme Notları

- Açılışta bir kez çekilir; sayfaya dönüşte ve mutasyonlardan (teslim, iptal, oluşturma) sonra invalidate edin. Sürekli polling gereksizdir; isterseniz 60 sn'lik pasif yenileme yeterli.
- Ciro alanlarını `NumberFormat.currency(locale: 'tr_TR', symbol: '₺')` ile gösterin.
- "Bugün" hesabı sunucudadır; istemcide tarih hesabı YAPMAYIN.

## Notlar

- Hazır olup uzun süre alınmayan ürünler için Faz 1'de yalnızca bu sayaç vardır; hatırlatma SMS'i Faz 2 adayıdır (firmaya sorulmuştur).
- Beklenen disk büyümesi: günde ~10 ürün × öncesi+sonrası video ≈ ayda ~50 GB — disk kartı bu yüzden dashboard'dadır.

---

# 9. Feature: Sosyal Medya İçerik Listesi

## Amaç

Müşterisi izin vermiş (`social_media_consent = true`) iş emirlerinin öncesi/sonrası içeriklerini admin'e tek yerde listelemek — firma bu içerikleri sosyal medya paylaşımlarında kullanır.

## İşleyiş Akışı

1. Admin "Sosyal Medya" ekranını açar → `GET /api/social-media/items?page=` çağrılır.
2. Yalnızca `social_media_consent = true` olan iş emirlerinin öncesi/sonrası içerikleri döner (signed URL'lerle).
3. Müşteri public sayfadan toggle'ı kapatırsa iş listeden düşer (bir sonraki listelemede görünmez).
4. Arşivlenmiş iş emirleri de listeden düşer (uyarı ile — medyaları artık sunucuda değildir).
5. Admin görseli/videoyu indirir ya da görüntüler; paylaşım uygulama DIŞINDA yapılır (Faz 1'de sosyal medya API entegrasyonu yoktur).

## UI Gereksinimleri

- Kart/grid listesi: her kart bir iş emri — ürün türü (CategoryPath), marka, öncesi/sonrası küçük önizlemeler, iş emri detayına link
- Sayfalama (`page`)
- Boş durum: "İzin vermiş müşteri içeriği yok"
- Görsel/video önizleme + "İndir" aksiyonu (signed URL'den lokal kayıt; URL 15 dk ömürlü — indirme hemen yapılmalı, gecikirse listeyi yenile)
- Arşivlenen işler için (listeden düşmüşse) ayrıca gösterim gerekmez; düşüş anına dair uyarı arşiv ekranında verilir

## İş Kuralları

- Liste yalnızca `social_media_consent = true` işleri döner; müşteri toggle'ı kapatınca düşer.
- İzin yalnızca **müşteri** tarafından public sayfadan verilir/geri alınır; admin değiştiremez.
- İzin kapatılınca o ana kadar paylaşılmış gönderiler firmanın sorumluluğundadır (teknik olarak yalnızca listeden düşme olur).
- Arşivlenmiş iş sosyal medya ekranından düşer (uyarı ile).

## Veritabanı Modelleri

Ayrı tablo yoktur; `work_orders.social_media_consent` + `media_files` kullanılır.

## DTO'lar

Doküman ayrı bir DTO tanımlamaz; response, iş emri kimliği + `CategoryPath`/`Brand` + öncesi/sonrası medya listelerinden (signed `ViewUrl`) oluşan sayfalı yapıdadır (`{ items, page, pageSize, totalCount }` zarfında).

## API Endpointleri

### `GET /api/social-media/items?page=`

- **Auth:** Evet — **Amaç:** `social_media_consent = true` iş emirlerinin öncesi/sonrası içerikleri.
- **Response:** sayfalı liste (medya signed URL'leri ile).
- **Hata:** 401.
- **Yan etki:** signed URL üretimi.

## Flutter Geliştirme Notları

- İndirme: `dio.download(viewUrl, path)`; URL süresi dolarsa listeyi yenileyip tekrar deneyin.
- Bu ekranı iş emri detayına navigasyonla bağlayın (kart tıklaması → detay).
- Cache'lemeyin — izin durumu müşteri tarafından her an değişebilir; ekran her açılışta taze çekilir.

## Notlar

- Kabul testi TRK-6: liste yalnızca consent=true işleri döner; müşteri toggle'ı kapatınca listeden düşer — bu davranışa güvenebilirsiniz.

---

# 10. Feature: Medya Arşivleme (Sunucu Diskini Boşaltma)

## Amaç

Bulut sağlayıcı (R2/S3) **kullanılmayacaktır** (kesin karar). Sunucu diski dolmaya başladığında, kapanmış (DELIVERED/CANCELLED) eski iş emirlerinin video/fotoğrafları **masaüstü uygulaması üzerinden şirketin kendi bilgisayarlarına arşiv olarak indirilir** ve sunucudan silinir. Bu feature'ın istemci tarafını (indirme + bütünlük doğrulama + onay) SİZ geliştirirsiniz — arşivleme akışının aktif tarafı masaüstü uygulamasıdır.

## İşleyiş Akışı

Akış üç adımdır ve **silme yalnızca istemci indirmeyi doğruladıktan sonra** yapılır:

1. **Adaylar:** `GET /api/archive/candidates?olderThanDays=90`
   → DELIVERED/CANCELLED olmuş ve **son durum değişikliği 90+ gün önce** olan iş emirleri, medya adedi ve toplam boyutlarıyla listelenir. "90+ gün" hesabı, iş emrinin **son durum değişikliği logunun** `changed_at`'ine göredir (DELIVERED için pratikte `delivered_at` ile aynıdır; CANCELLED için iptal anı). Açık iş asla listelenmez.
2. **Export:** `POST /api/archive/{workOrderId}/export`
   → o iş emrinin tüm medyaları için **uzun ömürlü (2 saat)** signed GET URL listesi döner. Masaüstü uygulaması dosyaları indirir ve bütünlük doğrular:
   - Boyut: indirilen dosya boyutu `sizeBytes` ile karşılaştırılır.
   - **MD5/ETag:** lokal dosyanın MD5'i `media_files.etag` (confirm anında kaydedilen MinIO ETag'i) ile karşılaştırılır. **Boyut karşılaştırması tek başına yeterli sayılmaz** — yalnızca MD5 eşleşenler confirm'e gönderilir.
   - URL'ler süresi ortasında dolarsa: `export` **idempotenttir** — tekrar çağrılınca taze URL'ler üretir.
3. **Confirm:** `POST /api/archive/{workOrderId}/confirm { verifiedMediaIds: [...] }`
   → sunucu doğrulanan nesneleri MinIO'dan siler; `media_files` satırı SİLİNMEZ: `is_archived=true, archived_at=now, storage_key=NULL` yapılır (denetim izi + "bu iş emrinin 4 medyası vardı, arşivde" bilgisi kalır).
   - Confirm **kısmi listeyi kabul eder**: 5 medyadan 3'ü doğrulandıysa 3'ü silinir; kalan medya adayı olarak listelenmeye devam eder.
   - Confirm'e yabancı ID gönderilirse: her `mediaId`'nin o iş emrine ait ve arşivlenmemiş olduğu doğrulanır; aksi **400, hiçbir şey silinmez** (all-or-nothing). "Daha önce export edildi mi" takibi YOKTUR — gereksiz durum; ownership kontrolü yeterlidir.

Önerilen istemci tarafı klasör düzeni: `Arşiv/{yıl}/{order_number}/before|after/...`

## UI Gereksinimleri

- **Arşiv ekranı:**
  - `olderThanDays` girişi (default 90) + "Adayları Listele" butonu
  - Aday tablosu: İş Emri No, Durum (DELIVERED/CANCELLED), Kapanış Tarihi (`closedAt`), Medya Adedi, Toplam Boyut (insan-okur), seçim checkbox'ları
  - Hedef klasör seçici (varsayılan: kullanıcının belirlediği arşiv kökü; alt yapı `Arşiv/{yıl}/{order_number}/before|after/...`)
  - "Arşivle" butonu → iş emri başına: export → indirme (dosya bazlı progress) → MD5 doğrulama ("doğrulanıyor" durumu) → confirm
  - Sonuç özeti: "5 medyadan 3'ü doğrulandı ve sunucudan silindi; 2'si doğrulanamadı, aday listesinde kalıyor" gibi net rapor
  - Uyarı metni (bilinçli risk): "Arşiv indirildikten sonra bu dosyaların tek kopyası şirket bilgisayarındadır. Harici disk / ikinci kopya önerilir."
  - Confirmation dialog: "Doğrulanan N medya sunucudan KALICI olarak silinecek. Devam edilsin mi?"
- Dashboard disk kartından bu ekrana yönlendirme.

## İş Kuralları

- Yalnızca **DELIVERED/CANCELLED** iş emirleri arşivlenebilir; **açık işin medyası silinemez** (export açık işte 409).
- "90+ gün": son durum değişikliği logunun `changed_at`'ine göre; 91 günlük listelenir, 89 günlük listelenmez; açık iş asla listelenmez.
- `export` idempotent: tekrar çağrı taze 2 saatlik URL'ler üretir.
- `confirm` kısmi kabul eder; yabancı/arşivlenmiş `mediaId` → 400, hiçbir şey silinmez.
- Bütünlük: yalnızca MD5==ETag eşleşen dosyalar confirm'e gönderilir; boyut tek başına yetmez.
- Arşivlenen kayıtta `storage_key` NULL'a çekilir; satır silinmez (denetim izi).
- Arşivlenmiş işin takip sayfası "Görseller arşivlenmiştir" gösterir; sosyal medya ekranından da düşer (uyarı ile).
- **Risk (bilinçli karar):** Arşiv şirket bilgisayarına indiğinde tek kopya artık şirkettedir; bilgisayar bozulursa medya kaybolur. Harici disk / ikinci kopya tavsiye edilir — sorumluluk teslimle firmaya geçer. Hangi bilgisayar/disk kullanılacağı ve eşik gün sayısı (öneri: 90) firmaya sorulmuş açık konudur.
- `diskUsageBytes` (dashboard) arşivleme sonrası azalır — admin döngüyü buradan izler.

## Veritabanı Modelleri

`media_files` tablosuna arşiv kolonları eklenmiştir (tablonun tamamı Medya feature'ında):

```sql
ALTER TABLE media_files
    ADD COLUMN is_archived BOOLEAN NOT NULL DEFAULT FALSE,
    ADD COLUMN archived_at TIMESTAMPTZ;
-- arşivlenen kayıtta storage_key NULL'a çekilir
```

Satırın silinmeyip işaretlenmesi, "bu iş emrinin kaç medyası vardı, ne zaman arşivlendi" denetim izinin korunması içindir.

## DTO'lar

### Request DTO'ları

```csharp
public record ArchiveConfirmRequest(IReadOnlyList<long> VerifiedMediaIds);
```
- **Amaç:** MD5 doğrulaması geçen medya kimliklerini bildirip sunucudan silinmelerini onaylamak. Kısmi liste geçerlidir.
- **Endpoint:** `POST /api/archive/{workOrderId}/confirm`.

### Response DTO'ları

```csharp
public record ArchiveCandidateResponse(
    long WorkOrderId, string OrderNumber, string Status,
    DateTime ClosedAt, int MediaCount, long TotalSizeBytes);
```
- **Amaç:** Arşivlenebilir iş emri satırı; `ClosedAt` = son durum değişikliği anı.
- **Endpoint:** `GET /api/archive/candidates`.

```csharp
public record ArchiveExportResponse(
    long WorkOrderId,
    IReadOnlyList<ArchiveMediaItem> Items);

public record ArchiveMediaItem(long MediaId, string Stage, string MediaType,
    string FileName, long SizeBytes, string DownloadUrl);
```
- **Amaç:** İndirilecek medya listesi; `DownloadUrl` 2 saat ömürlü signed GET; `SizeBytes` boyut karşılaştırması için.
- **Endpoint:** `POST /api/archive/{workOrderId}/export`.

## API Endpointleri

### `GET /api/archive/candidates?olderThanDays=`

- **Auth:** Evet — **Amaç:** Arşivlenebilir iş emirleri + medya adedi/boyutları.
- **Response:** `ArchiveCandidateResponse[]`.
- **Kural:** DELIVERED/CANCELLED + son durum değişikliği `olderThanDays`+ gün önce; kısmi confirm edilmiş işin kalan medyaları listelenmeye devam eder.
- **Hata:** 401.

### `POST /api/archive/{workOrderId}/export`

- **Auth:** Evet — **Amaç:** O işin tüm medyaları için 2 saatlik signed GET URL listesi.
- **Response DTO:** `ArchiveExportResponse`.
- **Kural:** yalnızca DELIVERED/CANCELLED; açık işte **409**. İdempotent — tekrar çağrı taze URL üretir.
- **Hata:** 409 (açık iş), 404.

### `POST /api/archive/{workOrderId}/confirm`

- **Auth:** Evet — **Amaç:** Doğrulanan medyayı MinIO'dan silmek, satırı arşivli işaretlemek.
- **Request DTO:** `ArchiveConfirmRequest`.
- **Başarılı:** doğrulanan nesneler silinir; satırlar `is_archived=true, archived_at=now, storage_key=NULL`.
- **Hata:** 400 — herhangi bir `mediaId` o işe ait değilse veya zaten arşivliyse; **hiçbir şey silinmez** (all-or-nothing). 404.
- **Yan etkiler:** dashboard `diskUsageBytes` azalır; takip sayfası "Görseller arşivlenmiştir" moduna geçer; iş sosyal medya listesinden düşer.

## Flutter Geliştirme Notları

- **İndirme + doğrulama hattı:** dosyayı geçici ada indir → `crypto` paketi ile MD5 hesapla (`md5.convert(bytes)` — büyük dosyada stream'li `ChunkedConversion` kullanın) → ETag ile karşılaştır → eşleşirse hedef klasöre taşı, `mediaId`'yi doğrulanmış listesine ekle.
- ETag'i nereden alacağınız: `ArchiveMediaItem`'da doğrudan ETag alanı yoktur; karşılaştırma sözleşmesi "lokal MD5 == media_files.etag"tır. Pratikte MinIO signed GET yanıtının **`ETag` HTTP başlığından** okuyun (indirme yanıtında gelir).
- 2 saatlik pencerede bitmeyecek büyük işlerde: kalan dosyalar için `export`'u yeniden çağırın (idempotent).
- Confirm 400 dönerse (yabancı ID) listeyi baştan çekin — muhtemelen ekranınız bayat.
- İndirilen dosyaların adlandırması: `ArchiveMediaItem.FileName` + `Stage` alt klasörü; önerilen kök düzen `Arşiv/{yıl}/{order_number}/before|after/...`.
- Uzun süren toplu arşivde iptal edilebilir kuyruk + kaldığı yerden devam (kısmi confirm zaten destekleniyor) tasarlayın.

## Notlar

- Arşivin amacı disk döngüsüdür: günde ~10 ürün ≈ ayda ~50 GB medya; VDS diski (160+ GB, MinIO verisi ayrı partition'da) arşivleme döngüsüyle sabit kalır.
- MinIO verisi sunucuda ayrı disk/partition'dadır (`/data/minio`): medya diski dolarsa OS ve PostgreSQL etkilenmez, yalnızca yeni upload'lar hata alır — istemci upload hatasında bu ihtimali de düşünmelidir ("sunucu diski dolu olabilir, arşivleme gerekli").

---

# 11. Feature: Veritabanı Yedeği İndirme (Admin)

## Amaç

Felaket senaryosuna karşı, sunucuda günlük alınan PostgreSQL yedeğinin (`pg_dump` + gzip) bir kopyasının **haftada bir, admin tarafından masaüstü uygulamasıyla** şirket bilgisayarına indirilmesi. Veritabanı küçüktür (metin verisi; asıl hacim medyadadır) — haftalık kopya yeterli görülmüştür.

## İşleyiş Akışı

1. Sunucuda cron her gece 03:00'te `pg_dump leathercare | gzip > /backup/db-{tarih}.sql.gz` alır; 30 günden eski yedekler her gece 04:00'te silinir. (Sunucu işi — istemci tetiklemez.)
2. Admin, uygulamadaki "Yedek İndir" aksiyonuna basar (haftalık rutin) → `GET /api/admin/backups/latest`.
3. Sunucu, `/backup` dizinindeki **en yeni** `db-*.sql.gz` dosyasını `application/gzip` olarak stream eder; istemci dosyayı seçilen klasöre kaydeder.
4. Dosya yoksa 404 — "Henüz yedek alınmamış" mesajı.

## UI Gereksinimleri

- Arşiv & Yedek ekranında "Son Veritabanı Yedeğini İndir" butonu + hedef klasör seçici + indirme progress'i
- Başarıda dosya adı/konumu gösterimi; 404'te bilgi mesajı
- Hatırlatma notu: "Haftada bir indirilmesi önerilir"

## İş Kuralları

- Endpoint yalnızca ADMIN'e açıktır (JWT).
- En yeni `db-*.sql.gz` stream edilir; dosya yoksa 404.
- Uygulama binary'si için yedek gerekmez (Git repo'dan yeniden publish edilir); medya yedeği bu kanaldan DEĞİL, arşiv akışından yönetilir.
- Yedek geri dönüş testi sunucu tarafında 3 ayda bir manuel yapılır ("test edilmemiş yedek, yedek değildir") — istemciyi etkilemez, bilgi amaçlıdır.

## Veritabanı Modelleri

Tablo yoktur; sunucu dosya sistemindeki `/backup` dizini kaynak alınır.

## DTO'lar

DTO yoktur; yanıt ham `application/gzip` dosya stream'idir.

## API Endpointleri

### `GET /api/admin/backups/latest`

- **Auth:** Evet (sadece ADMIN) — **Amaç:** Son pg_dump dosyasını indirmek.
- **Response:** `application/gzip` stream (`db-YYYY-MM-DD.sql.gz`).
- **Hata:** 404 (dosya yok), 401.
- **Yan etki:** Yok.

## Flutter Geliştirme Notları

- `dio.download` ile stream indirme; dosya adını `Content-Disposition` başlığından alın, yoksa `db-{bugün}.sql.gz` üretin.
- Büyük olması beklenmez (metin DB'si) ama yine de progress gösterin.

## Notlar

- Yedekleme özet tablosu (sunucu tarafı): PostgreSQL → `pg_dump` + gzip (cron) → VDS `/backup` (30 gün saklama), günlük · DB yedeğinin dışarı kopyası → bu endpoint ile şirket bilgisayarına, haftalık (admin tetikler) · Uygulama → Git repo'dan yeniden publish edilebilir.

---

# 12. Uçtan Uca Referans Senaryo (tüm feature'ların birleşimi)

Tipik bir müşterinin karşılanmasından teslimine kadar atılan HER istek, sırasıyla. Örnek: Ayşe Yılmaz, Nike sneaker, Bakım ve Boya + 1 bakım kremi.

### Faz 0 — Program açılışı (müşteri gelmeden)

```
POST /api/auth/login { email, password }
  ← 200 { token }                          → saklanır, her isteğe Authorization: Bearer

(paralel, açılışta bir kez:)
GET /api/dashboard/summary                 → panel kartları
GET /api/categories/tree                   → kategori ağacı CACHE'lenir (kabulde beklenmez)
GET /api/work-orders?status=IN_PROGRESS    → aktif işler listesi
```
Kategori ağacı cache'i yalnızca katalog ekranında değişiklik yapılırsa yenilenir.

### Faz 1 — Müşteri bulma / kayıt + İYS

```
GET /api/customers?search=05321234567
  ├─ items dolu  → müşteri kartı + geçmiş işler gösterilir, Faz 2'ye geç
  └─ items boş   → hızlı kayıt formu:

POST /api/customers { firstName, lastName, phone, email?, address? }
  ← 201 { customer(iysConsentStatus=PENDING), iysCodeExpiresAt }
  → Backend kodu üretti + SMS'i kuyrukladı (frontend SMS için HİÇBİR ŞEY yapmaz)
  → Ekran: kod kutusu + iysCodeExpiresAt'e göre geri sayım

POST /api/customers/{id}/iys/confirm { code }
  ← 200 { iysConsentStatus: SUBMITTED }    → SUBMITTED→APPROVED'ı arka plan halleder, BEKLENMEZ
  (kod gelmedi → POST .../iys/resend-code | müşteri istemiyor → ATLA butonu, akış bloklanmaz)
```

### Faz 2 — Ürün kaydı (4 adımlı seçim)

```
(cache'ten) Ana Kategori → Ürün Grubu → Ürün Türü seçilir (Kadın → Ayakkabı → Sneakers)

GET /api/categories/{level3Id}/services
  ← 200 { categoryPath, services: [{servicePriceId, serviceName, price}] }
  → Hizmet tıklanır → FİYAT OTOMATİK EKRANA GELİR
  → (varsa) sarf malzeme satırları eklenir → önerilen toplam gösterilir
  → admin nihai fiyatı elle değiştirebilir, ön ödeme girilir

POST /api/work-orders
  { customerId, categoryId, brand?, color?, material?, description?, existingDamages?,
    estimatedDeliveryDate?, servicePriceIds[], consumables[{consumableProductId,quantity}],
    price, hasPrepayment, prepaymentAmount? }
  ← 201 { orderNumber, suggestedPrice, price, remainingAmount, trackingUrl, status: RECEIVED }
  → DİKKAT: SMS henüz GİTMEZ (video bekleniyor — link boş sayfaya açılmasın)
```

### Faz 3 — Medya yükleme (her dosya için 3'lü dans)

```
1) POST /api/work-orders/{id}/media/request-upload
     { mediaType: VIDEO|PHOTO, stage: BEFORE, fileName, mimeType, sizeBytes }
   ← 200 { mediaFileId, uploadUrl(presigned PUT), expiresAt }
2) HTTP PUT uploadUrl  ← dosya DOĞRUDAN MinIO'ya (backend'e uğramaz; progress bar burada)
3) POST /api/work-orders/{id}/media/confirm { mediaFileId }
   ← 200 (backend StatObject ile boyut/ETag doğrular)

→ İLK BEFORE confirm'i ORDER_RECEIVED SMS'ini tetikler (takip linkiyle)
→ "Kayıt tamamlandı", dashboard'a dön. Karşılama toplamı: ~6-8 istek.
```

### Faz 4 — Atölye süreci (günler sonra)

```
PATCH /api/work-orders/{id}/status { newStatus: IN_PROGRESS }
... iş biter, AFTER medyası Faz 3'teki 3'lü dansla yüklenir ...
PATCH /api/work-orders/{id}/status { newStatus: READY }
  → Backend ORDER_READY SMS'ini kuyruklar (frontend yine dokunmaz)
```

### Faz 5 — Müşteri tarafı (backend'in Razor sayfası — masaüstü değil)

```
Müşteri SMS linkine tıklar → GET /t/{token} (sunucu render eder)
  → durum çubuğu, öncesi + (READY/DELIVERED ise) sonrası medya
İzin butonu → PUT /api/public/tracking/{token}/social-media-consent { consent: true|false }
```

### Faz 6 — Teslim

```
GET /api/work-orders?search=0532...        → iş bulunur, detayda KALAN tutar görünür
POST /api/work-orders/{id}/deliver { finalPaymentAmount }
  ← 200 status: DELIVERED                  → ciro artar, iş kapanır ama silinmez
```

### Faz 7 — (Aylar sonra) Arşiv

```
GET  /api/archive/candidates?olderThanDays=90   → kapalı + 90 gün geçmiş işler
POST /api/archive/{id}/export                   → 2 saatlik indirme URL'leri
(indir, MD5 == etag doğrula)
POST /api/archive/{id}/confirm { verifiedMediaIds } → sunucudan silinir
```

Backend'in kabul kriteri: yukarıdaki mutlu yolun tamamı (kayıt → kod SMS → confirm → SUBMITTED → polling APPROVED → iş emri → video upload+confirm → ORDER_RECEIVED SMS → IN_PROGRESS → READY → ORDER_READY SMS → public sayfada before+after → consent ON → deliver → DELIVERED → sosyal medya listesi → 91 gün sonra arşiv) uçtan uca yeşildir. İstemciniz bu akışa güvenerek geliştirilebilir.

---

# 13. Ekler

## 13.1 Durum Etiketleri Sözlüğü (uygulama genelinde tutarlı kullanın)

| Backend değeri | Türkçe etiket | Önerilen renk |
|---|---|---|
| RECEIVED | Teslim Alındı | Mavi |
| IN_PROGRESS | İşlemde | Turuncu |
| READY | Hazır | Yeşil |
| DELIVERED | Teslim Edildi | Gri/yeşil |
| CANCELLED | İptal Edildi | Kırmızı |

İYS: PENDING = "Onay bekleniyor", SUBMITTED = "İYS teyidi bekleniyor", APPROVED = "Onaylı", REJECTED = "Reddedildi".
SMS: QUEUED = "Kuyrukta", SENT = "Gönderildi", FAILED = "Başarısız".
Medya upload: PENDING = "Yükleme bekleniyor", UPLOADED = "Yüklendi", FAILED = "Başarısız".

## 13.2 Tüm Endpoint'lerin Özeti

| Method | Endpoint | Auth | Feature |
|---|---|---|---|
| POST | `/api/auth/login` | Yok | Auth |
| POST | `/api/customers` | JWT | Müşteri |
| GET | `/api/customers?search=&page=&pageSize=` | JWT | Müşteri |
| GET | `/api/customers/{id}` | JWT | Müşteri |
| PUT | `/api/customers/{id}` | JWT | Müşteri |
| POST | `/api/customers/{id}/iys/resend-code` | JWT | Müşteri/İYS |
| POST | `/api/customers/{id}/iys/confirm` | JWT | Müşteri/İYS |
| GET | `/api/categories/tree?includeInactive=` | JWT | Katalog |
| POST | `/api/categories` | JWT | Katalog |
| PUT | `/api/categories/{id}` | JWT | Katalog |
| GET/POST | `/api/service-types` · PUT `/api/service-types/{id}` | JWT | Katalog |
| GET | `/api/service-prices?categoryId=` | JWT | Katalog |
| PUT | `/api/service-prices/bulk` | JWT | Katalog |
| GET | `/api/categories/{id}/services` | JWT | Katalog |
| GET/POST/PUT | `/api/consumable-groups` | JWT | Katalog |
| GET/POST/PUT | `/api/consumable-products?groupId=&brand=` | JWT | Katalog |
| POST | `/api/work-orders` | JWT | İş Emri |
| GET | `/api/work-orders?status=&search=&page=&pageSize=` | JWT | İş Emri |
| GET | `/api/work-orders/{id}` | JWT | İş Emri |
| PUT | `/api/work-orders/{id}` | JWT | İş Emri |
| PATCH | `/api/work-orders/{id}/status` | JWT | İş Emri |
| POST | `/api/work-orders/{id}/deliver` | JWT | İş Emri |
| POST | `/api/work-orders/{id}/sms/resend` | JWT | SMS |
| POST | `/api/work-orders/{id}/media/request-upload` | JWT | Medya |
| POST | `/api/work-orders/{id}/media/confirm` | JWT | Medya |
| GET | `/api/work-orders/{id}/media` | JWT | Medya |
| DELETE | `/api/media/{id}` | JWT | Medya |
| GET | `/api/public/tracking/{token}` | Yok (token + rate limit) | Public |
| PUT | `/api/public/tracking/{token}/social-media-consent` | Yok (token + rate limit) | Public |
| GET | `/api/dashboard/summary` | JWT | Dashboard |
| GET | `/api/social-media/items?page=` | JWT | Sosyal Medya |
| GET | `/api/archive/candidates?olderThanDays=` | JWT | Arşiv |
| POST | `/api/archive/{workOrderId}/export` | JWT | Arşiv |
| POST | `/api/archive/{workOrderId}/confirm` | JWT | Arşiv |
| GET | `/api/admin/backups/latest` | JWT (ADMIN) | Yedek |

## 13.3 Sabitler ve Limitler (hızlı referans)

| Ne | Değer |
|---|---|
| JWT ömrü | 30 gün (refresh yok) |
| Login rate limit | IP başına dakikada 5 → 429 |
| İYS kodu | 4 hane, 5 dk geçerli, max 3 deneme |
| resend-code limiti | 60 sn'de 1, günde max 5 |
| İYS teyit polling | 15 dk'da bir; 7 gün SUBMITTED → REJECTED |
| SMS outbox | 5 sn döngü, turda max 10; 1 otomatik tekrar (30 sn sonra) |
| NETGSM mükerrer engeli | 1 saat / aynı numara + aynı içerik |
| Video limiti | ≤ 500 MB, yalnızca MP4 (H.264) |
| Foto limiti | ≤ 25 MB, yalnızca JPEG/PNG |
| İş emri başına medya | max 20 |
| Presigned PUT | 10 dk |
| Signed GET (izleme) | 15 dk |
| Signed GET (arşiv) | 2 saat |
| PENDING medya temizliği | 24 saat sonra (günlük job, 03:00 TR) |
| tracking_token | 43 karakter (32 byte Base64Url) |
| order_number | `WO-{yıl}-{seq:D6}`, sequence yılda sıfırlanmaz |
| Public sayfa rate limit | IP başına dakikada 30; consent 5 |
| Sayfalama | page ≥ 1, pageSize default 20 / max 100 |
| Sıralama | `created_at DESC` sabit |
| READY gecikme eşiği | 7 gün (dashboard sayacı) |
| Arşiv eşiği (öneri) | 90 gün |
| Nginx API body limiti | 2 MB (dosya API'ye gönderilmez!) |

## 13.4 Backend Kabul Testlerinden İstemciyi İlgilendiren Garantiler

Backend, aşağıdaki davranışları integration testlerle garanti eder — istemcinizi bu davranışlara göre yazabilirsiniz:

- **Auth:** doğru girişte 30 günlük token; yanlış şifre 401; aynı IP 6. deneme 429; süresi dolan token 401 → yeniden login yeni token verir; seed admin yalnızca boş tabloda oluşur.
- **Müşteri:** `05321234567` girişi DB'de `+905321234567` olur; duplicate kayıt 409 + mevcut müşteri body'si; `1234` gibi geçersiz telefon 400; PUT'ta `email=null` alanı temizler; telefon değişiminde İYS sıfırlanır + açık işlerin token'ları değişir + yeni linkli SMS kuyruklanır (kapalı işler etkilenmez).
- **İYS:** doğru kodla confirm → SUBMITTED + refid; 3 yanlış → `CODE_LOCKED` (doğru kod bile reddedilir, resend gerekir); +6 dk sonra `CODE_EXPIRED`; SUBMITTED'da resend 409, APPROVED'da `ALREADY_CONSENTED`; polling success→APPROVED / failure→REJECTED; 7 gün SUBMITTED→REJECTED; PENDING müşterinin iş emri SMS'leri normal gider.
- **İş emri:** örnek hesap 1.250 + 2×150 = `suggestedPrice 1.550`; boş hizmet+sarf → suggestedPrice 0; pasif/yanlış katalog seçimi 400 (`INVALID_CATALOG_ITEM`/`INVALID_CATEGORY_LEVEL`/`SERVICE_CATEGORY_MISMATCH`); ön ödeme kuralları 400; `price=0` geçerli; katalog değişse eski iş emri snapshot'ı değişmez; PUT ile hizmet listesi değişince güncel katalogla yeniden snapshot; fiyat değişimi log notu ("Fiyat: 500 → 750"); DELIVERED işe PUT 409 `ORDER_CLOSED`; eşzamanlı PUT'ta ikincisi 409.
- **Katalog:** seed 4 ana kategori + Bakım/Boya/Bakım ve Boya; level 3 altına ekleme 400; kökte aynı ad 409; `categories/{id}/services` yalnızca fiyatlı+aktif döner; bulk 300 satır tek istekte, tekrar gönderim günceller; level 2 pasifleşince alt türler görünmez + yeni iş emri açılamaz ama mevcutlar etkilenmez.
- **Durum makinesi:** RECEIVED→IN_PROGRESS→READY→(deliver)→DELIVERED zinciri 200; atlama/aynı-durum/kapalı-iş 409; READY→IN_PROGRESS→READY'de ikinci ORDER_READY SMS'i gitmez; PATCH ile DELIVERED 409; deliver READY değilken 409; CANCELLED her açık durumdan not ile 200, takip sayfası "İptal Edildi", consent 409.
- **Medya+SMS:** HEIC/MOV/501 MB video/26 MB foto → 400; confirm'de boyut uyuşmazlığı 400 (satır PENDING kalır); nesnesiz confirm 400; ilk BEFORE confirm SMS kuyruklar, ikincisi kuyruklamaz; 2 gün sonra yüklenen medya SMS'i o an tetikler; kapalı işe request-upload 409; 21. medya 400; DELETE MinIO+satırı siler, SMS tekrar gitmez; 25 saatlik PENDING temizlenir, 23 saatlik kalır.
- **SMS outbox:** QUEUED→SENT+bulkid; iki ağ hatası→FAILED (diğerleri devam eder); resend FAILED'i yeniden kuyruklar, mükerrer engelinde anlaşılır mesaj; 25 SMS'te turda max 10.
- **Public:** geçerli token 200 + TR etiket + fiyat/ödeme alanları JSON'da hiç yok; AfterMedia yalnızca READY'de dolu, geri dönüşte boşalır; geçersiz token 404 nötr, CANCELLED 200; consent toggle her seferinde 200 + timestamp güncellenir, CANCELLED'da 409; rate limitler (31. istek / 6. consent) 429; sosyal medya listesi yalnızca consent=true, kapatınca düşer.
- **Arşiv:** 91 gün listelenir / 89 gün listelenmez / açık iş asla; export idempotent; kısmi confirm (5'ten 3) çalışır, kalan aday kalır; yabancı ID 400 all-or-nothing; açık işe export 409; arşivli işin takip sayfası "Görseller arşivlenmiştir".
- **Dashboard:** TR saatiyle 23:30 kaydı bugüne yazılır; dailyRevenue = ön ödemeler + teslim ödemeleri, iptal düzeltmez; 8 gün READY sayaca girer, 6 gün girmez; diskUsageBytes arşivle azalır.

## 13.5 Firmadan Beklenen / Açık Konular (istemciyi etkileyebilecekler)

Aşağıdakiler geliştirme öncesi firmayla netleşecek konulardır; istemci tasarımında esnek bırakın:

1. İYS hizmet sağlayıcı kaydı, brandCode, NETGSM iş ortağı yetkilendirmesi (yoksa iys/add çalışmaz — test ortamında SMS/İYS FAILED görmek normaldir).
2. NETGSM API erişimi (kullanıcı/şifre, appkey, IP sınırı).
3. Onaylı SMS başlığı (msgheader — müşterinin telefonunda görünen isim).
4. KVKK: foto/video aydınlatma metni; medya saklama süresi (süresiz mi, X ay mı) — arşiv eşiğini etkileyebilir.
5-6. Durum SMS'lerinin ve İYS kod SMS'inin kesin metinleri (Türkçe karakter/karakter bütçesi kararı) — yalnızca backend config değişir.
7. Ürün türü + işlem/fiyat listesi (kataloğu ilk açılışta kim yükleyecek — Excel gelirse bulk import).
8. Özel fiyat matematiği detayı (malzeme çarpanı vb. — Faz 1'de yalnızca toplam önerilir).
9. Tahmini teslim tarihi: elle mi, otomatik gün hesabı mı? (Faz 1: elle, opsiyonel.)
10. İptalde ön ödeme politikası (Faz 1: yalnızca not alanı).
11. Teslimde eksik ödeme / borçlu teslim politikası (Faz 1: girilen tutar kaydedilir, eşitlik zorlanmaz).
12. Günlük ürün hacmi ve ortalama video boyutu (disk planlaması).
13. Uzun süre alınmayan ürünler için hatırlatma SMS'i istenir mi? (Faz 2 adayı; Faz 1'de yalnızca dashboard sayacı.)
14. Domain adı (SMS'te görünecek — kısa ve güven veren olmalı).
15. Sosyal medya izin metni + izin geri çekildiğinde yayınlanmış içerik beklentisi.
16. Arşiv sorumluluğu: hangi bilgisayar/disk, ikinci kopya, eşik gün (öneri 90).
17. İş emrinden bağımsız sarf satışı (mini POS) gerekir mi? (Faz 1'de YOK.)
18. ~300 hizmet fiyatının ilk girişi: Excel toplu import mu, elle mi?

## 13.6 Faz 2+ Adayları (şema migration ile genişler — bugün tasarımda yer ayırmayın, sadece bilin)

Video sıkıştırma/thumbnail (ffmpeg worker) · WhatsApp bildirimi · roller ve çoklu kullanıcı (refresh token bununla gelir) · usta ataması · QR ile teslim · tek SMS'te birleşik link (çoklu ürün) · hatırlatma SMS'i · bağımsız sarf satışı (mini POS) · tamir/onarım hizmetleri (şu an firma kararıyla yok).
