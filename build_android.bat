@echo off
REM ============================================
REM Build Script untuk Android APK
REM SmartSpend AI
REM ============================================

echo ============================================
echo Building Android APK - SmartSpend AI
echo ============================================
echo.

REM Set lokasi build output
set BUILD_DIR=build\android\apk
set OUTPUT_DIR=builds\android

REM Buat direktori output jika belum ada
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo [1/4] Cleaning previous build...
call flutter clean
echo.

echo [2/4] Getting dependencies...
call flutter pub get
echo.

echo [3/4] Building APK (Release)...
call flutter build apk --release
echo.

echo [4/4] Copying APK to builds folder...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    copy "build\app\outputs\flutter-apk\app-release.apk" "%OUTPUT_DIR%\smartspend_ai_v1.0.0_release.apk"
    echo.
    echo ============================================
    echo Build Berhasil!
    echo ============================================
    echo.
    echo APK Location: %OUTPUT_DIR%\smartspend_ai_v1.0.0_release.apk
    echo.
    echo File size:
    dir "%OUTPUT_DIR%\smartspend_ai_v1.0.0_release.apk" | findstr "smartspend"
    echo.
) else (
    echo ERROR: APK not found!
    echo Expected location: build\app\outputs\flutter-apk\app-release.apk
    exit /b 1
)

echo.
echo ============================================
echo Build selesai!
echo ============================================
pause















