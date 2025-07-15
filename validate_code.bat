@echo off
REM Validation script for Astacala Rescue Mobile
echo Starting code quality validation...

echo.
echo 1. Running Flutter Analyze...
flutter analyze

echo.
echo 2. Checking for deprecated API usage...
findstr /s /i "withOpacity" lib\*.dart
if %errorlevel% == 0 (
    echo WARNING: Found remaining withOpacity usage
) else (
    echo SUCCESS: No withOpacity usage found
)

echo.
echo 3. Checking for print statements...
findstr /s /i "print(" lib\*.dart
if %errorlevel% == 0 (
    echo WARNING: Found print statements
) else (
    echo SUCCESS: No print statements found
)

echo.
echo 4. Checking for modern API usage...
findstr /s /i "withValues" lib\*.dart | findstr /c:"alpha:" | wc -l
echo Modern withValues calls found

echo.
echo 5. Attempting build...
flutter build apk --debug

echo.
echo Validation complete!
pause
