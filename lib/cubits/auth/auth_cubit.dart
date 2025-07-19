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
      // Call the real API endpoint (using email field since our backend expects email)
      final response = await ApiService.login(
        email:
            emailOrUsername, // Backend expects email, but users can enter username or email
        password: password,
      );

      // Check if we received user data
      if (response['user'] != null && response['access_token'] != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Login failed: Invalid response from server'));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(e.toString()));
    } catch (e) {
      emit(AuthFailure('Login failed: ${e.toString()}'));
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
      // Call the real API endpoint
      final response = await ApiService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
        organization: organization,
        birthDate: birthDate,
      );

      // Check if registration was successful
      if (response['user'] != null && response['access_token'] != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure('Registration failed: Invalid response from server'));
      }
    } on ApiException catch (e) {
      emit(AuthFailure(e.toString()));
    } catch (e) {
      emit(AuthFailure('Registration failed: ${e.toString()}'));
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
    if (token != null) {
      // Token exists, but we should verify it's still valid
      try {
        // Try to get user profile to verify token validity
        await ApiService.getUserProfile();
        emit(AuthSuccess());
      } catch (e) {
        // Token is invalid or expired, clear it
        await ApiService.clearAuthToken();
        emit(AuthInitial());
      }
    } else {
      emit(AuthInitial());
    }
  }
}
