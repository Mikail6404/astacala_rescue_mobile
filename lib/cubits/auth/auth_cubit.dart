// package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astacala_rescue_mobile/cubits/auth/auth_state.dart';
import 'package:astacala_rescue_mobile/services/api_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // --- Login Logic ---
  Future<void> login(String emailOrUsername, String password) async {
    emit(AuthLoading());
    try {
      // Add timeout to prevent infinite loading
      final response = await ApiService.login(
        email: emailOrUsername,
        password: password,
      ).timeout(const Duration(seconds: 30));

      // Check if we received user data - handle Laravel Sanctum response structure
      // CRITICAL FIX (July 20, 2025): Laravel Sanctum uses nested response format
      // Expected: response['data']['user'] and response['data']['tokens']['accessToken']
      bool hasUser = false;
      bool hasToken = false;

      // Check for user data
      if (response['user'] != null) {
        hasUser = true;
      } else if (response['data'] != null && response['data']['user'] != null) {
        hasUser = true;
      }

      // Check for token (it's already stored by ApiService, just verify response structure)
      if (response['access_token'] != null ||
          response['token'] != null ||
          (response['data'] != null && response['data']['tokens'] != null)) {
        hasToken = true;
      }

      if (hasUser && (hasToken || response['success'] == true)) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Login failed: Invalid response from server'));
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout')) {
        emit(AuthFailure(
            'Login timeout. Please check your connection and try again.'));
      } else {
        emit(AuthFailure('Login failed: ${e.toString()}'));
      }
    }
  }

  // --- Registration Logic ---
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
    String? organization,
    String? birthDate,
  }) async {
    emit(AuthLoading());
    try {
      // Add timeout to prevent infinite loading
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        organization: organization,
        birthDate: birthDate,
      ).timeout(const Duration(seconds: 30));

      // Check if registration was successful - handle Laravel Sanctum response structure
      bool hasUser = false;
      bool hasToken = false;

      // Check for user data
      if (response['user'] != null) {
        hasUser = true;
      } else if (response['data'] != null && response['data']['user'] != null) {
        hasUser = true;
      }

      // Check for token (it's already stored by ApiService, just verify response structure)
      if (response['access_token'] != null ||
          response['token'] != null ||
          (response['data'] != null && response['data']['tokens'] != null)) {
        hasToken = true;
      }

      if (hasUser && (hasToken || response['success'] == true)) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Registration failed: Invalid response from server'));
      }
    } catch (e) {
      if (e.toString().contains('TimeoutException') ||
          e.toString().contains('timeout')) {
        emit(AuthFailure(
            'Registration timeout. Please check your connection and try again.'));
      } else {
        emit(AuthFailure('Registration failed: ${e.toString()}'));
      }
    }
  }

  // --- Logout Logic ---
  Future<void> logout() async {
    try {
      // Call the API logout endpoint to invalidate the token
      await ApiService.logout();
    } catch (e) {
      // Even if the API call fails, we still want to clear local auth state
      // This handles cases where the user is offline or the server is down
    } finally {
      // Always clear the authentication state
      emit(AuthInitial());
    }
  }

  // --- Check Authentication Status ---
  Future<void> checkAuthStatus() async {
    final token = await ApiService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      // Token exists - assume it's valid for faster startup
      // Only verify token validity if we need to make an authenticated request
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  // --- Verify Token Validity (when needed) ---
  Future<bool> verifyTokenValidity() async {
    final token = await ApiService.getAuthToken();
    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      // Try to get user profile to verify token validity
      await ApiService.getUserProfile();
      return true;
    } catch (e) {
      // Token is invalid or expired, clear it
      await ApiService.clearAuthToken();
      emit(AuthInitial());
      return false;
    }
  }
}
