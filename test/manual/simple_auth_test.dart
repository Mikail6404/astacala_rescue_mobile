import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  group('🔧 Simple Auth Test', () {
    test('Direct HTTP Registration Test', () async {
      print('\n🧪 Testing registration directly with HTTP...');

      final email =
          'simple_test_${DateTime.now().millisecondsSinceEpoch}@example.com';
      final password = 'simplepassword123';

      print('📧 Email: $email');
      print('🔐 Password: $password');

      try {
        // Test registration with direct HTTP call
        final registerUrl =
            Uri.parse('http://localhost:8000/api/auth/register');
        final registerResponse = await http.post(
          registerUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'name': 'Simple Test User',
            'email': email,
            'password': password,
            'password_confirmation': password,
          }),
        );

        print('📊 Registration Status: ${registerResponse.statusCode}');
        print('📄 Registration Body: ${registerResponse.body}');

        if (registerResponse.statusCode == 201) {
          final registerData = jsonDecode(registerResponse.body);
          print('✅ Registration successful!');

          // Extract token
          String? token;
          if (registerData['data'] != null &&
              registerData['data']['tokens'] != null) {
            token = registerData['data']['tokens']['accessToken'];
            print('🔑 Token extracted: $token');
          }

          // Test login
          print('\n🔐 Testing login...');
          final loginUrl = Uri.parse('http://localhost:8000/api/auth/login');
          final loginResponse = await http.post(
            loginUrl,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          );

          print('📊 Login Status: ${loginResponse.statusCode}');
          print('📄 Login Body: ${loginResponse.body}');

          if (loginResponse.statusCode == 200) {
            print('✅ Login successful!');
            print('🎉 Full authentication flow working!');
          } else {
            print('❌ Login failed');
          }
        } else {
          print('❌ Registration failed');
          print('Error: ${registerResponse.body}');
        }
      } catch (e) {
        print('❌ Error: $e');
        throw e;
      }
    });
  });
}
