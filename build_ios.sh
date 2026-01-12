#!/bin/bash

# ============================================
# Build Script untuk iOS IPA
# SmartSpend AI
# NOTE: Script ini hanya bisa dijalankan di macOS dengan Xcode
# ============================================

echo "============================================"
echo "Building iOS IPA - SmartSpend AI"
echo "============================================"
echo ""

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "ERROR: iOS build hanya bisa dilakukan di macOS dengan Xcode!"
    echo "Silakan jalankan script ini di Mac atau gunakan CI/CD service."
    exit 1
fi

# Set lokasi build output
OUTPUT_DIR="builds/ios"

# Buat direktori output jika belum ada
mkdir -p "$OUTPUT_DIR"

echo "[1/5] Cleaning previous build..."
flutter clean
echo ""

echo "[2/5] Getting dependencies..."
flutter pub get
echo ""

echo "[3/5] Building iOS (Release)..."
flutter build ios --release --no-codesign
echo ""

echo "[4/5] Building IPA..."
# NOTE: Untuk build IPA yang bisa diinstall, perlu:
# 1. Apple Developer Account
# 2. Provisioning Profile
# 3. Signing Certificate
# 
# Uncomment dan sesuaikan command di bawah jika sudah setup:
#
# flutter build ipa --release
#
# Atau gunakan Xcode:
# 1. Buka ios/Runner.xcworkspace di Xcode
# 2. Pilih Product > Archive
# 3. Export IPA dari Organizer

echo ""
echo "============================================"
echo "Build iOS selesai (Framework only)!"
echo "============================================"
echo ""
echo "NOTE: Untuk menghasilkan IPA yang bisa diinstall:"
echo "1. Buka ios/Runner.xcworkspace di Xcode"
echo "2. Setup signing & provisioning profile"
echo "3. Pilih Product > Archive"
echo "4. Export IPA dari Organizer"
echo ""
echo "Build location: build/ios/iphoneos/Runner.app"
echo ""















