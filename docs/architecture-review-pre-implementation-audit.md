# Architecture Review & Pre-Implementation Audit

> **İncelenen birincil doküman:** `docs/product-create-detail-teknik-analiz.md`  
> **Referans sırası:** Analysis Document → SDD → İlk Analysis (`teknik-analiz-ve-gelistirme-plani.md`) → Flutter kodu → `swagger_json` → Backend (salt okunur)  
> **Tarih:** 30 Temmuz 2026  
> **Rol:** Principal Software Architect / Technical Reviewer  
> **Yöntem:** Kod yazılmadı, mevcut dosyalar değiştirilmedi. Amaç: “Bu dokümanla gerçekten geliştirmeye başlanabilir mi?”

---

## 1. Executive Summary

**Karar: Hayır — Product Create / Product Detail / Media Upload entegrasyonuna bu dokümanla başlanamaz.**

`product-create-detail-teknik-analiz.md` masaüstü **as-is** sistemini yüksek doğrulukla belgelemiştir (endpoint’ler, DTO’lar, create→detay→upload sırası, validation, riskler). Bu anlamda **keşif kalitesi yüksektir**. Ancak doküman:

1. **Hedef kapsamı belirsiz bırakır / çelişkiye düşer** — SDD F6 “mobilde create/edit/medya/teslim YOK” derken Analiz §8–§11 aynı özelliklerin mobile taşınmasını “sonraki entegrasyon” olarak önerir.
2. **As-is envanter ile to-be tasarımı birbirine karışır** — “bugün kodda ne var” ile “mobilde ne yapılacak” aynı başlık altında; implementasyon ekibi hangisinin bağlayıcı olduğunu bilemez.
3. **Mobil upload için kritik kararları vermez** — sıkıştırma, HEIC stratejisi, Android Photo Picker, arka plan yükleme, offline, draft, rollback, cancel upload, iOS kapsamı açık ürün/mühendislik kararları olarak kapanmamıştır; yalnızca risk veya “öneri” düzeyindedir.
4. **SDD’nin bir kısmı bayatlamıştır** — F1 (DateOnly + fieldErrors) kodda zaten uygulanmış; SDD hâlâ “yapılacak” diye duruyor. Analiz bunu fark etmiş ama “hangi doküman kaynak gerçek?” sorusunu çözmemiştir.

**Tek cümlelik verdict:** Doküman *mevcut sistemi anlamak* için yeterlidir; *mobil Product Create + Media entegrasyonunu başlatmak* için **kapsam kilidi + 50 kritik sorunun cevaplanması** şarttır.

---

## 2. Doküman Kalite Skoru (100 üzerinden)

| Boyut | Skor | Gerekçe |
|---|---|---|
| As-is kod doğruluğu (desktop WO create/detail/media) | **88** | Endpoint, DTO, create→detail→upload sırası, status matrisi, presigned akış doğru |
| Kaynak çapraz doğrulama (backend + swagger) | **82** | Backend/controller doğrulaması güçlü; swagger şema kısıtları (required/enum) zayıf yansıtılmış |
| To-be mobil tasarım netliği | **28** | Kapsam SDD ile çelişiyor; UX/lifecycle kararları eksik |
| Belirsizliklerin kapatılması | **35** | Riskler listelenmiş ama “karar / kabul / ertele” tablosu yok |
| Çelişki yönetimi (SDD vs Analysis vs kod) | **40** | Çelişkiler kısmen görünür ama çözüm önceliği yok |
| Implementasyona hazırlık (AC, test, branch) | **45** | §11 tohumları var; acceptance criteria / out-of-scope listesi yok |
| **Ağırlıklı toplam** | **52 / 100** | Keşif dokümanı: iyi. Uygulama sözleşmesi: yetersiz. |

**Skor yorumu:** 70+ olmadan kod yazılmamalı. Kritik eksik: **kapsam kilidi (F6 mi, yeni F8+ mi?)**.

---

## 3. Kritik Eksikler

### 3.1 Dokümanda bulunmayan ama implementasyon için zorunlu bölümler

