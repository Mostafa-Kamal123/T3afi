import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/AIcheckPage.dart';
import 'package:t3afy/widgets/FullQuestionWidget.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customResponseCard.dart';
import 'package:t3afy/widgets/qusestionCard.dart';

class Dailycheckinpage extends StatefulWidget {
  Dailycheckinpage({super.key});
static String id='daily check in';

  @override
  State<Dailycheckinpage> createState() => _DailycheckinpageState();
}

class _DailycheckinpageState extends State<Dailycheckinpage> {
  int? selected;
  bool isCheckedIn = false;

Future<void> checkIfDone() async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final todayDocId = DateTime.now().toString().substring(0,10); // YYYY-MM-DD
  final doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("checkins")
      .doc(todayDocId)
      .get();

  if (doc.exists) {
    setState(() {
      isCheckedIn = true; // المستخدم عمل check-in اليوم
    });
  }
}
@override
void initState() {
  super.initState();
  checkIfDone();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Check-In",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: KTextFieldColor,
        
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              
                KTextFieldColor,
                KPrimaryColor,
              ])
            ),
            child:ListView(
              children: [
                // SizedBox(height: 20,),
                Qusestioncard(child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                  Column(
                    children: [
                      CustomResposeCard(
                        child:FaIcon(FontAwesomeIcons.faceSadTear, color: Colors.red,size: 40,), 
                        ontap: (){
                          setState(() {
                            sendAnswer(0);
                            selected=1;
                          });
                        }, color: selected==1?KButtonsColor:Colors.white,),
                        SizedBox(height: 5,),
                        Text("Terrible",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CustomResposeCard(
                        child:FaIcon(FontAwesomeIcons.faceFrown, color: Colors.deepOrange,size: 40),
                        ontap: (){
                          sendAnswer(1);
                          setState(() {
                            selected=2;
                          });
                        }, color: selected==2?KButtonsColor:Colors.white,),
                        SizedBox(height: 5,),
                        Text("Bad",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CustomResposeCard(
                        child:FaIcon(FontAwesomeIcons.faceMeh, color: Colors.orange,size: 40),
                        ontap: (){
                          sendAnswer(2);
                          setState(() {
                            selected=3;
                          });
                        }, color: selected==3?KButtonsColor:Colors.white,),
                        SizedBox(height: 5,),
                        Text("Okay",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CustomResposeCard(
                        child:FaIcon(FontAwesomeIcons.faceSmile, color: Colors.lightGreen,size: 40),
                        ontap: (){
                          sendAnswer(3);
                          setState(() {
                            selected=4;
                          });
                        }, color: selected==4?KButtonsColor:Colors.white,),
                        SizedBox(height: 5,),
                        Text("Good",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Column(
                    children: [
                      CustomResposeCard(
                        child:FaIcon(FontAwesomeIcons.faceLaugh, color: Colors.green,size: 40),
                        ontap: (){
                          sendAnswer(4);
                          setState(() {
                            selected=5;
                          });
                        }, color: selected==5?KButtonsColor:Colors.white,),
                        SizedBox(height: 5,),
                        Text("Great",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                    ],
                  ),
                  ],
                ), question: "How are you feeling?"),
                Fullquestionwidget(question: "Craving intensity?",fieldName: "Craving",),
                Fullquestionwidget(question: "How was your sleep quality today?",fieldName: "Sleep",),
                Fullquestionwidget(question: "How stressed do you feel today?",fieldName: "Stress",),
                Fullquestionwidget(question: "How much physical activity did you do today?",fieldName: "Physical activity",),
                Fullquestionwidget(question: "How? much did you interact with others today?",fieldName: "Interact connection",),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CustomButtonWidget(text: "Save", onTap: (){
                    setState(() {
                      isCheckedIn=true;
                    });
                    Navigator.pop(context);
                  }),
                )
              ],
            )
          ),
          if(isCheckedIn)
            Container(
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "You have already completed today's check-in!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          
        ],
        )
      ),
        ]
    ));
  
}
}
Future<void> sendAnswer( int score) async {

  final uid = FirebaseAuth.instance.currentUser!.uid;

  await FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("checkins")
      .doc(DateTime.now().toString().substring(0,10)) // اليوم
      .set({
        'date':Timestamp.now(),
        "Feelings": score
      }, SetOptions(merge: true));
}