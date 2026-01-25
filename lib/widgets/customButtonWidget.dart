import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class CustomButtonWidget extends StatelessWidget {
  CustomButtonWidget({super.key, required this.text,required this.onTap});
String? text;
VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(child: Text(text!,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),)),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: KButtonsColor
        ),
      ),
    );
  }
}