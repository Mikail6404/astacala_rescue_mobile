@echo off
echo ===============================================
echo   ASTACALA RESCUE - COMPLETE LOCAL SETUP
echo ===============================================
echo.

echo This script will:
echo 1. Start the Laravel backend server
echo 2. Launch the Flutter app on Android emulator
echo 3. Run connectivity tests
echo.

echo [1/4] Checking prerequisites...
echo.

echo 🔍 Checking Laravel backend directory...
if not exist "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api" (
    echo ❌ Laravel backend directory not found!
    echo Expected location: d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api
    echo Current directory: %CD%
    echo.
    echo Please check if the path is correct.
    pause
    exit /b 1
) else (
    echo ✅ Laravel backend directory found!
)

echo.
echo 🔍 Checking Flutter installation...
flutter --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ Flutter not found! Please install Flutter and add it to PATH.
    echo.
    echo To install Flutter:
    echo 1. Download from: https://flutter.dev/docs/get-started/install
    echo 2. Add Flutter to your PATH environment variable
    echo 3. Run 'flutter doctor' to verify installation
    pause
    exit /b 1
) else (
    echo ✅ Flutter is available!
    echo 📊 Flutter version:
    flutter --version
)

echo.
echo 🔍 Checking PHP installation...
php --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ❌ PHP not found! Laravel backend requires PHP.
    echo.
    echo To install PHP:
    echo 1. Download from: https://www.php.net/downloads
    echo 2. Add PHP to your PATH environment variable
    echo 3. Make sure Composer is also installed
    pause
    exit /b 1
) else (
    echo ✅ PHP is available!
)

echo.
echo ✅ All prerequisites check passed!
echo.

echo [2/4] Starting Laravel backend server...
cd /d "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"

REM Start backend server in background
start "Laravel Backend" cmd /c "echo Starting Laravel backend server... && php artisan serve --host=0.0.0.0 --port=8000 && pause"

echo ⏳ Waiting for backend to start...
timeout /t 5 >nul

echo [3/4] Testing backend accessibility...
curl -s http://localhost:8000/api/health >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo ✅ Backend is accessible!
) else (
    echo ⚠️  Backend might still be starting...
)

echo.
echo [4/4] Ready to test the mobile app!
echo.
echo 📱 To run the app:
echo    1. Make sure Android emulator is running
echo    2. Run: flutter run
echo.
echo 🔧 To test API connectivity:
echo    flutter test test/manual/api_connectivity_test.dart
echo.
echo 🌐 Backend URLs:
echo    - Health check: http://localhost:8000/api/health
echo    - From Android emulator: http://10.0.2.2:8000/api/health
echo.
echo 💡 If you see "Cannot connect to API service":
echo    1. Make sure the backend server window is running
echo    2. Check Android emulator has internet access
echo    3. Try restarting the emulator
echo.

cd /d "d:\astacala_rescue_mobile\astacala_rescue_mobile"

echo Ready! You can now run 'flutter run' to start the app.
echo Press any key to continue...
pause >nul
