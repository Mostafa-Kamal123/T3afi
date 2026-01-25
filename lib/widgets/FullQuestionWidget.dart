import 'package:flutter/material.dart';
import 'package:t3afy/widgets/customResponseCard.dart';
import 'package:t3afy/widgets/qusestionCard.dart';

class Fullquestionwidget extends StatelessWidget {
  Fullquestionwidget({super.key, required this.question});
final String question;

  @override
  Widget build(BuildContext context) {
    return Qusestioncard(child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomResposeCard(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("assets/Images/high.png",width: 30,height: 40,),
                        Text("   High      ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){}),
                    CustomResposeCard(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("assets/Images/moderate.png",width: 30,height: 40,),
                        Text("  Moderate  ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){}),
                    
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomResposeCard(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("assets/Images/low.png",width: 30,height: 37,),
                        Text("    Low ㅤ   ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){}),
                    CustomResposeCard(child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset("assets/Images/none.png",width: 30,height: 37,),
                        Text("   None  ㅤㅤ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                      ],
                    ), ontap: (){}),
                    
                  ],
                ),
              ],
            ), question: question);
  }
}