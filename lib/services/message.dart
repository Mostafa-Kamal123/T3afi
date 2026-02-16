import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? message;
  final String? senderId;
  final DateTime? createdAt;

  Message({this.message, this.senderId, this.createdAt});

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    DateTime? created;
    final ts = jsonData['createdAt'];
    if (ts is Timestamp) {
      created = ts.toDate();
    } else if (ts is int) {
      created = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is String) {
      try {
        created = DateTime.tryParse(ts);
      } catch (_) {
        created = null;
      }
    }

    return Message(
      message:jsonData['message'] ?? '',
      senderId: jsonData['senderId'],
      createdAt: created,
    );
  }
}