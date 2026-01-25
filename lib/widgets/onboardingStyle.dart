import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Onboardingstyle extends StatelessWidget {
Onboardingstyle({super.key, required this.image});
final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
      body: Column(
        
        children: [
          
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(image,
              fit: BoxFit.cover,
              width: 350,
              height: 380,),
            ),
          )
        ],
      ),
    );
  }
}