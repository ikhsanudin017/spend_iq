# 🔒 SkyVault
**Secure Your Financial Sky**

Aplikasi pengelolaan keuangan pribadi berbasis AI dengan fokus pada keamanan dan kemudahan.

[![Flutter](https://img.shields.io/badge/Flutter-3.27.2-blue)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange)](https://firebase.google.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## ✨ Fitur Utama

- 🔐 **Login Aman** - Google Sign-In & Email/Password dengan Firebase Auth
- 📊 **Dashboard Real-time** - Lihat saldo & transaksi dari semua bank
- 🤖 **AI Predictions** - Prediksi cashflow akurat dengan machine learning
- 💰 **AutoSave Cerdas** - AI tentukan hari aman untuk menabung
- 🔔 **Smart Alerts** - Notifikasi proaktif untuk tagihan & risiko cashflow
- 💬 **Chat AI** - Tanya AI tentang keuangan Anda
- 🎨 **Modern UI** - Tema cyan gradient yang aman & modern

---

## 🚀 Quick Start

### 1. Clone & Install Dependencies

```bash
git clone https://github.com/yourusername/skyvault.git
cd skyvault
flutter pub get
```

### 2. Setup Firebase (PENTING untuk Google Sign-In)

**Option A: Quick Setup**
Ikuti: [`QUICK_START_FIREBASE.md`](QUICK_START_FIREBASE.md)

**Option B: Detailed Guide**
Ikuti: [`SETUP_GOOGLE_SIGNIN.md`](SETUP_GOOGLE_SIGNIN.md)

**Ringkasan:**
1. Buat Firebase project di https://console.firebase.google.com/
2. Download `google-services.json`
3. Paste ke `android/app/google-services.json`
4. Enable Google Sign-In di Firebase Console

### 3. Run Aplikasi

```bash
# Debug mode (emulator/device)
flutter run

# Build APK
flutter build apk --split-per-abi
```

---

## 📱 Screenshots

| Splash | Login | Home Dashboard |
|--------|-------|----------------|
| ![Splash](docs/screenshots/splash.png) | ![Login](docs/screenshots/login.png) | ![Home](docs/screenshots/home.png) |

| Insights | AutoSave | Chat AI |
|----------|----------|---------|
| ![Insights](docs/screenshots/insights.png) | ![AutoSave](docs/screenshots/autosave.png) | ![Chat](docs/screenshots/chat.png) |

---

## 🏗️ Arsitektur

```
lib/
├── core/               # Core utilities & config
│   ├── constants/      # Colors, strings, constants
│   ├── router/         # GoRouter configuration
│   ├── theme/          # App themes
│   └── utils/          # Helper functions
├── data/               # Data layer
│   ├── datasources/    # API & local data sources
│   ├── models/         # Data models
│   └── repositories/   # Repository implementations
├── domain/             # Business logic
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Use cases
├── presentation/       # UI layer
│   ├── features/       # Feature pages
│   └── widgets/        # Reusable widgets
├── providers/          # Riverpod providers
└── services/           # Services (AI, notifications)
```

**Pattern:** Clean Architecture + Riverpod State Management

---

## 🛠️ Tech Stack

### Frontend:
- **Flutter 3.27.2** - Cross-platform framework
- **Dart** - Programming language
- **Riverpod** - State management
- **GoRouter** - Routing & navigation
- **Flutter Animate** - Animations

### Backend & Cloud:
- **Firebase Auth** - Authentication
- **Cloud Firestore** - Database
- **Google Sign-In** - OAuth login

### Local Storage:
- **Hive** - Local NoSQL database
- **Shared Preferences** - Simple key-value storage

### AI & ML:
- **Custom ML Model** - Cashflow predictions
- **Time Series Analysis** - Spending forecasts

---

## 📂 Project Structure

```
skyvault/
├── android/                    # Android native code
│   └── app/
│       └── google-services.json  # Firebase config (required)
├── ios/                        # iOS native code
│   └── Runner/
│       └── GoogleService-Info.plist  # Firebase config (iOS)
├── lib/                        # Flutter source code
│   ├── core/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   ├── providers/
│   ├── services/
│   └── main.dart
├── assets/                     # Images, icons, data
├── test/                       # Unit & widget tests
├── SETUP_GOOGLE_SIGNIN.md      # Firebase setup guide
├── ALUR_PROTOTYPE_SKYVAULT.md  # App flow documentation
├── PRESENTASI_MUP.md           # Project presentation
└── pubspec.yaml                # Dependencies
```

---

## 🔐 Security

- ✅ **Firebase Authentication** - Industry standard auth
- ✅ **Encrypted Local Storage** - Hive encryption
- ✅ **No Plain Text Passwords** - All hashed & secured
- ✅ **HTTPS Only** - All API communications
- ✅ **Biometric Support** - Fingerprint/Face ID (future)

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/unit/predictive_engine_test.dart

# Coverage report
flutter test --coverage
```

---

## 📦 Build & Release

### Android APK:

```bash
# Debug APK
flutter build apk --debug

# Release APK (split per ABI - recommended)
flutter build apk --split-per-abi

# Release App Bundle (for Play Store)
flutter build appbundle
```

Output: `build/app/outputs/flutter-apk/`

### iOS (requires macOS):

```bash
flutter build ios --release
```

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Commit changes: `git commit -m 'Add AmazingFeature'`
4. Push to branch: `git push origin feature/AmazingFeature`
5. Open Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Support

- 📧 Email: support@skyvault.app
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/skyvault/issues)
- 📖 Docs: [Documentation](https://github.com/yourusername/skyvault/wiki)

---

## 🙏 Acknowledgments

- Firebase team for excellent auth & database services
- Flutter community for amazing packages
- All contributors & testers

---

**Made with ❤️ by SkyVault Team**

**© 2025 SkyVault - Secure Your Financial Sky 🔒**
