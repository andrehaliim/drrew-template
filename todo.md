# Flutter Project Template Checklist

## 🟢 Tier 1 — Core Template (harus ada dari awal)

Ini fondasi yang dipakai di hampir 100% project, jadi worth diinvestasikan waktu paling banyak di sini.

- [ ] Splash screen — cek token/status login
- [ ] Auth flow — Login, Register, Forgot password (UI + provider/state)
- [ ] Theme system — light/dark toggle, Material 3 setup
- [ ] Navigation — go_router + bottom nav/drawer skeleton
- [ ] Networking layer — dio + interceptor (token, error handling, logging)
- [ ] Local storage — secure storage (token) + shared_preferences (settings)
- [ ] State management setup — Riverpod/Provider terstruktur rapi
- [ ] Common UI states — loading (shimmer), empty state, error state + retry, no-internet screen
- [ ] Reusable widgets — button, text field, dialog, loading indicator
- [ ] Environment/flavor config — dev/staging/prod

## 🟡 Tier 2 — Semi-core (sering dipakai, tapi bikin modular biar gampang dicabut)

Ini yang idealnya dibuat sebagai "feature module" terpisah, jadi tinggal include atau delete foldernya kalau project gak butuh.

- [ ] Onboarding/intro slider
- [ ] Edit profile & account settings
- [ ] Localization (multi-bahasa)
- [ ] Push notification (Firebase Cloud Messaging)
- [ ] Search + pagination/infinite scroll pattern
- [ ] Image picker + cropper
- [ ] Crash reporting & analytics (Crashlytics/Firebase Analytics)
- [ ] App update checker (force update)
- [ ] Rate app prompt
- [ ] Help/FAQ & contact support page

## 🔴 Tier 3 — Optional Module (plug-in sesuai jenis project)

Ini spesifik tergantung app-nya apa. Gak perlu dipaksa masuk ke template inti, tapi enak kalau kamu punya "kumpulan modul siap pakai" terpisah yang bisa di-copy-paste kapan perlu.

- [ ] Chat/messaging
- [ ] Payment gateway & cart/checkout
- [ ] Maps & location tracking/geofencing
- [ ] Social login (Google/Apple/FB)
- [ ] Biometric login
- [ ] Video player
- [ ] Multi-role/multi-akun
- [ ] SSL pinning, root/jailbreak detection (untuk app fintech/sensitif)