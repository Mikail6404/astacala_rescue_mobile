// package:astacala_rescue_mobile/cubits/report/report_cubit.dart

import 'package:astacala_rescue_mobile/cubits/report/report_state.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  Future<void> submitReport(ReportData data) async {
    emit(ReportSubmissionLoading());
    try {
      // TODO: Backend Integration - Replace with real API call
      // In a real app, you would send the data to your API here.
      // Example: await _apiService.submitReport(data.toJson());

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));

      // Mock validation - replace with actual API response handling
      if (data.teamName.isEmpty) {
        throw Exception('Team name cannot be empty');
      }

      emit(ReportSubmissionSuccess());
    } catch (e) {
      emit(ReportSubmissionFailure(e.toString()));
    }
  }
}
