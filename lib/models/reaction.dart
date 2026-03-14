// models/reaction_model.dart
class Reaction {
  final String userId;
  final String type; // 'like', 'share', 'comment'
  final String? commentText;
  final DateTime createdAt;

  Reaction({
    required this.userId,
    required this.type,
    this.commentText,
    required this.createdAt,
  });
}