// package:astacala_rescue_mobile/main.dart

import 'package:astacala_rescue_mobile/cubits/auth/auth_cubit.dart';
// Import the new wrapper
import 'package:astacala_rescue_mobile/screens/auth/auth_wrapper.dart';
import 'package:astacala_rescue_mobile/utils/app_colors.dart';
import 'package:astacala_rescue_mobile/utils/app_spacing.dart';
import 'package:astacala_rescue_mobile/utils/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const AuthWrapper(),
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // Enhanced AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.onSurface,
        titleTextStyle: AppTypography.headlineMedium.copyWith(
          color: AppColors.onSurface,
        ),
        iconTheme: IconThemeData(
          color: AppColors.onSurface,
          size: AppSpacing.iconSizeMedium,
        ),
        centerTitle: true,
        toolbarHeight: AppSpacing.appBarHeight,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // Enhanced Card Theme
      cardTheme: CardThemeData(
        elevation: AppSpacing.elevation3,
        shadowColor: AppColors.shadowMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      ),

      // Enhanced Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.lg,
            horizontal: AppSpacing.xxl,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          elevation: AppSpacing.elevation2,
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          textStyle: AppTypography.labelLarge,
          minimumSize: const Size(double.infinity, AppSpacing.buttonHeight),
        ),
      ),

      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
