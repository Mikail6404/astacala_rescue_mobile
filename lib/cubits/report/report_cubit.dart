// package:astacala_rescue_mobile/cubits/report/report_cubit.dart

import 'package:astacala_rescue_mobile/cubits/report/report_state.dart';
import 'package:astacala_rescue_mobile/models/report_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  Future<void> submitReport(ReportData data) async {
    emit(ReportSubmissionLoading());
    try {
      // In a real app, you would send the data to your API here.
      // For now, we'll just print it to the console to verify.
      print('--- Submitting Report ---');
      print('Team Name: ${data.teamName}');
      print('Personnel: ${data.personnelCount}');
      print('Location: ${data.location}');
      print('Coordinates: ${data.coordinates}');
      print('Image Path: ${data.image?.path}');
      print('-------------------------');

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 3));

      // You could add mock failure logic here if needed
      // if (data.teamName.isEmpty) throw Exception('Team name cannot be empty');

      emit(ReportSubmissionSuccess());
    } catch (e) {
      emit(ReportSubmissionFailure(e.toString()));
    }
  }
}