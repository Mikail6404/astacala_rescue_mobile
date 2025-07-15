// Test helper utilities for Astacala Rescue Mobile
// test/helpers/test_helpers.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Common test utilities for frontend interface testing

class TestHelpers {
  /// Creates a basic MaterialApp wrapper for widget testing
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  /// Creates a MaterialApp with navigation for route testing
  static Widget createTestAppWithRoutes({
    required Widget home,
    Map<String, WidgetBuilder>? routes,
  }) {
    return MaterialApp(
      home: home,
      routes: routes ?? {},
    );
  }

  /// Pumps widget and waits for all animations to complete
  static Future<void> pumpAndSettleWidget(
    WidgetTester tester,
    Widget widget,
  ) async {
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
  }

  /// Enters text and triggers a frame
  static Future<void> enterTextAndPump(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Taps widget and triggers a frame
  static Future<void> tapAndPump(
    WidgetTester tester,
    Finder finder,
  ) async {
    await tester.tap(finder);
    await tester.pump();
  }

  /// Simulates scroll gesture
  static Future<void> scrollAndPump(
    WidgetTester tester,
    Finder finder,
    Offset offset,
  ) async {
    await tester.drag(finder, offset);
    await tester.pump();
  }

  /// Verifies text exists on screen
  static void expectTextExists(String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies text exists multiple times
  static void expectTextExistsMultiple(String text, int count) {
    expect(find.text(text), findsNWidgets(count));
  }

  /// Verifies widget type exists
  static void expectWidgetExists<T>() {
    expect(find.byType(T), findsOneWidget);
  }

  /// Verifies icon exists
  static void expectIconExists(IconData icon) {
    expect(find.byIcon(icon), findsOneWidget);
  }

  /// Verifies widget with key exists
  static void expectKeyExists(String key) {
    expect(find.byKey(Key(key)), findsOneWidget);
  }
}

/// Mock data for testing
class MockData {
  static const String sampleTeamName = 'Tim Alpha Jakarta';
  static const String samplePhone = '081234567890';
  static const String sampleLocation = 'Jakarta Selatan';
  static const String sampleCoordinates = '-6.200000, 106.816666';
  static const String sampleDescription =
      'Banjir setinggi 2 meter di kawasan Kemang';
  static const int sampleVictimCount = 10;
  static const int samplePersonnelCount = 5;

  static const List<String> disasterTypes = [
    'Banjir',
    'Gempa',
    'Kebakaran',
    'Tanah Longsor',
    'Tsunami',
  ];

  static const List<String> severityLevels = [
    'Ringan',
    'Sedang',
    'Berat',
    'Sangat Berat',
  ];

  static const List<Map<String, dynamic>> sampleDisasterReports = [
    {
      'title': 'Banjir di Jakarta Selatan',
      'location': 'Kemang, Jakarta Selatan',
      'type': 'Banjir',
      'severity': 'Sedang',
      'time': '2 jam yang lalu',
      'status': 'Sedang Ditangani',
      'victimCount': 10,
    },
    {
      'title': 'Gempa 6.2 SR di Bandung',
      'location': 'Bandung Barat',
      'type': 'Gempa',
      'severity': 'Berat',
      'time': '5 jam yang lalu',
      'status': 'Membutuhkan Bantuan',
      'victimCount': 25,
    },
    {
      'title': 'Kebakaran Pemukiman',
      'location': 'Tanah Abang, Jakarta Pusat',
      'type': 'Kebakaran',
      'severity': 'Sedang',
      'time': '1 hari yang lalu',
      'status': 'Tertangani',
      'victimCount': 0,
    },
  ];

  static const Map<String, dynamic> sampleUserProfile = {
    'username': 'john_rescuer',
    'fullName': 'John Doe',
    'birthDate': '1990-01-01',
    'phone': '081234567890',
    'organization': 'Astacala Rescue Jakarta',
    'profileImageUrl': 'https://example.com/profile.jpg',
  };
}

/// Custom matchers for testing
class CustomMatchers {
  /// Matches Indonesian phone number format
  static Matcher get isValidIndonesianPhone => matches(r'^08\d{8,}$');

  /// Matches coordinate format
  static Matcher get isValidCoordinates =>
      matches(r'^-?\d+\.?\d*,\s*-?\d+\.?\d*$');

  /// Matches date format YYYY-MM-DD
  static Matcher get isValidDateFormat => matches(r'^\d{4}-\d{2}-\d{2}$');

  /// Matches non-empty string
  static Matcher get isNonEmptyString => allOf(isA<String>(), isNot(isEmpty));

  /// Matches positive integer
  static Matcher get isPositiveInteger => allOf(isA<int>(), greaterThan(0));

  /// Matches non-negative integer
  static Matcher get isNonNegativeInteger =>
      allOf(isA<int>(), greaterThanOrEqualTo(0));
}

/// Form validation helpers
class FormValidationHelpers {
  /// Validates team name field
  static String? validateTeamName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nama tim wajib diisi';
    }
    if (value.trim().length < 3) {
      return 'Nama tim minimal 3 karakter';
    }
    return null;
  }

  /// Validates phone number field
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^08\d{8,}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  /// Validates personnel count
  static String? validatePersonnelCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Jumlah personil wajib diisi';
    }
    final count = int.tryParse(value);
    if (count == null || count <= 0) {
      return 'Jumlah personil harus lebih dari 0';
    }
    return null;
  }

  /// Validates victim count
  static String? validateVictimCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }
    final count = int.tryParse(value);
    if (count == null || count < 0) {
      return 'Jumlah korban tidak valid';
    }
    return null;
  }

  /// Validates description
  static String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Deskripsi wajib diisi';
    }
    if (value.trim().length < 10) {
      return 'Deskripsi minimal 10 karakter';
    }
    return null;
  }

  /// Validates coordinates
  static String? validateCoordinates(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Koordinat wajib diisi';
    }
    if (!RegExp(r'^-?\d+\.?\d*,\s*-?\d+\.?\d*$').hasMatch(value)) {
      return 'Format koordinat tidak valid (contoh: -6.200000, 106.816666)';
    }
    return null;
  }
}
