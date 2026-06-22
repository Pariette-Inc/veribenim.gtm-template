___INFO___

{
  "type": "TAG",
  "id": "cvt_veribenim_consent_mode",
  "version": 1,
  "securityGroups": [],
  "displayName": "Veribenim - Consent Mode",
  "brand": {
    "id": "brand_veribenim",
    "displayName": "Veribenim",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPj/HwADBwIAMCbHYQAAAABJRU5ErkJggg=="
  },
  "description": "Veribenim Cookie Consent \u0026 Privacy Platform — Google Consent Mode v2 integration for GTM. Automatically syncs user consent choices with Google tags (Analytics, Ads, etc.).",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "TAG_MANAGEMENT",
    "UTILITY",
    "ANALYTICS",
    "ADVERTISING"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "GROUP",
    "name": "grpConsentCommand",
    "displayName": "Consent Command",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "consentCommand",
        "displayName": "Command",
        "macrosInSelect": false,
        "selectItems": [
          {
            "value": "default",
            "displayValue": "Default (Initialization)"
          },
          {
            "value": "update",
            "displayValue": "Update"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "default",
        "help": "\"Default\" sets the initial consent state when the page loads. \"Update\" changes the consent state after user interaction."
      },
      {
        "type": "TEXT",
        "name": "waitForUpdate",
        "displayName": "Wait for Update (ms)",
        "simpleValueType": true,
        "defaultValue": 500,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          }
        ],
        "help": "How long (in milliseconds) to wait for a consent update before using the default values. Recommended: 500.",
        "enablingConditions": [
          {
            "paramName": "consentCommand",
            "paramValue": "default",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "grpConsentSettings",
    "displayName": "Consent Settings",
    "groupStyle": "NO_ZIPPY",
    "subParams": [
      {
        "type": "SELECT",
        "name": "analytics_storage",
        "displayName": "Analytics Storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls storage for analytics purposes (e.g., visit duration)."
      },
      {
        "type": "SELECT",
        "name": "ad_storage",
        "displayName": "Ad Storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls storage for advertising purposes (e.g., cookies)."
      },
      {
        "type": "SELECT",
        "name": "ad_user_data",
        "displayName": "Ad User Data",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls whether user data can be sent to Google for advertising."
      },
      {
        "type": "SELECT",
        "name": "ad_personalization",
        "displayName": "Ad Personalization",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls whether data can be used for ad personalization (remarketing)."
      },
      {
        "type": "SELECT",
        "name": "functionality_storage",
        "displayName": "Functionality Storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls storage for website functionality (e.g., language preferences)."
      },
      {
        "type": "SELECT",
        "name": "personalization_storage",
        "displayName": "Personalization Storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "denied",
        "help": "Controls storage for personalization (e.g., video recommendations)."
      },
      {
        "type": "SELECT",
        "name": "security_storage",
        "displayName": "Security Storage",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": "granted",
            "displayValue": "Granted"
          },
          {
            "value": "denied",
            "displayValue": "Denied"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "granted",
        "help": "Controls storage for security purposes (e.g., authentication, fraud prevention). Always granted by default."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "grpAutoRead",
    "displayName": "Automatic Consent Reading",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "autoReadConsent",
        "checkboxText": "Automatically read consent from Veribenim storage",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When enabled, the template will automatically read the user's consent choices from Veribenim's localStorage (key: veribenimIsAwesome) and override the manual settings above. This is the recommended setting."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "grpRegion",
    "displayName": "Region Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "regions",
        "displayName": "Regions (comma-separated ISO 3166-2)",
        "simpleValueType": true,
        "defaultValue": "",
        "help": "Optionally restrict these consent defaults to specific regions. Leave blank to apply globally. Example: TR,DE,FR,AT,BE,BG,HR,CY,CZ,DK,EE,FI,GR,HU,IE,IT,LV,LT,LU,MT,NL,PL,PT,RO,SK,SI,ES,SE",
        "enablingConditions": [
          {
            "paramName": "consentCommand",
            "paramValue": "default",
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "grpAdvanced",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "urlPassthrough",
        "checkboxText": "Enable URL passthrough",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "Pass ad click information through URL parameters when ad storage consent is denied."
      },
      {
        "type": "CHECKBOX",
        "name": "adsDataRedaction",
        "checkboxText": "Enable ads data redaction",
        "simpleValueType": true,
        "defaultValue": true,
        "help": "When ad storage consent is denied, ad click identifiers will be redacted."
      },
      {
        "type": "CHECKBOX",
        "name": "enableDataLayerEvent",
        "checkboxText": "Push consent state to dataLayer",
        "simpleValueType": true,
        "defaultValue": false,
        "help": "Pushes a 'veribenim_consent_update' event to the dataLayer whenever consent state changes."
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Veribenim — Google Consent Mode v2 Template for GTM
// https://veribenim.com | https://pariette.com

const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState     = require('updateConsentState');
const gtagSet                = require('gtagSet');
const log                    = require('logToConsole');
const callInWindow           = require('callInWindow');
const copyFromWindow         = require('copyFromWindow');
const setInWindow            = require('setInWindow');
const makeNumber             = require('makeNumber');
const makeString             = require('makeString');
const getType                = require('getType');
const JSON                   = require('JSON');
const Object                 = require('Object');

const STORAGE_KEY = 'veribenimIsAwesome';

/**
 * Veribenim localStorage verisini oku.
 * Sandboxed JS'te doğrudan localStorage erişimi yok,
 * bu yüzden callInWindow ile window üzerinden okuyoruz.
 */
function readVeribenimConsent() {
  const raw = callInWindow('localStorage.getItem', STORAGE_KEY);
  if (!raw) return null;

  try {
    return JSON.parse(raw);
  } catch (e) {
    log('Veribenim GTM: Failed to parse consent data');
    return null;
  }
}

/**
 * Veribenim consent verisi + cookie kategorilerinden
 * GCM v2 consent state objesi oluştur.
 */
function buildConsentFromStorage(sessionData) {
  if (!sessionData || !sessionData.consents) return null;

  const consents = sessionData.consents;

  // Veribenim cookie kategorilerini window'dan oku (bundle tarafından set edilir)
  const categories = copyFromWindow('__vbn_cookieCategories');

  let analyticsAllowed  = false;
  let marketingAllowed  = false;
  let functionalAllowed = false;

  if (categories && getType(categories) === 'array') {
    // Kategori bazında consent durumunu hesapla
    for (let i = 0; i < categories.length; i++) {
      const cat = categories[i];
      if (!cat || !cat.cookies) continue;

      for (let j = 0; j < cat.cookies.length; j++) {
        const cookie = cat.cookies[j];
        if (consents[cookie.id] === true) {
          if (cat.id === 'analytics')  analyticsAllowed  = true;
          if (cat.id === 'marketing')  marketingAllowed  = true;
          if (cat.id === 'functional') functionalAllowed = true;
        }
      }
    }
  } else {
    // Kategori bilgisi yoksa, consent key isimlerinden tahmin et
    const keys = Object.keys(consents);
    for (let k = 0; k < keys.length; k++) {
      if (consents[keys[k]] === true) {
        const key = makeString(keys[k]).toLowerCase();
        if (key.indexOf('analytics') >= 0 || key.indexOf('istatistik') >= 0) analyticsAllowed = true;
        if (key.indexOf('marketing') >= 0 || key.indexOf('reklam') >= 0)     marketingAllowed = true;
        if (key.indexOf('function') >= 0  || key.indexOf('islevsel') >= 0)   functionalAllowed = true;
      }
    }
  }

  return {
    analytics_storage:       analyticsAllowed  ? 'granted' : 'denied',
    ad_storage:              marketingAllowed  ? 'granted' : 'denied',
    ad_user_data:            marketingAllowed  ? 'granted' : 'denied',
    ad_personalization:      marketingAllowed  ? 'granted' : 'denied',
    functionality_storage:   functionalAllowed ? 'granted' : 'denied',
    personalization_storage: functionalAllowed ? 'granted' : 'denied',
    security_storage:        'granted'
  };
}

/**
 * Template parametrelerinden consent state objesi oluştur.
 */
function buildConsentFromParams() {
  return {
    analytics_storage:       data.analytics_storage,
    ad_storage:              data.ad_storage,
    ad_user_data:            data.ad_user_data,
    ad_personalization:      data.ad_personalization,
    functionality_storage:   data.functionality_storage,
    personalization_storage: data.personalization_storage,
    security_storage:        data.security_storage
  };
}

/**
 * DataLayer'a consent durumunu push et.
 */
function pushToDataLayer(consentState, command) {
  if (!data.enableDataLayerEvent) return;

  callInWindow('dataLayer.push', {
    event: 'veribenim_consent_update',
    veribenim_consent_command: command,
    veribenim_consent_state: consentState
  });
}

// ── MAIN LOGIC ─────────────────────────────────────────────────────────────

if (data.consentCommand === 'default') {
  // ── DEFAULT: Sayfa yüklenirken başlangıç değerlerini ayarla ──

  let consentState = buildConsentFromParams();

  // Otomatik okuma aktifse, localStorage'dan consent al.
  // buildConsentFromStorage kategori bazında hem ilk ziyaret
  // (is_enabled_by_default) hem de kayıtlı kullanıcı tercihlerini çözer.
  if (data.autoReadConsent) {
    const sessionData = readVeribenimConsent();
    const storedConsent = buildConsentFromStorage(sessionData);
    if (storedConsent) consentState = storedConsent;
  }

  // wait_for_update ekle
  consentState.wait_for_update = makeNumber(data.waitForUpdate) || 500;

  // Region filtresi
  if (data.regions) {
    const regionList = makeString(data.regions).split(',');
    const trimmed = [];
    for (let r = 0; r < regionList.length; r++) {
      const val = makeString(regionList[r]).trim();
      if (val) trimmed.push(val);
    }
    if (trimmed.length > 0) {
      consentState.region = trimmed;
    }
  }

  setDefaultConsentState(consentState);

  log('Veribenim GTM: Default consent set', consentState);
  pushToDataLayer(consentState, 'default');

  // ── Advanced settings ──
  if (data.urlPassthrough) {
    gtagSet('url_passthrough', true);
  }
  if (data.adsDataRedaction) {
    gtagSet('ads_data_redaction', true);
  }

  // ── Veribenim consent değişiklik dinleyicisi ──
  // Bundle, consent değiştiğinde window.__vbn_gtm_onConsentChange callback'ini
  // çağırır. Bu callback GTM updateConsentState ile senkronize eder.
  function applyConsentUpdate(newConsentState) {
    if (!newConsentState) return;

    updateConsentState({
      analytics_storage:       newConsentState.analytics_storage       || 'denied',
      ad_storage:              newConsentState.ad_storage              || 'denied',
      ad_user_data:            newConsentState.ad_user_data            || 'denied',
      ad_personalization:      newConsentState.ad_personalization      || 'denied',
      functionality_storage:   newConsentState.functionality_storage   || 'denied',
      personalization_storage: newConsentState.personalization_storage || 'denied',
      security_storage:        'granted'
    });

    log('Veribenim GTM: Consent updated via listener', newConsentState);
    pushToDataLayer(newConsentState, 'update');
  }

  setInWindow('__vbn_gtm_onConsentChange', applyConsentUpdate, true);

  // Handshake: Bundle, GTM bu callback'i kaydetmeden ÖNCE consent değiştirmiş
  // olabilir (yarış durumu). Bu durumda bundle son durumu
  // window.__vbn_gtm_pendingConsent içine yazar; varsa hemen uygula.
  if (data.autoReadConsent) {
    const pending = copyFromWindow('__vbn_gtm_pendingConsent');
    if (pending) {
      applyConsentUpdate(pending);
    } else {
      // Kullanıcı zaten tercih yapmışsa (lastInteraction), kayıtlı durumu uygula.
      const session = readVeribenimConsent();
      if (session && session.lastInteraction) {
        const already = buildConsentFromStorage(session);
        if (already) applyConsentUpdate(already);
      }
    }
  }

} else if (data.consentCommand === 'update') {
  // ── UPDATE: Kullanıcı tercihini değiştirdiğinde ──

  let consentState = buildConsentFromParams();

  if (data.autoReadConsent) {
    const sessionData = readVeribenimConsent();
    const storedConsent = buildConsentFromStorage(sessionData);
    if (storedConsent) consentState = storedConsent;
  }

  updateConsentState(consentState);

  log('Veribenim GTM: Consent updated', consentState);
  pushToDataLayer(consentState, 'update');
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "vpiId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "vpiId": "2"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__vbn_cookieCategories"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__vbn_gtm_pendingConsent"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "__vbn_gtm_onConsentChange"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "localStorage.getItem"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "dataLayer.push"
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "write_data_layer",
        "vpiId": "3"
      },
      "param": [
        {
          "key": "allowedKeys",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "veribenim_consent_update"
              },
              {
                "type": 1,
                "string": "veribenim_consent_command"
              },
              {
                "type": 1,
                "string": "veribenim_consent_state"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_consent",
        "vpiId": "4"
      },
      "param": [
        {
          "key": "consentTypes",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "analytics_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_user_data"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "ad_personalization"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "functionality_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "personalization_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "consentType"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "security_storage"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Default consent - all denied
  code: |-
    const mockData = {
      consentCommand: 'default',
      waitForUpdate: 500,
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      autoReadConsent: false,
      regions: '',
      urlPassthrough: true,
      adsDataRedaction: true,
      enableDataLayerEvent: false
    };

    runCode(mockData);

    assertApi('setDefaultConsentState').wasCalledWith({
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500
    });
    assertApi('gtagSet').wasCalledWith('url_passthrough', true);
    assertApi('gtagSet').wasCalledWith('ads_data_redaction', true);
    assertApi('gtmOnSuccess').wasCalled();

- name: Default consent - with region
  code: |-
    const mockData = {
      consentCommand: 'default',
      waitForUpdate: 500,
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      autoReadConsent: false,
      regions: 'TR,DE,FR',
      urlPassthrough: false,
      adsDataRedaction: false,
      enableDataLayerEvent: false
    };

    runCode(mockData);

    assertApi('setDefaultConsentState').wasCalledWith({
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500,
      region: ['TR', 'DE', 'FR']
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Update consent - manual granted
  code: |-
    const mockData = {
      consentCommand: 'update',
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'granted',
      personalization_storage: 'granted',
      security_storage: 'granted',
      autoReadConsent: false,
      enableDataLayerEvent: false
    };

    runCode(mockData);

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'granted',
      personalization_storage: 'granted',
      security_storage: 'granted'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Default consent - auto-read from storage (user interacted)
  code: |-
    const mockData = {
      consentCommand: 'default',
      waitForUpdate: 500,
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      autoReadConsent: true,
      regions: '',
      urlPassthrough: false,
      adsDataRedaction: false,
      enableDataLayerEvent: false
    };

    const storage = '{"consents":{"ga":true,"fb":false},"lastInteraction":"2026-06-01"}';
    const categories = [
      { id: 'analytics', cookies: [ { id: 'ga' } ] },
      { id: 'marketing', cookies: [ { id: 'fb' } ] }
    ];

    mock('callInWindow', function(path) {
      if (path === 'localStorage.getItem') return storage;
      return undefined;
    });
    mock('copyFromWindow', function(key) {
      if (key === '__vbn_cookieCategories') return categories;
      return undefined;
    });

    runCode(mockData);

    assertApi('setDefaultConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: Update consent - auto-read from storage
  code: |-
    const mockData = {
      consentCommand: 'update',
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      autoReadConsent: true,
      enableDataLayerEvent: false
    };

    const storage = '{"consents":{"ga":true,"fb":true},"lastInteraction":"2026-06-01"}';
    const categories = [
      { id: 'analytics', cookies: [ { id: 'ga' } ] },
      { id: 'marketing', cookies: [ { id: 'fb' } ] }
    ];

    mock('callInWindow', function(path) {
      if (path === 'localStorage.getItem') return storage;
      return undefined;
    });
    mock('copyFromWindow', function(key) {
      if (key === '__vbn_cookieCategories') return categories;
      return undefined;
    });

    runCode(mockData);

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted'
    });
    assertApi('gtmOnSuccess').wasCalled();

- name: DataLayer event pushed on default
  code: |-
    const mockData = {
      consentCommand: 'default',
      waitForUpdate: 500,
      analytics_storage: 'denied',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      autoReadConsent: false,
      regions: '',
      urlPassthrough: false,
      adsDataRedaction: false,
      enableDataLayerEvent: true
    };

    let pushedEvent;
    mock('callInWindow', function(path, obj) {
      if (path === 'dataLayer.push') pushedEvent = obj;
      return undefined;
    });

    runCode(mockData);

    assertThat(pushedEvent).isDefined();
    assertThat(pushedEvent.event).isEqualTo('veribenim_consent_update');
    assertThat(pushedEvent.veribenim_consent_command).isEqualTo('default');
    assertApi('gtmOnSuccess').wasCalled();
