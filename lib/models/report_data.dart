// Enhanced Report Data Model for Comprehensive Disaster Reporting
// package:astacala_rescue_mobile/models/report_data.dart

import 'dart:io';
import 'package:latlong2/latlong.dart';

class ReportData {
  final String teamName;
  final int personnelCount;
  final String phone;
  final String disasterInfo;
  final String location;
  final String coordinates;
  final File? image;
  final String? disasterCondition;
  final int victimCount;
  final String description;

  // Enhanced fields for wizard
  final String? disasterType;
  final String? severity;
  final LatLng? gpsLocation;
  final List<File>? images;
  final String? additionalNotes;

  ReportData({
    required this.teamName,
    required this.personnelCount,
    required this.phone,
    required this.disasterInfo,
    required this.location,
    required this.coordinates,
    this.image,
    this.disasterCondition,
    required this.victimCount,
    required this.description,
    // Enhanced wizard fields
    this.disasterType,
    this.severity,
    this.gpsLocation,
    this.images,
    this.additionalNotes,
  });

  // Convert to JSON for API submission
  Map<String, dynamic> toJson() {
    return {
      'teamName': teamName,
      'personnelCount': personnelCount,
      'phone': phone,
      'disasterInfo': disasterInfo,
      'location': location,
      'coordinates': coordinates,
      'victimCount': victimCount,
      'description': description,
      'disasterType': disasterType,
      'severity': severity,
      'gpsLocation': gpsLocation != null
          ? {'lat': gpsLocation!.latitude, 'lng': gpsLocation!.longitude}
          : null,
      'imagesCount': images?.length ?? 0,
      'additionalNotes': additionalNotes,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  // Create from JSON (for API response)
  factory ReportData.fromJson(Map<String, dynamic> json) {
    return ReportData(
      teamName: json['teamName'] ?? '',
      personnelCount: json['personnelCount'] ?? 0,
      phone: json['phone'] ?? '',
      disasterInfo: json['disasterInfo'] ?? '',
      location: json['location'] ?? '',
      coordinates: json['coordinates'] ?? '',
      victimCount: json['victimCount'] ?? 0,
      description: json['description'] ?? '',
      disasterType: json['disasterType'],
      severity: json['severity'],
      gpsLocation: json['gpsLocation'] != null
          ? LatLng(json['gpsLocation']['lat'], json['gpsLocation']['lng'])
          : null,
      additionalNotes: json['additionalNotes'],
    );
  }
}
