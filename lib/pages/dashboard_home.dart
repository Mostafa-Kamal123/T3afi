import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
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
    // جلب البيانات من Firebase
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

    return Padding(
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
    );
  }
}