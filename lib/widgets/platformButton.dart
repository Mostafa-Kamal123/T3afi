import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class PlatformButton extends StatelessWidget {
  PlatformButton({super.key, required this.onTap, required this.image});
final String image;
VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(image,width: 50,),
          ],
        ),
        width:70,
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: KTextFieldColor
        ),
      ),
    );
  }
}