// package:astacala_rescue_mobile/cubits/report/report_state.dart

import 'package:flutter/material.dart';

@immutable
abstract class ReportState {}

class ReportInitial extends ReportState {}

// Report submission states
class ReportSubmissionLoading extends ReportState {}

class ReportSubmissionSuccess extends ReportState {}

class ReportSubmissionFailure extends ReportState {
  final String error;
  ReportSubmissionFailure(this.error);
}

// Report fetching states
class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final Map<String, dynamic> data;
  ReportLoaded(this.data);
}

class ReportFailure extends ReportState {
  final String error;
  ReportFailure(this.error);
}

// Dashboard statistics states
class DashboardStatsLoaded extends ReportState {
  final Map<String, dynamic> stats;
  DashboardStatsLoaded(this.stats);
}
