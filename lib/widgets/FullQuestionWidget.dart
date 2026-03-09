import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/customResponseCard.dart';
import 'package:t3afy/widgets/qusestionCard.dart';

class Fullquestionwidget extends StatefulWidget {
  Fullquestionwidget({super.key, required this.question});
final String question;

  @override
  State<Fullquestionwidget> createState() => _FullquestionwidgetState();
}

class _FullquestionwidgetState extends State<Fullquestionwidget> {
int? selectedScore;

  @override
  Widget build(BuildContext context) {
    return Qusestioncard(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomResposeCard(
                      color: selectedScore==3?KButtonsColor:Colors.white,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(FontAwesomeIcons.arrowTrendUp, color: Colors.red ),
                        Text(" High ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){
                      setState(() {
                        selectedScore=3;
                      });
                      sendAnswer(widget.question, 3);
                    }),
                    CustomResposeCard(
                      color: selectedScore==2?KButtonsColor:Colors.white,
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(FontAwesomeIcons.arrowsLeftRight, color: Colors.orange),
                        Text("   Mid  ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){
                      setState(() {
                        selectedScore=2;

                      });
                      sendAnswer(widget.question, 2);
                    }),
                    
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomResposeCard(
                      color: selectedScore==1?KButtonsColor:Colors.white, 
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(FontAwesomeIcons.arrowTrendDown, color: Colors.amber),
                        Text(" Low ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){
                      setState(() {
                        selectedScore=1;
                      });
                      sendAnswer(widget.question, 1);
                    }),
                    CustomResposeCard(
                      color: selectedScore==0?KButtonsColor:Colors.white, 
                      child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FaIcon(FontAwesomeIcons.circleMinus ,color: Colors.green ),
                        Text(" None",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){
                      setState(() {
                        selectedScore=0;
                      });
                      sendAnswer(widget.question, 0);
                    }),
                    
                  ],
                ),
              ],
            ), question: widget.question);
  }
}



Future<void> sendAnswer(String question, int score) async {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("checkins")
      .doc(DateTime.now().toString().substring(0,10)) // اليوم
      .set({
        question: score
      }, SetOptions(merge: true));
}