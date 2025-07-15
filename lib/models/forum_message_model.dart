// package:astacala_rescue_mobile/models/forum_message_model.dart

class ForumMessageModel {
  final String userName;
  final String userImageUrl;
  final String timestamp;
  final String message;
  final List<ForumMessageModel> replies; // List for nested replies

  ForumMessageModel({
    required this.userName,
    required this.userImageUrl,
    required this.timestamp,
    required this.message,
    this.replies = const [],
  });
}
