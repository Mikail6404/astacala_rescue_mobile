// Test helper utilities for Astacala Rescue Mobile
// test/helpers/test_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelpers {
  /// Creates a MaterialApp wrapper for testing widgets
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
    Locale? locale,
  }) {
    return MaterialApp(
      theme: theme ??
          ThemeData(
            primarySwatch: Colors.red,
            useMaterial3: true,
          ),
      locale: locale,
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Mock data for disaster reports
  static const List<Map<String, dynamic>> mockDisasterReports = [
    {
      'title': 'Banjir di Jakarta Selatan',
      'location': 'Kemang, Jakarta Selatan',
      'type': 'Banjir',
      'severity': 'Sedang',
      'victimCount': 10,
      'status': 'Sedang Ditangani',
      'time': '2 jam yang lalu',
      'coordinates': '-6.200000, 106.816666',
    },
  ];

  /// Custom matchers for testing
  static Matcher hasValidIndonesianPhoneNumber() {
    return predicate<String>(
      (phone) => RegExp(r'^08\d{8,}$').hasMatch(phone),
      'has valid Indonesian phone number format',
    );
  }
}
