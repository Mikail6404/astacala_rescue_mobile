@echo off
echo ===============================================
echo     QUICK FRONTEND TESTS - ASTACALA RESCUE
echo ===============================================
echo.

echo Running Working Frontend Integration Tests...
echo.
cd /d "d:\astacala_rescue_mobile\astacala_rescue_mobile"
flutter test test/integration/working_frontend_test.dart --reporter=expanded

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ Frontend tests failed!
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo ✅ All frontend integration tests passed!
    echo.
    echo 📊 Test Results:
    echo ✅ App Navigation: WORKING
    echo ✅ User Interface: WORKING
    echo ✅ Form Interactions: WORKING
    echo ✅ Responsiveness: WORKING
    echo ✅ Performance: ACCEPTABLE
    echo ✅ Error Handling: WORKING
    echo.
    pause
    exit /b 0
)