| Eksik bölüm | Neden kritik |
|---|---|
| **Kapsam kilidi / Out-of-Scope listesi** | SDD F6 ile Analiz §8–11 çatışıyor; “ne inşa edilecek?” yazılmamış |
| **To-be Acceptance Criteria** | As-is davranış “AC” sanılabilir; mobil hedef davranış tanımsız |
| **Karar log’u (Decision Record)** | Draft? Offline? Background upload? Sıkıştırma? iOS? — hepsi açık |
| **Error code → UI mapping tablosu (tam)** | `errorCode` listesi dağınık; hangi SnackBar/dialog/retry hangi kodda belirsiz |
| **Upload state machine diyagramı (to-be)** | As-is task status’ları var; cancel/pause/resume/background durumları yok |
| **Activity / sequence (mobil create + media)** | Desktop sequence var; mobil hedef akış yok |
| **Permission matrix (Android 13/14/15 + iOS)** | Yalnızca “kamera var, galeri yok” tespiti; sürüm bazlı model yok |
| **Background / foreground upload sözleşmesi** | Risk olarak geçiyor; ürün kararı yok |
| **Cancel / pause upload UX + API etkisi** | Cancel butonu yok; PENDING satır yan etkisi dokümante ama çözüm yok |
| **Idempotency / duplicate create stratejisi** | Create idempotent değil; çift tık / retry sonrası çift WO riski işlenmemiş |
| **Transaction sınırları (istemci)** | WO create başarı + media partial fail = “yarı ürün” kabul mü? |
| **Security threat model (kısa)** | JWT 30 gün, cihaz kaybı, başka WO’ya media — yüzeysel |
| **Observability (logging/analytics/crash)** | DiagnosticsLogger var; upload metrikleri / crash taxonomy yok |
| **Cache politikası (image/video/viewUrl)** | “Cache yok” deniyor; Image.network varsayılan cache davranışı ve signed URL etkileşimi yazılmamış |
| **Test planı (cihaz matrisi + edge case matrisi)** | §11 tohum; QA senaryo tablosu yok |
| **Branch / feature flag / rollout** | Modül sırası var; feature flag ve geri alma kriteri yok |
| **Swagger–kod–doküman senkron politikası** | `swagger_json` 19 Temmuz tarihli dump; güncellik garantisi yok |

### 3.2 Product Create sorularına dokümandan cevap / eksik

| Soru | Dokümanda cevap | Yeterli mi? |
|---|---|---|
| Ürün oluştuktan sonra mı medya? | **Evet — önce WO, sonra detayda medya** | As-is için evet |
| Upload fail → ürün oluşur mu? | Create medyadan bağımsız; **ürün oluşur, medya PENDING/hata** | Evet |
| Video fail → fotoğraflar? | Sıralı kuyruk; önceki `done` kalır, sonraki işlenir | Evet (as-is) |
| Rollback? | **Yok** (WO silinmez; media hard-delete ayrı) | Karar eksik: mobil kabulde “en az 1 BEFORE zorunlu mu?” |
| Draft? | **Yok** | Eksik karar |
| Otomatik kaydetme? | **Yok** | Eksik karar |
| Retry stratejisi? | As-is: **manuel**; to-be: “otomatik 3 + backoff önerisi” | Karar yok |
| İnternet koparsa? | As-is: hata mesajı, kuyruk bellek-içi kaybolabilir | To-be belirsiz |
| App kapanırsa upload? | As-is: **kaybolur**; PENDING sunucuda kalır | To-be belirsiz |
| Arka plan upload? | As-is: **hayır** | Karar yok |
| Upload bitince refresh? | Confirm sonrası `MediaGalleryCubit.load()` | Evet (as-is) |
| Progress? | `LinearProgressIndicator` + aşama etiketi | Evet (as-is); toplam kuyruk progress yok |
| 20 foto birden? | `remainingSlots` ile kısma + SnackBar; sayaç PENDING’i eksik sayıyor | Bug + mobil karar eksik |
| Video boyutu? | **500 MB** (istemci+sunucu) | Evet; mobilde pratik limit önerisi (100 MB) karar değil |
| Foto/video sıkıştırma? | As-is: **hayır** (yalnızca HEIC/MOV→dönüşüm) | Mobil karar eksik |
| HEIC? | İstemci kabul+ffmpeg; sunucu **red** | Mobil strateji eksik |
| Android 13 Photo Picker? | **Belirtilmemiş** | Eksik |
| Android permission modeli güncel mi? | “Galeri izni yok” tespiti; API-33+ ayrımı yok | Eksik |
| iOS? | SDD’de var; Analiz HEIC riski not ediyor; dağıtım kararı yok | Eksik |

