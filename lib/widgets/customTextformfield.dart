import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class CustomTextFormFeild extends StatelessWidget {
  CustomTextFormFeild({super.key, required this.hintText,required this.onChanged});
String? hintText;
Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
      validator: (value) {
        if(value!.isEmpty)
        return "feild required";
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: KTextFieldColor,
        hintText: hintText,
        
        hintStyle: TextStyle(fontSize: 16,color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: KTextFieldColor,
          ),

        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          

        ),

      ),
    );
  }
}