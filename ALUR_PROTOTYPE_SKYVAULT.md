# ALUR PROTOTYPE SKYVAULT
## Flow Aplikasi Lengkap - Dari Login sampai Home

---

## 🎯 Overview Alur

```
SPLASH → LOGIN → REGISTER/ONBOARDING → CONNECT BANKS → PERMISSIONS → HOME
```

---

## 📱 Detail Alur Step-by-Step

### 1. **SPLASH SCREEN** (`/`)
**File:** `lib/presentation/features/onboarding/splash_page.dart`

**Yang Terjadi:**
- Animasi logo SkyVault dengan gradien cyan
- Tagline: "Secure Your Financial Sky"
- Loading indicator
- **Logika routing otomatis** (2 detik):

```
┌─────────────────────────────────────────┐
│  CEK FIREBASE AUTHENTICATION            │
└─────────┬───────────────────────────────┘
          │
    ┌─────▼─────┐
    │ Logged In?│
    └─────┬─────┘
          │
   ┌──────┴──────┐
   │             │
  YES            NO
   │             │
   │          ┌──▼──────────────┐
   │          │ → LOGIN PAGE    │
   │          └─────────────────┘
   │
   ├─► Cek Onboarding Complete?
   │       │
   │   ┌───┴───┐
   │   │       │
   │  YES      NO
   │   │       │
   │   │    ┌──▼───────────────┐
   │   │    │ → ONBOARDING     │
   │   │    └──────────────────┘
   │   │
   │   ├─► Cek Bank Connected?
   │   │       │
   │   │   ┌───┴───┐
   │   │   │       │
   │   │  YES      NO
   │   │   │       │
   │   │   │    ┌──▼──────────────┐
   │   │   │    │ → CONNECT BANKS │
   │   │   │    └─────────────────┘
   │   │   │
   │   │   ├─► Cek Notification Permission?
   │   │   │       │
   │   │   │   ┌───┴───┐
   │   │   │   │       │
   │   │   │  YES      NO
   │   │   │   │       │
   │   │   │   │    ┌──▼────────────┐
   │   │   │   │    │ → PERMISSIONS │
   │   │   │   │    └───────────────┘
   │   │   │   │
   │   │   │   └──► HOME
   └───┴───┴───────► HOME
```

---

### 2. **LOGIN PAGE** (`/auth/login`)
**File:** `lib/presentation/features/auth/login_page.dart`

**Fitur:**
- ✅ Login dengan Google (Firebase Auth)
- ✅ Login dengan Email & Password
- ✅ Link ke Register
- ✅ Link ke Forgot Password

**Setelah Login Berhasil:**
```
LOGIN SUCCESS → SPLASH (untuk cek status onboarding)
```

**UI:**
- Gradien cyan SkyVault background
- Logo SkyVault di atas
- Form input email & password
- Tombol Google Sign-In
- Animated transitions

---

### 3. **REGISTER PAGE** (`/auth/register`)
**File:** `lib/presentation/features/auth/register_page.dart`

**Fitur:**
- ✅ Register dengan Google
- ✅ Register dengan Email & Password
- ✅ Validasi form (email, password min 6 char, confirm password)
- ✅ Link kembali ke Login

**Setelah Register Berhasil:**
```
REGISTER SUCCESS → ONBOARDING
```

---

### 4. **ONBOARDING PAGE** (`/onboarding`)
**File:** `lib/presentation/features/onboarding/onboarding_page.dart`

**Fitur:**
- ✅ 3 halaman PageView:
  1. **Prediksi Cashflow AI** - Prediksi akurat kapan uang habis
  2. **Autosave Cerdas** - AI tentukan hari aman untuk saving
  3. **Smart Alerts** - Notifikasi proaktif untuk risiko cashflow

- ✅ Tombol "Lewati" (skip)
- ✅ Page indicator (dots)
- ✅ Tombol "Mulai" di halaman terakhir

**Setelah Selesai:**
```
ONBOARDING COMPLETE → CONNECT BANKS
```

**UI:**
- Gradien cyan background
- Animasi slide & fade
- Icon ilustrasi besar
- Text penjelasan

---

### 5. **CONNECT BANKS PAGE** (`/onboarding/connect-banks`)
**File:** `lib/presentation/features/onboarding/connect_banks_page.dart`

**Fitur:**
- ✅ List bank yang tersedia:
  - BCA
  - Mandiri
  - BNI
  - BRI
  - Bank Jago
  - Jenius
  - BluBCA
  - GoPay
  - OVO
  - Dana

- ✅ Multi-select (checkbox)
- ✅ Informasi keamanan:
  - Keamanan berlapis
  - Analitik real-time
  - Prediksi personal

