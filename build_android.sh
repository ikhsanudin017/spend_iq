#!/bin/bash

# ============================================
# Build Script untuk Android APK
# SmartSpend AI
# ============================================

echo "============================================"
echo "Building Android APK - SmartSpend AI"
echo "============================================"
echo ""

# Set lokasi build output
BUILD_DIR="build/android/apk"
OUTPUT_DIR="builds/android"

# Buat direktori output jika belum ada
mkdir -p "$OUTPUT_DIR"

echo "[1/4] Cleaning previous build..."
flutter clean
echo ""

echo "[2/4] Getting dependencies..."
flutter pub get
echo ""

echo "[3/4] Building APK (Release)..."
flutter build apk --release
echo ""

echo "[4/4] Copying APK to builds folder..."
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    cp "build/app/outputs/flutter-apk/app-release.apk" "$OUTPUT_DIR/smartspend_ai_v1.0.0_release.apk"
    echo ""
    echo "============================================"
    echo "Build Berhasil!"
    echo "============================================"
    echo ""
    echo "APK Location: $OUTPUT_DIR/smartspend_ai_v1.0.0_release.apk"
    echo ""
    echo "File size:"
    ls -lh "$OUTPUT_DIR/smartspend_ai_v1.0.0_release.apk"
    echo ""
else
    echo "ERROR: APK not found!"
    echo "Expected location: build/app/outputs/flutter-apk/app-release.apk"
    exit 1
fi

echo ""
echo "============================================"
echo "Build selesai!"
echo "============================================"















