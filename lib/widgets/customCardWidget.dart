import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Customcardwidget extends StatelessWidget {
  // إضافة width و height كـ متغيرات
  final Widget child;
  final VoidCallback ontap;
final double? width;
final double? height;

  // تعديل الكونستركتور عشان ياخدهم
  Customcardwidget({
    super.key,
    required this.child,
    required this.ontap,
    this.width , // قيمة افتراضية
    this.height ,  // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
     height: height,
width: 370,
   // استخدم القيمة اللي اتعدت
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
             
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
