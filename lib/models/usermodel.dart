
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
