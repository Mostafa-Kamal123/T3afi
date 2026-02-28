import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/edit_doctor_profile_page.dart';

class Doctorprofile extends StatelessWidget {
  const Doctorprofile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Please login first")),
      );
    }

    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Scaffold(
              body: Center(child: Text("No profile data found")),
            );
          }

          // استخراج البيانات من Firestore
          final data = snapshot.data!.data() as Map<String, dynamic>;

          final String name = data['name'] as String? ?? 'Doctor';
          final String specialization =
              data['specialization'] as String? ?? 'General Physician';
          final int years = data['yearsOfExperience'] as int? ?? 0;
          final double rating = (data['rating'] as num?)?.toDouble() ?? 4.5;
          // عدد المرضى: لو موجود حقل patientCount، نستخدمه
          // وإلا ممكن نعرض قيمة افتراضية أو نحسبه لاحقًا
          final String patients = data['patientCount'] != null
              ? "${data['patientCount']}+"
              : "500+"; // قيمة افتراضية

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // الكونتينر العلوي
                    Container(
                      height: 340,
                      padding: const EdgeInsets.fromLTRB(26, 40, 16, 60),
                      decoration: BoxDecoration(
                        color: KTextFieldColor2,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back + Title
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                "Doctor Detail",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Doctor Info
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      specialization,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.star,
                                            color: Colors.orange, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Experience + Patients
                    Positioned(
                      bottom: -55,
                      left: 30,
                      right: 30,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text("Experience",
                                    style: TextStyle(
                                        color: KButtonsColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                Text("$years Years",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Patients",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: KButtonsColor,
                                        fontWeight: FontWeight.bold)),
                                Text(patients,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 150),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                    ListTile(
  leading: Icon(Icons.edit, color: KButtonsColor),
  title: const Text(
    "Edit Profile",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  ),
  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditDoctorProfilePage(),
      ),
    );
  },
),
                      const Divider(),

                      ListTile(
                        leading: Icon(Icons.settings, color: KButtonsColor),
                        title: const Text(
                          "Settings",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        trailing:
                            const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          print("Settings clicked");
                        },
                      ),
                      const Divider(),

                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          // هنا تضيفي منطق الـ sign out
                          print("Logout clicked");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}