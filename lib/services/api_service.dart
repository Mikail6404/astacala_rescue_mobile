// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Backend API base URL
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // HTTP client instance
  static final http.Client _client = http.Client();

  // Authentication token storage key
  static const String _tokenKey = 'auth_token';

  // --- AUTHENTICATION METHODS ---

  /// Get stored authentication token
  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Store authentication token
  static Future<void> setAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Clear authentication token
  static Future<void> clearAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  /// Get headers with authentication token
  static Future<Map<String, String>> _getHeaders(
      {bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await getAuthToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Get headers for multipart requests
  static Future<Map<String, String>> _getMultipartHeaders() async {
    final headers = {
      'Accept': 'application/json',
    };

    final token = await getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // --- HTTP HELPER METHODS ---

  /// Generic GET request
  static Future<Map<String, dynamic>> _get(String endpoint,
      {bool includeAuth = true}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await _client.get(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  static Future<Map<String, dynamic>> _post(
      String endpoint, Map<String, dynamic> data,
      {bool includeAuth = true}) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(includeAuth: includeAuth);

      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  static Future<Map<String, dynamic>> _put(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();

      final response = await _client.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  static Future<Map<String, dynamic>> _delete(String endpoint) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders();

      final response = await _client.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Multipart request for file uploads
  static Future<Map<String, dynamic>> _postMultipart(
    String endpoint,
    Map<String, String> fields,
    Map<String, File> files,
  ) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', url);

      // Add headers
      final headers = await _getMultipartHeaders();
      request.headers.addAll(headers);

      // Add fields
      request.fields.addAll(fields);

      // Add files
      for (final entry in files.entries) {
        final file = await http.MultipartFile.fromPath(
          entry.key,
          entry.value.path,
        );
        request.files.add(file);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- RESPONSE HANDLING ---

  /// Handle HTTP response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    try {
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        return data;
      } else {
        throw ApiException(
          message: data['message'] ?? 'Request failed',
          statusCode: statusCode,
          errors: data['errors'],
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;

      throw ApiException(
        message: 'Failed to parse response: $body',
        statusCode: statusCode,
      );
    }
  }

  /// Handle request errors
  static Exception _handleError(dynamic error) {
    if (error is SocketException) {
      return ApiException(
        message:
            'No internet connection. Please check your network and try again.',
        statusCode: 0,
      );
    } else if (error is http.ClientException) {
      return ApiException(
        message: 'Connection failed. Please try again.',
        statusCode: 0,
      );
    } else if (error is ApiException) {
      return error;
    } else {
      return ApiException(
        message: 'An unexpected error occurred: ${error.toString()}',
        statusCode: 0,
      );
    }
  }

  // --- AUTHENTICATION API ENDPOINTS ---

  /// User login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final data = await _post(
        '/auth/login',
        {
          'email': email,
          'password': password,
        },
        includeAuth: false);

    // Store the token if login successful
    if (data['access_token'] != null) {
      await setAuthToken(data['access_token']);
    }

    return data;
  }

  /// User registration
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? organization,
    String? birthDate,
  }) async {
    final data = await _post(
        '/auth/register',
        {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          if (phone != null) 'phone': phone,
          if (organization != null) 'organization': organization,
          if (birthDate != null) 'birth_date': birthDate,
        },
        includeAuth: false);

    // Store the token if registration successful
    if (data['access_token'] != null) {
      await setAuthToken(data['access_token']);
    }

    return data;
  }

  /// User logout
  static Future<Map<String, dynamic>> logout() async {
    final data = await _post('/auth/logout', {});
    await clearAuthToken();
    return data;
  }

  // --- USER PROFILE API ENDPOINTS ---

  /// Get current user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    return await _get('/users/profile');
  }

  /// Update user profile
  static Future<Map<String, dynamic>> updateUserProfile({
    String? name,
    String? phone,
    String? organization,
    String? birthDate,
  }) async {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (organization != null) data['organization'] = organization;
    if (birthDate != null) data['birth_date'] = birthDate;

    return await _put('/users/profile', data);
  }

  /// Update user avatar
  static Future<Map<String, dynamic>> updateUserAvatar(File avatarFile) async {
    return await _postMultipart(
      '/users/avatar',
      {},
      {'avatar': avatarFile},
    );
  }

  // --- DISASTER REPORTS API ENDPOINTS ---

  /// Submit disaster report
  static Future<Map<String, dynamic>> submitDisasterReport({
    required String title,
    required String description,
    required String type,
    required String severity,
    required double latitude,
    required double longitude,
    String? location,
    List<File>? images,
  }) async {
    final fields = {
      'title': title,
      'description': description,
      'type': type,
      'severity': severity,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      if (location != null) 'location': location,
    };

    final files = <String, File>{};
    if (images != null && images.isNotEmpty) {
      for (int i = 0; i < images.length; i++) {
        files['images[$i]'] = images[i];
      }
    }

    return await _postMultipart('/reports', fields, files);
  }

  /// Get disaster reports
  static Future<Map<String, dynamic>> getDisasterReports({
    int page = 1,
    int perPage = 10,
    String? type,
    String? severity,
    String? status,
  }) async {
    String endpoint = '/reports?page=$page&per_page=$perPage';

    if (type != null) endpoint += '&type=$type';
    if (severity != null) endpoint += '&severity=$severity';
    if (status != null) endpoint += '&status=$status';

    return await _get(endpoint);
  }

  /// Get single disaster report
  static Future<Map<String, dynamic>> getDisasterReport(int reportId) async {
    return await _get('/reports/$reportId');
  }

  /// Update disaster report status (admin only)
  static Future<Map<String, dynamic>> updateReportStatus({
    required int reportId,
    required String status,
    String? adminNotes,
  }) async {
    return await _put('/reports/$reportId/status', {
      'status': status,
      if (adminNotes != null) 'admin_notes': adminNotes,
    });
  }

  /// Get dashboard statistics
  static Future<Map<String, dynamic>> getDashboardStatistics() async {
    return await _get('/reports/statistics');
  }

  // --- NOTIFICATIONS API ENDPOINTS ---

  /// Get user notifications
  static Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    return await _get('/notifications?page=$page&per_page=$perPage');
  }

  /// Mark notification as read
  static Future<Map<String, dynamic>> markNotificationAsRead(
      int notificationId) async {
    return await _put('/notifications/$notificationId/read', {});
  }

  /// Mark all notifications as read
  static Future<Map<String, dynamic>> markAllNotificationsAsRead() async {
    return await _put('/notifications/read-all', {});
  }

  /// Get unread notification count
  static Future<Map<String, dynamic>> getUnreadNotificationCount() async {
    return await _get('/notifications/unread-count');
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      final errorMessages = <String>[];
      errors!.forEach((key, value) {
        if (value is List) {
          errorMessages.addAll(value.cast<String>());
        } else {
          errorMessages.add(value.toString());
        }
      });
      return errorMessages.join(', ');
    }
    return message;
  }
}
