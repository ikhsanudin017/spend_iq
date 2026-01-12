# 🔥 Panduan Setup Firebase untuk SmartSpend AI

## ✅ Status Implementasi

### Yang Sudah Selesai:
1. ✅ **Firebase Dependencies** - Sudah ditambahkan ke `pubspec.yaml`
2. ✅ **Authentication System** - Lengkap dengan Google Sign In
3. ✅ **Login/Register UI** - Modern dan responsive
4. ✅ **Onboarding Pages** - Welcome tour untuk user baru
5. ✅ **Splash Logic** - Cek auth status dan redirect otomatis
6. ✅ **Router** - Semua routes auth sudah ditambahkan
7. ✅ **Firebase Initialization** - Di `app_config.dart`

### Yang Perlu Dilakukan (Setup Firebase Project):
1. ⏳ **Buat Firebase Project** di Firebase Console
2. ⏳ **Download config files** untuk Android & iOS
3. ⏳ **Enable Authentication** (Google Sign In & Email/Password)
4. ⏳ **(Optional) Setup Firestore** untuk cloud sync

---

## 📋 Langkah-Langkah Setup Firebase

### 1️⃣ **Buat Firebase Project**

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik **"Add project"** atau **"Tambahkan project"**
3. Nama project: **`SmartSpend AI`** (atau nama lain)
4. (Optional) Enable Google Analytics
5. Klik **"Create project"**

### 2️⃣ **Tambahkan Android App**

1. Di Firebase Console, klik **"Add app"** → **Android**
2. **Package name**: `com.smartspend.ai` (sesuaikan dengan `android/app/build.gradle.kts`)
3. **App nickname**: `SmartSpend AI Android`
4. **SHA-1 certificate** (untuk Google Sign In):
   ```bash
   # Debug certificate
   cd android
   ./gradlew signingReport
   # Copy SHA-1 dari output
   ```
5. Download **`google-services.json`**
6. Letakkan file di: `android/app/google-services.json`

### 3️⃣ **Tambahkan iOS App**

1. Di Firebase Console, klik **"Add app"** → **iOS**
2. **Bundle ID**: `com.smartspend.ai` (sesuaikan dengan `ios/Runner/Info.plist`)
3. **App nickname**: `SmartSpend AI iOS`
4. Download **`GoogleService-Info.plist`**
5. Letakkan file di: `ios/Runner/GoogleService-Info.plist`
6. Buka XCode → Add files to "Runner"

### 4️⃣ **Enable Authentication Methods**

Di Firebase Console → **Authentication** → **Sign-in method**:

1. **Email/Password**: Enable
2. **Google**: Enable
   - Klik **Google**
   - Enable toggle
   - Pilih **Support email**
   - **Save**

### 5️⃣ **Configure Google Sign In**

#### Android:
File `android/app/build.gradle.kts` sudah dikonfigurasi dengan plugin Google services.

Pastikan ada:
```kotlin
plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Tambahkan jika belum ada
}
```

#### iOS:
1. Buka `ios/Runner/Info.plist`
2. Tambahkan:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Ganti dengan REVERSED_CLIENT_ID dari GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

### 6️⃣ **(Optional) Setup Firestore**

Untuk cloud sync data:

1. Di Firebase Console → **Firestore Database**
2. Klik **"Create database"**
3. Pilih **Production mode** (atau Test mode untuk development)
4. Pilih **Location** (asia-southeast1 untuk Asia Tenggara)

**Firestore Rules** (untuk production):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User data hanya bisa diakses oleh user yang bersangkutan
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      // Bank connections
      match /bank_connections/{bankId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // Goals
      match /goals/{goalId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
      
      // Autosave plans
      match /autosave_plans/{planId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
  }
}
```

---

## 🔧 Konfigurasi Android

### File: `android/app/build.gradle.kts`

Tambahkan plugin (jika belum ada):
```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ← Tambahkan ini
}
```

### File: `android/build.gradle.kts`

Tambahkan classpath (jika belum ada):
```kotlin
buildscript {
    dependencies {
        classpath("com.google.gms:google-services:4.4.0") // ← Tambahkan ini
    }
}
```

---

## 🔧 Konfigurasi iOS

### 1. Tambahkan GoogleService-Info.plist

1. Buka XCode
2. Drag & drop `GoogleService-Info.plist` ke folder `Runner`
3. Pastikan **"Copy items if needed"** dicentang
4. Pastikan **Target: Runner** dicentang

### 2. Update Info.plist

File `ios/Runner/Info.plist` tambahkan:
```xml
<!-- Google Sign In -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Ganti dengan REVERSED_CLIENT_ID dari GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>