### 3.3 Product Detail sorularına cevap / eksik

| Soru | Cevap (doküman+kod) | Eksik? |
|---|---|---|
| Medya silinebilir mi? | Açık işte evet (desktop); **mobilde UI yok (F6)** | Kapsam kararı |
| Video değiştirilebilir mi? | **Replace endpoint yok**; sil+yeniden yükle | Dokümante ama UX kararı yok |
| Foto yeniden yüklenebilir mi? | Yeni upload ile; replace yok | Aynı |
| Sıralama? | **Yok** (CreatedAt sıralı) | Eksik ürün kararı |
| Kapak fotoğrafı? | **Yok** | Eksik |
| Media cache? | Açık politika yok | Eksik |
| Thumbnail? | **Yok** (tam boy viewUrl) | Eksik |
| Tam ekran? | Video: dialog; **foto: yok** | Eksik (özellikle mobil) |
| Streaming mi download mı? | Video: media_kit URL açma (stream benzeri); ayrı download yok | Netleştirilmeli |
| Lazy loading / pagination? | Stage tab + grid; pagination **yok** (max 20) | Kısmen yeterli |
| Memory yönetimi? | Risk notu var; politika yok | Eksik |

---

## 4. Belirsizlikler

Her biri farklı ekip üyesi tarafından farklı şekilde implement edilebilir:

### B1 — Kapsam: F6 mi, yeni “Mobile Intake” mi?
Analiz §8 “taşınmalı” diyor; SDD F6 “create/medya yok” diyor; §11 create+media sırası öneriyor.  
**Problem:** İki haftalık sprint ya F6 sertleştirmesi ya da yeni büyük feature olur; karışırsa yarım ürün + regresyon.

### B2 — “Medya olmadan kabul” iş kuralı
SMS #1 ilk BEFORE confirm’de. Analiz bunu not ediyor ama “BEFORE zorunlu mu / kaç foto minimum?” demiyor.  
**Problem:** Operasyon “fotoğrafsız iş emri” istemiyorsa API buna zorlamıyor; UX zorlaması tasarlanmalı.

### B3 — Partial upload success semantiği
5 mediadan 3’ü OK, 2’si fail → WO “tamam mı”? Kullanıcı ne görür?  
**Problem:** Atölye personeli “yüklendi sandığı” işlerle çalışabilir.

### B4 — Retry: yeni request-upload vs PENDING reuse
Analiz Risk 3 doğru tespit: retry bugün yeni slot tüketir. To-be tercih yazılmamış.  
**Problem:** 20 limit + zayıf ağda limit erken dolar.

### B5 — Offline: bilinçli yok mu, Phase-2 mi, MVP’de kuyruk mu?
İlk analiz “offline YOK” diyor; yeni analiz “kalıcı kuyruk öner” diyor.  
**Problem:** Mimari ve paket seçimi tamamen değişir.

### B6 — Sıkıştırma parametreleri
“JPEG kalite / çözünürlük / video süre sınırı” sayısal hedef yok.  
**Problem:** Her geliştirici farklı trade-off seçer; backend limit aşımı veya aşırı kalite kaybı.

### B7 — iOS dağıtım kapsamı
SDD “dağıtım kapsamındaysa iOS”; Analiz HEIC’i zorunlu risk sayıyor.  
**Problem:** Android-only ise HEIC önceliği düşer; iOS varsa Day-1 blocker.

### B8 — UseCase / Mapper / Domain katmanı
Analiz “yok, DTO doğrudan UI” diyor ama mobil create önerirken mimari genişletme söylemiyor.  
**Problem:** Büyük form+upload mobilde StatefulWidget şişmesi; test edilebilirlik.

### B9 — Navigation / deep link
Barkod→detail var; create deep link, `trackingUrl` share, cold start yok.  
**Problem:** “Tarayıcıdan bulunamadıysa yeni kabul” önerisi navigasyon sözleşmesi olmadan yapılamaz.

