@echo off
echo ===============================================
echo     ASTACALA RESCUE - BACKEND STARTUP
echo ===============================================
echo.

echo Starting Laravel backend server...
echo This will make the API accessible for the mobile app.
echo.

cd /d "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"

echo ✅ Checking if server is already running...
netstat -an | findstr ":8000" >nul
if %ERRORLEVEL% equ 0 (
    echo ⚠️  Port 8000 is already in use. Stopping existing server...
    taskkill /f /im php.exe >nul 2>&1
    timeout /t 2 >nul
)

echo.
echo 🚀 Starting Laravel server on all interfaces...
echo    - For web/desktop: http://localhost:8000
echo    - For Android emulator: http://10.0.2.2:8000 
echo    - API endpoints: http://localhost:8000/api/*
echo.

php artisan serve --host=0.0.0.0 --port=8000

echo.
echo Server stopped.
pause
