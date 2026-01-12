# 🤖 Setup Gemini AI untuk Chat Spend-IQ

## Cara Mendapatkan API Key Gratis

1. **Buka Google AI Studio**
   - Kunjungi: https://aistudio.google.com/app/apikey
   - Login dengan Google account Anda

2. **Buat API Key**
   - Klik tombol **"Create API Key"**
   - Pilih project atau buat project baru
   - Copy API key yang diberikan

3. **Setup API Key di Aplikasi**

   **Opsi 1: Hardcode (untuk testing)**
   - Buka file: `lib/services/gemini_service.dart`
   - Ganti `YOUR_GEMINI_API_KEY_HERE` dengan API key Anda:
   ```dart
   static const String _defaultApiKey = 'PASTE_API_KEY_DISINI';
   ```

   **Opsi 2: Environment Variable (Recommended untuk production)**
   - Simpan API key di secure storage atau environment variable
   - Update `geminiServiceProvider` di `lib/services/gemini_service.dart` untuk membaca dari storage

## Model yang Digunakan

- **Model**: `gemini-1.5-flash` (Gratis)
- **Temperature**: 0.7
- **Max Tokens**: 1024

## Fitur

- ✅ Chat AI dengan konteks finansial
- ✅ Fallback ke logic lama jika Gemini tidak tersedia
- ✅ Responsive design untuk semua ukuran layar
- ✅ Support tablet dan mobile

## Catatan

- API key gratis memiliki rate limit
- Untuk production, gunakan secure storage untuk menyimpan API key
- Jika API key tidak di-setup, aplikasi akan menggunakan fallback response

