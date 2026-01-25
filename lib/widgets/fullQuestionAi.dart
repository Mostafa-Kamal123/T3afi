import 'package:flutter/material.dart';
import 'package:t3afy/widgets/customResponseCard.dart';
import 'package:t3afy/widgets/qusestionCard.dart';

class FullquestionAI extends StatelessWidget {
  FullquestionAI({super.key, required this.question});
final String question;

  @override
  Widget build(BuildContext context) {
    return Qusestioncard(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CustomResposeCard(child: Center(child: Text(" Yes ",style: TextStyle(fontSize: 18),)), ontap: (){})),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: CustomResposeCard(child: Center(child: Text(" No ",style: TextStyle(fontSize: 18),)), ontap: (){})),
                    
                  ],
                ),
                
              ],
            ), question: question);
  }
}