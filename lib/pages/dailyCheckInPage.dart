import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/AIcheckPage.dart';
import 'package:t3afy/widgets/FullQuestionWidget.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customResponseCard.dart';
import 'package:t3afy/widgets/qusestionCard.dart';

class Dailycheckinpage extends StatelessWidget {
  const Dailycheckinpage({super.key});
static String id='daily check in';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Check-In",style: TextStyle(fontWeight: FontWeight.bold),),
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
        child:ListView(
          children: [
            // SizedBox(height: 20,),
            Qusestioncard(child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Column(
                children: [
                  CustomResposeCard(
                    child:Image.asset("assets/Images/terrible.png",width: 60,) , 
                    ontap: (){}),
                    SizedBox(height: 5,),
                    Text("Terrible",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Column(
                children: [
                  CustomResposeCard(
                    child:Image.asset("assets/Images/bad.png",width: 60,) , 
                    ontap: (){}),
                    SizedBox(height: 5,),
                    Text("Bad",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Column(
                children: [
                  CustomResposeCard(
                    child:Image.asset("assets/Images/okay.png",width: 60,) , 
                    ontap: (){}),
                    SizedBox(height: 5,),
                    Text("Okay",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Column(
                children: [
                  CustomResposeCard(
                    child:Image.asset("assets/Images/good.png",width: 60,) , 
                    ontap: (){}),
                    SizedBox(height: 5,),
                    Text("Good",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              Column(
                children: [
                  CustomResposeCard(
                    child:Image.asset("assets/Images/great.png",width: 60,) , 
                    ontap: (){}),
                    SizedBox(height: 5,),
                    Text("Great",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)
                ],
              ),
              ],
            ), question: "How are you feeling?"),
            Fullquestionwidget(question: "Craving intensity?"),
            Fullquestionwidget(question: "How was your sleep quality today?"),
            Fullquestionwidget(question: "How stressed do you feel today?"),
            Fullquestionwidget(question: "How much physical activity did you do today?"),
            Fullquestionwidget(question: "How? much did you interact with others today?"),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomButtonWidget(text: "Save", onTap: (){
                Navigator.pushNamed(context, Aicheckpage.id);
              }),
            )
          ],
        )
      ),
    );
  }
}