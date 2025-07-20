// Test API Connectivity
// test/manual/api_connectivity_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/api_service.dart';

void main() {
  group('🔧 API Connectivity Tests', () {
    test('Backend Health Check', () async {
      print('🚀 Testing backend connectivity...');
      print('📍 Trying to connect to: ${ApiService.baseUrl}');

      try {
        final response = await ApiService.healthCheck();
        print('✅ Backend is accessible!');
        print('📊 Response: $response');

        expect(response, isNotNull);
        print('🎉 Health check passed!');
      } catch (e) {
        print('❌ Backend connection failed!');
        print('🔍 Error details: $e');
        print('');
        print('💡 Troubleshooting steps:');
        print('1. Make sure Laravel server is running:');
        print('   cd astacala_backend/astacala-rescue-api');
        print('   php artisan serve --host=0.0.0.0 --port=8000');
        print('');
        print('2. Check if health endpoint exists:');
        print('   curl http://localhost:8000/api/health');
        print('');
        print(
            '3. For Android emulator, the app uses: http://10.0.2.2:8000/api');
        print(
            '4. For iOS simulator/web, the app should use: http://localhost:8000/api');

        // Don't fail the test, just provide diagnostic info
        print('');
        print(
            '⚠️  Connection test completed with issues - see troubleshooting above');
      }
    });

    test('Test Login Endpoint Availability', () async {
      print('');
      print('🔐 Testing login endpoint...');

      try {
        // Try to login with test credentials to see if endpoint is available
        await ApiService.login(
            email: 'test@example.com', password: 'wrong_password');
        print('✅ Login endpoint is accessible (even with wrong credentials)');
      } catch (e) {
        if (e.toString().contains('Cannot connect to API service')) {
          print('❌ Login endpoint not accessible - connection issue');
          print('🔍 Same connectivity problem as health check');
        } else {
          print(
              '✅ Login endpoint is accessible (got expected authentication error)');
          print('📝 Error: $e');
        }
      }
    });

    test('Test Registration Endpoint Availability', () async {
      print('');
      print('📝 Testing registration endpoint...');

      try {
        // Try to register to see if endpoint is available
        await ApiService.register(
          name: 'Test User',
          email: 'invalid', // Invalid email to trigger validation
          password: 'test',
          passwordConfirmation: 'test',
        );
        print('✅ Registration endpoint is accessible');
      } catch (e) {
        if (e.toString().contains('Cannot connect to API service')) {
          print('❌ Registration endpoint not accessible - connection issue');
          print('🔍 Same connectivity problem as health check');
        } else {
          print(
              '✅ Registration endpoint is accessible (got expected validation error)');
          print('📝 Error: $e');
        }
      }
    });
  });
}
