import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/patient_card.dart';
import 'package:t3afy/services/patients_management.dart';
import 'patient_logic.dart';

class DoctorPatientsPage extends StatefulWidget {
  const DoctorPatientsPage({super.key});

  @override
  State<DoctorPatientsPage> createState() => _DoctorPatientsPageState();
}

class _DoctorPatientsPageState extends State<DoctorPatientsPage> {
  late Future<List<Map<String, dynamic>>> _patientsFuture;
  String _searchId = "";
Map<String, dynamic>? currentDoctor;

  @override
  void initState() {
    super.initState();
    _patientsFuture = PatientService().getPatientsForDoctor();
      _loadCurrentDoctor();
  }

void _loadCurrentDoctor() async {
  // جلب الإيميل بتاع المستخدم الحالي
  final email = FirebaseAuth.instance.currentUser?.email;

  if (email == null) {
    print("Current user has no email!");
    return;
  }

  try {
    final docSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'doctor')
        .where('email', isEqualTo: email) // البحث على أساس الإيميل
        .limit(1)
        .get();

    if (docSnap.docs.isNotEmpty) {
      setState(() {
        currentDoctor = docSnap.docs.first.data();
        print("Doctor data loaded: $currentDoctor");
      });
    } else {
      print("No doctor found with this email");
    }
  } catch (e) {
    print("Error loading doctor data: $e");
  }
}
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      // AppBar
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 10),
                const Text(
                  "Recovering Patients",
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
            // Row للسيرش والزر
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchId = value.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search by ID",
                      hintStyle: TextStyle(
                        color: KTextFieldColor2,
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: KTextFieldColor2,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
          ElevatedButton.icon(
 onPressed: currentDoctor == null ? null :() {
  print("===== Add button pressed =====");
  
  try {
    print("About to show dialog...");
    PatientsManagement.addPatientDialog(
      context: context,
      doctorCustomId: currentDoctor?['customId'] ?? "UNKNOWN_DOCTOR",
      onPatientAdded: () {
        print("Patient added callback triggered");
        setState(() {
          _patientsFuture = PatientService().getPatientsForDoctor();
        });
      },
    );
    print("showDialog call finished");
  } catch (e, stack) {
    print("ERROR while showing dialog: $e");
    print(stack);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("خطأ في فتح النافذة: $e")),
    );
  }
},
  icon: const Icon(Icons.add, size: 24),
  label: const Text("Add", style: TextStyle(fontSize: 18)),
  style: ElevatedButton.styleFrom(
    backgroundColor: KButtonsColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),


              ],
            ),

            const SizedBox(height: 16),

            // FutureBuilder لعرض المرضى
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _patientsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No patients found"));
                  }

                  final patients = PatientsManagement.searchById(
                    snapshot.data!,
                    _searchId,
                  );

                 final screenWidth = MediaQuery.of(context).size.width;

if (screenWidth < 600) {
  // الموبايل: ListView عمودي
  return ListView.builder(
    itemCount: patients.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: PatientCard(patient: patients[index]),
      );
    },
  );
}

// الويب / التابلت: Grid من الكروت
int crossAxisCount = 1;
if (screenWidth > 1200) crossAxisCount = 4;
else if (screenWidth > 900) crossAxisCount = 3;
else if (screenWidth > 600) crossAxisCount = 2;

return GridView.builder(
  padding: const EdgeInsets.only(top: 8),
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
         // أقصى عرض لكل كارد (جربي 400–500 حسب الشاشة)
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 2.2,  // ابدئي بـ 2.5 – لو الكارد طويل غيريه لـ 2.8 أو 3.0
  ),
  itemCount: patients.length,
  itemBuilder: (context, index) {
    return PatientCard(patient: patients[index], 
       onPatientDeleted: () {
      setState(() {
        _patientsFuture = PatientService().getPatientsForDoctor();
      });
    },
    onPatientEdited: () {           // ← أضيفي ده
    setState(() {
      _patientsFuture = PatientService().getPatientsForDoctor();
    });
  },);
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

  // ➤ Dialog Add Patient
              
                  

  // العرض للموبايل
  Widget _buildMobileView(List<Map<String, dynamic>> patients) {
    return ListView.builder(
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            PatientCard(patient: patients[index],
            onPatientDeleted: () {
      setState(() {
        _patientsFuture = PatientService().getPatientsForDoctor();
      });
    },
    ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

}
