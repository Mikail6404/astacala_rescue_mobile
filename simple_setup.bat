@echo off
setlocal enabledelayedexpansion

echo ===============================================
echo   ASTACALA RESCUE - SIMPLE LOCAL SETUP
echo ===============================================
echo.

echo This script will start the Laravel backend server
echo and provide instructions for running the Flutter app.
echo.

echo Step 1: Checking prerequisites...
echo.

REM Check Laravel directory
echo Checking Laravel backend directory...
if exist "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api\artisan" (
    echo ✓ Laravel backend found
) else (
    echo ✗ Laravel backend not found at: d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api
    echo Please check the path and try again.
    pause
    exit /b 1
)

REM Check Flutter
echo Checking Flutter...
flutter --version >nul 2>&1
if !errorlevel! equ 0 (
    echo ✓ Flutter is available
) else (
    echo ✗ Flutter not found in PATH
    echo Please install Flutter: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Check PHP
echo Checking PHP...
php --version >nul 2>&1
if !errorlevel! equ 0 (
    echo ✓ PHP is available
) else (
    echo ✗ PHP not found in PATH
    echo Please install PHP: https://www.php.net/downloads
    pause
    exit /b 1
)

echo.
echo ✓ All prerequisites OK!
echo.

echo Step 2: Starting Laravel backend server...
echo.

cd /d "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"

REM Check if server is already running
netstat -an 2>nul | findstr ":8000" >nul
if !errorlevel! equ 0 (
    echo Server might already be running on port 8000
    echo If you see connection issues, close any existing server first.
    echo.
)

echo Starting Laravel server in a new window...
echo (Keep that window open while testing the mobile app)
echo.

start "Astacala Backend Server" cmd /c "echo Astacala Rescue Backend Server && echo ================================ && echo Server will start in 3 seconds... && timeout /t 3 >nul && php artisan serve --host=0.0.0.0 --port=8000"

echo Waiting for server to start...
timeout /t 8 >nul

echo.
echo Step 3: Testing server...
echo.

REM Test if server is responding
curl -s http://localhost:8000/api/health >nul 2>&1
if !errorlevel! equ 0 (
    echo ✓ Backend server is responding!
) else (
    echo ? Backend server might still be starting...
    echo   Check the server window that opened.
)

echo.
echo ================================================
echo              SETUP COMPLETE!
echo ================================================
echo.
echo Your Laravel backend is now running on:
echo - http://localhost:8000 (for web/desktop)
echo - http://10.0.2.2:8000 (for Android emulator)
echo.
echo Backend API Health Check:
echo - http://localhost:8000/api/health
echo.
echo TO RUN YOUR FLUTTER APP:
echo 1. Make sure Android emulator is running
echo 2. Open a new terminal/command prompt
echo 3. Navigate to: d:\astacala_rescue_mobile\astacala_rescue_mobile
echo 4. Run: flutter run
echo.
echo TO TEST API CONNECTION:
echo flutter test test/manual/api_connectivity_test.dart
echo.
echo TROUBLESHOOTING:
echo - Keep the backend server window open
echo - If login fails, check the server window for errors
echo - For Android emulator, use 10.0.2.2:8000
echo - For web/desktop, use localhost:8000
echo.

cd /d "d:\astacala_rescue_mobile\astacala_rescue_mobile"

echo Ready to test! Press any key to finish...
pause >nul
echo.
echo You can now run: flutter run
