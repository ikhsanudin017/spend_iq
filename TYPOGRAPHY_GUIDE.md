# Hierarki Typography Spend-IQ

Dokumentasi lengkap hierarki font untuk aplikasi Spend-IQ.

## Font Family
- **Primary**: Inter (Google Fonts)
- **Numbers**: Space Grotesk (Google Fonts)

## Hierarki Typography

### 1. DISPLAY (Hero Text - Terbesar)
Digunakan untuk teks hero, splash screen, dan landing page.

| Style | Size | Weight | Letter Spacing | Line Height | Use Case |
|-------|------|--------|----------------|-------------|----------|
| `displayLarge` | 57px | w700 | -1.5 | 1.2 | Splash screen title, Hero banner |
| `displayMedium` | 45px | w600 | -1.0 | 1.2 | Landing page title |
| `displaySmall` | 36px | w600 | -0.5 | 1.3 | Section hero, Large card title |

**Contoh Penggunaan:**
```dart
Text('Spend-IQ', style: theme.textTheme.displayLarge)
Text('Welcome Back', style: theme.textTheme.displayMedium)
```

---

### 2. HEADLINE (Judul Utama)
Digunakan untuk judul halaman, section utama, dan card besar.

| Style | Size | Weight | Letter Spacing | Line Height | Use Case |
|-------|------|--------|----------------|-------------|----------|
| `headlineLarge` | 32px | w600 | -0.5 | 1.3 | Halaman utama title |
| `headlineMedium` | 28px | w600 | -0.3 | 1.3 | Card besar title, Modal title |
| `headlineSmall` | 24px | w600 | -0.2 | 1.4 | Section title, Card title |

**Contoh Penggunaan:**
```dart
Text('Dashboard', style: theme.textTheme.headlineLarge)
Text('Total Saldo', style: theme.textTheme.headlineMedium)
Text('Ringkasan Hari Ini', style: theme.textTheme.headlineSmall)
```

---

### 3. TITLE (Sub Judul)
Digunakan untuk AppBar, card title, dan list item title.

| Style | Size | Weight | Letter Spacing | Line Height | Use Case |
|-------|------|--------|----------------|-------------|----------|
| `titleLarge` | 22px | w600 | 0 | 1.4 | AppBar title, Card title utama |
| `titleMedium` | 16px | w500 | 0.1 | 1.5 | List item title, Sub section |
| `titleSmall` | 14px | w500 | 0.1 | 1.5 | Small card title, Chip text |

**Contoh Penggunaan:**
```dart
AppBar(title: Text('Settings', style: theme.textTheme.titleLarge))
Text('Mandiri', style: theme.textTheme.titleMedium)
Text('BCA', style: theme.textTheme.titleSmall)
```

---

### 4. BODY (Konten Utama)
Digunakan untuk paragraf, deskripsi, dan konten utama.

| Style | Size | Weight | Letter Spacing | Line Height | Use Case |
|-------|------|--------|----------------|-------------|----------|
| `bodyLarge` | 16px | w400 | 0.2 | 1.6 | Paragraf utama, Deskripsi panjang |
| `bodyMedium` | 14px | w400 | 0.2 | 1.5 | Konten standar, Deskripsi |
| `bodySmall` | 12px | w400 | 0.3 | 1.4 | Konten kecil, Helper text |

**Contoh Penggunaan:**
```dart
Text('Pilih bank yang ingin dihubungkan untuk agregasi saldo dan insight.', 
     style: theme.textTheme.bodyLarge)
Text('Saldo: Rp5.3 jt', style: theme.textTheme.bodyMedium)
Text('Koneksi aman & terenkripsi', style: theme.textTheme.bodySmall)
```

---

### 5. LABEL (Label & Button)
Digunakan untuk button text, input label, dan navigation.

| Style | Size | Weight | Letter Spacing | Line Height | Use Case |
|-------|------|--------|----------------|-------------|----------|
| `labelLarge` | 14px | w600 | 0.1 | 1.4 | Button text, Input label |
| `labelMedium` | 12px | w500 | 0.2 | 1.4 | Tab label, Navigation |
| `labelSmall` | 11px | w500 | 0.3 | 1.3 | Badge, Tag kecil |

**Contoh Penggunaan:**
```dart
FilledButton(child: Text('Simpan', style: theme.textTheme.labelLarge))
Text('Home', style: theme.textTheme.labelMedium)
Chip(label: Text('New', style: theme.textTheme.labelSmall))
```

---

## Number Theme (Space Grotesk)
Untuk menampilkan angka, saldo, dan nilai finansial.

| Style | Size | Weight | Letter Spacing | Use Case |
|-------|------|--------|----------------|----------|
| `display` | 44px | w600 | -1.1 | Total saldo besar |
| `medium` | 24px | w500 | -0.3 | Saldo per bank |
| `small` | 16px | w500 | 0 | Saldo kecil, Nominal |

**Contoh Penggunaan:**
```dart
final numberTheme = ref.watch(numberThemeProvider);
Text('Rp25.900.000', style: numberTheme.display)
Text('Rp7.352.000', style: numberTheme.medium)
Text('Rp4.038.000', style: numberTheme.small)
```

---

## Best Practices

### 1. Konsistensi
- Gunakan style yang sama untuk elemen yang sama di seluruh aplikasi
- Jangan campur style yang berbeda untuk tujuan yang sama

### 2. Hierarchy
- Display > Headline > Title > Body > Label
- Gunakan ukuran yang lebih besar untuk informasi lebih penting

### 3. Readability
- Body text minimal 14px untuk readability
- Line height minimal 1.4 untuk paragraf panjang
- Letter spacing disesuaikan dengan ukuran font

### 4. Color
- `onSurface`: Untuk teks utama (hitam/putih)
- `onSurfaceVariant`: Untuk teks sekunder (abu-abu)

### 5. Weight
- w700: Display, Hero text
- w600: Headline, Title besar, Button
- w500: Title kecil, Label
- w400: Body text

---

## Contoh Implementasi

### Card dengan Title dan Body
```dart
Card(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Total Saldo', style: theme.textTheme.headlineMedium),
      SizedBox(height: 8),
      Text('Rp25.900.000', style: numberTheme.display),
      SizedBox(height: 4),
      Text('3 akun terhubung', style: theme.textTheme.bodyMedium),
    ],
  ),
)
```

### List Item
```dart
ListTile(
  title: Text('Mandiri', style: theme.textTheme.titleMedium),
  subtitle: Text('Saldo: Rp7.352.000', style: theme.textTheme.bodySmall),
  trailing: Text('****1234', style: theme.textTheme.labelSmall),
)
```

### Button
```dart
FilledButton(
  onPressed: () {},
  child: Text('Simpan', style: theme.textTheme.labelLarge),
)
```

---

## Responsive Typography

Untuk layar kecil, gunakan `ResponsiveUtils.fontSize()`:

```dart
Text(
  'Spend-IQ',
  style: theme.textTheme.headlineLarge?.copyWith(
    fontSize: ResponsiveUtils.fontSize(context, 28),
  ),
)
```

---

## Update Log
- **v1.0.0** (2024): Initial typography system dengan Inter & Space Grotesk






