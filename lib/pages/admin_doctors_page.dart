import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'doctor_card.dart';
import 'doctors_service.dart';
import 'package:t3afy/services/patients_management.dart'; // لو عايزة تستخدمي نفس dialog logic مع تعديل

class AdminDoctorsPage extends StatefulWidget {
  const AdminDoctorsPage({super.key});

  @override
  State<AdminDoctorsPage> createState() => _AdminDoctorsPageState();
}

class _AdminDoctorsPageState extends State<AdminDoctorsPage> {
  late Future<List<Map<String, dynamic>>> _doctorsFuture;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _doctorsFuture = DoctorsService.getAllDoctors();
  }

  void _refreshDoctors() {
    setState(() {
      _doctorsFuture = DoctorsService.getAllDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Container(
            color: KTextFieldColor2,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  color: Colors.white,
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Manage Doctors",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            // Search + Add button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value.trim()),
                    decoration: InputDecoration(
                      hintText: "Search by name or ID",
                      hintStyle: TextStyle(color: KTextFieldColor2, fontSize: 16),
                      prefixIcon: const Icon(Icons.search, color: KTextFieldColor2),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    // هنا نفتح dialog إضافة دكتور
                    DoctorsService.showAddDoctorDialog(
                      context: context,
                      onDoctorAdded: _refreshDoctors,
                    );
                  },
                  icon: const Icon(Icons.add, size: 24),
                  label: const Text("Add Doctor", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KButtonsColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Doctors list / grid
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _doctorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No doctors found"));
                  }

                  final doctors = DoctorsService.filterDoctors(snapshot.data!, _searchQuery);

                  final screenWidth = MediaQuery.of(context).size.width;

                  if (screenWidth < 600) {
                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DoctorCard(
                            doctor: doctors[index],
                            onDoctorDeleted: _refreshDoctors,
                            onDoctorEdited: _refreshDoctors,
                          ),
                        );
                      },
                    );
                  }

                  int crossAxisCount = 1;
                  if (screenWidth > 1200) crossAxisCount = 4;
                  else if (screenWidth > 900) crossAxisCount = 3;
                  else if (screenWidth > 600) crossAxisCount = 2;

                  return GridView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 2.0,
                    ),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      return DoctorCard(
                        doctor: doctors[index],
                        onDoctorDeleted: _refreshDoctors,
                        onDoctorEdited: _refreshDoctors,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}