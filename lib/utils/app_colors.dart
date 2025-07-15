// lib/utils/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Emergency Red Theme
  static const Color primary = Color(0xFF8B0000);
  static const Color primaryLight = Color(0xFFBA1E1E);
  static const Color primaryDark = Color(0xFF6D0000);
  static const Color primaryContainer = Color(0xFFFFECEC);

  // Secondary Colors - Supporting Blue
  static const Color secondary = Color(0xFF1976D2);
  static const Color secondaryLight = Color(0xFF42A5F5);
  static const Color secondaryDark = Color(0xFF0D47A1);
  static const Color secondaryContainer = Color(0xFFE3F2FD);

  // Surface Colors
  static const Color surface = Color(0xFFFFFBFF);
  static const Color surfaceVariant = Color(0xFFF3F0F4);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(0xFFF8F8F8);
  static const Color surfaceContainerHigh = Color(0xFFF0F0F0);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundGradientStart = Color(0xFFFAFAFA);
  static const Color backgroundGradientEnd = Color(0xFFF0F0F0);

  // Text Colors
  static const Color onBackground = Color(0xFF1C1B1F);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color onSurfaceVariant = Color(0xFF49454F);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Neutral Colors
  static const Color neutral10 = Color(0xFF1C1B1F);
  static const Color neutral20 = Color(0xFF313033);
  static const Color neutral30 = Color(0xFF484649);
  static const Color neutral40 = Color(0xFF605D62);
  static const Color neutral50 = Color(0xFF787579);
  static const Color neutral60 = Color(0xFF939094);
  static const Color neutral70 = Color(0xFFAEAAAE);
  static const Color neutral80 = Color(0xFFCAC4CA);
  static const Color neutral90 = Color(0xFFE6E0E6);
  static const Color neutral95 = Color(0xFFF4EFF4);
  static const Color neutral99 = Color(0xFFFFFBFF);

  // Semantic Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successContainer = Color(0xFFE8F5E8);
  static const Color onSuccess = Color(0xFFFFFFFF);
  static const Color onSuccessContainer = Color(0xFF1B5E20);

  static const Color warning = Color(0xFFF57C00);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color onWarning = Color(0xFFFFFFFF);
  static const Color onWarningContainer = Color(0xFFE65100);

  static const Color error = Color(0xFFD32F2F);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFFB71C1C);

  static const Color info = Color(0xFF1976D2);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color onInfo = Color(0xFFFFFFFF);
  static const Color onInfoContainer = Color(0xFF0D47A1);

  // Disaster Type Colors
  static const Color earthquake = Color(0xFF8D6E63);
  static const Color flood = Color(0xFF2196F3);
  static const Color fire = Color(0xFFFF5722);
  static const Color landslide = Color(0xFF795548);
  static const Color typhoon = Color(0xFF607D8B);

  // Emergency Status Colors
  static const Color criticalEmergency = Color(0xFFD32F2F);
  static const Color highEmergency = Color(0xFFF57C00);
  static const Color mediumEmergency = Color(0xFFFBC02D);
  static const Color lowEmergency = Color(0xFF689F38);
  static const Color resolvedEmergency = Color(0xFF388E3C);

  // Shadow Colors
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x14000000);
  static const Color shadowHard = Color(0x1A000000);

  // Gradient Collections
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [criticalEmergency, error],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF4CAF50)],
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundGradientStart, backgroundGradientEnd],
  );

  // Helper methods
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}
