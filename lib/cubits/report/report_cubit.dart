// package:astacala_rescue_mobile/cubits/report/report_cubit.dart

import 'package:astacala_rescue_mobile/cubits/report/report_state.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';
import 'package:astacala_rescue_mobile/services/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  Future<void> submitReport(ReportData data) async {
    emit(ReportSubmissionLoading());
    try {
      // Validate required fields
      if (data.teamName.isEmpty) {
        throw Exception('Team name cannot be empty');
      }

      if (data.gpsLocation == null) {
        throw Exception('Location is required');
      }

      // Call the real API endpoint
      await ApiService.submitDisasterReport(
        title: data.disasterInfo.isNotEmpty ? data.disasterInfo : data.teamName,
        description: _buildDescription(data),
        type: data.disasterType ?? 'other',
        severity: data.severity ?? 'medium',
        latitude: data.gpsLocation!.latitude,
        longitude: data.gpsLocation!.longitude,
        location: data.location,
        images: data.images,
      );

      emit(ReportSubmissionSuccess());
    } on ApiException catch (e) {
      emit(ReportSubmissionFailure(e.toString()));
    } catch (e) {
      emit(ReportSubmissionFailure(e.toString()));
    }
  }

  String _buildDescription(ReportData data) {
    final buffer = StringBuffer();

    // Add basic info
    buffer.writeln('Tim: ${data.teamName}');
    buffer.writeln('Jumlah Personel: ${data.personnelCount}');
    buffer.writeln('Kontak: ${data.phone}');

    // Add disaster details
    if (data.disasterInfo.isNotEmpty) {
      buffer.writeln('Info Bencana: ${data.disasterInfo}');
    }

    if (data.victimCount > 0) {
      buffer.writeln('Jumlah Korban: ${data.victimCount}');
    }

    if (data.disasterCondition != null && data.disasterCondition!.isNotEmpty) {
      buffer.writeln('Kondisi: ${data.disasterCondition}');
    }

    if (data.description.isNotEmpty) {
      buffer.writeln('Deskripsi: ${data.description}');
    }

    if (data.additionalNotes != null && data.additionalNotes!.isNotEmpty) {
      buffer.writeln('Catatan Tambahan: ${data.additionalNotes}');
    }

    return buffer.toString();
  }

  // New method to fetch submitted reports
  Future<void> fetchReports({
    int page = 1,
    String? type,
    String? severity,
    String? status,
  }) async {
    emit(ReportLoading());
    try {
      final response = await ApiService.getDisasterReports(
        page: page,
        type: type,
        severity: severity,
        status: status,
      );

      emit(ReportLoaded(response));
    } on ApiException catch (e) {
      emit(ReportFailure(e.toString()));
    } catch (e) {
      emit(ReportFailure('Failed to fetch reports: ${e.toString()}'));
    }
  }

  // Method to fetch dashboard statistics
  Future<void> fetchDashboardStats() async {
    try {
      final response = await ApiService.getDashboardStatistics();
      emit(DashboardStatsLoaded(response));
    } on ApiException catch (e) {
      emit(ReportFailure(e.toString()));
    } catch (e) {
      emit(ReportFailure('Failed to fetch dashboard stats: ${e.toString()}'));
    }
  }
}
