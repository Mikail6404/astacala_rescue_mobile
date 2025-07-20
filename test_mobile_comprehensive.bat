#!/bin/bash
# Mobile Testing Script for Astacala Rescue Mobile
# test_mobile_comprehensive.bat

@echo off
echo.
echo ========================================
echo    ASTACALA MOBILE TESTING SUITE
echo ========================================
echo.

echo 📱 Starting comprehensive mobile testing...
echo.

echo ⚙️  Step 1: Checking Flutter environment...
flutter doctor -v
if %errorlevel% neq 0 (
    echo ❌ Flutter environment check failed
    pause
    exit /b 1
)
echo ✅ Flutter environment OK
echo.

echo 🔍 Step 2: Running static analysis...
flutter analyze
if %errorlevel% neq 0 (
    echo ❌ Static analysis failed
    pause
    exit /b 1
)
echo ✅ Static analysis passed
echo.

echo 🧪 Step 3: Running unit tests...
flutter test --reporter=expanded --coverage
if %errorlevel% neq 0 (
    echo ❌ Unit tests failed
    pause
    exit /b 1
)
echo ✅ Unit tests passed
echo.

echo 📊 Step 4: Generating test coverage report...
if exist "coverage\lcov.info" (
    echo ✅ Coverage report generated
) else (
    echo ⚠️  Coverage report not found
)
echo.

echo 🚀 Step 5: Building for Android testing...
flutter build apk --debug
if %errorlevel% neq 0 (
    echo ❌ Android build failed
    pause
    exit /b 1
)
echo ✅ Android debug build successful
echo.

echo 📱 Step 6: Checking connected devices...
flutter devices
echo.

echo 🔗 Step 7: Running integration tests on device...
echo Choose testing option:
echo 1. Run on Android emulator
echo 2. Run on connected device
echo 3. Skip device testing
echo.
set /p choice="Enter your choice (1-3): "

if "%choice%"=="1" (
    echo Running on Android emulator...
    flutter test integration_test/mobile_environment_test.dart
) else if "%choice%"=="2" (
    echo Running on connected device...
    flutter test integration_test/mobile_environment_test.dart
) else (
    echo Skipping device testing...
)
echo.

echo 🌐 Step 8: Testing backend connectivity...
echo Checking if backend server is running...
curl -s http://10.0.2.2:8000/api/health > nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend server is accessible
) else (
    echo ⚠️  Backend server not accessible at http://10.0.2.2:8000
    echo    Make sure XAMPP and Laravel server are running
)
echo.

echo 🎯 Step 9: Performance testing...
echo Running performance benchmarks...
flutter test test/mobile/mobile_testing_suite.dart --plain-name="Performance"
echo.

echo 📊 Step 10: Generating test report...
echo Creating comprehensive test report...
echo.
echo ========================================
echo          TEST RESULTS SUMMARY
echo ========================================
echo.
echo ✅ Static Analysis: PASSED
echo ✅ Unit Tests: PASSED
echo ✅ Build Process: PASSED
echo.
echo 📊 Coverage Report: See coverage/lcov.info
echo 📱 Integration Tests: See above results
echo 🌐 Backend Connectivity: See above results
echo.
echo ========================================
echo     MOBILE TESTING COMPLETED
echo ========================================
echo.
echo Next steps:
echo 1. Review test coverage report
echo 2. Test on different device sizes
echo 3. Test on real network conditions
echo 4. Test offline functionality
echo 5. Validate performance metrics
echo.
pause
