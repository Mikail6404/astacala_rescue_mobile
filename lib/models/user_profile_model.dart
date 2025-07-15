// package:astacala_rescue_mobile/models/user_profile_model.dart

class UserProfileModel {
  final String username;
  final String fullName;
  final String birthDate;
  final String phone;
  final String organization;
  final String? profileImageUrl;

  UserProfileModel({
    required this.username,
    required this.fullName,
    required this.birthDate,
    required this.phone,
    required this.organization,
    this.profileImageUrl,
  });
}
