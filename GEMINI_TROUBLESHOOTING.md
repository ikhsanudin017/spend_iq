# 🔧 Troubleshooting Gemini AI

## Masalah: Model tidak ditemukan

Jika Anda mendapat error `models/gemini-xxx is not found`, ikuti langkah berikut:

### 1. Verifikasi API Key
- Pastikan API key valid di: https://aistudio.google.com/app/apikey
- API key harus dimulai dengan `AIzaSy`
- Pastikan API key tidak expired

### 2. Cek Model yang Tersedia
Untuk API key gratis, biasanya model yang tersedia adalah:
- `gemini-1.5-flash` (paling umum, gratis)
- `gemini-1.5-pro` (terkadang tersedia)
- `gemini-pro` (legacy, mungkin tidak tersedia)

### 3. Test API Key
Buka browser dan test dengan curl:
```bash
curl "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=YOUR_API_KEY" \
  -H 'Content-Type: application/json' \
  -d '{"contents":[{"parts":[{"text":"hi"}]}]}'
```

Ganti `YOUR_API_KEY` dengan API key Anda.

### 4. Solusi Alternatif
Jika semua model gagal:
1. Buat API key baru di https://aistudio.google.com/app/apikey
2. Pastikan project memiliki akses ke Gemini API
3. Enable Gemini API di Google Cloud Console jika perlu

### 5. Cek Console Log
Saat test, cek console log untuk melihat:
- Model mana yang dicoba
- Error message spesifik
- Apakah API key valid

## Status Saat Ini
- ✅ API key sudah diisi: `AIzaSyB2d_OLCuDHGfOmzauvqQCNH5YSvFJPgk4`
- ✅ Kode akan mencoba 3 model secara otomatis
- ✅ Test request untuk memastikan model bekerja
- ✅ Auto-retry dengan model lain jika gagal


