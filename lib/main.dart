// package:astacala_rescue_mobile/main.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
import 'package:astacala_rescue_mobile/cubits/report/report_cubit.dart';
// Import the new wrapper
import 'package:astacala_rescue_mobile/screens/auth/auth_wrapper.dart';
import 'package:astacala_rescue_mobile/screens/report/report_wizard_screen.dart';
import 'package:astacala_rescue_mobile/screens/map/map_screen.dart';
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
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B0000),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Color(0xFF2C3E50),
            titleTextStyle: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          cardTheme: CardTheme(
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B0000),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B0000), width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthWrapper(),
        routes: {
          '/report': (context) => BlocProvider(
                create: (context) => ReportCubit(),
                child: const ReportWizardScreen(),
              ),
          '/map': (context) => const MapScreen(),
        },
      ),
    );
  }
}
