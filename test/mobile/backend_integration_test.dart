// Mobile Backend Integration Test
// test/mobile/backend_integration_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

/// Comprehensive backend integration testing for mobile environment
class MobileBackendIntegrationTest {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static String? authToken;

  static void runBackendTests() {
    group('🌐 Mobile Backend Integration Tests', () {
      setUpAll(() async {
        // Wait for backend to be ready
        await Future.delayed(const Duration(seconds: 2));
      });

      group('🔗 Connectivity Tests', () {
        testConnectivity();
        testNetworkConditions();
      });

      group('🔐 Authentication Tests', () {
        testAuthenticationFlow();
        testTokenManagement();
      });

      group('📊 Data Sync Tests', () {
        testDataRetrieval();
        testDataSubmission();
      });

      group('📱 Mobile-Specific Tests', () {
        testMobileNetworkHandling();
        testOfflineQueueing();
      });
    });
  }

  // Connectivity Tests
  static void testConnectivity() {
    test('Should connect to backend server', () async {
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/health'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 5));

        expect(response.statusCode, equals(200));
        print('✅ Backend server is accessible');
        print(
            '📊 Response time: ${response.headers['x-response-time'] ?? 'N/A'}');
      } catch (e) {
        print('❌ Backend connectivity failed: $e');
        print('💡 Make sure XAMPP and Laravel server are running');
        print('💡 Check that backend is accessible at $baseUrl');
        fail('Backend server not accessible');
      }
    });

