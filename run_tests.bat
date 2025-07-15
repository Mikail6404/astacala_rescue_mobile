@echo off
REM Test runner script for Astacala Rescue Mobile
echo Running Frontend Interface Tests...

echo.
echo ========================================
echo Unit Tests - Models
echo ========================================
flutter test test/unit/models/ --reporter=expanded

echo.
echo ========================================  
echo Widget Tests - Screens
echo ========================================
flutter test test/widget/screens/ --reporter=expanded

echo.
echo ========================================
echo Integration Tests - User Flows  
echo ========================================
flutter test test/integration/user_flows/ --reporter=expanded

echo.
echo ========================================
echo Test Coverage Report
echo ========================================
flutter test --coverage

echo.
echo ========================================
echo Test Summary Complete
echo ========================================
pause
