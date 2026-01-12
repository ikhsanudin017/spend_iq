# 🔥 FIREBASE SETUP - SPEND-IQ
## Panduan Setup Firebase untuk SkyVault

---

## ✅ Step 1: Firebase Project (DONE)
- ✅ Project Name: **spend-iq**
- ✅ Project sudah dibuat

---

## 📱 Step 2: Add Android App

### Di Firebase Console (https://console.firebase.google.com/):

1. Pilih project **"spend-iq"**
2. Klik ⚙️ (Settings) → **Project Settings**
3. Scroll ke **Your apps** → Klik icon **Android** (robot)
4. Isi form:

```
Android package name: com.example.smartspend_ai
App nickname (optional): SkyVault
Debug signing certificate SHA-1: 53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
```

**⚠️ PENTING: Copy SHA-1 di atas PERSIS seperti itu!**

5. Klik **"Register app"**

---

## 📥 Step 3: Download Config File

1. Firebase akan muncul tombol **"Download google-services.json"**
2. **DOWNLOAD** file tersebut
3. **COPY** file ke folder:
   ```
   D:\PROJECT\SmartSpend\smartspend_ai\android\app\google-services.json
   ```

### Struktur folder harus seperti ini:
```
android/
└── app/
    ├── google-services.json  ← PASTE DI SINI
    ├── build.gradle.kts
    └── src/
```

---

## 🔑 Step 4: Enable Google Sign-In

1. Di Firebase Console (project spend-iq)
2. Menu kiri → **Authentication**
3. Tab **"Sign-in method"**
4. Cari **"Google"** → Klik
5. Toggle **Enable** → **ON** ✅
6. **Support email**: [PILIH EMAIL ANDA]
7. Klik **"Save"**

---

## 🔧 Step 5: Rebuild APK

Setelah semua step di atas selesai, rebuild aplikasi:

```powershell
flutter clean
flutter pub get
flutter build apk --split-per-abi
```

---

## ✅ Checklist

Pastikan semua ini sudah dilakukan:

- [ ] Firebase project "spend-iq" sudah dibuat
- [ ] Android app sudah ditambahkan dengan package name `com.example.smartspend_ai`
- [ ] SHA-1 sudah ditambahkan: `53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07`
- [ ] File `google-services.json` sudah di-download
- [ ] File `google-services.json` sudah di-paste ke `android/app/`
- [ ] Google Sign-In sudah di-enable di Firebase Console
- [ ] Aplikasi sudah di-rebuild dengan `flutter build apk`

---

## 🧪 Testing

Setelah rebuild:

1. Install APK yang baru: `app-arm64-v8a-release.apk`
2. Buka SkyVault
3. Klik **"Login dengan Google"**
4. Pilih akun Google
5. **Expected:** Login berhasil! ✅

---

## 🐛 Troubleshooting

### Error: "API not enabled"
**Solusi:** 
- Firebase Console → Authentication
- Pastikan Google Sign-In sudah **Enabled** ✅

### Error: "Sign in failed"
**Solusi:**
- Pastikan SHA-1 sudah benar
- Pastikan `google-services.json` ada di `android/app/`
- Rebuild dengan `flutter clean` dulu

### Login cancelled atau return null
**Solusi:**
- Emulator harus ada Google Play Services
- Atau test di real device

---

## 📝 Info SHA-1

**Debug SHA-1:**
```
53:8C:19:3E:92:44:88:8E:3B:B7:B4:8D:2D:50:40:20:39:6B:24:07
```

**SHA-256 (optional):**
```
1F:E9:C0:38:6B:01:F9:D9:B7:F5:02:2A:47:BF:0C:0B:71:38:A4:22:47:3F:77:94:B8:40:04:22:2E:C8:78:F6
```

Keystore location:
```
C:\Users\Lemon Zestt\.android\debug.keystore
```

---

**© 2025 SkyVault - Firebase Ready! 🚀**







