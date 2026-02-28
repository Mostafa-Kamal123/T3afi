import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';


class PatientsManagement {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;


//edit patient info 
/// Edit existing patient
static Future<void> editPatientDialog({
  required BuildContext context,
  required Map<String, dynamic> patient,
  required String patientId,
  required VoidCallback onPatientEdited,
}) async {
  final formKey = GlobalKey<FormState>();

  // Controllers مع القيم الحالية
  final nameController = TextEditingController(text: patient['name']?.toString().trim() ?? '');
  final emailController = TextEditingController(text: patient['email']?.toString().trim() ?? '');
  final phoneController = TextEditingController(text: patient['phone']?.toString().trim() ?? '');
  final customIdController = TextEditingController(text: patient['customId']?.toString().trim() ?? '');

  // Normalize risk level (case + fallback)
  String selectedRisk = (patient['riskLevel']?.toString().trim().toLowerCase() ?? 'unknown');
  final riskLevels = ['stable', 'at risk', 'relapsed', 'unknown'];

  if (!riskLevels.contains(selectedRisk)) {
    selectedRisk = 'unknown';
  }

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text("Edit Patient Information"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Name is required";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return null; // optional
                    final email = v.trim();
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    final trimmed = v?.trim() ?? '';
                    if (trimmed.isEmpty) return null; // optional
                    if (trimmed.length < 9) return "Phone number too short";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Custom ID
                TextFormField(
                  controller: customIdController,
                  decoration: const InputDecoration(
                    labelText: "Custom ID",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Custom ID is required";
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Risk Level
                DropdownButtonFormField<String>(
                  value: selectedRisk,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Risk Level",
                    border: OutlineInputBorder(),
                  ),
                  items: riskLevels.map((level) {
                    String display = level.split(' ').map((w) {
                      return w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '';
                    }).join(' ');
                    return DropdownMenuItem(
                      value: level,
                      child: Text(display),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) selectedRisk = value;
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
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(patientId)
                    .update({
                  'name': nameController.text.trim(),
                  'email': emailController.text.trim(),
                  'phone': phoneController.text.trim(),
                  'customId': customIdController.text.trim(),
                  'riskLevel': selectedRisk,  // lowercase
                });

                Navigator.pop(dialogContext);
                onPatientEdited();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Patient information updated successfully"),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error: $e"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Save Changes"),
          ),
        ],
      );
    },
  ).whenComplete(() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    customIdController.dispose();
  });
} 

//delete patient
/// Delete patient with confirmation
static Future<void> deletePatient({
  required BuildContext context,
  required String patientId, // uid or document ID
  required VoidCallback onPatientDeleted,
}) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Delete Patient"),
      content: const Text("Are you sure you want to delete this patient? This action cannot be undone."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  try {
    await _firestore.collection('users').doc(patientId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Patient deleted successfully"),
        backgroundColor: Colors.green,
      ),
    );

    onPatientDeleted(); // Refresh list
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
    );
  }
}
  /// Add new patient with email verification
  static Future<void> addPatientDialog({
    required BuildContext context,
    required int doctorCustomId,
    required VoidCallback onPatientAdded,
  }) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    String riskLevel = "stable";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add New Patient",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: riskLevel,
                    decoration: InputDecoration(
                      labelText: "Risk Level",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: const ["stable", "at risk", "relapsed"]
                        .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) riskLevel = val;
                    },
                  ),
                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final email = emailController.text.trim();
                          final phone = phoneController.text.trim();

                          if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(content: Text("Please fill all fields")),
                            );
                            return;
                          }

                          try {
                            // Generate strong random password
                            final randomPassword = _generateRandomPassword();

                            // 1. Create user in Authentication
                            final credential = await _auth.createUserWithEmailAndPassword(
                              email: email,
                              password: randomPassword,
                            );

                            final user = credential.user;
                            if (user == null) throw Exception("Failed to create account");

                            // 2. Send verification email
                            await user.sendEmailVerification();

                            // 3. Save patient data in Firestore
                            final patientData = {
                              "uid": user.uid,
                              "customId": DateTime.now().millisecondsSinceEpoch.toString(),
                              "name": name,
                              "email": email,
                              "phone": phone,
                              "riskLevel": riskLevel,
                              "doctorCustomId": doctorCustomId,
                              "role": "patient",
                              "createdAt": FieldValue.serverTimestamp(),
                              "createdBy": "doctor",
                              "emailVerified": false,
                            };

                            await _firestore.collection('users').doc(user.uid).set(patientData);

                            // 4. Close dialog and show password to doctor
                            Navigator.pop(dialogContext);

                            _showPasswordToDoctor(
                              context: context,
                              password: randomPassword,
                              email: email,
                              onDone: onPatientAdded,
                            );
                          } on FirebaseAuthException catch (e) {
                            String msg = e.message ?? "An error occurred";
                            if (e.code == 'email-already-in-use') {
                              msg = "Email already in use";
                            } else if (e.code == 'invalid-email') {
                              msg = "Invalid email format";
                            }
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(content: Text(msg), backgroundColor: Colors.red),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                            );
                          }
                        },
                        child: const Text("Add Patient"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: KPrimaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show temporary password to the doctor
  static void _showPasswordToDoctor({
    required BuildContext context,
    required String password,
    required String email,
    required VoidCallback onDone,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Patient Added Successfully!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "A verification link has been sent to: $email",
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 20),
            const Text("Temporary Password for the patient:"),
            const SizedBox(height: 12),
            SelectableText(
              password,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Copy the password above and send it to the patient immediately (via WhatsApp or phone).\n\n"
              "Instruct them to:\n"
              "1. Click the verification link in their email\n"
              "2. Log in using this password\n"
              "3. Change the password immediately from settings",
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDone();
            },
            child: const Text("Done", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  /// Generate strong random password
  static String _generateRandomPassword({int length = 12}) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*()_+-=';
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  /// Search patients by ID
  static List<Map<String, dynamic>> searchById(
    List<Map<String, dynamic>> patients,
    String searchId,
  ) {
    if (searchId.isEmpty) return patients;

    return patients
        .where((patient) =>
            patient['customId']?.toString().toLowerCase().contains(searchId.toLowerCase()) ?? false)
        .toList();
  }
}