<key>GIDClientID</key>
<string>YOUR-CLIENT-ID.apps.googleusercontent.com</string>
```

---

## 🧪 Testing

### Test Google Sign In:
```bash
flutter run
# Klik tombol "Masuk dengan Google"
# Pilih akun Google
# Harus redirect ke Onboarding Page
```

### Test Email/Password:
```bash
flutter run
# Klik "Daftar"
# Isi form registrasi
# Harus redirect ke Onboarding Page
```

---

## 📁 File Structure (Setelah Setup)

```
smartspend_ai/
├── android/
│   ├── app/
│   │   ├── google-services.json ← HARUS ADA
│   │   └── build.gradle.kts (updated)
│   └── build.gradle.kts (updated)
├── ios/
│   ├── Runner/
│   │   ├── GoogleService-Info.plist ← HARUS ADA
│   │   └── Info.plist (updated)
│   └── Runner.xcodeproj/
└── lib/
    ├── data/
    │   ├── datasources/auth/ ← Authentication datasources
    │   ├── models/user_model.dart ← User model
    │   └── repositories/auth_repository_impl.dart ← Auth repo
    ├── domain/
    │   ├── entities/user.dart ← User entity
    │   └── repositories/auth_repository.dart ← Auth repo interface
    ├── presentation/
    │   └── features/
    │       ├── auth/ ← Login, Register, Forgot Password
    │       └── onboarding/ ← Onboarding, Splash
    └── providers/auth_providers.dart ← Auth state management
```

---

## 🎯 Flow Aplikasi (Setelah Setup Firebase)

```
1. App Start → Splash
   ↓
2. Cek Auth Status
   ├─ Belum login? → Login Page
   ├─ Sudah login tapi belum onboarding? → Onboarding Page
   ├─ Sudah onboarding tapi belum connect bank? → Connect Banks
   ├─ Sudah connect bank tapi belum izin notif? → Permissions
   └─ Semua sudah? → Home Page
```

---

## ❓ Troubleshooting

### Error: "google-services.json not found"
**Solusi**: Download dari Firebase Console dan letakkan di `android/app/`

### Error: "GoogleService-Info.plist not found"
**Solusi**: Download dari Firebase Console dan add ke XCode Runner target

### Google Sign In gagal di Android
**Solusi**: 
1. Pastikan SHA-1 certificate sudah ditambahkan di Firebase Console
2. Run: `cd android && ./gradlew signingReport`
3. Copy SHA-1 dan tambahkan di Firebase Console

### Google Sign In gagal di iOS
**Solusi**: 
1. Pastikan REVERSED_CLIENT_ID sudah benar di Info.plist
2. Pastikan GoogleService-Info.plist ada di XCode

---

## 📝 Checklist Setup

- [ ] Buat Firebase Project
- [ ] Tambahkan Android App
- [ ] Download `google-services.json` → `android/app/`
- [ ] Update `android/build.gradle.kts` (add google-services plugin)
- [ ] Tambahkan iOS App
- [ ] Download `GoogleService-Info.plist` → `ios/Runner/`
- [ ] Update `ios/Runner/Info.plist` (add CFBundleURLTypes)
- [ ] Enable Authentication (Email/Password & Google)
- [ ] Get SHA-1 certificate (Android)
- [ ] Add SHA-1 to Firebase Console
- [ ] Test Google Sign In
- [ ] Test Email/Password Sign In
- [ ] (Optional) Setup Firestore
- [ ] (Optional) Setup Firestore Rules

---

## 🚀 Next Steps (Setelah Firebase Setup)

1. ✅ Test authentication flow
2. ✅ Test onboarding flow
3. ⏳ Implement cloud sync (Firestore)
4. ⏳ Add logout functionality di Settings
5. ⏳ Add profile edit page
6. ⏳ Add delete account functionality

---

**Status**: ✅ Kode implementasi SELESAI, tinggal setup Firebase Project di console

**Contact**: Jika ada kendala, tanyakan saja!









