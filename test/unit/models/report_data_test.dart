// Unit tests for ReportData model
// test/unit/models/report_data_test.dart

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';

void main() {
  group('ReportData Model Tests', () {
    late ReportData testReportData;

    setUp(() {
      testReportData = ReportData(
        teamName: 'Tim Rescue Jakarta',
        personnelCount: 5,
        phone: '081234567890',
        disasterInfo: 'Banjir di Jakarta Selatan',
        location: 'Jakarta Selatan',
        coordinates: '-6.200000, 106.816666',
        description: 'Banjir setinggi 2 meter',
        victimCount: 10,
        disasterType: 'Banjir',
        severity: 'Sedang',
        gpsLocation: const LatLng(-6.200000, 106.816666),
      );
    });

    test('should create ReportData with required fields', () {
      expect(testReportData.teamName, 'Tim Rescue Jakarta');
      expect(testReportData.personnelCount, 5);
      expect(testReportData.phone, '081234567890');
      expect(testReportData.disasterInfo, 'Banjir di Jakarta Selatan');
      expect(testReportData.location, 'Jakarta Selatan');
    });

    test('should handle optional fields correctly', () {
      expect(testReportData.disasterType, 'Banjir');
      expect(testReportData.severity, 'Sedang');
      expect(testReportData.gpsLocation, const LatLng(-6.200000, 106.816666));
      expect(testReportData.image, null);
      expect(testReportData.images, null);
    });

    test('should validate victim count is non-negative', () {
      expect(testReportData.victimCount, greaterThanOrEqualTo(0));
      expect(testReportData.victimCount, 10);
    });

    test('should validate personnel count is positive', () {
      expect(testReportData.personnelCount, greaterThan(0));
      expect(testReportData.personnelCount, 5);
    });

    test('should handle GPS coordinates correctly', () {
      expect(testReportData.gpsLocation?.latitude, -6.200000);
      expect(testReportData.gpsLocation?.longitude, 106.816666);
    });

    test('should create ReportData with minimal required fields', () {
      final minimalReport = ReportData(
        teamName: 'Tim Minimal',
        personnelCount: 1,
        phone: '081111111111',
        disasterInfo: 'Test disaster',
        location: 'Test location',
        coordinates: '0.0, 0.0',
        description: 'Test description',
        victimCount: 0,
      );

      expect(minimalReport.teamName, 'Tim Minimal');
      expect(minimalReport.victimCount, 0);
      expect(minimalReport.disasterType, null);
      expect(minimalReport.severity, null);
    });

    test('should handle phone number validation format', () {
      expect(testReportData.phone, matches(r'^\d+$')); // Only digits
      expect(testReportData.phone.length, greaterThanOrEqualTo(10));
    });

    test('should handle coordinates string format', () {
      expect(testReportData.coordinates, contains(','));
      final parts = testReportData.coordinates.split(',');
      expect(parts.length, 2);
      expect(double.tryParse(parts[0].trim()), isNotNull);
      expect(double.tryParse(parts[1].trim()), isNotNull);
    });

    test('should handle images list correctly', () {
      final reportWithImages = ReportData(
        teamName: 'Test Team',
        personnelCount: 1,
        phone: '081234567890',
        disasterInfo: 'Test',
        location: 'Test',
        coordinates: '0.0, 0.0',
        description: 'Test',
        victimCount: 0,
        images: <File>[], // Empty list for testing
      );

      expect(reportWithImages.images, isNotNull);
      expect(reportWithImages.images, isEmpty);
    });
  });

  group('ReportData Edge Cases', () {
    test('should handle empty string fields', () {
      final reportWithEmptyFields = ReportData(
        teamName: '',
        personnelCount: 1,
        phone: '',
        disasterInfo: '',
        location: '',
        coordinates: '0.0, 0.0',
        description: '',
        victimCount: 0,
      );

      expect(reportWithEmptyFields.teamName, isEmpty);
      expect(reportWithEmptyFields.phone, isEmpty);
      expect(reportWithEmptyFields.disasterInfo, isEmpty);
    });

    test('should handle very large victim count', () {
      final reportWithLargeCount = ReportData(
        teamName: 'Test Team',
        personnelCount: 1,
        phone: '081234567890',
        disasterInfo: 'Major disaster',
        location: 'Test',
        coordinates: '0.0, 0.0',
        description: 'Large scale disaster',
        victimCount: 10000,
      );

      expect(reportWithLargeCount.victimCount, 10000);
    });

    test('should handle extreme GPS coordinates', () {
      final reportWithExtremeCoords = ReportData(
        teamName: 'Test Team',
        personnelCount: 1,
        phone: '081234567890',
        disasterInfo: 'Test',
        location: 'Test',
        coordinates: '0.0, 0.0',
        description: 'Test',
        victimCount: 0,
        gpsLocation: const LatLng(90.0, 180.0), // Max valid coordinates
      );

      expect(reportWithExtremeCoords.gpsLocation?.latitude, 90.0);
      expect(reportWithExtremeCoords.gpsLocation?.longitude, 180.0);
    });
  });
}