- ✅ Tombol "Lanjutkan" (disabled jika belum pilih bank)

**Logika:**
```
SELECT BANKS → SIMPAN KE HIVE → CONNECT BANKS → PERMISSIONS
```

**UI:**
- Gradient card untuk info
- List tile untuk setiap bank dengan avatar
- Animasi selection
- Disclaimer privasi SkyVault

---

### 6. **PERMISSIONS PAGE** (`/onboarding/permissions`)
**File:** `lib/presentation/features/onboarding/permissions_page.dart`

**Fitur:**
- ✅ Request notification permission
- ✅ Penjelasan kenapa butuh notification:
  - Alert tagihan jatuh tempo
  - Prediksi cashflow warning
  - Insight saving opportunities

- ✅ 2 tombol:
  - **"Izinkan Notifikasi"** → Request permission → Home
  - **"Lewati"** → Langsung ke Home

**Logika:**
```
ALLOW PERMISSIONS → GRANT → HOME
SKIP → HOME (tanpa notifications)
```

**UI:**
- Gradien background
- Icon bell besar
- Penjelasan benefits
- 2 CTA buttons

---

### 7. **HOME PAGE** (`/home`)
**File:** `lib/presentation/features/home/home_page.dart`

**Fitur Utama:**
- ✅ **Balance Card** - Total saldo dari semua bank
- ✅ **Quick Stats** - Income, Expenses, Savings bulan ini
- ✅ **AI Insights** - 3 insight cards:
  - Hari aman menabung
  - Safe spending hari ini
  - Prediksi kebutuhan bulanan

- ✅ **Recent Transactions** - 5 transaksi terakhir
- ✅ **Quick Actions** - Add transaction, view bills, set goals

**Bottom Navigation:**
```
HOME | INSIGHTS | AUTOSAVE | ALERTS | CHAT
```

---

## 🔄 Flow Diagram Visual

```
┌──────────────┐
│   SPLASH     │ (2 detik loading)
│  SkyVault    │
└──────┬───────┘
       │
       ├─ Not Logged In? ──┐
       │                   │
       │              ┌────▼─────┐
       │              │  LOGIN   │ ←─── "Belum punya akun?"
       │              └────┬─────┘
       │                   │
       │         Google/Email Login
       │                   │
       │              ┌────▼─────────┐
       │              │   REGISTER   │ ──┐
       │              └──────────────┘   │
       │                                 │
       ├─ Logged In & Not Onboarded? ◄──┘
       │                   │
       │              ┌────▼───────────┐
       │              │  ONBOARDING    │
       │              │  (3 pages)     │
       │              └────┬───────────┘
       │                   │
       │             "Mulai" / "Lewati"
       │                   │
       ├─ No Bank Connected? ◄─────────┘
       │                   │
       │              ┌────▼──────────────┐
       │              │  CONNECT BANKS    │
       │              │ (select >= 1)     │
       │              └────┬──────────────┘
       │                   │
       │              "Lanjutkan"
       │                   │
       ├─ No Permission? ◄────────────────┘
       │                   │
       │              ┌────▼─────────────┐
       │              │   PERMISSIONS    │
       │              │ (notification)   │
       │              └────┬─────────────┘
       │                   │
       │         "Izinkan" / "Lewati"
       │                   │
       └───────────────────┘
                   │
              ┌────▼─────────────┐
              │      HOME        │
              │  (Dashboard)     │
              └──────────────────┘
                   │
        ┌──────────┼──────────┬──────────┬──────────┐
        │          │          │          │          │
    ┌───▼───┐  ┌──▼──┐  ┌────▼────┐  ┌──▼───┐  ┌──▼──┐
    │ HOME  │  │INSIG│  │AUTOSAVE │  │ALERTS│  │CHAT │
    └───────┘  └─────┘  └─────────┘  └──────┘  └─────┘
```

---

## 🎨 Tema SkyVault

### Color Palette:
```
Primary Cyan:   #2D9CDB → #56CCF2 (gradien)
Navy Text:      #0B274A
White BG:       #FFFFFF
Sky Tint:       #F7FCFF, #F0F9FF
Border:         #E0F2FE
```

### Typography:
- **Logo/Headlines:** Plus Jakarta Sans (bold, large)
- **Body Text:** Inter (regular, clean)
- **Numbers:** JetBrains Mono (monospace)

### Design Principles:
- **Flat Design** - No heavy shadows, clean borders
- **Cyan Gradient** - Sky theme dengan trust & security
- **White Space** - Breathable, tidak cramped
- **Responsive** - Optimal di Oppo A77s (720x1600, 20:9)

---

## ✅ Checklist Fitur

