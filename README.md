# Veribenim Consent Mode — Google Tag Manager template

[English](#english) · [Türkçe](#türkçe)

---

## English

This tag template connects the [Veribenim](https://veribenim.com) cookie banner to
Google consent mode v2 in Google Tag Manager. It sets the default consent states
before any other tag runs and updates them whenever a visitor makes, changes or
restores a choice in the banner.

### Requirements

- A Veribenim site with the banner script installed.
- The banner script must be in `<head>` **before** the GTM container snippet and
  **without** `async`, so it runs first on every page.
- A web GTM container.

### Installation

1. **Add the template.** In GTM go to *Templates → Tag Templates → Search Gallery*,
   search for "Veribenim" and add it to your workspace.
   (Manual install: *Templates → Tag Templates → New → ⋮ → Import* and pick
   `template.tpl` from this repository.)
2. **Default tag (required).**
   *Tags → New → Veribenim Consent Mode*, set *Consent command* to **Default**.
   Trigger: **Consent Initialization - All Pages**.
3. **Update tag (recommended).**
   *Tags → New → Veribenim Consent Mode*, set *Consent command* to **Update**.
   Trigger: a *Custom Event* trigger with event name **`vbn_consent_update`**.
4. Publish, then verify (see below).

> **Trigger warning.** Use *Consent Initialization - All Pages* for the Default tag,
> not *All Pages* or *Initialization*. Those fire later and race with your other
> tags, so some tags would run before the defaults exist — i.e. without consent.

### How it works

| Signal from the banner | What the template does |
|---|---|
| `window.__vbn_cookieCategories` | Only checks that the banner script loaded. If it is missing, the Default tag sets the defaults and then **fails** (status *Failed* in Preview). Visitors are still not tracked without consent; only the banner is missing. |
| `window.__vbn_gtm_onConsentChange(payload)` | Registered by the Default tag. The banner calls it on every decision and on every restored decision. The template calls `updateConsentState` with the payload. |
| Data layer event `vbn_consent_update` with `vbn_consent` and `vbn_consent_source` (`user` / `restored`) | The Default tag applies `vbn_consent` if it is already in the data layer. The Update tag applies it when the event fires. This covers a returning visitor whose choice was restored before the container loaded. |

The banner payload contains `analytics_storage`, `ad_storage`, `ad_user_data`,
`ad_personalization`, `functionality_storage` and `personalization_storage`.
Banner categories map as: Analytics → `analytics_storage`; Marketing →
`ad_storage`, `ad_user_data`, `ad_personalization`; Functional →
`functionality_storage`, `personalization_storage`.

Rules the template follows:

1. **Missing keys are never filled in.** If the banner sends only some consent
   types, only those are updated.
2. **Invalid values are ignored.** Anything other than `granted` / `denied`, and
   unknown consent types, are skipped and logged.
3. **The tag fails if the banner script is not on the page.** A silent success
   would hide the problem.
4. **`security_storage` is always granted** and can never be denied.

### Fields

| Field | Meaning |
|---|---|
| Consent command | **Default**: set defaults and listen for the banner. **Update**: apply `vbn_consent` from the data layer. |
| Default consent settings | One row per region. *Region*: ISO 3166-2 codes, comma separated (e.g. `TR, DE, US-CA`); blank = every region without its own row. The most specific region wins. *Granted* / *Denied*: comma-separated consent types. Types you don't list are not set. A type listed in both columns is denied. The default row denies all six types. |
| Wait for update (milliseconds) | `wait_for_update` for every default row. Default `500`. |
| Redact ads data when ad_storage is denied | Sets `ads_data_redaction`. On by default. The banner script also always sets it. |
| Pass ad click information through URLs | Sets `url_passthrough`. **Off** by default. Match the *URL passthrough* setting of your Veribenim site. |

### Matching your Veribenim site settings

- **Google consent mode signal of the banner.** The banner script can send
  `gtag('consent', …)` itself (Console → Integration → Consent signal bridges →
  Google Consent Mode). Both sources send the same values. If you manage consent
  mode only through this template, you can turn the banner's own Google signal off
  to keep a single source. The banner still calls the template and still pushes
  `vbn_consent_update` when it is off.
- **Basic / Advanced consent mode.** In *Advanced* (default) Google tags load and
  send cookieless pings while consent is denied. In *Basic* the banner script blocks
  Google tag scripts (`gtag/js`, `google-analytics.com`, `googleadservices.com`,
  `doubleclick.net`) until consent is given; the GTM container itself is not
  blocked. The template does not need a setting for this.
- **URL passthrough.** Keep the template checkbox the same as the site setting.

### Verifying

**GTM Preview (Tag Assistant debug mode)**

1. Click *Preview*, open your site, accept nothing yet.
2. Select the **Consent Initialization** event: the Veribenim Default tag shows
   *Succeeded*. If it shows *Failed*, the banner script is missing or loads after
   GTM (check order and `async`).
3. Open the **Consent** tab on that event: *On-page Default* shows your defaults
   (for example `ad_storage: Denied`, `security_storage: Granted`).
4. Accept or reject in the banner. A **`vbn_consent_update`** event appears; its
   Consent tab shows *On-page Update* with your choice, and the Data Layer tab
   shows `vbn_consent` and `vbn_consent_source: "user"`. The Update tag fired on it.
5. Reload the page. `vbn_consent_update` appears again with
   `vbn_consent_source: "restored"`. Check that the update appears before the
   event that fires your page view tags.
6. In the browser console (only in Preview) messages start with
   `Veribenim Consent Mode:`.

**Tag Assistant (tagassistant.google.com) on the live site**

- Each Google tag's Consent tab lists the default and update states.
- Before a choice: `ad_storage`, `analytics_storage`, `ad_user_data`,
  `ad_personalization` are *Denied*. After accepting: *Granted*.
- In Google requests, the `gcs` / `gcd` parameters change after the update.

### Development

Template tests live in the `___TESTS___` section of `template.tpl`. They run only
in the GTM Template Editor (*Tests* tab → *Run Tests*).

### Links

- [Veribenim](https://veribenim.com)
- [Google consent mode](https://developers.google.com/tag-platform/security/concepts/consent-mode)
- [Consent mode in GTM templates](https://developers.google.com/tag-platform/tag-manager/templates/consent-apis)

---

## Türkçe

Bu etiket şablonu, [Veribenim](https://veribenim.com) çerez banner'ını Google
Tag Manager içindeki Google Consent Mode v2'ye bağlar. Diğer etiketlerden önce
varsayılan rıza durumlarını ayarlar; ziyaretçi banner'da karar verdiğinde,
kararını değiştirdiğinde ya da önceki kararı geri yüklendiğinde durumu günceller.

### Gereksinimler

- Banner script'i kurulu bir Veribenim sitesi.
- Banner script'i `<head>` içinde GTM kodundan **önce** ve `async` **olmadan**
  durmalı; her sayfada ilk o çalışmalı.
- Bir web GTM konteyneri.

### Kurulum

1. **Şablonu ekleyin.** GTM'de *Şablonlar → Etiket Şablonları → Galeride Ara*,
   "Veribenim" diye arayın, çalışma alanına ekleyin. (Elle kurulum: *Yeni → ⋮ →
   İçe aktar* ile bu depodaki `template.tpl`.)
2. **Default etiketi (zorunlu).** Etiket türü *Veribenim Consent Mode*,
   *Consent command* = **Default**. Tetikleyici: **Consent Initialization - All Pages**.
3. **Update etiketi (önerilir).** *Consent command* = **Update**. Tetikleyici:
   olay adı **`vbn_consent_update`** olan *Özel Etkinlik* tetikleyicisi.
4. Yayınlayın ve aşağıdaki adımlarla doğrulayın.

> **Tetikleyici uyarısı.** Default etiketi *Consent Initialization - All Pages*
> tetikleyicisine bağlanmalı. *All Pages* ya da *Initialization* daha geç çalışır
> ve diğer etiketlerle yarışır; bazı etiketler varsayılan durum ayarlanmadan, yani
> rızasız çalışmış olur.

### Nasıl çalışır

- `window.__vbn_cookieCategories` yalnızca banner'ın yüklendiğini anlamak için
  okunur. Yoksa Default etiketi varsayılanları ayarlar, sonra **başarısız** olur
  (Preview'da *Failed*). Ziyaretçi yine rızasız izlenmez; yalnızca banner yoktur.
- `window.__vbn_gtm_onConsentChange(payload)` Default etiketi tarafından kaydedilir;
  banner her kararda ve her geri yüklemede bunu çağırır.
- `vbn_consent_update` dataLayer olayı `vbn_consent` ve `vbn_consent_source`
  (`user` / `restored`) taşır. Default etiketi `vbn_consent` dataLayer'da zaten
  varsa uygular; Update etiketi olay geldiğinde uygular. Konteyner yüklenmeden
  önce geri yüklenen karar böylece kaybolmaz.

Kurallar: eksik anahtar tamamlanmaz; `granted`/`denied` dışındaki değer ve
bilinmeyen rıza türü yok sayılır; banner yoksa etiket başarısız olur;
`security_storage` her zaman `granted` (hiç reddedilmez).

### Alanlar

| Alan | Anlamı |
|---|---|
| Consent command | **Default**: varsayılanları ayarla ve banner'ı dinle. **Update**: dataLayer'daki `vbn_consent`'i uygula. |
| Default consent settings | Her bölge için bir satır. *Region*: ISO 3166-2 kodları, virgülle (ör. `TR, DE, US-CA`); boş = kendi satırı olmayan tüm bölgeler. En özgül bölge kazanır. *Granted* / *Denied*: virgülle ayrılmış rıza türleri. Yazılmayan tür ayarlanmaz; iki sütunda da geçen tür reddedilir. Varsayılan satır altı türün hepsini reddeder. |
| Wait for update | Her satırın `wait_for_update` değeri (ms). Varsayılan `500`. |
| Redact ads data… | `ads_data_redaction`. Varsayılan açık; banner da her zaman açar. |
| Pass ad click information… | `url_passthrough`. Varsayılan **kapalı**; Veribenim sitenizdeki *URL passthrough* ayarıyla aynı tutun. |

### Site ayarlarıyla uyum

- **Banner'ın kendi Google Consent Mode sinyali** (Konsol → Entegrasyon → Rıza
  Sinyali Köprüleri): açıkken banner `gtag('consent', …)` de gönderir, değerler
  aynıdır. Rızayı yalnızca bu şablonla yönetmek isterseniz kapatabilirsiniz;
  kapalıyken de banner şablonu çağırır ve `vbn_consent_update` olayını iter.
- **Basic / Advanced:** Advanced'te (varsayılan) Google etiketleri yüklenir, rıza
  yokken çerezsiz ping gönderir. Basic'te banner Google etiket script'lerini rıza
  gelene kadar engeller; GTM konteynerinin kendisi engellenmez. Şablonda ayrı alan
  gerekmez.

### Doğrulama

**GTM Preview**

1. *Önizleme*'ye basın, siteyi açın, henüz karar vermeyin.
2. **Consent Initialization** olayında Veribenim Default etiketi *Succeeded*
   olmalı. *Failed* ise banner script'i yok ya da GTM'den sonra/async yükleniyor.
3. Aynı olayın **Consent** sekmesinde *On-page Default* değerleriniz görünmeli
   (ör. `ad_storage: Denied`, `security_storage: Granted`).
4. Banner'da kabul/ret yapın: **`vbn_consent_update`** olayı gelir; Consent
   sekmesinde *On-page Update*, Data Layer sekmesinde `vbn_consent` ve
   `vbn_consent_source: "user"` görünür; Update etiketi bu olayda çalışır.
5. Sayfayı yenileyin: `vbn_consent_update` bu kez
   `vbn_consent_source: "restored"` ile gelir. Güncellemenin, sayfa görüntüleme
   etiketlerinizi tetikleyen olaydan önce göründüğünü kontrol edin.
6. Tarayıcı konsolunda (yalnızca Preview'da) `Veribenim Consent Mode:` ile
   başlayan mesajlar görünür.

**Tag Assistant (canlı site)**

- Her Google etiketinin Consent sekmesinde varsayılan ve güncel durum listelenir.
- Karar öncesi reklam/analitik türleri *Denied*, kabul sonrası *Granted* olmalı.
- Google isteklerindeki `gcs` / `gcd` parametreleri güncellemeden sonra değişir.

### Geliştirme

Şablon testleri `template.tpl` içindeki `___TESTS___` bölümündedir ve yalnızca GTM
Şablon Düzenleyicisi'nde (*Testler* sekmesi → *Testleri Çalıştır*) koşar.

### Galeriye gönderim kontrol listesi (sahibi için)

1. `template.tpl`'yi GTM'de içe aktar; *Testler* sekmesinde tüm testleri çalıştır.
2. *Bilgi* sekmesinde gerçek marka görselini yükle (kare, 48–96 px, PNG/JPEG/GIF,
   50 KB altı). Şu anki görsel 1×1 yer tutucudur.
3. *Bilgi* sekmesinde "Agree to the Community Template Gallery Terms of Service"
   kutusunu işaretle, şablonu yeniden **dışa aktar** ve bu dosyanın yerine koy.
4. `main` dalına birleştir; GitHub'da Issues açık ve e-posta bildirimleri açık olsun.
5. O commit'in tam SHA'sını `metadata.yaml`'daki yer tutucunun yerine yaz,
   commit et ve `main`'e gönder.
6. tagmanager.google.com/gallery → *Submit Template* → depo adresi.
