# 📱 Build Guide - SmartSpend AI

## 📍 Lokasi Build Files

### Android APK
- **Build Output**: `builds/android/smartspend_ai_v1.0.0_release.apk`
- **Temporary Build**: `build/app/outputs/flutter-apk/app-release.apk`

### iOS IPA
- **Build Output**: `builds/ios/` (setelah export dari Xcode)
- **Temporary Build**: `build/ios/iphoneos/Runner.app`

---

## 🤖 Build Android APK

### Prerequisites
- Flutter SDK terinstall
- Android Studio terinstall
- Android SDK terinstall
- Java JDK 17 atau lebih baru

### Cara Build (Windows)
```bash
# Jalankan script build
build_android.bat
```

### Cara Build (Linux/Mac)
```bash
# Berikan permission execute
chmod +x build_android.sh

# Jalankan script build
./build_android.sh
```

### Cara Build Manual
```bash
# 1. Clean previous build
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build APK
flutter build apk --release

# 4. APK akan ada di:
# build/app/outputs/flutter-apk/app-release.apk
```

### Build APK Split (untuk mengurangi ukuran)
```bash
# Build APK per ABI (armeabi-v7a, arm64-v8a, x86_64)
flutter build apk --split-per-abi --release

# Output:
# build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# build/app/outputs/flutter-apk/app-x86_64-release.apk
```

### Build App Bundle (untuk Google Play Store)
```bash
# Build AAB (Android App Bundle)
flutter build appbundle --release

# Output:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 🍎 Build iOS IPA

### Prerequisites
- **macOS** (wajib, tidak bisa di Windows/Linux)
- Xcode terinstall (latest version)
- Apple Developer Account (untuk signing)
- CocoaPods terinstall
- Provisioning Profile & Signing Certificate

### Cara Build (macOS)
```bash
# 1. Install CocoaPods dependencies
cd ios
pod install
cd ..

# 2. Jalankan script build (framework only)
chmod +x build_ios.sh
./build_ios.sh
```

### Cara Build IPA Manual (di macOS)
```bash
# 1. Clean previous build
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Install CocoaPods
cd ios
pod install
cd ..

# 4. Build iOS (release)
flutter build ios --release

# 5. Buka Xcode untuk build IPA
open ios/Runner.xcworkspace
```

### Build IPA dengan Xcode
1. Buka `ios/Runner.xcworkspace` di Xcode
2. Pilih **Product > Scheme > Runner**
3. Pilih **Product > Destination > Any iOS Device**
4. Setup **Signing & Capabilities**:
   - Pilih Team (Apple Developer Account)
   - Pilih Provisioning Profile
   - Pastikan Bundle Identifier benar
5. Pilih **Product > Archive**
6. Setelah archive selesai, **Organizer** akan terbuka
7. Pilih archive yang baru dibuat
8. Klik **Distribute App**
9. Pilih metode distribusi:
   - **App Store Connect** (untuk App Store)
   - **Ad Hoc** (untuk testing)
   - **Enterprise** (untuk enterprise distribution)
   - **Development** (untuk development)
10. Ikuti wizard untuk export IPA
11. IPA akan tersimpan di lokasi yang dipilih

### Build IPA via Command Line (di macOS)
```bash
# Build IPA langsung (perlu signing setup)
flutter build ipa --release

# Output:
# build/ios/ipa/smartspend_ai.ipa
```

---

## 🔐 Signing Configuration

### Android Signing
Untuk production build, perlu setup signing key:

1. **Generate keystore**:
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Buat file `android/key.properties`**:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>
```

3. **Update `android/app/build.gradle.kts`**:
```kotlin
// Tambahkan di bagian android {}
signingConfigs {
    create("release") {
        val keystorePropertiesFile = rootProject.file("key.properties")
        val keystoreProperties = Properties()
        if (keystorePropertiesFile.exists()) {
            keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
        // ...
    }
}
```

### iOS Signing
Setup di Xcode:
1. Buka `ios/Runner.xcworkspace`
2. Pilih **Runner** project
3. Pilih **Signing & Capabilities** tab
4. Pilih **Team** (Apple Developer Account)
5. Pilih **Provisioning Profile**
6. Pastikan **Bundle Identifier** unik

---

## 📦 Build Variants

### Android
- **Debug**: `flutter build apk --debug`
- **Profile**: `flutter build apk --profile`
- **Release**: `flutter build apk --release`

### iOS
- **Debug**: `flutter build ios --debug`
- **Profile**: `flutter build ios --profile`
- **Release**: `flutter build ios --release`

---

## 🚀 Quick Build Commands

### Android
```bash
# APK Release
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release

# Split APK (smaller size)
flutter build apk --split-per-abi --release
```

### iOS
```bash
# iOS Release (framework only)
flutter build ios --release

# IPA (need signing)
flutter build ipa --release
```

---

## 📂 Struktur Build Output

```
builds/
├── android/
│   └── smartspend_ai_v1.0.0_release.apk
└── ios/
    └── (IPA files setelah export dari Xcode)

build/
├── app/
│   └── outputs/
│       ├── flutter-apk/
│       │   └── app-release.apk
│       └── bundle/
│           └── release/
│               └── app-release.aab
└── ios/
    ├── iphoneos/
    │   └── Runner.app
    └── ipa/
        └── smartspend_ai.ipa
```

---

## 🔍 Troubleshooting

### Android Build Issues
1. **Gradle sync failed**:
   - Hapus `.gradle` folder
   - Hapus `build` folder
   - Run `flutter clean`
   - Run `flutter pub get`

2. **Signing error**:
   - Pastikan `key.properties` ada dan benar
   - Pastikan keystore file ada
   - Check password keystore

3. **SDK version error**:
   - Update `compileSdk` di `build.gradle.kts`
   - Update Android SDK di Android Studio

### iOS Build Issues
1. **CocoaPods error**:
   ```bash
   cd ios
   pod deintegrate
   pod install
   cd ..
   ```

2. **Signing error**:
   - Pastikan Apple Developer Account aktif
   - Pastikan Provisioning Profile valid
   - Check Bundle Identifier di Xcode

3. **Xcode version**:
   - Update Xcode ke versi terbaru
   - Update CocoaPods: `sudo gem install cocoapods`

---

## 📝 Notes

- **Android**: Bisa build di Windows, Linux, atau macOS
- **iOS**: Hanya bisa build di macOS dengan Xcode
- **Signing**: Wajib untuk production build
- **Testing**: Gunakan debug build untuk development
- **Distribution**: 
  - Android: Upload AAB ke Google Play Console
  - iOS: Upload IPA ke App Store Connect

---

## 🎯 Next Steps

1. **Setup Signing** untuk production build
2. **Test Build** di device fisik
3. **Upload ke Store**:
   - Android: Google Play Console
   - iOS: App Store Connect
4. **Monitor Crash Reports** setelah release

---

**Happy Building! 🚀**















