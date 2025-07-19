# 📱 Mobile App Backend Integration Guide

**Project:** Astacala Rescue Mobile - Backend Integration  
**Date:** July 16, 2025  
**Frontend Status:** ✅ COMPLETE - 83+ Tests Passing  
**Backend Status:** ✅ COMPLETE - Production Ready  
**Integration Status:** 🔄 PENDING IMPLEMENTATION  

---

## 📋 **INTEGRATION OVERVIEW**

### **🎯 Current Mobile App State**
The Astacala Rescue Mobile application frontend is 100% complete with:
- ✅ **All UI Screens:** Login, Dashboard, Reports, Profile, Settings
- ✅ **State Management:** Complete BLoC/Cubit architecture
- ✅ **Mock Data System:** Fully functional with realistic test data
- ✅ **Testing Suite:** 83+ comprehensive tests (unit, widget, integration)
- ✅ **Material 3 Design:** Production-ready UI/UX implementation

### **🔗 Integration Objective**
Replace the current mock data system with real API calls to the Laravel backend, maintaining all existing functionality while adding persistent data storage and multi-user capabilities.

---

## 🗂️ **CRITICAL FILES FOR INTEGRATION**

### **📊 State Management (BLoC/Cubit Files)**
These files contain mock data that needs to be replaced with API calls:

#### **1. Authentication Management**
**File:** `lib/cubits/auth_cubit.dart`  
**Current State:** Mock login/register with hardcoded responses  
**Integration Needed:**
- Replace mock login with `/api/login` endpoint
- Replace mock register with `/api/register` endpoint  
- Implement JWT token storage and management
- Add logout functionality with `/api/logout`

```dart
// Current mock implementation (to be replaced):
Future<void> login(String email, String password) async {
  // Mock implementation with hardcoded success
}

// Integration target:
Future<void> login(String email, String password) async {
  final response = await apiClient.post('/api/login', {
    'email': email,
    'password': password,
  });
  // Handle real API response and token storage
}
```

#### **2. Disaster Report Management**
**File:** `lib/cubits/report_cubit.dart`  
**Current State:** Mock CRUD operations with local list storage  
**Integration Needed:**
- Connect to `/api/reports` for data fetching
- Implement report creation with image upload via `/api/reports`
- Add report update functionality
- Integrate filtering and search capabilities

```dart
// Current mock implementation:
Future<void> submitReport(DisasterReport report) async {
  // Mock implementation adding to local list
}

// Integration target:
Future<void> submitReport(DisasterReport report, List<File> images) async {
  final formData = FormData.fromMap({
    'title': report.title,
    'description': report.description,
    'type': report.type.name,
    // ... other fields
  });
  
  for (int i = 0; i < images.length; i++) {
    formData.files.add(MapEntry(
      'images[]',
      await MultipartFile.fromFile(images[i].path),
    ));
  }
  
  final response = await apiClient.post('/api/reports', data: formData);
}
```

#### **3. User Profile Management**
**File:** `lib/cubits/profile_cubit.dart`  
**Current State:** Mock profile data with local storage simulation  
**Integration Needed:**
- Connect to `/api/profile` for profile data
- Implement profile updates via `/api/profile`
- Add avatar upload functionality `/api/profile/avatar`

#### **4. Notification System**  
**File:** `lib/cubits/notification_cubit.dart`  
**Current State:** Mock notification list with static data  
**Integration Needed:**
- Connect to `/api/notifications` for real notifications
- Implement read status updates
- Add real-time notification support (WebSocket/Push)

### **📋 Data Models**
**Location:** `lib/models/`  
**Status:** ✅ READY - All models have proper JSON serialization  
**Files:**
- `user_model.dart` - Already matches API response structure
- `disaster_report_model.dart` - Compatible with backend schema  
- `notification_model.dart` - Ready for API integration

### **🌐 Network Layer (To Be Created)**
**Target Location:** `lib/services/`  
**Required Files:**
- `api_client.dart` - HTTP client with authentication
- `auth_service.dart` - JWT token management
- `upload_service.dart` - File upload functionality
- `error_handler.dart` - API error handling

---

## 🔧 **STEP-BY-STEP INTEGRATION PLAN**

