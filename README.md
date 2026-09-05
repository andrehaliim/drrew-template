# drrew_template

A Flutter template meant to be a starting point for new projects (Android & iOS). It already includes an auth flow, theming (light/dark), navigation, a networking layer, and reusable widgets — ready to use while learning the concepts behind it.

Paired backend: [`drrew-template-backend`](https://github.com/andrehaliim/drrew-template-backend) (FastAPI).

## ✨ Features

- **Auth** — Login, Register, Logout, silent token refresh, auto-logout on refresh failure
- **State management** — Riverpod 3
- **Navigation** — GoRouter with a reactive auth redirect
- **Networking** — Dio + interceptors (auth, token refresh, error handling, logging)
- **Storage** — `flutter_secure_storage` (tokens) + `SharedPreferences` (settings)
- **Theme** — Material 3, light/dark mode with an animated toggle
- **Reusable widgets** — text field, button, dialog, bottom nav
- **Flavors** — dev / staging / prod

## 🧰 Requirements

- [FVM](https://fvm.app/) (Flutter Version Management)
- Flutter **3.47.2** (managed via FVM)
- Android Studio / Xcode (for an emulator or a physical device)
- VS Code (recommended) with the Flutter & Dart extensions
- `drrew-template-backend` up and running (see the backend README)

## 🚀 Installation

1. **Clone the repo**

   ```bash
   git clone https://github.com/andrehaliim/drrew_template.git
   cd drrew_template
   ```

2. **Install FVM** (if you don't have it yet)

   ```bash
   dart pub global activate fvm
   ```

3. **Install Flutter 3.47.2 via FVM**

   ```bash
   fvm install 3.47.2
   fvm use 3.47.2
   ```

   This automatically picks up `.fvmrc` at the project root.

4. **Install dependencies**

   ```bash
   fvm flutter pub get
   ```

5. **Generate the `.g.dart` files** (Riverpod generator)

   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```

6. **Set the API base URL**

   The default base URL lives in `lib/config/env/env.dart`. If your backend runs on a different local IP, override it with `--dart-define=API_BASE_URL=http://YOUR_IP:8000` when running (see commands below).

7. **Plug in a physical device / start an emulator**, then confirm it's detected:

   ```bash
   fvm flutter devices
   ```

## ▶️ Run Commands

This project uses 3 environments: **dev**, **staging**, and **prod** — each with its own entry point (`main_dev.dart`, `main_staging.dart`, `main_prod.dart`) and its own Android flavor.

### Development

```bash
fvm flutter run -t lib/main_dev.dart --flavor dev --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://192.168.6.138:8000
```

### Staging

```bash
fvm flutter run -t lib/main_staging.dart --flavor staging --dart-define=FLAVOR=staging --dart-define=API_BASE_URL=https://staging-api.example.com
```

### Production

```bash
fvm flutter run -t lib/main_prod.dart --flavor prod --dart-define=FLAVOR=prod --dart-define=API_BASE_URL=https://api.example.com
```

> Replace `API_BASE_URL` with your actual backend address. For release builds (not `run`), just swap `flutter run` for `flutter build apk` / `flutter build ios` with the same flags.

## 📁 Folder Structure (flat, not feature-first)

```
lib/
├── config/env/       # flavor & base URL config
├── models/           # data classes / state
├── network/          # dio client, interceptors, exceptions
├── providers/        # Riverpod providers
├── router/           # go_router config
├── screens/          # UI pages
├── theme/            # theme data
├── widgets/          # reusable widgets
├── main.dart         # bootstrap()
├── main_dev.dart
├── main_staging.dart
└── main_prod.dart
```