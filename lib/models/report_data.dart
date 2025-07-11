// package:astacala_rescue_mobile/models/report_data.dart

import 'dart:io';

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
  });
}