import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Customcardwidget extends StatelessWidget {
  // إضافة width و height كـ متغيرات
  final Widget child;
  final VoidCallback ontap;
  final double width;
  final double height;

  // تعديل الكونستركتور عشان ياخدهم
  Customcardwidget({
    super.key,
    required this.child,
    required this.ontap,
    this.width = 150,   // قيمة افتراضية
    this.height = 130,  // قيمة افتراضية
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: height, // استخدم القيمة اللي اتعدت
        width: width,   // استخدم القيمة اللي اتعدت
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
