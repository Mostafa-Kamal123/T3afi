import 'package:cloud_firestore/cloud_firestore.dart';

// =======================
// User Model
// =======================
class UserModel {
  final String uid;  // هنا UID هي Document ID نفسه
  final String name;
  final String role;

  UserModel({required this.uid, required this.name, required this.role});

  // بنجيب البيانات من Firestore ونعين docId كـ UID
  factory UserModel.fromMap(Map<String, dynamic> data, String docId) {
    return UserModel(
      uid: docId,  
      name: data['name'] ?? '',       // لو name مش موجود نخليها فاضية
      role: data['role'] ?? 'Patient', // لو role مش موجود، نعتبره Patient
    );
  }

  // طريقة عرض الاسم + الدور
  String get displayName {
    final lowerRole = role.toLowerCase();  // نخلي المقارنة insensitive للحروف الكبيرة
    if (lowerRole == 'doctor') return 'Dr $name';
    if (lowerRole == 'admin') return 'Admin $name';
    return name; // Patient أو أي دور تاني
  }
}

// =======================
// Post Model
// =======================
class PostModel {
  final String id;
  final String userId; // Document ID للكاتب
  final String text;
  final DateTime createdAt;

  PostModel({required this.id, required this.userId, required this.text, required this.createdAt});

  factory PostModel.fromMap(Map<String, dynamic> data, String id) {
    return PostModel(
      id: id,
      userId: data['userId'],  // هنا لازم يكون ID اليوزر اللي كتب البوست
      text: data['text'] ?? '', // لو مافيش نص، نخليها فاضية
      createdAt: (data['createdAt'] as Timestamp).toDate(),
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
Future<List<PostModel>> fetchPosts() async {
  final snapshot = await postsCollection
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs
      .map((doc) => PostModel.fromMap(doc.data(), doc.id))
      .toList();
}