### B10 — `swagger_json` otoritesi
Dump eski olabilir; required/enum alanları swagger’da zayıf (nullable görünen alanlar).  
**Problem:** Sözleşme “swagger mı, backend validator mı, Flutter DTO mu?”

### B11 — StatusLog `note` gösterimi
Analiz backend’in note yazıp response’ta dönmediğini doğru söylüyor. Mobilde iptal nedeni gösterilecek mi? Backend değişikliği mi istemci-only mi?  
**Problem:** “Eksik alan” ile “bilinçli gizleme” ayrılmamış.

### B12 — Concurrent desktop+mobile
Aynı WO’ya masaüstü media + mobil status. 409 davranışı detail’de var; create yarışı / çift create yok.  
**Problem:** İki personel aynı müşteri için iki WO açabilir.

---

## 5. Çelişkiler

| # | Kaynak A | Kaynak B | Çelişki |
|---|---|---|---|
| C1 | **SDD F6** / ilk analiz §3.3: mobilde create, edit, media, SMS, fiyat, teslim **YOK** | **Analiz §8–§11**: mobilde create + media + kalıcı kuyruk **önerilir / sıralanır** | En kritik çelişki — implementasyon kapsamı kilitlenmemiş |
| C2 | **SDD F1**: DateOnly + fieldErrors “yapılacak” | **Kod + Analiz**: `dateOnlyToJson` ve `FieldErrorResolver` **zaten var** | SDD bayat; hangi doküman “yapılacaklar listesi”? |
| C3 | **SDD F5.6**: fallback `pageSize=1` | **Kod / Analiz**: `findByOrderNumber` `pageSize=20` | Yanlış “bulunamadı” risk modeli farklı |
| C4 | **İlk analiz**: Faz kapsamında offline **YOK** (bilinçli) | **Analiz §8.3 / §10**: offline kuyruk / background upload önerisi | Offline politikası çelişkili |
| C5 | **Analiz §8 intro**: mobil create/media yok (F5–F6) | **Aynı §8.1**: create alanları “taşınmalı: Evet” | Doküman kendi içinde çelişiyor |
| C6 | **Backend MediaRules**: HEIC/MOV **red** | **Flutter MediaFormatValidator**: HEIC/MOV **kabul + convert** | Desen doğru ama mobil ffmpeg yokken Analiz “taşınır” demeden strateji kilitlemiyor |
| C7 | **WorkOrderResponse.media[]** detayda geliyor | **MediaGalleryCubit** ayrıca `GET .../media` çağırıyor | Bilinçli olabilir; Analiz not ediyor ama “mobilde hangisi?” kararı yok |
| C8 | **Swagger** request alanları çoğunlukla `nullable: true`, required listesi zayıf | **FluentValidation + runtime** katı kurallar | Swagger’a bakarak geliştiren yanlış varsayar |
| C9 | **Analiz**: “Product Create mobil entegrasyonu” | **Mevcut mobil kod**: create route **yok**; F6 AC: media render edilmemeli | “Hazırlık notları” mevcut roadmap’i ihlal ediyor |
| C10 | **SDD**: yeni paketler yalnız feature branch’te | **Analiz §8.3**: image_picker/compression/background için paket ima ediyor ama “yeni paket önerme” yasağı önceki görevde vardı; bu audit’te karar listesi yok | Paket/onay süreci tanımsız |

---

## 6. Riskler (implementasyon öncesi)

