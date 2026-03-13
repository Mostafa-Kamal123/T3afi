import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/card_in_progress.dart';
import 'package:t3afy/widgets/multi_line_charts.dart';
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
              Row(
                children: [
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.faceLaugh,color: Colors.green,),title: "Feelings",subtitle: "View mood insights",onTap: (),)),
                  
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.fire,color: Colors.red,), title: "Craving ", subtitle: "Craving chart",onTap: ())),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.moon,color: Colors.blue,), title: "Sleep", subtitle: "Sleep pattern",onTap: ())),
                              
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.faceGrimace,color: Colors.orange,), title: "Stress", subtitle: "Stress insights",onTap: ())),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.personRunning,color: Colors.indigoAccent,), title: "Physical Activity", subtitle: "Activity progress",onTap: ())),
                  
                  Expanded(child: ProgressCard(icon: FaIcon(FontAwesomeIcons.peopleGroup,color: Colors.purpleAccent,), title: "Social Interaction", subtitle: "Connection trend",onTap: ())),
                ],
              ),
              Expanded(child: MultiLineCharts())
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
    
    total+=(3-data['Craving'])??0;
    total+=data['Physical activity']??0;
    total +=(3-data['Stress'])??0;
    total+=data['Sleep']??0;
    total+=data['Interact connection']??0;
  return total /19;
  }
  