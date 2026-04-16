# Veribenim — Google Tag Manager Consent Mode Template

Google Consent Mode v2 integration template for [Veribenim](https://veribenim.com) Cookie Consent & Privacy Platform.

## What This Template Does

This template connects Veribenim's cookie consent banner with Google's Consent Mode v2 API inside Google Tag Manager. It ensures that Google tags (Analytics, Ads, etc.) respect user consent choices made through the Veribenim banner.

## Supported Consent Types

| Consent Type | Veribenim Category | Description |
|---|---|---|
| `analytics_storage` | Analytics | Visit duration, page views |
| `ad_storage` | Marketing | Advertising cookies |
| `ad_user_data` | Marketing | User data for ads |
| `ad_personalization` | Marketing | Remarketing |
| `functionality_storage` | Functional | Language, preferences |
| `personalization_storage` | Functional | Recommendations |
| `security_storage` | — | Always granted |

## Setup Instructions

### 1. Import the Template

In your GTM container:
1. Go to **Templates** > **Tag Templates** > **Search Gallery**
2. Search for "Veribenim"
3. Click **Add to workspace**

Or import manually:
1. Go to **Templates** > **Tag Templates** > **New**
2. Click the three-dot menu > **Import**
3. Select `template.tpl` from this repository

### 2. Create the Default Consent Tag

1. Go to **Tags** > **New**
2. Choose **Veribenim - Consent Mode** as the tag type
3. Set **Command** to **Default (Initialization)**
4. Enable **Automatically read consent from Veribenim storage** (recommended)
5. Set trigger to **Consent Initialization - All Pages**

### 3. Create the Update Consent Tag

1. Go to **Tags** > **New**
2. Choose **Veribenim - Consent Mode** as the tag type
3. Set **Command** to **Update**
4. Enable **Automatically read consent from Veribenim storage**
5. Create a custom event trigger for `veribenim_consent_update`

### 4. Verify with Tag Assistant

1. Open [Tag Assistant](https://tagassistant.google.com/)
2. Connect your site
3. Check the **Consent** tab to verify signals are being sent

## How It Works

```
Page Load
  |
  v
[Veribenim Bundle loads]
  |-- Sets window.__vbn_cookieCategories (for GTM to read)
  |-- Stores consent in localStorage (key: veribenimIsAwesome)
  |
  v
[GTM Default Tag fires]
  |-- Reads localStorage via callInWindow
  |-- Calls setDefaultConsentState() with correct values
  |-- Registers __vbn_gtm_onConsentChange listener
  |
  v
[User interacts with banner]
  |
  v
[Veribenim Bundle calls __vbn_gtm_onConsentChange]
  |
  v
[GTM listener calls updateConsentState()]
  |-- Google tags adjust behavior accordingly
```

## Advanced Settings

- **Region filtering**: Restrict default consent to specific regions (ISO 3166-2 codes)
- **URL passthrough**: Pass ad click info through URL when ad_storage is denied
- **Ads data redaction**: Redact ad click identifiers when ad_storage is denied
- **DataLayer events**: Push `veribenim_consent_update` events for custom triggers

## Requirements

- Veribenim account with an active environment
- Veribenim JS bundle installed on your website
- Google Tag Manager container

## Links

- [Veribenim](https://veribenim.com)
- [Documentation](https://veribenim.com/docs)
- [Pariette](https://pariette.com)
