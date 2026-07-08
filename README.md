<div align="center">

# 🔒 Latchly

### Lock any app behind your PIN.

Pick the apps that matter and Latchly guards them with a PIN, pattern position, or fingerprint — with focus schedules and an intruder log, all offline.

![License](https://img.shields.io/badge/License-MIT-D97706?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Android-D97706?style=flat-square&logo=android)
![Built with Flutter](https://img.shields.io/badge/Built%20with-Flutter-027DFD?style=flat-square&logo=flutter)
![Privacy](https://img.shields.io/badge/Data-Offline%20%26%20Encrypted-FBBF24?style=flat-square)
![Trackers](https://img.shields.io/badge/Trackers-0-FBBF24?style=flat-square)

</div>

> ### 🔒 Private by design
> Latchly runs **completely offline**. Your lock settings and any intruder photos are **encrypted on your device and never leave it** — no account, no cloud, no servers, no tracking.

Most app lockers ask for sign-ups, show ads, or phone home with the list of apps you hide. Latchly doesn't have servers. Everything — which apps you lock, your schedules, your PIN verifier, intruder snapshots — stays on your phone, encrypted.

## ✨ Features

**Lock what matters**
- Pick any installed app from a searchable list with icons and lock it behind your **PIN or fingerprint**
- **Lock newly installed apps automatically**
- Choose exactly when apps relock: **the moment you leave**, after **1 / 5 / 15 / 30 min**, or **when the screen turns off**

**Focus Schedules** ⭐
- Lock a chosen set of apps during **time windows** — e.g. social apps 9-5 on weekdays, games during study time
- Weekday sets, overnight windows, and all-day rules — enforced automatically by the background guard

**Stay in control**
- **Intruder log** — after too many wrong attempts, Latchly silently snaps a front-camera photo and logs the time and app
- **Anti-shoulder-surfing** — optional randomized keypad and a masked PIN
- Escalating **cooldown** after repeated wrong guesses
- Optional **decoy cover** — show a fake "app has stopped" dialog; a long-press reveals the real unlock

**Yours to keep**
- **Encrypted backup & restore** (`.ltbackup`) protected by a passphrase of your choosing
- Change your PIN, toggle fingerprint unlock, and manage everything from Settings

## 🧠 How it works

Latchly uses the standard, Play-acceptable technique for cross-app locking — **Usage Access + an overlay**, never an accessibility service:

1. A lightweight **foreground service** watches which app is in the foreground using Android's `UsageStatsManager` (polling recent usage events).
2. When a **locked** app comes to the front and isn't in an unlocked session (per your relock policy and schedules), Latchly launches a native **lock screen** over it.
3. The lock screen verifies your PIN against a stored **verifier hash** (never the raw PIN) entirely on-device, or accepts your **fingerprint**, then lets you through.
4. A **boot receiver** restarts the guard after a reboot.

The main app (app picker, schedules, settings, onboarding) is Flutter with the shared Secure Suite design system; the on-top lock screen is native Kotlin for reliability.

> **Note:** Cross-app locking is **Android-only by platform design** — iOS does not allow one app to lock another. Real lock behavior requires granting the permissions below on a **physical device**; it cannot be exercised in an emulator or automated test.

## 🔒 Privacy & Security

- **Offline-only.** No network code, nothing to leak.
- **Your PIN is never stored.** Latchly keeps only a salted **PBKDF2-HMAC-SHA256** verifier hash. The same algorithm runs in Dart and in native Kotlin so the lock screen can check your PIN offline, byte-for-byte identically.
- **Encrypted at rest.** Your full config (locked apps, schedules, settings) is encrypted with **AES-256-GCM** under a random key held in Android's hardware-backed Keystore (`flutter_secure_storage`). The subset the native guard needs lives in **EncryptedSharedPreferences**.
- **Intruder photos stay on the device**, in app-private storage, and can be deleted any time.
- **Encrypted backups.** `.ltbackup` files are encrypted with a separate passphrase (Argon2id-derived key) — a backup file alone is useless to anyone else.
- **No accounts, no telemetry, no ads.**

## 🔑 Permissions — and why

Latchly asks only for what cross-app locking genuinely needs, and explains each in-app on a guided checklist:

| Permission | Why it's needed |
| --- | --- |
| **Usage access** (`PACKAGE_USAGE_STATS`) | To detect which app is in the foreground so a locked app can be caught. This is the standard, non-accessibility way to do app-lock. |
| **Display over other apps** (`SYSTEM_ALERT_WINDOW`) | To show the lock screen on top of a locked app, and to launch it reliably from the background on modern Android. |
| **Foreground service** (`FOREGROUND_SERVICE` / `_SPECIAL_USE`) | To keep the guard running with an ongoing notification. |
| **Notifications** (`POST_NOTIFICATIONS`) | To show the ongoing "protection active" notice (Android 13+). |
| **Ignore battery optimization** | Optional, but keeps the guard alive in the background on aggressive OEM ROMs. |
| **Camera** | Optional — only used for silent intruder snapshots if you enable that feature. |
| **Run at boot** (`RECEIVE_BOOT_COMPLETED`) | To restart protection after the phone restarts. |
| **Query all packages** (`QUERY_ALL_PACKAGES`) | To list the launchable apps you can choose to lock. Latchly reads labels/icons/package names **locally only**; nothing about your installed apps ever leaves the device. |

## 🚀 Getting Started

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install) (matching this repo's channel) and Android Studio.

```sh
# 1. Clone
git clone https://github.com/MalicKAbdullah/latchly.git
cd latchly

# 2. Install dependencies
flutter pub get

# 3. Run on a connected Android device (recommended over an emulator)
flutter run
```

> Locally, the shared `core_*` packages are wired as **path dependencies** to `../../packages`. At publish time they point at the [secure-suite-core](https://github.com/MalicKAbdullah/secure-suite-core) git repository, like the other suite apps.

**Build a debug/release APK:**

```sh
flutter build apk --debug
flutter build apk --release
```

Run the checks the way CI does:

```sh
flutter analyze
flutter test
```

**App icon:** a launcher icon can be dropped into `assets/icon/` and wired up with `flutter_launcher_icons` later; the current build ships the default adaptive icon.

## 🧱 Built With

- **Flutter** & **Dart** — the app UI, config, schedules, and all the pure-Dart lock logic
- **Kotlin** — the foreground monitor service, native lock activity, and boot receiver
- **Riverpod** (state) · **go_router** (navigation) · **local_auth** / AndroidX **BiometricPrompt** (fingerprint) · **UsageStatsManager** + overlay (enforcement)
- [**secure-suite-core**](https://github.com/MalicKAbdullah/secure-suite-core) — shared encryption, storage & design system

## 📄 License

[MIT](LICENSE) © 2026 Abdullah Malik — part of the [Secure Suite](https://github.com/MalicKAbdullah/secure-suite-core).
