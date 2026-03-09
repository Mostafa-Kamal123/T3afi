import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
// استبدلي بالمسار الصحيح لصفحة تعديل بروفايل الأدمن
// import 'package:t3afy/pages/edit_admin_profile_page.dart';  

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No profile data found"));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final String name = data['name'] as String? ?? 'Admin';
          final String email = data['email'] as String? ?? currentUser.email ?? 'No email';
          final String phone = data['phone'] as String? ?? 'Not provided';
          final String role = data['role'] as String? ?? 'Administrator';
          // تاريخ الانضمام (اختياري)
          final Timestamp? createdAt = data['createdAt'] as Timestamp?;
          final String joinDate = createdAt != null
              ? "${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}"
              : "Unknown";

          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Header العلوي
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
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              const Text(
                                "Admin Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Admin Info
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      role,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.email, color: Colors.white70, size: 20),
                                        const SizedBox(width: 8),
                                        Text(
                                          email,
                                          style: const TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Info Cards (ممكن تضيفي أكتر حسب احتياجك)
                    Positioned(
                      bottom: -70,
                      left: 24,
                      right: 24,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem(
                                  title: "Joined",
                                  value: joinDate,
                                  icon: Icons.calendar_today,
                                ),
                                _buildStatItem(
                                  title: "Role",
                                  value: role,
                                  icon: Icons.security,
                                ),
                              ],
                            ),
                            // ممكن تضيفي هنا إحصائيات إضافية لو عندك
                            // مثل: عدد الدكاترة، عدد المرضى، إلخ
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 140),

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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     // builder: (context) => const EditAdminProfilePage(),
                          //   ),
                          // );
                        },
                      ),
                      const Divider(),

                      ListTile(
                        leading: Icon(Icons.settings, color: KButtonsColor),
                        title: const Text(
                          "Settings",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: اذهب لصفحة الإعدادات
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Settings page coming soon")),
                          );
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
                        onTap: () async {
                          // TODO: أضيفي منطق الـ sign out الحقيقي
                          await FirebaseAuth.instance.signOut();
                          // ثم توجه لصفحة الـ login
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login', // أو اسم الراوت بتاعك
                            (route) => false,
                          );
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

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: KButtonsColor, size: 28),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: KButtonsColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}