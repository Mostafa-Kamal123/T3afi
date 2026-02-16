import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'patient')
       .where('doctorCustomId', isEqualTo: doctorCustomID)

        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
}}
class LoginLogic{
  Future<String?> login({
    required String  email,
    required String  password,
  })async{
    final credential=
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email.trim(),
    
     password: password.trim(),);
     if(!credential.user!.emailVerified){
      return "not-verified";
     }
     final uid=credential.user!.uid;
     final userDoc=await FirebaseFirestore.instance
     .collection('users')
     .doc(uid)
     .get();

     if(!userDoc.exists || !userDoc.data()!.containsKey('role')){
      return "no-role";
   
     }
     return userDoc.data()?['role'];
  }
}