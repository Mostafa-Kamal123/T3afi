import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/card_in_progress.dart';
import 'package:t3afy/widgets/recovery_score_indecator.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});
static String id='progress page';
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
void initState() {
  super.initState();
  loadRecoveryScore();
}
  
  double max_score=19;
  double recoveryScore=0;
  void loadRecoveryScore() async {

  var data = await getTodayCheckin();
print(data);
  if(data != null){
    setState(() {
      recoveryScore = calculateRecoveryScore(data);
    });
  }
}
@override

  
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
      body: 
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            
            children: [
              Center(child: Text("Daily Recovery Score",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
              SizedBox(height: 20,),
              Center(
          
                child: RecoveryScoreIndicator(score: recoveryScore),
              ),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.faceLaugh),title: "Feelings",subtitle: "View mood insights",),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.fire), title: "Craving ", subtitle: "Triggers & craving chart"),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.moon), title: "Sleep", subtitle: "Sleep pattern"),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.faceGrimace), title: "Stress", subtitle: "Stress level insights"),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.personRunning), title: "Physical Activity", subtitle: "Activity progress"),
              SizedBox(height: 10,),
              ProgressCard(icon: FaIcon(FontAwesomeIcons.peopleGroup), title: "Social Interaction", subtitle: "Connection trend"),
            ],
          ),
        ),
      
    );
  }
}
Future<Map<String,dynamic>?> getTodayCheckin()async{
    final uid=FirebaseAuth.instance.currentUser!.uid;
    final doc= await FirebaseFirestore.instance.collection("users")
    .doc(uid)
    .collection("checkins")
    .doc(DateTime.now().toString().substring(0,10))
    .get();

    return doc.data();
  }
  var data=getTodayCheckin();
double calculateRecoveryScore(Map<String,dynamic> data){
    num total =0;
    total+=data['Feelings']??0;
    
    total+=(3-data['Craving intensity?'])??0;
    total+=data['How much physical activity did you do today?']??0;
    total +=(3-data['How stressed do you feel today?'])??0;
    total+=data['How was your sleep quality today?']??0;
    total+=data['How? much did you interact with others today?']??0;
  return total /19;
  }
  