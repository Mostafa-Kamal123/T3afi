import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/profile_image.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({super.key});

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  
void initState() {
  super.initState();
  
}
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, asyncSnapshot) {
        if(!asyncSnapshot.hasData){
          return CircularProgressIndicator();
        }
        var data=asyncSnapshot.data!.data();
        return Scaffold(
          backgroundColor: KPrimaryColor,
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.25,
            
            decoration: BoxDecoration(
              color: KTextFieldColor,
              borderRadius: BorderRadiusDirectional.only(bottomStart: Radius.circular(50),bottomEnd: Radius.circular(50))
            ),
              ),
              Column(
                children: [
                  SizedBox(height: 125,),
                  Center(child: ProfileImage()),
                  SizedBox(height: 10,),
                  Text(
                    
                data!['name'],
              
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Text(data['email'])
                ],
              )
            ],
          ),
        );
      }
    );
  }
}