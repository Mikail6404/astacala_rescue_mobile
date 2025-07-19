// package:astacala_rescue_mobile/screens/auth/auth_wrapper.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/auth/auth_state.dart';
import 'package:astacala_rescue_mobile/screens/auth/welcome_screen.dart';
import 'package:astacala_rescue_mobile/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when the app starts
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder will rebuild the UI based on the AuthState
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          // Show loading screen while checking authentication
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Color(0xFF8B0000),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Astacala Rescue',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B0000),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Checking authentication...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AuthSuccess) {
          // If login is successful, show the MainScreen
          return const MainScreen();
        } else {
          // Otherwise, show the WelcomeScreen (for AuthInitial, AuthFailure, etc.)
          return const WelcomeScreen();
        }
      },
    );
  }
}
