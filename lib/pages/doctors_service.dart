import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

// Extension لتسهيل capitalize (علشان الـ Dropdown)
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

class DoctorsService {
  /// جلب كل الدكاترة من Firestore
  static Future<List<Map<String, dynamic>>> getAllDoctors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id; // ← مهم جدًا عشان الـ edit & delete يشتغلوا
        return data;
      }).toList();
    } catch (e) {
      debugPrint("Error fetching doctors: $e");
      return [];
    }
  }

  /// فلترة الدكاترة بناءً على السيرش
  static List<Map<String, dynamic>> filterDoctors(
    List<Map<String, dynamic>> doctors,
    String query,
  ) {
    if (query.trim().isEmpty) return doctors;

    final lowerQuery = query.toLowerCase().trim();
    return doctors.where((doc) {
      final name = (doc['name'] ?? '').toString().toLowerCase();
      final email = (doc['email'] ?? '').toString().toLowerCase();
      final customId = (doc['customId'] ?? '').toString().toLowerCase();
      return name.contains(lowerQuery) ||
          email.contains(lowerQuery) ||
          customId.contains(lowerQuery);
    }).toList();
  }

  /// Dialog لإضافة دكتور جديد
  static Future<void> showAddDoctorDialog({
    required BuildContext context,
    required VoidCallback onDoctorAdded,
  }) async {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final specCtrl = TextEditingController();
    final customIdCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add New Doctor"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Name is required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v?.trim().isEmpty ?? true) return "Email is required";
                    if (!v!.trim().contains('@')) return "Invalid email";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneCtrl,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: specCtrl,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Specialization is required" : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: customIdCtrl,
                  decoration: const InputDecoration(labelText: "Custom ID (optional)"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                // إنشاء حساب في Authentication
                final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailCtrl.text.trim(),
                  password: "TempPass123!", // ← في الإنتاج: استخدمي باسورد عشوائي أو اطلبيه
                );

                // حفظ البيانات في Firestore
                await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
                  'name': nameCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'phone': phoneCtrl.text.trim(),
                  'specialization': specCtrl.text.trim(),
                  'customId': customIdCtrl.text.trim(),
                  'role': 'doctor',
                  'status': 'active',
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pop(ctx);
                onDoctorAdded();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Doctor added successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Failed to add doctor: $e")),
                );
              }
            },
            child: const Text("Add Doctor"),
          ),
        ],
      ),
    );
  }

  /// Dialog لتعديل بيانات دكتور
 static Future<void> showEditDoctorDialog({
  required BuildContext context,
  required Map<String, dynamic> doctor,
  required String doctorId,
  required VoidCallback onDoctorEdited,
}) async {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: doctor['name']?.toString() ?? '');
  final emailController = TextEditingController(text: doctor['email']?.toString() ?? '');
  final phoneController = TextEditingController(text: doctor['phone']?.toString() ?? '');
  final specializationController = TextEditingController(text: doctor['specialization']?.toString() ?? '');
  final customIdController = TextEditingController(text: doctor['customId']?.toString() ?? '');

  // Normalize status value
  String status = (doctor['status']?.toString().trim().toLowerCase()) ?? 'active';

  // القايمة الكاملة اللي عندك (عدليها حسب الداتا الفعلية في Firestore)
  final statusOptions = [
    'active',
    'pending',
    'approved',
    'suspended',
    'inactive',
  ];

  // لو القيمة مش موجودة → نختار أول قيمة أو قيمة افتراضية
  if (!statusOptions.contains(status)) {
    status = statusOptions.first; // أو 'pending' أو 'active'
  }

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Edit Doctor Information"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Name is required" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v?.trim().isEmpty ?? true) return "Email is required";
                    if (!v!.trim().contains('@')) return "Invalid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: specializationController,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  validator: (v) => v?.trim().isEmpty ?? true ? "Specialization is required" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: customIdController,
                  decoration: const InputDecoration(labelText: "Custom ID"),
                ),
                const SizedBox(height: 24),

                DropdownButtonFormField<String>(
                  value: status,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Status",
                    border: OutlineInputBorder(),
                  ),
                  items: statusOptions.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s.capitalize()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      status = value;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                await FirebaseFirestore.instance.collection('users').doc(doctorId).update({
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'phone': phoneController.text.trim(),
                  'specialization': specializationController.text.trim(),
                  'customId': customIdController.text.trim(),
                  'status': status,
                });

                Navigator.pop(dialogContext);
                onDoctorEdited();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Doctor updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Update failed: $e")),
                );
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      );
    },
  );
} /// حذف دكتور
  static Future<void> deleteDoctor({
    required BuildContext context,
    required String doctorId,
    required VoidCallback onDoctorDeleted,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(doctorId).delete();

      // ملاحظة: حذف الحساب من Authentication يحتاج Admin SDK أو Cloud Function
      // لو عايزة تحذفي الحساب كامل، ممكن تعملي Cloud Function منفصلة

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Doctor deleted successfully"),
          backgroundColor: Colors.green,
        ),
      );

      onDoctorDeleted();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete doctor: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}