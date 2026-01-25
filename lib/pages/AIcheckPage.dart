import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/fullQuestionAi.dart';

class Aicheckpage extends StatelessWidget {
  const Aicheckpage({super.key});
static String id='ai check';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Check",style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: KTextFieldColor,
        
      ),
      body: Container(
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
        child: ListView(
          children: [
            FullquestionAI(question: "Have you noticed a decline in your academic performance recently?"),
            FullquestionAI(question: "Do you feel socially isolated or withdrawn from friends and family?"),
            FullquestionAI(question: "Are you facing financial difficulties affecting your daily life?"),
            FullquestionAI(question: "Are you experiencing physical or mental health problems?"),
            FullquestionAI(question: "Have you encountered legal issues due to your behaviors?"),
            FullquestionAI(question: "Is there tension or problems in your personal or family relationships?"),
            FullquestionAI(question: "Do you tend to engage in risky or reckless behaviors?"),
            FullquestionAI(question: "Do you experience withdrawal symptoms when trying to stop harmful behaviors?"),
            FullquestionAI(question: "Do you have difficulty accepting treatment or tend to deny your problem?"),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: CustomButtonWidget(text: "Save", onTap: (){}),
            )

          ],
        ),
      ),
    );
  }
}