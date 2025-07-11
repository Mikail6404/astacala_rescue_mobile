// package:astacala_rescue_mobile/models/disaster_report_card_model.dart

class DisasterReportCardModel {
  final String title;
  final String imageUrl;
  final int commentCount;
  final String weatherCondition; // This is the missing property
  final int temperature;

  const DisasterReportCardModel({
    required this.title,
    required this.imageUrl,
    required this.commentCount,
    required this.weatherCondition, // It also needs to be in the constructor
    required this.temperature,
  });
}