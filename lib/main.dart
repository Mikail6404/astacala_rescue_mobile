// package:astacala_rescue_mobile/main.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
// Import the new wrapper
import 'package:astacala_rescue_mobile/screens/auth/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the AuthCubit to the entire app
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: MaterialApp(
        title: 'Astacala Rescue',
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}