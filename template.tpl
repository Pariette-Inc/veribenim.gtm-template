___INFO___

{
  "type": "TAG",
  "id": "cvt_veribenim_consent_mode",
  "version": 1,
  "securityGroups": [],
  "displayName": "Veribenim Consent Mode",
  "categories": [
    "TAG_MANAGEMENT",
    "UTILITY"
  ],
  "brand": {
    "id": "brand_veribenim",
    "displayName": "Veribenim",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPj/HwADBwIAMCbHYQAAAABJRU5ErkJggg=="
  },
  "description": "Sends the choices visitors make in the Veribenim cookie banner to Google consent mode v2. Sets default consent states (optionally per region) and updates them whenever the banner reports a decision. Requires the Veribenim banner script on the page. Setup guide: https://github.com/Pariette-Inc/veribenim.gtm-template#readme",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "consentCommand",
    "displayName": "Consent command",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "default",
        "displayValue": "Default"
      },
      {
        "value": "update",
        "displayValue": "Update"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "default",
    "help": "<strong>Default</strong> sets the initial consent states and listens for the Veribenim banner. Fire it on the <strong>Consent Initialization - All Pages</strong> trigger.<br><strong>Update</strong> applies the <em>vbn_consent</em> value that the banner pushes to the data layer. Fire it on a custom event trigger for <em>vbn_consent_update</em>."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "defaultSettings",
    "displayName": "Default consent settings",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Region (leave blank to apply globally)",
        "name": "region",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Granted consent types (comma separated)",
        "name": "granted",
        "type": "TEXT"
      },
      {
        "defaultValue": "ad_storage,analytics_storage,ad_user_data,ad_personalization,functionality_storage,personalization_storage",
        "displayName": "Denied consent types (comma separated)",
        "name": "denied",
        "type": "TEXT"
      }
    ],
    "newRowButtonText": "Add region",
    "help": "One row per region. Region uses ISO 3166-2 codes, for example <em>TR, DE, US-CA</em>. A row with a blank region applies to every region without its own row; the most specific region wins.<br>Consent types: ad_storage, analytics_storage, ad_user_data, ad_personalization, functionality_storage, personalization_storage. Types you don't list aren't set. Unknown names are ignored. <em>security_storage</em> is always granted and can't be denied.",
    "enablingConditions": [
      {
        "paramName": "consentCommand",
        "paramValue": "default",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "waitForUpdate",
    "displayName": "Wait for update (milliseconds)",
    "simpleValueType": true,
    "defaultValue": "500",
    "valueValidators": [
      {
        "type": "NON_NEGATIVE_NUMBER"
      }
    ],
    "help": "How long Google tags wait for an update before using the defaults. Example: <em>500</em>. An invalid value falls back to 500.",
    "enablingConditions": [
      {
        "paramName": "consentCommand",
        "paramValue": "default",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "adsDataRedaction",
    "checkboxText": "Redact ads data when ad_storage is denied",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "Sets <em>ads_data_redaction</em>. When ad_storage is denied, ad click identifiers in Google Ads and Floodlight requests are redacted. The Veribenim banner script always turns this on as well.",
    "enablingConditions": [
      {
        "paramName": "consentCommand",
        "paramValue": "default",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "CHECKBOX",
    "name": "urlPassthrough",
    "checkboxText": "Pass ad click information through URLs",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Sets <em>url_passthrough</em>. Click identifiers (gclid, dclid, wbraid) are added to internal links while storage is denied. Off by default; match the URL passthrough setting of your Veribenim site.",
    "enablingConditions": [
      {
        "paramName": "consentCommand",
        "paramValue": "default",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Veribenim Consent Mode — Google Tag Manager community template.
// https://veribenim.com
//
// Contract with the Veribenim banner script (bundle):
//   - window.__vbn_cookieCategories  set by the bundle as soon as it runs;
//                                    used here only to tell whether the
//                                    banner loaded.
//   - window.__vbn_gtm_onConsentChange(payload)
//                                    registered by this template; the bundle
//                                    calls it on every decision and on every
//                                    restored decision.
//   - dataLayer event 'vbn_consent_update' with 'vbn_consent' (the same
//     payload) and 'vbn_consent_source' ('user' | 'restored').
//   payload = { analytics_storage, ad_storage, ad_user_data,
//               ad_personalization, functionality_storage,
//               personalization_storage } each 'granted' | 'denied'.
//
// Rules:
//   1. Missing keys are never filled in. Only the keys the banner sent are
//      updated.
//   2. Values other than 'granted' / 'denied' are ignored.
//   3. If the banner did not load, the tag fails (after the defaults are set,
//      so visitors are still not tracked without consent).
//   security_storage is never denied.

const setDefaultConsentState = require('setDefaultConsentState');
const updateConsentState = require('updateConsentState');
const gtagSet = require('gtagSet');
const copyFromWindow = require('copyFromWindow');
const setInWindow = require('setInWindow');
const copyFromDataLayer = require('copyFromDataLayer');
const getType = require('getType');
const makeNumber = require('makeNumber');
const makeString = require('makeString');
const log = require('logToConsole');

const CONSENT_TYPES = [
  'ad_storage',
  'analytics_storage',
  'ad_user_data',
  'ad_personalization',
  'functionality_storage',
  'personalization_storage',
  'security_storage'
];
const DEFAULT_WAIT_FOR_UPDATE = 500;
const LOG_PREFIX = 'Veribenim Consent Mode:';

function isConsentType(type) {
  return CONSENT_TYPES.indexOf(type) >= 0;
}

function splitList(value) {
  const out = [];
  if (value === undefined || value === null) return out;
  const parts = makeString(value).split(',');
  for (let i = 0; i < parts.length; i++) {
    const item = parts[i].trim();
    if (item) out.push(item);
  }
  return out;
}

// Banner payload -> consent update. Keeps only known consent types with a
// valid value; never fills in a missing key; never denies security_storage.
// Returns undefined when nothing valid is left.
function sanitizeUpdate(payload) {
  if (getType(payload) !== 'object') return undefined;
  const out = {};
  let count = 0;
  for (let i = 0; i < CONSENT_TYPES.length; i++) {
    const type = CONSENT_TYPES[i];
    const value = payload[type];
    if (value === undefined) continue;
    if (value !== 'granted' && value !== 'denied') {
      log(LOG_PREFIX, 'ignored invalid value for ' + type + ':', value);
      continue;
    }
    if (type === 'security_storage' && value === 'denied') {
      log(LOG_PREFIX, 'ignored security_storage: denied (security storage is never denied)');
      continue;
    }
    out[type] = value;
    count++;
  }
  return count > 0 ? out : undefined;
}

function applyUpdate(payload, origin) {
  const update = sanitizeUpdate(payload);
  if (!update) {
    log(LOG_PREFIX, 'no valid consent values from ' + origin + ', nothing updated');
    return false;
  }
  updateConsentState(update);
  log(LOG_PREFIX, 'consent updated from ' + origin, update);
  return true;
}

function waitForUpdate() {
  const raw = data.waitForUpdate;
  if (raw === undefined || raw === null || raw === '') return DEFAULT_WAIT_FOR_UPDATE;
  const ms = makeNumber(raw);
  if (ms !== ms || ms < 0) return DEFAULT_WAIT_FOR_UPDATE;
  return ms;
}

// One table row -> one setDefaultConsentState call.
function buildDefault(row, wait) {
  const state = {};
  const granted = splitList(row.granted);
  const denied = splitList(row.denied);

  for (let i = 0; i < granted.length; i++) {
    if (isConsentType(granted[i])) {
      state[granted[i]] = 'granted';
    } else {
      log(LOG_PREFIX, 'ignored unknown consent type:', granted[i]);
    }
  }
  for (let j = 0; j < denied.length; j++) {
    const type = denied[j];
    if (!isConsentType(type)) {
      log(LOG_PREFIX, 'ignored unknown consent type:', type);
    } else if (type === 'security_storage') {
      log(LOG_PREFIX, 'ignored security_storage in denied list (security storage is never denied)');
    } else {
      // Listed in both columns: denied wins.
      state[type] = 'denied';
    }
  }
  state.security_storage = 'granted';
  state.wait_for_update = wait;

  const regions = splitList(row.region);
  if (regions.length > 0) state.region = regions;
  return state;
}

function runDefault() {
  const rows = getType(data.defaultSettings) === 'array' ? data.defaultSettings : [];
  const wait = waitForUpdate();
  let configured = false;

  for (let i = 0; i < rows.length; i++) {
    if (getType(rows[i]) !== 'object') continue;
    const state = buildDefault(rows[i], wait);
    setDefaultConsentState(state);
    configured = true;
    log(LOG_PREFIX, 'default consent set', state);
  }

  if (data.adsDataRedaction === true) {
    gtagSet({ ads_data_redaction: true });
  }
  if (data.urlPassthrough === true) {
    gtagSet({ url_passthrough: true });
  }

  // The banner calls this on every decision and every restored decision.
  setInWindow('__vbn_gtm_onConsentChange', function(payload) {
    applyUpdate(payload, 'banner');
  }, true);

  // A restored decision may already be in the data layer: the banner script
  // runs before the container and pushes 'vbn_consent_update' before this
  // callback exists.
  const restored = copyFromDataLayer('vbn_consent');
  if (restored !== undefined) applyUpdate(restored, 'data layer');

  if (!configured) {
    log(LOG_PREFIX, 'no default consent rows configured');
    return false;
  }

  const categories = copyFromWindow('__vbn_cookieCategories');
  if (getType(categories) !== 'array') {
    log(LOG_PREFIX, 'Veribenim banner script not found. Load it before the GTM container snippet, without async.');
    return false;
  }
  return true;
}

function runUpdate() {
  return applyUpdate(copyFromDataLayer('vbn_consent'), 'data layer');
}

const ok = data.consentCommand === 'update' ? runUpdate() : runDefault();

if (ok) {
  data.gtmOnSuccess();
} else {
  data.gtmOnFailure();
}


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
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
        "versionId": "1"
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
        "publicId": "read_data_layer",
        "versionId": "1"
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
                "string": "vbn_consent"
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
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "ads_data_redaction"
              },
              {
                "type": 1,
                "string": "url_passthrough"
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
        "versionId": "1"
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
  }
]


___TESTS___

scenarios:
- name: Default - global row sets denied defaults and security_storage granted
  code: |-
    runCode(baseData());

    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied',
      analytics_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500
    });
    assertApi('gtagSet').wasCalledWith({ ads_data_redaction: true });
    assertApi('gtagSet').wasNotCalledWith({ url_passthrough: true });
    assertApi('updateConsentState').wasNotCalled();
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();
- name: Default - one call per region row, region list trimmed
  code: |-
    const d = baseData();
    d.waitForUpdate = '2000';
    d.defaultSettings = [
      { region: ' TR, DE ,FR ', granted: '', denied: 'ad_storage,analytics_storage,ad_user_data,ad_personalization' },
      { region: '', granted: 'ad_storage,analytics_storage', denied: 'ad_user_data,ad_personalization' }
    ];
    runCode(d);

    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied',
      analytics_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      security_storage: 'granted',
      wait_for_update: 2000,
      region: ['TR', 'DE', 'FR']
    });
    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'granted',
      analytics_storage: 'granted',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      security_storage: 'granted',
      wait_for_update: 2000
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Default - unknown types ignored, security_storage never denied, denied wins
  code: |-
    const d = baseData();
    d.defaultSettings = [
      { region: '', granted: 'analytics_storage,foo_storage', denied: 'analytics_storage,security_storage,bar' }
    ];
    runCode(d);

    assertApi('setDefaultConsentState').wasCalledWith({
      analytics_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Default - url_passthrough only when enabled, invalid wait falls back to 500
  code: |-
    const d = baseData();
    d.urlPassthrough = true;
    d.adsDataRedaction = false;
    d.waitForUpdate = 'abc';
    d.defaultSettings = [ { region: '', granted: '', denied: 'ad_storage' } ];
    runCode(d);

    assertApi('gtagSet').wasCalledWith({ url_passthrough: true });
    assertApi('gtagSet').wasNotCalledWith({ ads_data_redaction: true });
    assertApi('setDefaultConsentState').wasCalledWith({
      ad_storage: 'denied',
      security_storage: 'granted',
      wait_for_update: 500
    });
- name: Default - banner callback updates exactly the keys it receives
  code: |-
    runCode(baseData());

    assertThat(callbacks.__vbn_gtm_onConsentChange).isFunction();
    callbacks.__vbn_gtm_onConsentChange({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    });

    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    });
- name: Default - missing keys in banner payload are not filled in
  code: |-
    runCode(baseData());

    callbacks.__vbn_gtm_onConsentChange({ analytics_storage: 'granted' });

    assertApi('updateConsentState').wasCalledWith({ analytics_storage: 'granted' });
    assertApi('updateConsentState').wasNotCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'denied',
      ad_user_data: 'denied',
      ad_personalization: 'denied',
      functionality_storage: 'denied',
      personalization_storage: 'denied',
      security_storage: 'granted'
    });
