import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/ProfileAdminPage.dart';
import 'package:t3afy/services/firebase.dart';
import 'package:t3afy/widgets/patient_status_chart.dart';
import 'package:t3afy/widgets/stat_card.dart';

class DashboardHome extends StatefulWidget {
  @override
  _DashboardHomeState createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  FirebaseService firebaseService = FirebaseService();

  // بيانات StatCards
  int patients = 0;
  int doctors = 0;

  // بيانات الشارت
  Map<String, int> statusData = {
    "Stable": 0,
    "At Risk": 0,
    "Relapsed": 0,
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final p = await firebaseService.countPatients();
    final d = await firebaseService.countDoctors();

    final stable = await firebaseService.countStable();
    final risk = await firebaseService.countRisk();
    final relapse = await firebaseService.countRelapse();

    setState(() {
      patients = p;
      doctors = d;
      statusData = {
        "Stable": stable,
        "At Risk": risk,
        "Relapsed": relapse,
      };
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
return Scaffold(
  drawer: Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: KTextFieldColor2),
          child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
        ),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text("Dashboard"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.people),
          title: Text("Patients"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.medical_services),
          title: Text("Doctors"),
          onTap: () {},
        ),
      ],
    ),
  ),
  body: Column(
    children: [
      // AppBar هنا
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        decoration: BoxDecoration(
          color: KTextFieldColor2,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          children: [
            if (MediaQuery.of(context).size.width < 900)
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    // دلوقتي الـ context متصل بالـ Scaffold
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            Text(
              "Admin Dashboard",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Spacer(),
            Icon(Icons.notifications_none),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.person_rounded, size: 26),
              tooltip: "Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminProfilePage()),
                );
              },
            ),
          ],
        ),
      ),


          // ==== محتوى الـ Dashboard ====
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // ==== Stat Cards ====
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: "Total Patients",
                          future: firebaseService.countPatients(),
                          icon: Icons.people,
                          color: KButtonsColor,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: StatCard(
                          title: "Total Doctors",
                          future: firebaseService.countDoctors(),
                          icon: Icons.medical_services,
                          color: KButtonsColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // ==== Patient Status Chart ====
                  PatientStatusChart(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}