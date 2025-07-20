# Astacala Rescue - Local Environment Setup (PowerShell)
# setup_local_environment.ps1

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "  ASTACALA RESCUE - COMPLETE LOCAL SETUP" -ForegroundColor Cyan  
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "This script will:" -ForegroundColor Yellow
Write-Host "1. Start the Laravel backend server" -ForegroundColor White
Write-Host "2. Provide instructions for Flutter app" -ForegroundColor White
Write-Host "3. Run connectivity tests" -ForegroundColor White
Write-Host ""

Write-Host "[1/4] Checking prerequisites..." -ForegroundColor Green
Write-Host ""

# Check Laravel directory
$laravelPath = "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"
Write-Host "🔍 Checking Laravel backend directory..." -ForegroundColor Yellow
if (Test-Path $laravelPath) {
    Write-Host "✅ Laravel backend directory found!" -ForegroundColor Green
} else {
    Write-Host "❌ Laravel backend directory not found!" -ForegroundColor Red
    Write-Host "Expected location: $laravelPath" -ForegroundColor White
    Write-Host "Please check if the path is correct." -ForegroundColor White
    Read-Host "Press Enter to exit"
    exit 1
}

# Check Flutter
Write-Host ""
Write-Host "🔍 Checking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Flutter is available!" -ForegroundColor Green
        Write-Host "📊 Flutter version:" -ForegroundColor Cyan
        Write-Host $flutterVersion -ForegroundColor White
    } else {
        throw "Flutter command failed"
    }
} catch {
    Write-Host "❌ Flutter not found!" -ForegroundColor Red
    Write-Host "Please install Flutter and add it to PATH:" -ForegroundColor White
    Write-Host "1. Download from: https://flutter.dev/docs/get-started/install" -ForegroundColor White
    Write-Host "2. Add Flutter to your PATH environment variable" -ForegroundColor White
    Write-Host "3. Run 'flutter doctor' to verify installation" -ForegroundColor White
    Read-Host "Press Enter to exit"
    exit 1
}

# Check PHP
Write-Host ""
Write-Host "🔍 Checking PHP installation..." -ForegroundColor Yellow
try {
    $phpVersion = php --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ PHP is available!" -ForegroundColor Green
    } else {
        throw "PHP command failed"
    }
} catch {
    Write-Host "❌ PHP not found!" -ForegroundColor Red
    Write-Host "Laravel backend requires PHP:" -ForegroundColor White
    Write-Host "1. Download from: https://www.php.net/downloads" -ForegroundColor White
    Write-Host "2. Add PHP to your PATH environment variable" -ForegroundColor White
    Write-Host "3. Make sure Composer is also installed" -ForegroundColor White
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "✅ All prerequisites check passed!" -ForegroundColor Green
Write-Host ""

Write-Host "[2/4] Starting Laravel backend server..." -ForegroundColor Green
Set-Location $laravelPath

# Check if port 8000 is in use
$portInUse = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($portInUse) {
    Write-Host "⚠️  Port 8000 is already in use." -ForegroundColor Yellow
    Write-Host "This might be the Laravel server already running." -ForegroundColor White
} else {
    Write-Host "🚀 Starting Laravel server..." -ForegroundColor Yellow
    Write-Host "Opening new window for backend server..." -ForegroundColor White
    
    # Start Laravel server in new window
    Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$laravelPath'; Write-Host 'Starting Laravel backend server...' -ForegroundColor Green; php artisan serve --host=0.0.0.0 --port=8000"
    
    Write-Host "⏳ Waiting for backend to start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
}

Write-Host ""
Write-Host "[3/4] Testing backend accessibility..." -ForegroundColor Green
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/health" -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Backend is accessible!" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Cyan
} catch {
    Write-Host "⚠️  Backend might still be starting or not accessible..." -ForegroundColor Yellow
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor White
}

Write-Host ""
Write-Host "[4/4] Ready to test the mobile app!" -ForegroundColor Green
Write-Host ""
Write-Host "📱 To run the app:" -ForegroundColor Cyan
Write-Host "   1. Make sure Android emulator is running" -ForegroundColor White
Write-Host "   2. Run: flutter run" -ForegroundColor White
Write-Host ""
Write-Host "🔧 To test API connectivity:" -ForegroundColor Cyan
Write-Host "   flutter test test/manual/api_connectivity_test.dart" -ForegroundColor White
Write-Host ""
Write-Host "🌐 Backend URLs:" -ForegroundColor Cyan
Write-Host "   - Health check: http://localhost:8000/api/health" -ForegroundColor White
Write-Host "   - From Android emulator: http://10.0.2.2:8000/api/health" -ForegroundColor White
Write-Host ""
Write-Host "💡 If you see 'Cannot connect to API service':" -ForegroundColor Yellow
Write-Host "   1. Make sure the backend server window is running" -ForegroundColor White
Write-Host "   2. Check Android emulator has internet access" -ForegroundColor White
Write-Host "   3. Try restarting the emulator" -ForegroundColor White
Write-Host ""

Set-Location "d:\astacala_rescue_mobile\astacala_rescue_mobile"

Write-Host "Ready! You can now run 'flutter run' to start the app." -ForegroundColor Green
Write-Host ""
Read-Host "Press Enter to continue"