- name: Default - invalid values in banner payload are ignored
  code: |-
    runCode(baseData());

    callbacks.__vbn_gtm_onConsentChange({
      analytics_storage: 'yes',
      ad_storage: 'denied',
      ad_user_data: true,
      security_storage: 'denied',
      unknown_storage: 'granted'
    });
    assertApi('updateConsentState').wasCalledWith({ ad_storage: 'denied' });
- name: Default - payload with no valid values does not update
  code: |-
    runCode(baseData());

    callbacks.__vbn_gtm_onConsentChange({ analytics_storage: 'maybe' });
    callbacks.__vbn_gtm_onConsentChange(undefined);
    callbacks.__vbn_gtm_onConsentChange('granted');
    assertApi('updateConsentState').wasNotCalled();
- name: Default - restored consent already in data layer is applied
  code: |-
    dataLayerValues.vbn_consent = {
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'denied',
      personalization_storage: 'denied'
    };
    runCode(baseData());

    assertApi('setDefaultConsentState').wasCalled();
    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'granted',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'granted',
      functionality_storage: 'denied',
      personalization_storage: 'denied'
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Default - banner not loaded fails the tag but keeps defaults and callback
  code: |-
    windowValues.__vbn_cookieCategories = undefined;
    runCode(baseData());

    assertApi('setDefaultConsentState').wasCalled();
    assertThat(callbacks.__vbn_gtm_onConsentChange).isFunction();
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: Default - empty settings table fails the tag
  code: |-
    const d = baseData();
    d.defaultSettings = [];
    runCode(d);

    assertApi('setDefaultConsentState').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: Update - applies vbn_consent from the data layer
  code: |-
    dataLayerValues.vbn_consent = {
      analytics_storage: 'denied',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    };
    runCode({ consentCommand: 'update' });

    assertApi('setDefaultConsentState').wasNotCalled();
    assertApi('updateConsentState').wasCalledWith({
      analytics_storage: 'denied',
      ad_storage: 'granted',
      ad_user_data: 'granted',
      ad_personalization: 'denied',
      functionality_storage: 'granted',
      personalization_storage: 'granted'
    });
    assertApi('gtmOnSuccess').wasCalled();
- name: Update - no vbn_consent in the data layer fails the tag
  code: |-
    runCode({ consentCommand: 'update' });

    assertApi('updateConsentState').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
setup: |-
  const callbacks = {};
  const windowValues = {
    __vbn_cookieCategories: [
      { id: 'analytics', cookies: [ { id: 'ga' } ] },
      { id: 'marketing', cookies: [ { id: 'ads' } ] }
    ]
  };
  const dataLayerValues = {};

  mock('copyFromWindow', function(key) {
    return windowValues[key];
  });
  mock('setInWindow', function(key, value, overrideExisting) {
    callbacks[key] = value;
    return true;
  });
  mock('copyFromDataLayer', function(key) {
    return dataLayerValues[key];
  });

  function baseData() {
    return {
      consentCommand: 'default',
      defaultSettings: [
        {
          region: '',
          granted: '',
          denied: 'ad_storage,analytics_storage,ad_user_data,ad_personalization,functionality_storage,personalization_storage'
        }
      ],
      waitForUpdate: '500',
      urlPassthrough: false,
      adsDataRedaction: true
    };
  }
