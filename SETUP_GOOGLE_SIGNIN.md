# SETUP GOOGLE SIGN-IN UNTUK SKYVAULT
## Panduan Lengkap Konfigurasi Firebase Authentication

---

## ⚠️ PENTING: Google Sign-In Memerlukan Firebase Setup

Saat ini Google Sign-In **BELUM BISA** berfungsi karena belum ada file konfigurasi Firebase. Ikuti langkah di bawah untuk mengaktifkannya.

---

## 📋 Langkah-Langkah Setup

### 1. **Buat Firebase Project**

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add Project"** atau **"Tambah Project"**
3. Nama project: `skyvault-app` (atau nama lain)
4. Aktifkan Google Analytics (opsional)
5. Tunggu project selesai dibuat

---

### 2. **Tambahkan Android App ke Firebase**

1. Di Firebase Console, klik ⚙️ (Settings) → **Project Settings**
2. Scroll ke bawah, klik **"Add app"** → Pilih **Android**
3. Isi form:
   ```
   Android package name: com.example.smartspend_ai
   App nickname: SkyVault (opsional)
   Debug signing certificate SHA-1: [LIHAT CARA DAPAT DI BAWAH]
   ```

#### Cara Dapat SHA-1 Fingerprint:

**Windows (PowerShell):**
```powershell
cd android
.\gradlew signingReport
```

