# 🚀 QUICK MANUAL SETUP GUIDE

## ✅ Backend Server is Running!

The Laravel backend server is now running on:
- **For web/desktop**: http://localhost:8000
- **For Android emulator**: http://10.0.2.2:8000
- **API Health Check**: http://localhost:8000/api/health

## 📱 How to Run Your Flutter App

### Step 1: Open Android Emulator
1. Open Android Studio
2. Start an Android emulator (any API level 28+)
3. Wait for the emulator to fully boot

### Step 2: Run Flutter App
```powershell
# Make sure you're in the Flutter project directory
cd "d:\astacala_rescue_mobile\astacala_rescue_mobile"

# Run the app
flutter run
```

### Step 3: Test Login/Signup
1. Try creating a new account or logging in
2. **Previous Error**: "No internet connection"
3. **New Error (if backend is not accessible)**: "Cannot connect to API service. Please ensure the backend server is running on localhost:8000"

## 🔧 Test API Connection (Optional)
```powershell
# Test if the API is working
flutter test test/manual/api_connectivity_test.dart
```

## ❌ If You See Connection Errors

### "Cannot connect to API service"
- ✅ Backend server is running (check the server terminal window)
- ✅ Use correct URL:
  - Android emulator: `http://10.0.2.2:8000/api`
  - Web: `http://localhost:8000/api`

### Check Backend Health
```powershell
# Test from command line
curl http://localhost:8000/api/health
```
Should return:
```json
{"status":"ok","message":"Astacala Rescue API is running","timestamp":"...","version":"1.0.0"}
```

## 🎯 What You Should See Now

### ✅ If Everything Works
- Login/signup forms work normally
- No "No internet connection" error
- App connects to local backend

### ❌ If There Are Still Issues
- Clear error message: "Cannot connect to API service..."
- Instructions to check backend server
- Helpful troubleshooting steps

## 🔄 Restart Backend Server (if needed)
If you need to restart the backend:
```powershell
# Stop current server (Ctrl+C in server terminal)
# Then restart:
cd "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"
php artisan serve --host=0.0.0.0 --port=8000
```

## 📋 Quick Commands Summary

```powershell
# 1. Start backend (if not already running)
cd "d:\astacala_rescue_mobile\astacala_backend\astacala-rescue-api"
php artisan serve --host=0.0.0.0 --port=8000

# 2. In another terminal, run Flutter app
cd "d:\astacala_rescue_mobile\astacala_rescue_mobile"
flutter run

# 3. Test API connectivity (optional)
flutter test test/manual/api_connectivity_test.dart
```

**The backend is ready! Now run `flutter run` and test your app!** 🎉
