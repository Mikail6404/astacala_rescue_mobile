@echo off
echo Fixing Flutter build and emulator issues...

echo Step 1: Cleaning Flutter project...
flutter clean

echo Step 2: Clearing pub cache...
flutter pub cache clean

echo Step 3: Re-downloading dependencies...
flutter pub get

echo Step 4: Cleaning Android build...
cd android
call gradlew clean
cd ..

echo Step 5: Rebuilding Android...
flutter build apk --debug

echo Build fix complete!
pause
