
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/forgotPassword2.dart';
import 'package:t3afy/pages/registerPage.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

class ForgotPassword1 extends StatelessWidget {
  ForgotPassword1({super.key});
  static String id='forgot Password';
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
                CustomTextFormFeild(hintText: "Enter Your Email",onChanged: (data) {
                  email=data;
                },),
                
                SizedBox(height: 10,),
                
                SizedBox(height: 200,),
                CustomButtonWidget(text: "Save",onTap: () {
                  Navigator.pushNamed(context, ForgotPassword2.id);
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