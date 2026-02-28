
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class LoginLogic {
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user!;
      final uid = user.uid;

      // جلب بيانات اليوزر من Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!userDoc.exists || !userDoc.data()!.containsKey('role')) {
        return "no-role";
      }

      final role = userDoc.data()?['role'] as String?;

      // ── الاستثناء الخاص بالأدمن ──
      if (role == "admin") {
        // الأدمن يدخل حتى لو الإيميل مش verified
        return "admin";
      }

      // باقي الرولز لازم يكونوا verified
      if (!user.emailVerified) {
        return "not-verified";
      }

      // إرجاع الرول العادي
      return role;

    } on FirebaseAuthException catch (e) {
      print("Auth error: ${e.code} - ${e.message}");
      return "auth-error";
    } catch (e) {
      print("Unexpected error: $e");
      return "error";
    }
  }
}