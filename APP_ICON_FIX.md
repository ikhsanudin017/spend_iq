# 🔧 Fix App Icon - SmartSpend AI

## 🎯 Masalah
Logo aplikasi di launcher/home screen terlihat terlalu "full" dan kurang rapi. Perlu logo yang lebih minimalis.

## ✅ Solusi Cepat

### Opsi 1: Gunakan Design Tool (Recommended)

1. **Buat Logo Baru dengan Figma/Canva**:
   - Ukuran: 1024x1024 px
   - Format: PNG dengan transparansi
   - Desain: Minimalis, chart line sederhana
   - Background: Gradient biru (#2563EB → #60A5FA)
   - Icon: Garis chart putih mulus naik + 1 dot

2. **Replace Logo**:
   ```bash
   # Copy logo baru
   cp your_logo.png assets/images/logo_smartspend.png
   ```

3. **Generate App Icons**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Rebuild**:
   ```bash
   flutter clean
   flutter build apk --release
   ```

### Opsi 2: Buat Logo dengan Flutter (Advanced)

1. **Run Logo Generator** (jika script tersedia):
   ```bash
   dart scripts/generate_logo_icon.dart
   ```

2. **Generate App Icons**:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

3. **Rebuild**:
   ```bash
   flutter clean
   flutter build apk --release
   ```

## 🎨 Desain Logo Minimalis (Recommended)

### Spesifikasi
- **Size**: 1024x1024 px
- **Format**: PNG dengan transparansi
- **Background**: Gradient biru (circle)
  - Start: #2563EB (Blue)
  - End: #60A5FA (Light Blue)
- **Icon**: Chart line putih
  - Garis mulus naik (quadratic bezier)
  - Stroke: 12% dari ukuran
  - 1 dot di ujung (radius 7%)
- **Style**: Minimalis, clean, modern

### Visual Guide
```
┌─────────────────┐
│                 │
│    ╱╲           │
│   ╱  ╲          │
│  ╱    ╲●        │
│ ╱      ╲        │
│─────────────────│
```

## 📋 Checklist

- [ ] Logo baru dibuat (minimalis, clean)
- [ ] Ukuran 1024x1024 px
- [ ] Format PNG dengan transparansi
- [ ] Disimpan di `assets/images/logo_smartspend.png`
- [ ] Run `flutter pub run flutter_launcher_icons`
- [ ] Test di device (lihat icon di launcher)
- [ ] Icon terlihat jelas dan tidak blur
- [ ] Rebuild aplikasi

## 🚀 Quick Start

1. **Buat logo** dengan Figma/Canva (lihat `logo_generator.md`)
2. **Replace file**: `assets/images/logo_smartspend.png`
3. **Generate icons**: `flutter pub run flutter_launcher_icons`
4. **Test**: Install di device dan lihat icon di launcher
5. **Rebuild**: `flutter build apk --release`

## 📝 Notes

- App icon harus simple karena akan ditampilkan dalam ukuran kecil (48x48, 96x96, dll)
- Hindari terlalu banyak detail
- Pastikan kontras baik (putih di biru)
- Test di berbagai ukuran icon

---

**Status**: ⏳ Menunggu logo baru dari user atau designer















