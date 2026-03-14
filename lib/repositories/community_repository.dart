import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:t3afy/models/postmodel.dart';
import 'package:t3afy/models/reaction.dart';
import 'package:t3afy/models/usermodel.dart';


abstract class CommunityRepository {
  Future<void> addPost(PostModel post);
  Future<void> addReaction(String postId, Reaction reaction);
  Future<List<PostModel>> fetchPosts();
  Future<Map<String, UserModel>> fetchUsers();
}

class FirebaseCommunityRepository implements CommunityRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addPost(PostModel post) async {
    await firestore.collection('Posts').doc(post.id).set({
      'userId': post.userId,
      'text': post.text,
      'createdAt': Timestamp.fromDate(post.createdAt),
    });
  }

  @override
  Future<void> addReaction(String postId, Reaction reaction) async {
    await firestore.collection('Posts').doc(postId).collection('Reactions').add({
      'userId': reaction.userId,
      'type': reaction.type,
      'commentText': reaction.commentText ?? '',
      'createdAt': Timestamp.fromDate(reaction.createdAt),
    });
  }
Future<List<PostModel>> fetchPosts() async {
  final snapshot = await firestore
      .collection('Posts')
      .orderBy('createdAt', descending: true)
      .get();

  List<PostModel> posts = [];

  for (var doc in snapshot.docs) {
    final data = doc.data();

    // نجيب التفاعلات
    final reactionsSnapshot = await firestore
        .collection('Posts')
        .doc(doc.id)
        .collection('Reactions')
        .get();

    List<Reaction> reactions = reactionsSnapshot.docs.map((r) {
      final rData = r.data();

      return Reaction(
        userId: rData['userId'],
        type: rData['type'],
        commentText: rData['commentText'],
        createdAt: (rData['createdAt'] as Timestamp).toDate(),
      );
    }).toList();

    posts.add(
      PostModel(
        id: doc.id,
        userId: data['userId'],
        text: data['text'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        reactions: reactions,
      ),
    );
  }

  return posts;
}
  @override
Future<Map<String, UserModel>> fetchUsers() async {
  final snapshot = await firestore.collection('Users').get();

  return Map.fromEntries(snapshot.docs.map((doc) {
    final data = doc.data() as Map<String, dynamic>; // مهم جداً
    final user = UserModel.fromMap(data, doc.id);    // doc.id هنا
    return MapEntry(user.uid, user);
  }));
}}