| Seviye | Risk | Etki |
|---|---|---|
| **P0** | Kapsam çelişkisi (F6 vs Mobile Create/Media) | Yanlış feature’a haftalar harcanır |
| **P0** | Create idempotent değil + çift submit | Çift iş emri / çift barkod |
| **P0** | Mobil HEIC/MOV + ffmpeg yok | iPhone medya yükleyemez |
| **P0** | 500 MB tek PUT + mobil ağ | Kabul masasında işlemin yarım kalması |
| **P1** | PENDING’lerin 20 limitte yer tutması + retry yeni slot | Limit dolması, operasyon blokajı |
| **P1** | viewUrl 15 dk + cache/yenileme yok | “Medya bozuldu” yanlış alarmı |
| **P1** | JWT 30 gün, revocation yok | Çalıntı cihazda uzun erişim |
| **P1** | Başka `workOrderId`’ye media (IDOR) — backend WO ownership check var mı net değil* | Yetkisiz yükleme |
| **P1** | Offline önerisi vs “offline yok” kararı | Mimari salınım |
| **P2** | Thumbnail yok → 25 MB decode grid | OOM / jank |
| **P2** | StatusLog note response’ta yok | İptal nedeni görünmez |
| **P2** | Geçici ffmpeg dosyası cleanup yok | Disk dolması (özellikle masaüstü) |
| **P2** | Sayaç bug (PENDING/kuyruk) | MEDIA_LIMIT_EXCEEDED sürprizi |

\*Backend `RequestUpload` work order’ın varlığını ve açık oluşunu kontrol ediyor; **kullanıcı/rol bazlı “bu WO bana mı ait?” yok** (tek admin rolü varsayımı). Multi-user gelirse risk büyür — Analiz bunu threat olarak işlemiyor.

---

## 7. API Audit Sonuçları

Kaynak: `swagger_json` + `MediaController` / `WorkOrdersController` + Analiz.

| Soru | Sonuç |
|---|---|
| Video upload endpoint var mı? | **Ayrı “video” ucu yok.** Aynı `POST .../media/request-upload` + `mediaType=VIDEO` |
| Multipart endpoint? | **Hayır.** JSON request-upload + **presigned PUT** (raw body) + JSON confirm |
| Tek request mi çoklu mu? | **Dosya başına 3 adım** (request → PUT → confirm); çoklu dosya = N×3, istemcide sıralı |
| Max upload sayısı? | **20 / work order** (PENDING dahil) |
| Max file size? | Foto **25 MB**, video **500 MB** |
| Content-Type kısıtı? | Evet: `image/jpeg`, `image/png`, `video/mp4` |
| Authorization? | API uçları JWT zorunlu; MinIO PUT **imzalı URL** (JWT gitmez) |
| Upload timeout tanımlı mı? | API Dio 15s; **upload Dio timeout yapılandırılmamış** (Analiz doğru) |
| Delete media? | **Evet** `DELETE /api/media/{id}` |
| Replace media? | **Yok** |
| Reorder? | **Yok** |
| Media metadata? | Sınırlı: `id, mediaType, stage, viewUrl, createdAt` — **size/mime/etag/duration yok** |
| Thumbnail URL? | **Yok** |
| Video duration? | **Yok** |
| Dosya tipi dönüyor mu? | `mediaType` (PHOTO/VIDEO) evet; mime hayır |

**API verdict:** Mevcut API **desktop as-is ve SDD F6** için yeterli. **Mobil create+camera upload+dayanıklı büyük video** için fonksiyonel yeterlilik var, operasyonel yeterlilik yok (resumable, thumbnail, richer metadata).

---

## 8. UI/UX Audit Sonuçları

| Durum | Desktop Create | Desktop Detail/Media | Mobil Detail (F6) | Analiz’in to-be önerisi |
|---|---|---|---|---|
| Loading | Submit spinner var | Skeleton var | Skeleton var | — |
| Empty state | Kısmi (hizmet/sarf boş metinleri) | Stage “medya yok” | Timeline boş shrink | Create empty’leri zayıf |
| Error state | SnackBar + kırmızı kutu + fieldErrors | Retry butonu | Retry var | Error taxonomy yok |
| Success state | Navigate to detail (SnackBar yok) | Status haptic (mobil) | Haptic | Create success feedback zayıf |
| Progress | — | Upload tile + LinearProgress | — | Toplam kuyruk progress önerisi kararsız |
| Confirmation | — | READY/Cancel/Delete/Deliver | READY/Cancel sheet | Create’de “BEFORE zorunlu” confirm yok |
| Validation feedback | Kısmi (maxLength yok) | — | — | Analiz bug’ları listeliyor, AC yok |
| Offline ekranı | Yok | Yok | Yok | Öneri var, karar yok |
| Permission ekranı | — | — | Kamera permanent-deny var | Galeri/photos eksik |
| Cancel upload | **Yok** | **Yok** | — | Eksik |
| Retry upload | Manuel buton | Var | — | Otomatik belirsiz |
| Fullscreen foto | **Yok** | **Yok** | — | “Gerekli” denmiş, tasarım yok |
| Shimmer | SkeletonBox kullanılıyor (shimmer paketi yok) | Var | Var | — |

