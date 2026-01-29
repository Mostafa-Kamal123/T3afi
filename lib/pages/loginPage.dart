
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/main.dart';
import 'package:t3afy/pages/forgotPassword1.dart';
import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/DoctorProfile.dart';
import 'package:t3afy/pages/DoctorHome.dart';
import 'package:t3afy/pages/registerPage.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});
  static String id='loginPage';
String?email;

String? pass;

bool isLoading=false;

GlobalKey <FormState> formKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                Align(alignment: Alignment.centerLeft, child: Text("Login",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)),
                SizedBox(height: 10,),
               
                CustomTextFormFeild(hintText: "Email",onChanged: (data) {
                  email=data;
                },),
                SizedBox(height: 10,),
                CustomTextFormFeild(hintText: "Password",onChanged: (data) {
                  pass=data;
                },),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: (){
                    Navigator.pushNamed(context, ForgotPassword1.id);
                  }, child: Text("Forgot Passowrd?",style: TextStyle(color: KButtonsColor,fontSize: 16,
                  
                  ),)),
                ),
                SizedBox(height: 50,),
                CustomButtonWidget(text: "Login",onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>Homepage()));
                  },),
                SizedBox(height: 30,),
                Text("OR Login with"),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        
                        PlatformButton(
                          image: "assets/Images/facebook.png",
                          onTap: (){}),
                          PlatformButton(onTap: (){}, image: "assets/Images/google.png")
                      ],
                    ),
                    SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>(Registerpage())));
                      },
                      child: Text(" Sign Up",style: TextStyle(color: KButtonsColor),)),
                  ],
                )
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