### Authentication:
- [x] Firebase Auth setup
- [x] Google Sign-In
- [x] Email/Password login
- [x] Register with validation
- [x] Forgot password UI

### Onboarding:
- [x] 3-page tour
- [x] Skip functionality
- [x] Page indicators
- [x] Onboarding completion tracking

### Bank Integration:
- [x] 10 bank options (BCA, Mandiri, BNI, BRI, dll)
- [x] Multi-select banks
- [x] Save to local storage (Hive)
- [x] Validation (minimum 1 bank)

### Permissions:
- [x] Notification permission request
- [x] Skip option
- [x] Permission status tracking

### Main App:
- [x] Home dashboard
- [x] Insights page
- [x] Autosave page
- [x] Alerts page
- [x] Chat AI page
- [x] Bottom navigation
- [x] Profile & Settings

---

## 📦 APK Build Info

**Latest Build:**
```
Version: 1.0.0+1
Build Date: 2025-11-13
App Name: SkyVault
Package: com.example.smartspend_ai

Files Generated:
- app-arm64-v8a-release.apk (22.0MB) ⭐ RECOMMENDED
- app-armeabi-v7a-release.apk (19.9MB)
- app-x86_64-release.apk (23.1MB)

Location:
build\app\outputs\flutter-apk\
```

---

## 🔐 Data Flow

### User Data (Firebase):
```
User {
  uid: String
  email: String
  displayName: String
  photoURL: String?
  hasCompletedOnboarding: bool
  createdAt: Timestamp
}
```

### Local Data (Hive):
```
Connected Banks: List<String>
Accounts: List<Account>
Transactions: List<Transaction>
Goals: List<Goal>
Preferences: Map<String, dynamic>
```

### State Management (Riverpod):
```
- authRepositoryProvider
- financeRepositoryProvider
- bankConnectionsProvider
- accountsProvider
- transactionsProvider
- predictiveEngineProvider
```

---

## 🚀 Testing Flow

### Manual Test Steps:

1. **First Launch (New User):**
   ```
   Install APK → Splash (2s) → Login → Register → Onboarding (3 pages) 
   → Connect Banks (select 1+) → Permissions → Home
   ```

2. **Returning User (Completed Setup):**
   ```
   Launch → Splash (2s) → Auto navigate to Home
   ```

3. **Logged In but Not Onboarded:**
   ```
   Launch → Splash → Onboarding → Connect Banks → Permissions → Home
   ```

4. **Logged In but No Banks:**
   ```
   Launch → Splash → Connect Banks → Permissions → Home
   ```

5. **Skip Scenarios:**
   - Skip onboarding → Go to Connect Banks
   - Skip permissions → Go to Home (no notifications)

---

## 🎯 User Journey Examples

### **Scenario 1: User Baru Pertama Kali**
```
1. Download & Install SkyVault
2. Buka app → Splash SkyVault
3. Klik "Login dengan Google"
4. Otorisasi Google → Masuk
5. Lihat Onboarding (3 halaman)
6. Klik "Mulai" di halaman 3
7. Pilih bank: BCA, Mandiri
8. Klik "Lanjutkan"
9. Izinkan notifikasi
10. Masuk ke Home Dashboard ✅
```

### **Scenario 2: User Lama Kembali**
```
1. Buka app
2. Splash 2 detik
3. Auto login (sudah login)
4. Langsung ke Home Dashboard ✅
```

### **Scenario 3: User Skip Onboarding**
```
1. Buka app → Splash → Login
2. Di Onboarding → Klik "Lewati"
3. Langsung ke Connect Banks
4. Pilih bank → Lanjutkan
5. Skip permissions
6. Masuk Home (tanpa notif) ✅
```

---

## 📝 Notes untuk Development

### Known Limitations:
- Firebase belum dikonfigurasi fully → Authentication mock/graceful fallback
- Bank APIs belum real → Data seed dari local JSON
- Predictive AI belum train → Mock predictions
- Notifications belum implement fully → Permission UI only

### Next Steps (Post-MVP):
1. Setup Firebase project lengkap (google-services.json)
2. Integrate real bank APIs (Open Banking)
3. Train ML model untuk predictions
4. Implement real-time notifications
5. Add investment tracking
6. Add debt management

---

## 🔒 Security Notes

### Data Protection:
- ✅ Firebase Auth untuk user management
- ✅ Local data encrypted dengan Hive encryption
- ✅ No plain text passwords stored
- ✅ Secure communication (HTTPS only)

### Privacy:
- ✅ User consent untuk bank connections
- ✅ Clear privacy policy link
- ✅ Data tidak dibagikan ke pihak ketiga
- ✅ User dapat delete account (future)

---

**© 2025 SkyVault - Secure Your Financial Sky 🔒**







