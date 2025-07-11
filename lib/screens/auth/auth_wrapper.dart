// package:astacala_rescue_mobile/screens/auth/auth_wrapper.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/auth/auth_state.dart';
import 'package:astacala_rescue_mobile/screens/auth/welcome_screen.dart';
import 'package:astacala_rescue_mobile/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocBuilder will rebuild the UI based on the AuthState
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthSuccess) {
          // If login is successful, show the HomeScreen
          return const MainScreen();
        } else {
          // Otherwise, show the WelcomeScreen (for AuthInitial, AuthFailure, etc.)
          return const WelcomeScreen();
        }
      },
    );
  }
}