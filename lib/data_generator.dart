import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataGenerator {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Random random = Random();

  Future<void> generateDoctors() async {
    final doctors = firestore.collection('doctors');

    for (int id = 1000; id < 1010; id++) {
      await doctors.doc(id.toString()).set({
        'name': 'Doctor $id',
        'gender': random.nextBool() ? 'Male' : 'Female',
        'email': 'doctor$id@example.com',
        'phone': '010${random.nextInt(90000000) + 10000000}',
        'specialty': 'Specialty ${random.nextInt(5) + 1}',
        'experience': random.nextInt(20) + 1,
        'patients_count': 0,
      }).catchError((e) {
        print('Error adding doctor $id: $e');
      });
    }
  }

  Future<void> generateRecoveries() async {
    final recoveries = firestore.collection('recoveries');
    List<String> doctorIds = List.generate(10, (i) => (1000 + i).toString());
    List<String> riskLevels = ['stable', 'at risk', 'relaped'];

    for (int id = 1; id <= 500; id++) {
      String assignedDoctor = doctorIds[(id ~/ 15) % 10];
      String risk = riskLevels[random.nextInt(3)];

      await recoveries.doc(id.toString()).set({
        'name': 'Patient $id',
        'gender': random.nextBool() ? 'Male' : 'Female',
        'email': 'patient$id@example.com',
        'phone': '010${random.nextInt(90000000) + 10000000}',
        'risk_level': risk,
        'doctor_id': assignedDoctor,
      }).catchError((e) {
        print('Error adding patient $id: $e');
      });
    }
  }

  Future<void> generateData() async {
    await generateDoctors();
    await generateRecoveries();
  }
}
