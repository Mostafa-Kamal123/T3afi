import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Qusestioncard extends StatelessWidget {
  Qusestioncard({super.key, required this.child, required this.question});
final Widget child;
final String question;
  @override
  Widget build(BuildContext context) {
    return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                
                width: double.infinity,
              padding: EdgeInsets.all(8),
              
              
              decoration: BoxDecoration(
                color:KTextFieldColor2 ,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0,5),
                  )
                ]
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(question,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  child,
                ],
              )
                        ),
            );
  }
}