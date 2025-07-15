// package:astacala_rescue_mobile/cubits/report/report_state.dart

import 'package:flutter/material.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportSubmissionLoading extends ReportState {}

class ReportSubmissionSuccess extends ReportState {}

class ReportSubmissionFailure extends ReportState {
  final String error;
  ReportSubmissionFailure(this.error);
}