### **Phase 1: API Client Setup**

#### **Step 1.1: Create HTTP Client Service**
**File:** `lib/services/api_client.dart`
```dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  late Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));
    
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle API errors globally
        handler.next(error);
      },
    ));
  }
  
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}
```

#### **Step 1.2: Install Required Dependencies**
Add to `pubspec.yaml`:
```yaml
dependencies:
  dio: ^5.3.2
  shared_preferences: ^2.2.2
  image_picker: ^1.0.4  # Already included
  path_provider: ^2.1.1
```

### **Phase 2: Authentication Integration**

#### **Step 2.1: Update AuthCubit**
**File:** `lib/cubits/auth_cubit.dart`

Replace existing mock methods with real API calls:

```dart
// Replace the mock login method
Future<void> login(String email, String password) async {
  emit(state.copyWith(status: AuthStatus.loading));
  
  try {
    final response = await _apiClient.post('/login', data: {
      'email': email,
      'password': password,
    });
    
    if (response.data['success']) {
      final userData = response.data['data'];
      final user = User.fromJson(userData['user']);
      final token = userData['token'];
      
      await _apiClient.setToken(token);
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: AuthStatus.error,
      error: _handleError(e),
    ));
  }
}

// Replace the mock register method
Future<void> register({
  required String name,
  required String email,
  required String password,
  required String phone,
}) async {
  emit(state.copyWith(status: AuthStatus.loading));
  
  try {
    final response = await _apiClient.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'phone': phone,
      'role': 'VOLUNTEER',
    });
    
    if (response.data['success']) {
      final userData = response.data['data'];
      final user = User.fromJson(userData['user']);
      final token = userData['token'];
      
      await _apiClient.setToken(token);
      
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: AuthStatus.error,
      error: _handleError(e),
    ));
  }
}

// Add logout functionality
Future<void> logout() async {
  try {
    await _apiClient.post('/logout');
  } catch (e) {
    // Handle error but continue with local logout
  } finally {
    await _apiClient.clearToken();
    emit(AuthState.initial());
  }
}
```

### **Phase 3: Disaster Report Integration**

#### **Step 3.1: Update ReportCubit**
**File:** `lib/cubits/report_cubit.dart`

```dart
// Replace mock data loading
Future<void> loadReports() async {
  emit(state.copyWith(status: ReportStatus.loading));
  
  try {
    final response = await _apiClient.get('/reports');
    
    if (response.data['success']) {
      final reportData = response.data['data'] as List;
      final reports = reportData.map((json) => DisasterReport.fromJson(json)).toList();
      
      emit(state.copyWith(
        status: ReportStatus.loaded,
        reports: reports,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: ReportStatus.error,
      error: _handleError(e),
    ));
  }
}

// Replace mock report submission
Future<void> submitReport(DisasterReport report, List<File> images) async {
  emit(state.copyWith(status: ReportStatus.loading));
  
  try {
    final formData = FormData.fromMap({
      'title': report.title,
      'description': report.description,
      'type': report.type.name,
      'severity': report.severity.name,
      'location[latitude]': report.location.latitude,
      'location[longitude]': report.location.longitude,
      'location[address]': report.location.address,
    });
    
    // Add metadata if available
    if (report.metadata.isNotEmpty) {
      report.metadata.forEach((key, value) {
        formData.fields.add(MapEntry('metadata[$key]', value.toString()));
      });
    }
    
    // Add images
    for (int i = 0; i < images.length; i++) {
      formData.files.add(MapEntry(
        'images[]',
        await MultipartFile.fromFile(
          images[i].path,
          filename: 'image_$i.jpg',
        ),
      ));
    }
    
    final response = await _apiClient.post('/reports', data: formData);
    
    if (response.data['success']) {
      final newReport = DisasterReport.fromJson(response.data['data']);
      
      emit(state.copyWith(
        status: ReportStatus.loaded,
        reports: [newReport, ...state.reports],
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: ReportStatus.error,
      error: _handleError(e),
    ));
  }
}

// Add statistics loading
Future<void> loadStatistics() async {
  try {
    final response = await _apiClient.get('/reports/statistics');
    
    if (response.data['success']) {
      final stats = response.data['data'];
      
      emit(state.copyWith(
        statistics: ReportStatistics.fromJson(stats),
      ));
    }
  } catch (e) {
    // Handle error silently for statistics
  }
}
```

