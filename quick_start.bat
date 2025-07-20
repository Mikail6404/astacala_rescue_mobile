@echo off
echo ===============================================
echo   ASTACALA RESCUE - QUICK START
echo ===============================================
echo.

echo Checking prerequisites...

if not exist "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api\artisan" (
    echo ERROR: Laravel backend not found!
    echo Expected: d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api
    pause
    exit
)
echo ✓ Laravel backend found

flutter --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Flutter not found!
    echo Install Flutter: https://flutter.dev/docs/get-started/install
    pause
    exit
)
echo ✓ Flutter found

php --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: PHP not found!
    echo Install PHP: https://www.php.net/downloads
    pause
    exit
)
echo ✓ PHP found

echo.
echo All prerequisites OK!
echo.

echo Starting Laravel backend server...
echo.

cd /d "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"

echo Opening backend server in new window...
start "Backend Server" cmd /k "php artisan serve --host=0.0.0.0 --port=8000"

echo.
echo Waiting for server to start...
timeout /t 5 >nul

echo.
echo ================================================
echo              READY TO TEST!
echo ================================================
echo.
echo Backend Server: http://localhost:8000
echo API Health: http://localhost:8000/api/health
echo.
echo TO RUN FLUTTER APP:
echo 1. Make sure Android emulator is running
echo 2. Open new terminal in: d:\astacala_rescue_mobile\astacala_rescue_mobile
echo 3. Run: flutter run
echo.
echo Press any key to finish setup...
pause >nul
