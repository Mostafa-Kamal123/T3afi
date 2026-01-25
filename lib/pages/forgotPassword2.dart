
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/registerPage.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

class ForgotPassword2 extends StatelessWidget {
  ForgotPassword2({super.key});
  static String id='forgot Password2';
String?email;

String? pass;

bool isLoading=false;

GlobalKey <FormState> formKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KPrimaryColor,
        ),
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                
                Image.asset(KLogo,
                width: 300,
                ),
                SizedBox(height: 30,),
                Align(alignment: Alignment.centerLeft, child: Text("Forgot Your password",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)),
                SizedBox(height: 20,),
                CustomTextFormFeild(hintText: "New Password",onChanged: (data) {
                  email=data;
                },),
                
                SizedBox(height: 10,),
                CustomTextFormFeild(hintText: "Repeat Password",onChanged: (data) {
                  email=data;
                },),
                SizedBox(height: 150,),
                CustomButtonWidget(text: "Save",onTap: () {
                  },),
                
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> LoginMethod() async {
  //   UserCredential user=await FirebaseAuth.instance.
  //   signInWithEmailAndPassword(email: email!, password: pass!);
  // }
}