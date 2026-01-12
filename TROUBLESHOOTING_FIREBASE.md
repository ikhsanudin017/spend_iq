# ðŸ”§ Troubleshooting Firebase & Google Sign-In

## âœ… Checklist Setup Firebase

Pastikan semua langkah ini sudah dilakukan:

### 1. **SHA-1 Fingerprint di Firebase Console** âš ï¸ PENTING!

**SHA-1 Anda:**
```
53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
```

**Cara cek apakah sudah ditambahkan:**
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project **"spend-iq"**
3. Klik âš™ï¸ **Settings** â†’ **Project Settings**
4. Scroll ke **"Your apps"** â†’ Klik Android app (`com.ikhsan.spend_iq`)
5. Lihat di bagian **"SHA certificate fingerprints"**
6. **Pastikan SHA-1 di atas sudah ada di list!**

**Jika belum ada:**
- Klik **"Add fingerprint"**
- Paste SHA-1: `53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07`
- Klik **"Save"**

---

### 2. **Google Sign-In Enabled di Firebase**

1. Firebase Console â†’ **Authentication** (menu kiri)
2. Tab **"Sign-in method"**
3. Cari **"Google"** â†’ Harus ada status **"Enabled"** (hijau) âœ…
4. Jika belum, klik **"Google"** â†’ Toggle **Enable** â†’ **Save**

---

### 3. **google-services.json Valid**

**Lokasi file:** `android/app/google-services.json`

**Cek isi file:**
- Package name: `com.ikhsan.spend_iq` âœ…
- Project ID: `spend-iq` âœ…
- SHA-1 sudah ada di file âœ…

---

### 4. **Google Services Plugin Sudah Ditambahkan**

**File:** `android/app/build.gradle.kts`

**Harus ada:**
```kotlin
plugins {
    id("com.google.gms.google-services")  // â† INI HARUS ADA!
}
```

---

### 5. **Rebuild APK Setelah Setup**

**PENTING:** Setelah menambahkan SHA-1 atau mengubah konfigurasi Firebase, **WAJIB rebuild APK**:

```powershell
flutter clean
flutter pub get
flutter build apk --release --split-per-abi
```

**Jangan install APK lama!** Install APK yang baru saja di-build.

---

## ðŸ› Masalah Umum & Solusi

### Error: "Firebase belum dikonfigurasi"

**Penyebab:**
- Firebase tidak terinisialisasi saat app start
- `google-services.json` tidak terbaca oleh Gradle

**Solusi:**
1. Pastikan Google Services plugin sudah ditambahkan (lihat checklist #4)
2. Rebuild APK dengan `flutter clean` terlebih dahulu
3. Install APK yang baru

---

### Error: "ID Token tidak tersedia"

**Penyebab:**
- SHA-1 belum ditambahkan di Firebase Console
- SHA-1 salah atau tidak match

**Solusi:**
1. Cek SHA-1 di Firebase Console (lihat checklist #1)
2. Pastikan SHA-1 yang ditambahkan sama persis dengan:
   ```
   53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
   ```
3. Setelah menambahkan SHA-1, **tunggu 5-10 menit** agar Firebase memproses
4. Rebuild dan install APK baru

---

### Error: "Login gagal. Pastikan: 1. SHA-1 sudah ditambahkan..."

**Penyebab:**
- SHA-1 belum ditambahkan
- Google Sign-In belum di-enable
- `google-services.json` tidak valid

**Solusi:**
1. Ikuti checklist #1 (SHA-1)
2. Ikuti checklist #2 (Enable Google Sign-In)
3. Verifikasi `google-services.json` (checklist #3)
4. Rebuild APK

---

### Error: "Google Sign-In belum diaktifkan di Firebase Console"

**Penyebab:**
- Google Sign-In provider belum di-enable di Firebase

**Solusi:**
1. Firebase Console â†’ Authentication â†’ Sign-in method
2. Klik **"Google"**
3. Toggle **Enable** â†’ ON
4. Pilih **Support email**
5. Klik **"Save"**

---

### Google Sign-In Dialog Tidak Muncul

**Penyebab:**
- Emulator tidak punya Google Play Services
- Device tidak punya akun Google

**Solusi:**
1. Gunakan emulator dengan **Google Play** (bukan Google APIs)
2. Atau test di **real device** yang sudah login Google account
3. Pastikan device/emulator ada koneksi internet

---

## âœ… Verifikasi Setup

### Test 1: Cek Firebase Initialization

Jalankan app dan lihat log di console:
```
âœ… Firebase initialized successfully
```

Jika muncul:
```
âš ï¸ Firebase initialization failed
```
â†’ Artinya `google-services.json` tidak terbaca. Cek Google Services plugin.

---

### Test 2: Cek Google Sign-In

1. Buka app
2. Tap "Login dengan Google"
3. **Harus muncul dialog pilih akun Google**
4. Pilih akun â†’ **Harus berhasil login**

Jika error muncul, lihat pesan error dan cocokkan dengan solusi di atas.

---

## ðŸ“‹ Quick Fix Checklist

Jika Google Sign-In masih belum bisa, cek satu per satu:

- [ ] SHA-1 sudah ditambahkan di Firebase Console
- [ ] Google Sign-In sudah di-enable di Firebase Console
- [ ] `google-services.json` ada di `android/app/`
- [ ] Google Services plugin sudah ditambahkan di `build.gradle.kts`
- [ ] Sudah rebuild APK setelah setup Firebase
- [ ] Install APK yang baru (bukan APK lama)
- [ ] Device/emulator ada koneksi internet
- [ ] Device/emulator sudah login Google account (untuk test)

---

## ðŸš€ Langkah Terakhir

Setelah semua checklist selesai:

1. **Rebuild APK:**
   ```powershell
   flutter clean
   flutter build apk --release --split-per-abi
   ```

2. **Install APK baru:**
   - Uninstall app lama (jika ada)
   - Install APK baru dari `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

3. **Test Google Sign-In:**
   - Buka app
   - Tap "Login dengan Google"
   - Harus berhasil! âœ…

---

**Â© 2025 Spend-IQ - Smart Financial Intelligence ðŸ§ **








