---
title: Rahma — Privacy Policy
layout: default
---

# Rahma — Privacy Policy

**Effective Date:** May 1, 2026
**Last Updated:** April 30, 2026
**App Name:** Rahma (رحمة)
**Package:** `com.rahma.rahma_app`
**Contact:** rahmahislamic48@gmail.com

---

## Summary

Rahma is an offline-first Islamic companion app. We do not run servers, do not collect analytics, do not collect crash reports, do not show ads, and do not maintain user accounts. The only data that leaves your device is what is required to deliver the feature you actively use, as described below.

## 1. What we collect

We collect **no personal information** from you on our own infrastructure (we do not operate any).

### 1.1 Data stored locally on your device only

| Data | Purpose | Location |
|---|---|---|
| Bookmarked Quran verses | Resume reading | Device SQLite |
| Prayer time settings | Calculate your daily prayers | Device SharedPreferences |
| Manual location override (optional) | Calculate prayer times when GPS is off | Device SharedPreferences |
| Adhkar counter progress | Track daily remembrance | Device SQLite |
| Cached mosque list | Show last-fetched mosques offline | Device SQLite |

This data never leaves your device. If you uninstall the app, this data is deleted by Android.

### 1.2 Data sent to third-party services when you use specific features

| Feature you use | Service contacted | Data sent | Why |
|---|---|---|---|
| **Masjid Finder** | Overpass API (OpenStreetMap) — `overpass-api.de` | Bounding-box coordinates around your current GPS location | Query OSM for nearby mosques |
| **Quran Radio** | Cloudflare R2 — `*.r2.cloudflarestorage.com` | Standard HTTPS request (your IP, the requested file URL, User-Agent) | Stream audio file |

We do not attach any user identifier to these requests. Both endpoints are reached over HTTPS only.

### 1.3 What we do not collect

- Personal info (name, email, phone, address)
- Account credentials (no sign-in required)
- Photos, videos, files, microphone, camera
- Contacts, calendar, SMS, call logs
- Browsing history outside this app
- Device IDs, advertising IDs, fingerprints
- Crash logs (Crashlytics is **not** integrated)
- Usage analytics (Analytics is **not** integrated)
- Behavioral / location tracking history

## 2. Permissions and why we ask for them

| Android permission | When asked | Purpose | Required? |
|---|---|---|---|
| `ACCESS_COARSE_LOCATION` / `ACCESS_FINE_LOCATION` | First use of Prayer Times, Qibla, or Masjid Finder | Compute prayer times, Qibla bearing, or query nearby mosques | Optional — you can enter location manually instead |
| `POST_NOTIFICATIONS` (Android 13+) | First launch | Show prayer-time alerts | Optional — you can deny |
| `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` | Implicit | Fire prayer alarms at the exact minute | Required for accurate alarms |
| `RECEIVE_BOOT_COMPLETED` | Implicit | Re-arm prayer alarms after device reboot | Required if you use prayer alarms |
| `INTERNET` / `ACCESS_NETWORK_STATE` | Implicit | Reach Overpass + R2 only when those features are used | Required for Masjid Finder + Quran Radio only |
| `VIBRATE` | Implicit | Haptic feedback on adhkar counter | Optional |
| `WAKE_LOCK` | Implicit | Wake the device for prayer alarms | Required if you use prayer alarms |

Compass / sensor data is read directly from device hardware and never leaves the device. Reading sensors does not require a runtime permission on Android.

## 3. Children

The app is rated for ages 4+. We collect no data from anyone, including children, beyond what Section 1 describes. There is no chat, no social feature, no advertising, and no in-app purchases.

## 4. Data retention

| Data | Retention |
|---|---|
| All on-device data (bookmarks, settings, counter) | Until you clear app data or uninstall |
| Outbound queries (Overpass, R2) | Not stored by us — we operate no server. The third party's own retention policy applies (see links below). |

## 5. Third parties

| Service | Used for | Their privacy policy |
|---|---|---|
| OpenStreetMap / Overpass API | Mosque search | https://wiki.osmfoundation.org/wiki/Privacy_Policy |
| Cloudflare R2 | Audio streaming | https://www.cloudflare.com/privacypolicy/ |
| Google Play Services | App distribution + Android system | https://policies.google.com/privacy |

We do not use Firebase, Google Analytics for Firebase, AdMob, Facebook SDK, or any other tracking SDK in this app.

## 6. Your rights

Because we hold no personal data on any server, there is no account to delete, no profile to export, and no record to subject-access-request. To remove all app data from your device:

- Android: Settings → Apps → Rahma → Storage → Clear data, then Uninstall.

For questions, write to `rahmahislamic48@gmail.com`. We respond within 7 days where applicable.

## 7. Changes to this policy

We may update this policy. The current version is always served from the URL shown in the app's About screen. Substantive changes will be announced via an in-app notification on next launch.

## 8. Contact

| | |
|---|---|
| Email | rahmahislamic48@gmail.com |
| Source | https://github.com/serverax/my_campanion |
| Issues | https://github.com/serverax/my_campanion/issues |

---

*This policy describes the app as published. If you build the app from source, behavior depends on your build configuration.*