**UX Lead özeti:** Doküman eksik state’leri **tespit ediyor** ama **tasarım sözleşmesine bağlamıyor**. Özellikle cancel upload, partial failure banner, “SMS için BEFORE fotoğrafı çek” wizard adımı ve offline ekranı olmadan mobil kabul UX’i tasarlanamaz.

---

## 9. Güvenlik Audit Sonuçları

| Madde | Durum | Not |
|---|---|---|
| Kamera izinleri | Tarayıcı için var | Medya çekimi yok (F6); yeni feature’da gerekçe metni eksik |
| Galeri izinleri | Yok | Android 13+ Photo Picker vs `READ_MEDIA_*` kararı yok |
| Dosya tipi doğrulama | Uzantı + sunucu mime whitelist | Magic-byte / content sniffing yok — uzantı spoof riski düşük ama var |
| Executable upload | Whitelist dışı red | İyi |
| MIME doğrulama | Sunucu mime→ext tablosu | İstemci beyanına kısmen güven (boyut confirm’de doğrulanır; içerik tipi StatObject’te mime re-check yok) |
| Boyut doğrulama | Çift taraflı | İyi |
| Video doğrulama | Yalnızca mime/size; codec/container derin kontrol yok | Bozuk mp4 confirm’de geçebilir |
| Yetkisiz erişim | JWT | Rol ayrımı yok (tek admin modeli) |
| Başkasının ürününe medya | ID ile; auth’lu herhangi admin yükleyebilir | Faz 1’de kabul edilebilir; dokümante edilmeli |
| Rate limit | Login + public tracking var; **media upload rate limit yok** | Spam upload mümkün |
| Spam / duplicate upload | Aynı dosya tekrar yüklenebilir; dedup yok | 20 limit sert tavan |
| Signed URL sızıntısı | viewUrl 15 dk | Log/analytics’e URL yazılırsa risk |
| Token revocation | Yok (30 gün) | Mobil cihaz kaybı — ilk analizde var, Product analizinde yüzeysel |

---

## 10. Performans Audit Sonuçları

| Senaryo | Risk | Analiz kapsamı |
|---|---|---|
| 100 fotoğraf | API max 20 — senaryo geçersiz; UI 20’de kesmeli | Sayaç bug’ı ile limit aşımı denemesi mümkün |
| 500 MB video | Tek PUT; mobil 4G/Edge’te pratikte kırılgan | Risk var; limit kararı yok |
| Çok yavaş internet | Upload timeout tanımsız; retry slot yakar | P0/P1 |
| Upload queue | Sıralı; toplam süre = Σ dosya | UX progress eksik |
| Memory | Tam boy Image.network decode | `cacheWidth` önerisi var, zorunlu değil |
| Disk cache | Politika yok; signed URL + HTTP cache etkileşimi belirsiz | Eksik |
| Thumbnail üretimi | Yok | Mobilde pahalı |
| Video preview | media_kit desktop; mobil detail’de video UI yok | F6 ile uyumlu; create+media gelirse paket kararı |
| Liste/scroll | Max 20 grid — genelde OK | 4 sütun mobil için yanlış |
| Image decode | Ana risk | Karar eksik |

---

## 11. Implementasyon Öncesi Cevaplanması Gereken Sorular (50)

### Kapsam ve ürün (1–12)

1. Bu sprint’in kapsamı **SDD F6 sertleştirme** mi, yoksa **yeni “Mobile Product Create + Media” (F8+)** mi?
2. Mobilde iş emri **oluşturma** açılacak mı? (Evet/Hayır — ikisi birden “belki” kabul edilmez.)
3. Mobilde **medya yükleme/silme** açılacak mı?
4. Mobilde **düzenleme (PUT)** açılacak mı?
5. Mobilde **teslim (/deliver)** açılacak mı? (SDD: hayır — teyit?)
6. Mobilde **fiyat/kapora** gösterilecek mi, gizlenecek mi, PIN arkası mı?
7. Kabulde **en az bir BEFORE fotoğraf zorunlu** mu? Zorunluysa istemci mi backend mi enforce edecek?
8. Medyasız iş emri operasyonel olarak **kabul edilebilir** mi?
9. Draft / yarım form kaydı isteniyor mu?
10. Otomatik kaydetme isteniyor mu?
11. iOS bu fazda **hedef platform** mu?
12. “Tarayıcıda bulunamadı → yeni kabul aç” akışı bu fazda mı?

