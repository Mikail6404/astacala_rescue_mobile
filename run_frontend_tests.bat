@echo off
echo Running Astacala Rescue Frontend Tests...
echo.

echo Testing Models...
flutter test test/unit/models/report_data_test.dart
if errorlevel 1 (
    echo FAILED: Model tests failed
    pause
    exit /b 1
)

flutter test test/unit/models/user_profile_model_test.dart
if errorlevel 1 (
    echo FAILED: User profile model tests failed
    pause
    exit /b 1
)

echo.
echo Testing Widgets...
flutter test test/widget/screens/home_screen_test.dart
if errorlevel 1 (
    echo FAILED: Home screen widget tests failed
    pause
    exit /b 1
)

flutter test test/widget/widgets/disaster_card_test.dart
if errorlevel 1 (
    echo FAILED: Disaster card widget tests failed
    pause
    exit /b 1
)

echo.
echo Testing Integration Flows...
flutter test test/integration/user_flows/disaster_reporting_flow_test.dart
if errorlevel 1 (
    echo FAILED: Integration tests failed
    pause
    exit /b 1
)

echo.
echo All frontend tests passed successfully!
echo.
echo Test Summary:
echo - Model Tests: PASSED
echo - Widget Tests: PASSED  
echo - Integration Tests: PASSED
echo.
echo Frontend testing implementation complete!
pause
