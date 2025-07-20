#!/bin/bash
# Quick Mobile Testing Script
# run_mobile_tests.bat

@echo off
echo.
echo ========================================
echo      QUICK MOBILE TESTING SUITE
echo ========================================
echo.

echo 📱 Choose testing option:
echo.
echo 1. Unit Tests Only
echo 2. Backend Integration Tests
echo 3. Mobile Environment Tests
echo 4. Device Compatibility Tests
echo 5. Performance Tests
echo 6. All Mobile Tests
echo 7. Custom Test Selection
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" (
    echo.
    echo 🧪 Running Unit Tests...
    flutter test --reporter=expanded
) else if "%choice%"=="2" (
    echo.
    echo 🌐 Running Backend Integration Tests...
    flutter test test/mobile/backend_integration_test.dart --reporter=expanded
) else if "%choice%"=="3" (
    echo.
    echo 📱 Running Mobile Environment Tests...
    flutter test integration_test/mobile_environment_test.dart
) else if "%choice%"=="4" (
    echo.
    echo 🔧 Running Device Compatibility Tests...
    flutter test test/mobile/mobile_testing_suite.dart --plain-name="Device"
) else if "%choice%"=="5" (
    echo.
    echo ⚡ Running Performance Tests...
    flutter test test/mobile/mobile_testing_suite.dart --plain-name="Performance"
) else if "%choice%"=="6" (
    echo.
    echo 🚀 Running All Mobile Tests...
    echo.
    echo Step 1: Unit Tests
    flutter test --reporter=expanded
    echo.
    echo Step 2: Backend Integration
    flutter test test/mobile/backend_integration_test.dart
    echo.
    echo Step 3: Mobile Environment
    flutter test integration_test/mobile_environment_test.dart
    echo.
    echo Step 4: Performance Tests
    flutter test test/mobile/mobile_testing_suite.dart --plain-name="Performance"
) else if "%choice%"=="7" (
    echo.
    echo 🎯 Custom Test Selection
    echo Enter test file path or pattern:
    set /p custom_test="Test path: "
    flutter test %custom_test% --reporter=expanded
) else (
    echo Invalid choice. Exiting...
    pause
    exit /b 1
)

echo.
echo ========================================
echo           TESTING COMPLETED
echo ========================================
echo.

echo 📊 Test Results Summary:
echo Check the output above for detailed results
echo.

echo 💡 Next Steps:
echo 1. Review any failed tests
echo 2. Check code coverage
echo 3. Test on real devices
echo 4. Validate backend connectivity
echo.

echo 🔧 Troubleshooting Tips:
echo - Ensure backend server is running (XAMPP + Laravel)
echo - Check device/emulator connection
echo - Verify network connectivity
echo - Update Flutter and dependencies if needed
echo.

pause
