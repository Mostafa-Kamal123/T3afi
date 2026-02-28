import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// دالة ترجّع اللون حسب حالة المريض
Color statusColor(String status) {
  switch (status.toLowerCase()) {
    case "stable":
      return Colors.green;
    case "at risk":
      return Colors.orange;
    case "relapsed":
      return Colors.red;
    default:
      return Colors.grey;
  }
}

class PatientService{
  Future<List<Map<String,dynamic>>> getPatientsForDoctor() async{
    final currentUser=FirebaseAuth.instance.currentUser;
    if(currentUser==null)return[];

    final  doctorDoc =await FirebaseFirestore.instance
    .collection('users')

    .doc(currentUser.uid)
    .get();

    final doctorCustomID=doctorDoc.data()?['customId'];
 if (doctorCustomID == null) return [];
 
try {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('role', isEqualTo: 'patient')
      .where('doctorCustomId', isEqualTo: doctorCustomID)
      .get();

final patients = querySnapshot.docs.map((doc) {
  final data = doc.data();
  data['docId'] = doc.id;  // ← ده السطر اللي لازم تضيفيه
  return data;
}).toList();               
  debugPrint("Found ${patients.length} patients");
  return patients;
} catch (e) {
  debugPrint("Error fetching patients: $e");
  return [];
}

}}