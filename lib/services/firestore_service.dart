import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// =======================
  /// Create Doctor (PENDING)
  /// =======================
  Future<void> createDoctor({
    required String uid,
    required int customId, // 👈 ID من 100 لـ 500
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

      'status': 'pending', // 👈 أهم سطر (مستني موافقة الادمن)
      'createdAt': Timestamp.now(),
    });
  }

  /// =======================
  /// Create Patient
  /// =======================
  Future<void> createPatient({
    required String uid,
    required int customId, // 👈 ID من 1000 لـ 5000
    required String name,
    required String email,
    required String phone,
    required String riskLevel,
    required int doctorCustomId, // 👈 مش UID
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
}
