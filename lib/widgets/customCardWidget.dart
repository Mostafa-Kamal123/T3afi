import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Customcardwidget extends StatelessWidget {
  Customcardwidget({super.key, required this.child,required this.ontap});
final Widget child;
VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
              height: 130,
              width: 150,
              decoration: BoxDecoration(
                color: KPrimaryColor,
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
              child: child
            ),
    );
  }
}