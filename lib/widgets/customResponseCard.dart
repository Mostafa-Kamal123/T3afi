import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class CustomResposeCard extends StatelessWidget {
  CustomResposeCard({super.key, required this.child,required this.ontap, required this.color});
final Widget child;
final Color color;
VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
              
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius:20,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  )
                  ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              )
            ),
    );
  }
}