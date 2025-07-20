// lib/utils/connectivity_helper.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class ConnectivityHelper {
  /// Check if the backend API is accessible and show detailed debug info
  static Future<Map<String, dynamic>> checkBackendConnectivity() async {
    final result = <String, dynamic>{
      'connected': false,
      'error': null,
      'apiUrl': ApiService.baseUrl,
      'platform': _getPlatformInfo(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    try {
      if (kDebugMode) {
        print('🔍 Checking backend connectivity...');
        print('📍 API URL: ${ApiService.baseUrl}');
        print('🖥️  Platform: ${result['platform']}');
      }

      final response = await ApiService.healthCheck();

      result['connected'] = true;
      result['response'] = response;

      if (kDebugMode) {
        print('✅ Backend is accessible!');
        print('📊 Health check response: $response');
      }
    } catch (e) {
      result['error'] = e.toString();

      if (kDebugMode) {
        print('❌ Backend connection failed!');
        print('🔍 Error: $e');
        print('');
        print('💡 Troubleshooting for ${result['platform']}:');
        _printTroubleshootingSteps();
      }
    }

    return result;
  }

  static String _getPlatformInfo() {
    if (kIsWeb) return 'Web';

    try {
      if (Platform.isAndroid) return 'Android';
      if (Platform.isIOS) return 'iOS';
      if (Platform.isWindows) return 'Windows';
      if (Platform.isMacOS) return 'macOS';
      if (Platform.isLinux) return 'Linux';
    } catch (e) {
      // Handle case where Platform is not available
    }

    return 'Unknown';
  }

  static void _printTroubleshootingSteps() {
    print('1. ✅ Make sure Laravel server is running:');
    print('   cd astacala_backend/astacala-rescue-api');
    print('   php artisan serve --host=0.0.0.0 --port=8000');
    print('');
    print('2. ✅ Test health endpoint manually:');
    print('   curl http://localhost:8000/api/health');
    print('');
    print('3. 📱 For Android emulator:');
    print('   - App uses: http://10.0.2.2:8000/api');
    print('   - 10.0.2.2 maps to host machine localhost');
    print('   - Make sure emulator has internet access');
    print('');
    print('4. 🌐 For web/iOS simulator:');
    print('   - App uses: http://localhost:8000/api');
    print('   - Should work if server is running locally');
    print('');
    print('5. 🔥 Check firewall/antivirus:');
    print('   - Allow PHP/Laravel on port 8000');
    print('   - Allow emulator network access');
  }

  /// Show user-friendly connectivity status
  static String getUserFriendlyError(String error) {
    if (error.contains('Cannot connect to API service')) {
      return 'Cannot connect to the local server. Please make sure the backend is running.';
    } else if (error.contains('SocketException')) {
      return 'Network connection failed. Please check if the backend server is accessible.';
    } else if (error.contains('TimeoutException')) {
      return 'Connection timed out. The server might be slow or unreachable.';
    } else if (error.contains('401')) {
      return 'Authentication failed. Please check your credentials.';
    } else if (error.contains('422')) {
      return 'Validation error. Please check your input data.';
    } else if (error.contains('500')) {
      return 'Server error. Please check the backend logs.';
    } else {
      return 'Connection error: Please ensure the backend server is running.';
    }
  }
}