### Upload semantiği (13–28)

13. Upload fail olduğunda WO **silinecek mi / rollback** mü, yoksa medyasız WO mu kalacak? (Bugünkü davranış: kalır — değiştirilecek mi?)
14. Kısmi başarıda kullanıcıya hangi **tek gerçek durum** gösterilecek?
15. Retry **PENDING satırı yeniden kullanacak** mı, yoksa yeni `request-upload` mı?
16. Otomatik retry sayısı, backoff, hangi hata sınıflarında?
17. Upload **iptal (cancel)** desteklenecek mi? İptalde PENDING + MinIO nesnesi ne olacak?
18. Pause/resume olacak mı?
19. Arka plan upload (foreground service / BGProcessing) bu fazda zorunlu mu?
20. Uygulama kill edilince kuyruk **persist** edilecek mi?
21. Offline’da kuyruğa alıp sonra mı göndereceğiz, yoksa offline’da işlem yasak mı?
22. Mobil pratik video limiti kaç MB / kaç saniye?
23. Fotoğraf sıkıştırma hedefi nedir? (max kenar px, JPEG quality)
24. Video sıkıştırma/transcode mobilde yapılacak mı? Hangi kütüphane/strateji?
25. HEIC: kamera JPEG zorla mı, çekim sonrası convert mi, HEIC red + kullanıcı mesajı mı?
26. MOV/HEVC aynı strateji?
27. Android 13+ **Photo Picker** mı, yoksa geniş galeri izni mi?
28. Aynı anda max kaç yükleme (1 mi, 2 mi)? Sıralı mı kalacak?

### Detail / media UX (29–38)

29. Fotoğrafa tıklanınca **tam ekran** zorunlu mu? Masaüstüne de geriye dönük eklenecek mi?
30. Video preview mobilde media_kit mi, başka player mı, yoksa sistem player mı?
31. Thumbnail sunucu tarafı mı, istemci downscale mı, yoksa “şimdilik yok” mu?
32. viewUrl dolunca otomatik refresh mi, pull-to-refresh mi, timer mı?
33. Medya sıralama / kapak fotoğrafı bu fazda var mı? (Varsayılan: yok — teyit)
34. Replace media UX’i (sil+yükle) kullanıcıya nasıl anlatılacak?
35. Silme sonrası SMS davranışı kullanıcıya her seferinde mi gösterilecek?
36. 20 limit dolunca UX metni ve PENDING temizliği kullanıcıya nasıl açıklanacak?
37. Create sonrası otomatik “BEFORE çek” wizard adımı olacak mı?
38. Success feedback: create sonrası SnackBar mı, doğrudan camera mı, detail mi?

### API / güvenlik / gözlemlenebilirlik (39–50)

39. F7 `by-number` ucu bu fazda backend’e istenecek mi, fallback yeterli mi?
40. `StatusLogResponse.note` response’a eklenecek mi?
41. `MediaFileResponse`’a `sizeBytes` / `mimeType` / `durationMs` eklenecek mi?
42. Media upload için **rate limit** istenecek mi?
43. Create için istemci **idempotency-key** (gelecek) mi, yoksa UI disable yeterli mi?
44. Başka admin’in WO’suna media (IDOR) Faz 1’de kabul mü?
45. JWT cihaz kaybı için kısa vadeli kabul metni imzalanacak mı?
46. Upload/API için hangi log alanları PII sayılır (trackingUrl, phone)?
47. Crash/analytics aracı bu fazda var mı? (Sentry vb. — yoksa bilinçli yok)
48. `swagger_json` ne sıklıkla yenilenecek; sözleşme kaynağı hangisi?
49. Minimum Android SDK / iOS sürümü nedir?
50. Feature flag ile mobilde create/media’yı kapalı tutup kademeli açma var mı?

