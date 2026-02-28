import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/admin_doctors_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: KButtonsColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome, Admin",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage the system",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),

            // أمثلة على كروت أو أزرار للأدمن
            _buildAdminCard(
              title: "Manage Doctors",
              subtitle: "View, edit, or add doctors",
              icon: Icons.medical_services_rounded,
              onTap: () {
                // Navigator.push(context, ... صفحة إدارة الدكاترة
              },
            ),
            const SizedBox(height: 16),

           _buildAdminCard(
  title: "Manage Patients",
  subtitle: "View all patients and their status",
  icon: Icons.people_alt_rounded,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdminDoctorsPage(), // ← اسم الصفحة اللي هتعمليها
      ),
    );
  },
),
            const SizedBox(height: 16),

            _buildAdminCard(
              title: "System Statistics",
              subtitle: "Total users, active sessions, etc.",
              icon: Icons.analytics_rounded,
              onTap: () {
                // صفحة الإحصائيات
              },
            ),
            const SizedBox(height: 16),

            _buildAdminCard(
              title: "Reports & Logs",
              subtitle: "View system logs and reports",
              icon: Icons.description_rounded,
              onTap: () {
                // صفحة التقارير
              },
            ),

            const Spacer(),

            // زرار خروج أو تسجيل خروج
            Align(
              alignment: Alignment.center,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, 'loginPage');
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Sign Out", style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: KButtonsColor, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}