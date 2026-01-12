# 🚀 QUICK START - Firebase Setup untuk Google Sign-In

## ⚡ 3 Langkah Cepat

### 1️⃣ Buat Firebase Project & Download Config

1. Buka: https://console.firebase.google.com/
2. **Add Project** → Nama: `skyvault-app`
3. **Add Android App**:
   - Package: `com.example.smartspend_ai`
   - Get SHA-1: Jalankan di terminal:
     ```powershell
     cd android
     .\gradlew signingReport
     ```
     Copy SHA-1 yang muncul (format: `AB:CD:EF:12:...`)
4. **Download google-services.json**
5. **Paste file** ke: `android/app/google-services.json`

### 2️⃣ Aktifkan Google Sign-In

1. Firebase Console → **Authentication**
2. **Sign-in method** tab
3. Enable **Google** ✅
4. Pilih support email
5. **Save**

### 3️⃣ Rebuild & Test

```powershell
flutter clean
flutter pub get
flutter build apk --split-per-abi
```

Install APK → Test **"Login dengan Google"** ✅

---

## 📸 Screenshots Langkah-Langkah

### Get SHA-1:
```powershell
cd android
.\gradlew signingReport
```

Output:
```
Variant: debug
Config: debug
Store: C:\Users\...\debug.keystore
Alias: AndroidDebugKey
MD5: 12:34:56:...
SHA1: AB:CD:EF:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:12  ← COPY INI
SHA-256: ...
```

### Struktur File Setelah Setup:
```
android/
└── app/
    ├── google-services.json  ✅ HARUS ADA
    ├── build.gradle.kts
    └── src/
```

---

## ❌ Troubleshooting

### Error: "API not enabled"
→ **Solusi:** Enable Google Sign-In di Firebase Console → Authentication

### Error: "SHA-1 mismatch"
→ **Solusi:** Tambahkan SHA-1 debug ke Firebase Project Settings

### Login cancelled atau return null
→ **Solusi:** 
1. Pastikan emulator ada Google Play Services
2. Atau test di real device

---

## 📄 Dokumentasi Lengkap

Lihat: **`SETUP_GOOGLE_SIGNIN.md`** untuk panduan detail

---

**© 2025 SkyVault 🔒**