Atau gunakan keytool:
```powershell
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**Output akan seperti:**
```
Certificate fingerprints:
SHA1: A1:B2:C3:D4:E5:F6:... (COPY INI)
SHA256: ...
```

4. **Paste SHA-1** ke form Firebase
5. Klik **"Register app"**

---

### 3. **Download & Install google-services.json**

1. Firebase Console akan memberikan file **`google-services.json`**
2. **Download** file tersebut
3. **Copy** file ke folder:
   ```
   android/app/google-services.json
   ```

4. Struktur folder harus seperti ini:
   ```
   android/
   ├── app/
   │   ├── google-services.json  ← TARUH DI SINI
   │   ├── build.gradle.kts
   │   └── src/
   └── build.gradle.kts
   ```

---

### 4. **Aktifkan Google Sign-In di Firebase**

1. Di Firebase Console, buka **Authentication** (menu kiri)
2. Klik tab **"Sign-in method"**
3. Klik **"Google"**
4. Toggle **"Enable"** → ON
5. Pilih **Support email** (email Anda)
6. Klik **"Save"**

---

### 5. **Aktifkan Email/Password (Opsional)**

1. Masih di **Authentication → Sign-in method**
2. Klik **"Email/Password"**
3. Toggle **"Enable"** → ON
4. Klik **"Save"**

---

### 6. **Setup Firestore (Opsional tapi Recommended)**

1. Di Firebase Console, buka **Firestore Database**
2. Klik **"Create database"**
3. Pilih **"Start in test mode"** (untuk development)
4. Pilih **region**: `asia-southeast1` (Singapore)
5. Klik **"Enable"**

---

### 7. **Rebuild Aplikasi**

Setelah `google-services.json` ditambahkan:

```powershell
flutter clean
flutter pub get
flutter build apk --split-per-abi
```

Atau untuk testing di emulator:
```powershell
flutter run -d emulator-5554
```

---

## 📱 Testing Google Sign-In

### Setelah Setup Selesai:

1. **Install APK** yang baru
2. **Buka SkyVault**
3. Di halaman Login, tap **"Login dengan Google"**
4. Pilih akun Google
5. Izinkan akses
6. ✅ **Berhasil!** Akan redirect ke Onboarding/Home

### Jika Masih Error:

#### Error: `PlatformException(sign_in_failed)`
**Solusi:**
- Pastikan SHA-1 sudah ditambahkan di Firebase Console
- Pastikan `google-services.json` sudah di folder `android/app/`
- Rebuild aplikasi dengan `flutter clean`

#### Error: `API key not valid`
**Solusi:**
- Pastikan API key di `google-services.json` valid
- Pastikan package name sama: `com.example.smartspend_ai`

#### Error: `Network error`
**Solusi:**
- Pastikan HP/emulator ada koneksi internet
- Coba restart emulator

---

## 🔐 Konfigurasi Release (Untuk Production)

Untuk APK release yang akan dipublish ke Play Store:

### 1. Generate Release Keystore

```powershell
keytool -genkey -v -keystore skyvault-release.keystore -alias skyvault -keyalg RSA -keysize 2048 -validity 10000
```

Isi informasi:
```
Enter keystore password: [BUAT PASSWORD KUAT]
Re-enter new password: [ULANGI]
First and Last Name: SkyVault
Organizational Unit: Tech Team
Organization: SkyVault
City: Jakarta
State: DKI Jakarta
Country Code: ID
```

### 2. Get SHA-1 dari Release Keystore

```powershell
keytool -list -v -keystore skyvault-release.keystore -alias skyvault
```

### 3. Tambahkan SHA-1 Release ke Firebase

1. Firebase Console → Project Settings → Your apps
2. Klik app Android Anda
3. Scroll ke **"SHA certificate fingerprints"**
4. Klik **"Add fingerprint"**
5. Paste SHA-1 dari release keystore
6. **Save**

### 4. Configure Build untuk Release

Buat file `android/key.properties`:
```properties
storePassword=<PASSWORD_KEYSTORE>
keyPassword=<PASSWORD_KEY>
keyAlias=skyvault
storeFile=../skyvault-release.keystore
```

Update `android/app/build.gradle.kts`:
```kotlin
// Tambahkan di atas android {}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ...
        }
    }
}
```

### 5. Build Release APK

```powershell
flutter build apk --release --split-per-abi
```

---

## 📊 Monitoring & Analytics

### Firebase Console - Authentication Dashboard:

Setelah setup, Anda bisa monitor:
- ✅ Total users yang login
- ✅ Active users (daily/weekly/monthly)
- ✅ Sign-in methods used (Google vs Email)
- ✅ User list dengan email & UID

**Cara akses:**
1. Firebase Console → **Authentication**
2. Tab **"Users"** untuk list users
3. Tab **"Dashboard"** untuk analytics

---

## 🐛 Troubleshooting Common Issues

### 1. **Google Sign-In selalu return null**
```
Kemungkinan penyebab:
- SHA-1 belum ditambahkan
- Package name tidak match
- Google Sign-In belum di-enable di Firebase
```

**Solusi:**
- Verify SHA-1 di Firebase Console
- Cek `android/app/build.gradle.kts` → namespace = `com.example.smartspend_ai`
- Enable Google Sign-In di Firebase Authentication

---

### 2. **Error: "The caller does not have permission"**
```
Kemungkinan penyebab:
- Google Sign-In method belum di-enable di Firebase Console
```

**Solusi:**
- Firebase Console → Authentication → Sign-in method
- Enable "Google" provider

---

### 3. **Error saat build: "google-services.json not found"**
```
Kemungkinan penyebab:
- File google-services.json belum ditambahkan
- File ada di folder yang salah
```

**Solusi:**
- Download `google-services.json` dari Firebase Console
- Paste ke `android/app/` (bukan `android/`)
- Run `flutter clean && flutter pub get`

---

### 4. **Emulator tidak bisa login Google**
```
Kemungkinan penyebab:
- Emulator belum login akun Google
- Google Play Services belum installed
```

**Solusi:**
- Gunakan emulator dengan **Google Play** (bukan Google APIs)
- Atau test di real device

---

## ✅ Checklist Setup

Pastikan semua langkah ini sudah dilakukan:

- [ ] Firebase project sudah dibuat
- [ ] Android app sudah ditambahkan ke Firebase
- [ ] SHA-1 debug sudah ditambahkan ke Firebase
- [ ] File `google-services.json` sudah di `android/app/`
- [ ] Google Sign-In sudah di-enable di Firebase Console
- [ ] Aplikasi sudah di-rebuild (`flutter clean && flutter build apk`)
- [ ] Test login Google di emulator/device

---

## 📝 Template google-services.json

Jika Anda belum setup Firebase, aplikasi akan gracefully fallback (tidak crash).

Tapi untuk **PRODUCTION**, Firebase **WAJIB** dikonfigurasi!

File `google-services.json` akan terlihat seperti ini (JANGAN COMMIT KE GIT):

```json
{
  "project_info": {
    "project_number": "123456789012",
    "project_id": "skyvault-app",
    "storage_bucket": "skyvault-app.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef123456",
        "android_client_info": {
          "package_name": "com.example.smartspend_ai"
        }
      },
      "oauth_client": [
        {
          "client_id": "123456789012-abcdefghijklmnop.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "AIzaSyAbCdEfGhIjKlMnOpQrStUvWxYz1234567"
        }
      ]
    }
  ]
}
```

---

## 🔗 Resources

- [Firebase Console](https://console.firebase.google.com/)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

---

## 📞 Support

Jika masih ada masalah setelah mengikuti panduan ini:

1. Cek Firebase Console → Authentication → Users (apakah user ter-create?)
2. Cek logcat Android: `flutter run -v` (lihat error detail)
3. Pastikan internet connection stabil
4. Coba dengan akun Google yang berbeda

---

**© 2025 SkyVault - Secure Your Financial Sky 🔒**