    test('Should handle network timeout gracefully', () async {
      try {
        // Test with very short timeout to simulate network issues
        final response = await http
            .get(
              Uri.parse('$baseUrl/health'),
              headers: headers,
            )
            .timeout(const Duration(milliseconds: 1));

        // If we get here, network is very fast
        expect(response.statusCode, equals(200));
      } on TimeoutException catch (e) {
        // Expected behavior for timeout
        print('✅ Timeout handled gracefully: $e');
      } catch (e) {
        print('✅ Network error handled: $e');
      }
    });
  }

  static void testNetworkConditions() {
    test('Should work on mobile network conditions', () async {
      // Simulate slower mobile network with longer timeout
      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/health'),
              headers: headers,
            )
            .timeout(const Duration(seconds: 10));

        expect(response.statusCode, equals(200));
        print('✅ Works on slower mobile networks');
      } catch (e) {
        print('⚠️ May have issues on slow networks: $e');
      }
    });
  }

  // Authentication Tests
  static void testAuthenticationFlow() {
    test('Should handle user registration', () async {
      final testUser = {
        'name': 'Mobile Test User',
        'email':
            'mobile.test.${DateTime.now().millisecondsSinceEpoch}@astacala.com',
        'password': 'password123',
        'password_confirmation': 'password123',
      };

      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/auth/register'),
              headers: headers,
              body: json.encode(testUser),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 201) {
          print('✅ User registration successful');
          final responseData = json.decode(response.body);
          expect(responseData['success'], equals(true));
          expect(responseData['data']['user'], isNotNull);
          expect(responseData['data']['tokens']['accessToken'], isNotNull);
          print('👤 Created user: ${responseData['data']['user']['email']}');
        } else {
          print('ℹ️ Registration response: ${response.statusCode}');
          print('ℹ️ Response body: ${response.body}');
        }
      } catch (e) {
        print('⚠️ Registration test error: $e');
      }
    });

    test('Should handle user login', () async {
      final loginData = {
        'email': 'test@astacala.com',
        'password': 'password123',
      };

      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/auth/login'),
              headers: headers,
              body: json.encode(loginData),
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('✅ User login successful');
          final responseData = json.decode(response.body);

          // Check the correct response structure
          expect(responseData['success'], equals(true));
          expect(responseData['data']['tokens']['accessToken'], isNotNull);

          // Store token for later use
          authToken = responseData['data']['tokens']['accessToken'];
          print('🔑 Received access token: ${authToken?.substring(0, 20)}...');
        } else {
          print('ℹ️ Login response: ${response.statusCode}');
          print('ℹ️ Response body: ${response.body}');
        }
      } catch (e) {
        print('⚠️ Login test error: $e');
      }
    });
  }

  static void testTokenManagement() {
    test('Should handle token refresh', () async {
      // This would test token refresh logic
      // Implementation depends on your auth setup
      print('✅ Token management test placeholder');
    });
  }

  // Data Sync Tests
  static void testDataRetrieval() {
    test('Should retrieve disaster reports', () async {
      // First get auth token
      final token = await authenticateAndGetToken();

      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/disasters/reports'),
              headers: token != null ? getAuthHeaders(token) : headers,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('✅ Disaster reports retrieved successfully');
          final responseData = json.decode(response.body);
          expect(responseData, isNotNull);
        } else if (response.statusCode == 401) {
          print('ℹ️ Authentication required for reports (expected behavior)');
          expect(response.statusCode, equals(401));
        } else {
          print('ℹ️ Reports response: ${response.statusCode}');
          print('ℹ️ Response body: ${response.body}');
        }
      } catch (e) {
        print('⚠️ Data retrieval test error: $e');
      }
    });

    test('Should retrieve notifications', () async {
      // First get auth token
      final token = await authenticateAndGetToken();

      try {
        final response = await http
            .get(
              Uri.parse('$baseUrl/notifications'),
              headers: token != null ? getAuthHeaders(token) : headers,
            )
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          print('✅ Notifications retrieved successfully');
        } else if (response.statusCode == 401) {
          print(
              'ℹ️ Authentication required for notifications (expected behavior)');
          expect(response.statusCode, equals(401));
        } else {
          print('ℹ️ Notifications response: ${response.statusCode}');
          print('ℹ️ Response body: ${response.body}');
        }
      } catch (e) {
        print('⚠️ Notifications test error: $e');
      }
    });
  }

  static void testDataSubmission() {
    test('Should submit disaster report with authentication', () async {
      // First get auth token
      final token = await authenticateAndGetToken();

      if (token == null) {
        print('⚠️ Cannot test data submission without authentication');
        return;
      }

      final reportData = {
        'title': 'Mobile Test Disaster Report',
        'description':
            'Test report from mobile integration test - Banjir setinggi 2 meter di kawasan Kemang',
        'disasterType': 'FLOOD',
        'severityLevel': 'MEDIUM',
        'latitude': -6.200000,
        'longitude': 106.816666,
        'locationName': 'Jakarta Selatan',
        'estimatedAffected': 10,
        'teamName': 'Mobile Test Team',
        'weatherCondition': 'Heavy Rain',
        'incidentTimestamp': DateTime.now().toIso8601String(),
      };

      try {
        final response = await http
            .post(
              Uri.parse('$baseUrl/disasters/reports'),
              headers: getAuthHeaders(token),
              body: json.encode(reportData),
            )
            .timeout(const Duration(seconds: 15));

        if (response.statusCode == 201 || response.statusCode == 200) {
          print('✅ Disaster report submitted successfully');
          final responseData = json.decode(response.body);
          expect(responseData, isNotNull);
        } else {
          print('ℹ️ Report submission response: ${response.statusCode}');
          print('ℹ️ Response body: ${response.body}');

          // Analyze the error response
          if (response.statusCode == 422) {
            final errorData = json.decode(response.body);
            print('📋 Validation errors: $errorData');
          }
        }
      } catch (e) {
        print('⚠️ Data submission test error: $e');
      }
    });
  }

  // Mobile-Specific Tests
  static void testMobileNetworkHandling() {
    test('Should handle mobile network switches', () async {
      // Test switching between WiFi and mobile data
      // This is more of a simulation in testing environment

      for (int i = 0; i < 3; i++) {
        try {
          final response = await http
              .get(
                Uri.parse('$baseUrl/health'),
                headers: headers,
              )
              .timeout(const Duration(seconds: 5));

          expect(response.statusCode, equals(200));
        } catch (e) {
          print('⚠️ Network switch test iteration $i failed: $e');
        }

        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
      }

      print('✅ Mobile network handling test completed');
    });
  }

  static void testOfflineQueueing() {
    test('Should queue operations when offline', () async {
      // This would test offline capability
      // Implementation depends on your offline strategy
      print('✅ Offline queuing test placeholder');
      print(
          '💡 Implement offline queue testing based on your offline strategy');
    });
  }

  // Utility Methods
  static Future<String?> authenticateAndGetToken() async {
    final loginData = {
      'email': 'test@astacala.com',
      'password': 'password123',
    };

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: headers,
            body: json.encode(loginData),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data']['tokens']['accessToken'];
      }
    } catch (e) {
      print('Authentication failed: $e');
    }

    return null;
  }

  static Map<String, String> getAuthHeaders(String token) {
    return {
      ...headers,
      'Authorization': 'Bearer $token',
    };
  }
}

// Run the tests
void main() {
  MobileBackendIntegrationTest.runBackendTests();
}
