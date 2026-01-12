# ðŸ”§ FIX GOOGLE SIGN-IN - Spend-IQ

## âœ… Yang Sudah Diperbaiki:

1. âœ… **Google Sign-In Configuration**
   - Menambahkan scopes: `['email', 'profile']` di `FirebaseAuthDatasource`
   - File: `lib/data/datasources/auth/firebase_auth_datasource.dart`

2. âœ… **Logo & Branding**
   - Logo diubah dari `logo_smartspend.png` â†’ `logo_smarts_iq.png`
   - Nama aplikasi diubah dari "SkyVault" â†’ "Spend-IQ"
   - Update di: splash screen, chat page, AndroidManifest, iOS plist, pubspec.yaml

---

## ðŸ”‘ SHA-1 Fingerprint (Debug Keystore)

**SHA-1 untuk ditambahkan di Firebase Console:**
```
53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
```

---

## ðŸ“‹ Langkah-Langkah Fix Google Sign-In:

### 1. **Tambahkan SHA-1 ke Firebase Console**

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **"spend-iq"**
3. Klik âš™ï¸ **Settings** â†’ **Project Settings**
4. Scroll ke bawah, cari **"Your apps"** â†’ Android app (`com.ikhsan.spend_iq`)
5. Klik **"Add fingerprint"** atau **"Add SHA certificate fingerprint"**
6. Paste SHA-1 di atas:
   ```
   53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
   ```
7. Klik **"Save"**

---

### 2. **Pastikan Google Sign-In Enabled**

1. Firebase Console â†’ **Authentication** (menu kiri)
2. Tab **"Sign-in method"**
3. Cek **"Google"** â†’ Harus **Enabled** âœ…
4. Jika belum, klik **"Google"** â†’ Toggle **Enable** â†’ **Save**

---

### 3. **Verifikasi google-services.json**

Pastikan file `android/app/google-services.json` sudah ada dan benar:
- Package name: `com.ikhsan.spend_iq` âœ…
- Project ID: `spend-iq` âœ…

---

### 4. **Rebuild Aplikasi**

```powershell
flutter clean
flutter pub get
flutter build apk --split-per-abi
```

---

## ðŸ§ª Testing Google Sign-In

Setelah rebuild:

1. **Install APK** baru
2. **Buka Spend-IQ**
3. Di halaman Login, tap **"Login dengan Google"**
4. Pilih akun Google
5. âœ… **Harus berhasil!**

---

## ðŸ› Troubleshooting

### Error: `PlatformException(sign_in_failed)`
**Solusi:**
- Pastikan SHA-1 sudah ditambahkan di Firebase Console
- Pastikan `google-services.json` ada di `android/app/`
- Rebuild dengan `flutter clean`

### Error: `API key not valid`
**Solusi:**
- Cek `google-services.json` â†’ pastikan API key valid
- Pastikan package name match: `com.ikhsan.spend_iq`

### Error: `Network error`
**Solusi:**
- Pastikan HP/emulator ada koneksi internet
- Coba restart emulator/device

---

## âœ… Checklist

- [x] Google Sign-In scopes ditambahkan (`email`, `profile`)
- [x] SHA-1 fingerprint sudah didapat
- [ ] SHA-1 ditambahkan di Firebase Console â† **LANGKAH INI HARUS DILAKUKAN!**
- [x] Google Sign-In enabled di Firebase Console
- [x] `google-services.json` sudah ada
- [x] Logo & branding diupdate ke Spend-IQ
- [ ] APK rebuild dengan perubahan baru

---

**Â© 2025 Spend-IQ - Smart Financial Intelligence ðŸ§ **








