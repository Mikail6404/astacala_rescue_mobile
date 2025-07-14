@echo off
echo Starting Android Emulator with safe settings...

echo Checking available AVDs...
"D:\Android_SDK\emulator\emulator.exe" -list-avds

echo.
echo Launching Medium_Phone with software rendering (safe mode)...
"D:\Android_SDK\emulator\emulator.exe" -avd Medium_Phone -gpu swiftshader_indirect -no-snapshot -wipe-data

pause
