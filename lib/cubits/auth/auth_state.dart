// package:astacala_rescue_mobile/cubits/auth/auth_state.dart

import 'package:flutter/material.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  // You can add a user object here later
  // final User user;
  // AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}
