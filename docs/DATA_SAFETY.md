---
title: Rahma — Play Store Data Safety Form Answers
layout: default
---

# Rahma — Data Safety Form (Play Console reference)

This file lists the answers to enter in **Google Play Console → App content → Data safety**. Answers reflect the app **as currently configured** (no Firebase, no analytics, no crash reporting, no backend).

If you later add Firebase / analytics / a backend, update this file AND the Play Console form AND the privacy policy in lockstep — they must match.

---

## Step 1 — Data collection and security

### Does your app collect or share any of the required user data types?

**Answer: Yes** — only **Approximate location** and **Precise location**, only when the user actively uses Prayer Times / Qibla / Masjid Finder.

### Is all of the user data collected by your app encrypted in transit?

**Answer: Yes** (`usesCleartextTraffic="false"` is set; all outbound calls use HTTPS).

### Do you provide a way for users to request that their data is deleted?

**Answer: Yes** — uninstalling the app or "Clear data" in Android settings deletes all locally stored data. We hold no remote data on user.

---

## Step 2 — Data types

For each row below, mark only what is true. **Everything else: leave unchecked.**

### Personal info — **NONE**
- Name: ❌ No
- Email address: ❌ No
- User IDs: ❌ No
- Address: ❌ No
- Phone number: ❌ No
- Race and ethnicity: ❌ No
- Political or religious beliefs: ❌ No (the app subject is Islamic but we collect no statement of belief from the user)
- Sexual orientation: ❌ No
- Other info: ❌ No

### Financial info — **NONE**
All ❌ No.

### Health and fitness — **NONE**
All ❌ No.

### Messages — **NONE**
All ❌ No.

### Photos and videos — **NONE**
All ❌ No.

### Audio files — **NONE**
(The app *plays* Quran audio, it does **not** record or upload audio.)

### Files and docs — **NONE**

### Calendar — **NONE**

### Contacts — **NONE**

### App activity — **NONE**
- App interactions: ❌ No
- In-app search history: ❌ No
- Installed apps: ❌ No
- Other user-generated content: ❌ No
- Other actions: ❌ No

### Web browsing — **NONE**

### App info and performance — **NONE**
- Crash logs: ❌ No (no Crashlytics integration)
- Diagnostics: ❌ No
- Other performance data: ❌ No

### Device or other IDs — **NONE**
- Device or other IDs: ❌ No
- Advertising ID: ❌ No

### Location — **YES** (for Prayer Times, Qibla, Masjid Finder)

For both **Approximate location** and **Precise location**, fill:

| Question | Answer |
|---|---|
| Collected? | ✅ Yes |
| Shared with third parties? | ✅ Yes (only when user opens Masjid Finder — coordinates sent to Overpass API / OpenStreetMap) |
| Processed ephemerally? | ✅ Yes — bounding-box query is built and discarded; coordinates are not retained on any server we control (we run none) |
| Required for app to function? | ❌ No — user can opt out; manual location entry available |
| Why collected? | App functionality (prayer time calc, qibla bearing, find nearby mosques) |
| Encrypted in transit? | ✅ Yes (HTTPS) |
| Can user request deletion? | ✅ Yes (uninstall or clear app data) |

---

## Step 3 — Sensitive permissions

| Permission | Declared? | Justification on Play form |
|---|---|---|
| `ACCESS_FINE_LOCATION` | ✅ | "Calculate accurate prayer times and Qibla direction; show distance to nearby mosques. User can opt out and enter location manually." |
| `ACCESS_COARSE_LOCATION` | ✅ | Same — used as a fallback when fine location is unavailable. |
| `SCHEDULE_EXACT_ALARM` | ✅ | "Trigger prayer-time alerts at the exact prescribed minute. The app does not use this permission for any other purpose." |
| `USE_EXACT_ALARM` (Android 13+) | ✅ | Same as above. |
| `POST_NOTIFICATIONS` | ✅ | "Show prayer-time reminders." |
| `RECEIVE_BOOT_COMPLETED` | ✅ | "Re-arm prayer alarms after device reboot so users do not miss prayers." |
| `WAKE_LOCK` | ✅ | "Wake the device briefly to fire a scheduled prayer alarm." |
| `VIBRATE` | ✅ | "Haptic feedback on the adhkar counter." |
| Camera, mic, contacts, photos, SMS, call log, NFC, body sensors, accessibility services | ❌ Not declared |

---

## Step 4 — Background location declaration

**Background location: NOT requested.** The app uses location only in the foreground when a feature requests it. No `ACCESS_BACKGROUND_LOCATION` permission. The `ACCESS_BACKGROUND_LOCATION` declaration form does NOT need to be submitted.

---

## Step 5 — Ads & families policy

| | |
|---|---|
| Contains ads? | ❌ No |
| Uses Google Mobile Ads / AdMob? | ❌ No |
| Targets children? | The app is suitable for all ages including under-13. If you choose **Designed for Families**, follow the additional policy review there. |

---

## Step 6 — Privacy policy URL

Once GitHub Pages is enabled (see commit message), enter:

```
https://serverax.github.io/my_campanion/PRIVACY_POLICY
```

---

## Final checklist before submitting Data Safety form

- [ ] Privacy policy URL above is reachable in a browser (verify in incognito).
- [ ] App's actual Manifest matches what is declared here (`grep uses-permission android/app/src/main/AndroidManifest.xml`).
- [ ] If you add Firebase / analytics / a backend later, update this file, the Manifest, the privacy policy, and the Play Console form **together**. Mismatches between them are the most common cause of Play Store rejection.