---

## 12. Önceliklendirilmiş Aksiyon Listesi

### P0 — Geliştirme başlamadan (bloklayıcı)

| # | Aksiyon | Sahip önerisi | Çıktı |
|---|---|---|---|
| A1 | **Kapsam kilidi toplantısı:** F6-only vs Mobile Intake (Create+Media) | PO + Architect | 1 sayfalık Decision Record |
| A2 | A1 = F6-only ise Analiz §8–§11’i “gelecek faz önerisi” diye etiketle; entegrasyon promptunu **F6 sertleştirme** ile sınırla | Architect | Revize kapsam |
| A3 | A1 = Create+Media ise SDD’ye **F8 (Mobile Intake)** ekle; F6 AC’lerini bilinçli supersede et | Architect | Yeni SDD bölümü |
| A4 | BEFORE zorunluluğu + medyasız WO kabul politikası | PO + Operasyon | İş kuralı metni |
| A5 | Offline / background upload: **bu fazda YOK** veya **VAR** diye kilitle (ortası yasak) | Architect | Decision Record |
| A6 | iOS bu fazda var/yok + HEIC stratejisi | PO + Mobile lead | Decision Record |
| A7 | Create çift-submit koruması (UI + isteğe bağlı idempotency) kabul kriteri | Tech lead | AC maddesi |

### P1 — Kapsam netleşince tasarım tamamla

| # | Aksiyon |
|---|---|
| A8 | To-be sequence + upload state machine (cancel/retry/persist) diyagramları |
| A9 | ErrorCode → UI mapping tablosu |
| A10 | Permission matrix (Android 13/14/15, iOS) |
| A11 | Sıkıştırma sayısal hedefleri + pratik video limiti |
| A12 | PENDING reuse retry tasarımı |
| A13 | viewUrl expiry UX |
| A14 | SDD F1’i “DONE” olarak işaretle / doküman senkronu |
| A15 | findByOrderNumber: F7 kararı veya pageSize=20 risk kabulü |

### P2 — Sertleştirme / borç

| # | Aksiyon |
|---|---|
| A16 | Sayaç bug (PENDING/kuyruk) düzeltme AC’si |
| A17 | Fiyat-0 virgül parse bug AC’si |
| A18 | Temp conversion file cleanup |
| A19 | Thumbnail stratejisi (istemci downscale minimum) |
| A20 | StatusLog note API genişletmesi (isteğe bağlı backend) |
| A21 | Upload rate limit (isteğe bağlı backend) |
| A22 | swagger_json yenileme + CI drift check |
| A23 | Güvenlik: token kaybı kabul metni / orta vade revocation |

---

## Ek A — “Bu dokümanla başlanır mı?” kontrol listesi

| Soru | Durum |
|---|---|
| As-is desktop create/detail/media anlaşıldı mı? | **Evet** |
| Mobil hedef kapsam kilitli mi? | **Hayır** |
| Upload fail / partial / kill / offline davranışları ürün kararı mı? | **Hayır** |
| HEIC/iOS/Android picker kararları var mı? | **Hayır** |
| API yeterliliği desktop için net mi? | **Evet** |
| API yeterliliği dayanıklı mobil upload için net mi? | **Hayır (bilinçli gap)** |
| SDD ile Analysis hizalı mı? | **Hayır (C1, C5)** |
| 50 sorunun ≥80%’i cevaplı mı? | **Hayır (~35% as-is cevaplı, to-be çoğunluk açık)** |

**Final verdict:**  
`product-create-detail-teknik-analiz.md` bir **keşif ve envanter** dokümanı olarak değerlidir (≈88/100 as-is). Bir **implementasyon sözleşmesi** olarak yetersizdir (≈52/100).  
Yarın kod yazılacaksa önce **A1–A7 Decision Record’ları** kapanmalı; aksi halde ekip ya SDD’yi ihlal eden create/media’ya ya da Analiz’in “hazırlık notlarını” yok sayan F6’ya doğru körlemesine gidecektir.

---

*Bu audit salt inceleme ürünüdür; kod ve mevcut analiz dosyaları değiştirilmemiştir.*
