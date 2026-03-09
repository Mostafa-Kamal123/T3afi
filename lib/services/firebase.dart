import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// get all users
  Future<List<Map<String, dynamic>>> getUsers() async {

    final snapshot = await _db.collection("users").get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
Future<int> countStable() async {
  final snapshot = await _db
      .collection("users")
      .where("riskLevel", isEqualTo: "stable")
      .get();

  return snapshot.docs.length;
}

Future<int> countRisk() async {
  final snapshot = await _db
      .collection("users")
      .where("riskLevel", isEqualTo: "at risk")
      .get();

  return snapshot.docs.length;
}

Future<int> countRelapse() async {
  final snapshot = await _db
      .collection("users")
      .where("riskLevel", isEqualTo: "relapsed")
      .get();

  return snapshot.docs.length;
}
  /// count patients
  Future<int> countPatients() async {

    final snapshot = await _db
        .collection("users")
        .where("role", isEqualTo: "patient")
        .get();

    return snapshot.docs.length;
  }

  /// count doctors
  Future<int> countDoctors() async {

    final snapshot = await _db
        .collection("users")
        .where("role", isEqualTo: "doctor")
        .get();

    return snapshot.docs.length;
  }

}