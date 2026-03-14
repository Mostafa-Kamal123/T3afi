import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t3afy/models/reaction.dart';
import 'package:t3afy/models/usermodel.dart';
class PostModel {
   final String id;
  final String userId;
  final String text;
  final DateTime createdAt;
  int likesCount;       // عدد اللايكات
  bool isLikedByMe;     // هل أنا حبيت البوست؟
  List<Reaction> reactions;

  PostModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
    this.likesCount = 0,
    this.isLikedByMe = false,
    this.reactions = const [],
  });

  

  factory PostModel.fromMap(Map<String, dynamic> map, String docId) {
    return PostModel(
      id: docId,
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      reactions: [], // ممكن تجيبيهم بعدين من الـ subcollection
    );
  }
}
// =======================
// Firestore Collections
// =======================
final usersCollection = FirebaseFirestore.instance.collection('users');
final postsCollection = FirebaseFirestore.instance.collection('Posts');

// =======================
// Fetch Users
// =======================
Future<Map<String, UserModel>> fetchUsers() async {
  final snapshot = await usersCollection.get();
  // بنعمل Map: UID -> UserModel
  return {
    for (var doc in snapshot.docs)
      doc.id: UserModel.fromMap(doc.data(), doc.id)
  };
}

// =======================
// Fetch Posts
// =======================
Future<List<PostModel>> fetchPosts(String currentUserId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('Posts')
      .orderBy('createdAt', descending: true)
      .get();

  List<PostModel> posts = [];

  for (var doc in snapshot.docs) {

    final post = PostModel.fromMap(doc.data(), doc.id);

    final reactionsSnapshot = await FirebaseFirestore.instance
        .collection('Posts')
        .doc(doc.id)
        .collection('Reactions')
        .get();

    for (var reactionDoc in reactionsSnapshot.docs) {

      final data = reactionDoc.data();

      post.reactions.add(
        Reaction(
          userId: data['userId'],
          type: data['type'],
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        ),
      );
    }

    posts.add(post);
  }

  return posts;
}