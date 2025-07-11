// package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:astacala_rescue_mobile/cubits/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // --- Login Logic ---
  Future<void> login(String username, String password) async {
    emit(AuthLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock API logic: fail if password is "password"
      if (password == 'password') {
        throw Exception('Invalid credentials');
      }

      // On success
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // --- Registration Logic ---
  Future<void> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    emit(AuthLoading());
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      // Mock API logic: fail if username already exists
      if (username == 'mikail') {
          throw Exception('Username already exists');
      }

      // On success
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // --- Logout Logic ---
  Future<void> logout() async {
    // Here you might clear tokens or user data in a real app
    emit(AuthInitial());
  }
}