### **Phase 4: Profile Integration**

#### **Step 4.1: Update ProfileCubit**
**File:** `lib/cubits/profile_cubit.dart`

```dart
// Replace mock profile loading
Future<void> loadProfile() async {
  emit(state.copyWith(status: ProfileStatus.loading));
  
  try {
    final response = await _apiClient.get('/profile');
    
    if (response.data['success']) {
      final user = User.fromJson(response.data['data']);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: user,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: ProfileStatus.error,
      error: _handleError(e),
    ));
  }
}

// Replace mock profile update
Future<void> updateProfile(User updatedUser) async {
  emit(state.copyWith(status: ProfileStatus.loading));
  
  try {
    final response = await _apiClient.put('/profile', data: {
      'name': updatedUser.name,
      'phone': updatedUser.phone,
      'bio': updatedUser.bio,
      if (updatedUser.location != null) ...{
        'location[latitude]': updatedUser.location!.latitude,
        'location[longitude]': updatedUser.location!.longitude,
        'location[address]': updatedUser.location!.address,
      },
    });
    
    if (response.data['success']) {
      final user = User.fromJson(response.data['data']);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: user,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: ProfileStatus.error,
      error: _handleError(e),
    ));
  }
}

// Add avatar upload functionality
Future<void> updateAvatar(File imageFile) async {
  emit(state.copyWith(status: ProfileStatus.loading));
  
  try {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'avatar.jpg',
      ),
    });
    
    final response = await _apiClient.post('/profile/avatar', data: formData);
    
    if (response.data['success']) {
      final user = User.fromJson(response.data['data']);
      
      emit(state.copyWith(
        status: ProfileStatus.loaded,
        user: user,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: ProfileStatus.error,
      error: _handleError(e),
    ));
  }
}
```

### **Phase 5: Notification Integration**

#### **Step 5.1: Update NotificationCubit**  
**File:** `lib/cubits/notification_cubit.dart`

```dart
// Replace mock notification loading
Future<void> loadNotifications() async {
  emit(state.copyWith(status: NotificationStatus.loading));
  
  try {
    final response = await _apiClient.get('/notifications');
    
    if (response.data['success']) {
      final notificationData = response.data['data'] as List;
      final notifications = notificationData
          .map((json) => NotificationModel.fromJson(json))
          .toList();
      
      emit(state.copyWith(
        status: NotificationStatus.loaded,
        notifications: notifications,
      ));
    }
  } catch (e) {
    emit(state.copyWith(
      status: NotificationStatus.error,
      error: _handleError(e),
    ));
  }
}

// Add mark as read functionality
Future<void> markAsRead(int notificationId) async {
  try {
    await _apiClient.post('/notifications/$notificationId/read');
    
    final updatedNotifications = state.notifications.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(readAt: DateTime.now());
      }
      return notification;
    }).toList();
    
    emit(state.copyWith(notifications: updatedNotifications));
  } catch (e) {
    // Handle error silently or show message
  }
}
```

---

## 🧪 **TESTING INTEGRATION**

### **🔧 Test Updates Required**

#### **1. Update Widget Tests**
**Files:** `test/widgets/` (all widget test files)
- **Mock API Responses:** Create mock HTTP client for testing
- **State Testing:** Ensure all state transitions work with real API flow
- **Error Handling:** Test API error scenarios

#### **2. Update Integration Tests**
**Files:** `integration_test/` 
- **End-to-End Flow:** Test complete user journey with backend
- **Authentication Flow:** Test login/register/logout cycle
- **Report Submission:** Test full report creation with image upload

#### **3. Create API Mock Service**
**File:** `test/mocks/mock_api_client.dart`
```dart
class MockApiClient extends Mock implements ApiClient {
  @override
  Future<Response> post(String path, {dynamic data}) async {
    // Return mock responses for testing
    if (path == '/login') {
      return Response(
        data: {
          'success': true,
          'data': {
            'user': mockUserJson,
            'token': 'mock_token_123'
          }
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: path),
      );
    }
    // Add other endpoints...
  }
}
```

