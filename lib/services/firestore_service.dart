import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =======================
  /// Create Doctor (PENDING)
    /// Create Doctor
    /// 
    /// 
    Future<int> getNextDoctorId() async {
  final counterRef = FirebaseFirestore.instance.collection('counters').doc('doctors');

  return await FirebaseFirestore.instance.runTransaction<int>((transaction) async {
    final snapshot = await transaction.get(counterRef);

    int newId;

    if (!snapshot.exists) {
      // أول مرة
      newId = 1001; // أو 1 — حسب اللي عايزه
      transaction.set(counterRef, {'lastId': newId});
    } else {
      final current = snapshot.data()?['lastId'] as int? ?? 1000;
      newId = current + 1;
      transaction.update(counterRef, {'lastId': newId});
    }

    return newId;
  });
}
  Future<void> createDoctor({
    required String uid,
    required int customId,
    required String name,
    required String email,
    required String phone,
    required String specialization,
    required int yearsOfExperience,
    required String licenseNumber,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'customId': customId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'doctor',
      'specialization': specialization,
      'yearsOfExperience': yearsOfExperience,
      'licenseNumber': licenseNumber,
      'status': 'pending', // لازم موافقة Admin
      'createdAt': Timestamp.now(),
    });
  }

  /// Create Patient
  Future<void> createPatient({
    required String uid,
    required int customId,
    required String name,
    required String email,
    required String phone,
    required String riskLevel,
    required int doctorCustomId,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'customId': customId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': 'patient',
      'riskLevel': riskLevel,
      'doctorCustomId': doctorCustomId,
      'createdAt': Timestamp.now(),
    });
  }

  /// =======================
  /// Check Doctor by customId
  /// =======================
  Future<bool> isDoctorValid(int doctorCustomId) async {
    final query = await _firestore
        .collection('users')
        .where('customId', isEqualTo: doctorCustomId)
        .where('role', isEqualTo: 'doctor')
        .where('status', isEqualTo: 'approved') // 👈 بس الدكاترة المقبولة
        .limit(1)
        .get();

    return query.docs.isNotEmpty;
  }

  /// =======================
  /// Get full user data
  /// =======================
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  /// =======================
  /// Update doctor status (Admin)
  /// =======================
  Future<void> updateDoctorStatus({
    required String uid,
    required String status, // approved / rejected
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'status': status,
    });
  }

Future<int> generateDoctorId() async {
  final ref = FirebaseFirestore.instance
      .collection('counters')
      .doc('doctorCounter');

  return FirebaseFirestore.instance.runTransaction((t) async {
    final snap = await t.get(ref);
    int newId = snap['lastId'] + 1;
    t.update(ref, {'lastId': newId});
    return newId;
  });
}
Future<int> generatePatientId() async {
  final ref = FirebaseFirestore.instance
      .collection('counters')
      .doc('patientCounter');

  return FirebaseFirestore.instance.runTransaction((t) async {
    final snap = await t.get(ref);
    int newId = snap['lastId'] + 1;
    t.update(ref, {'lastId': newId});
    return newId;
  });
}}