### **📋 Testing Checklist**
- [ ] All 83+ existing tests updated and passing
- [ ] API client properly mocked in tests
- [ ] Authentication flow tested
- [ ] Report submission tested
- [ ] Profile management tested
- [ ] Error handling scenarios covered
- [ ] Network connectivity issues handled

---

## 🔒 **SECURITY CONSIDERATIONS**

### **🛡️ Authentication Security**
- **Token Storage:** Use Flutter Secure Storage for production
- **Token Refresh:** Implement automatic token refresh
- **Logout Security:** Clear all local data on logout

### **📁 File Upload Security**
- **File Validation:** Validate image types and sizes on client
- **Privacy:** Remove EXIF data from images before upload
- **Error Handling:** Handle upload failures gracefully

### **🌐 Network Security**
- **HTTPS:** Use HTTPS for production API calls
- **Certificate Pinning:** Implement for production security
- **Input Validation:** Validate all user inputs before API calls

---

## 🚀 **DEPLOYMENT CONSIDERATIONS**

### **📱 Mobile App Updates**
1. **Environment Configuration:**
   ```dart
   class ApiConfig {
     static const String baseUrl = kDebugMode 
       ? 'http://127.0.0.1:8000/api'  // Development
       : 'https://api.astacala-rescue.com/api';  // Production
   }
   ```

2. **Build Configuration:**
   - Update `android/app/src/main/AndroidManifest.xml` for network permissions
   - Configure iOS `Info.plist` for HTTP access in development

### **🔗 Backend Coordination**
- Ensure backend is running on `http://127.0.0.1:8000`
- Verify all API endpoints are accessible
- Test file upload functionality
- Confirm database connectivity

---

## ✅ **INTEGRATION SUCCESS CRITERIA**

### **🎯 Functional Requirements**
- [ ] User can register and login with persistent sessions
- [ ] Users can submit disaster reports with images
- [ ] Reports are saved to database and visible to all users
- [ ] Profile management works with avatar upload
- [ ] Notifications system shows real-time updates
- [ ] All existing app features continue to work

### **🧪 Technical Requirements**
- [ ] All 83+ tests pass with real backend integration
- [ ] API responses match expected data models
- [ ] Error handling works for network issues
- [ ] File uploads complete successfully
- [ ] Authentication persists across app restarts

### **📊 Performance Requirements**
- [ ] API calls complete within 30 seconds
- [ ] Image uploads handle files up to 10MB
- [ ] App remains responsive during API calls
- [ ] Loading states provide good user experience

---

## 🆘 **TROUBLESHOOTING GUIDE**

### **🔧 Common Issues**

#### **Issue: API Connection Failed**
**Symptoms:** All API calls return network errors
**Solutions:**
1. Verify backend server is running on `http://127.0.0.1:8000`
2. Check mobile device/emulator can access localhost
3. Ensure CORS is properly configured in backend

#### **Issue: Authentication Not Working**
**Symptoms:** Login succeeds but subsequent API calls return 401
**Solutions:**
1. Verify token is being stored correctly
2. Check token is added to Authorization header
3. Ensure Sanctum is configured properly in backend

#### **Issue: File Uploads Failing**
**Symptoms:** Image uploads return errors or don't appear
**Solutions:**
1. Verify `storage:link` was run in Laravel
2. Check file permissions on storage directory
3. Ensure multipart/form-data is being sent correctly

---

## 📞 **SUPPORT & CONTACT**

**Developer:** Muhammad Mikail Gabril  
**Institution:** Universitas Telkom - D3 Sistem Informasi  
**Repository:** https://github.com/Mikail6404/astacala_rescue_mobile/tree/nitro-AN-515-57  
**Backend Documentation:** `../astacala_backend/BACKEND_DEVELOPMENT_DOCUMENTATION.md`  

**Project Context:** Final Year Project (Tugas Akhir)  
**Industry Partner:** Yayasan Astacala  
**Integration Date:** July 16, 2025  

---

*This integration guide provides complete step-by-step instructions for connecting the Astacala Rescue Mobile app to its Laravel backend. Follow the phases sequentially to ensure successful integration while maintaining the app's existing functionality and comprehensive test coverage.*
