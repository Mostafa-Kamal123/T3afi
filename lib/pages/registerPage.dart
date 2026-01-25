
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/loginPage.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

    class Registerpage extends StatefulWidget {
    Registerpage({super.key});
    static String id='registerPage';
    @override
    State<Registerpage> createState() => _RegisterpageState();
    }

    class _RegisterpageState extends State<Registerpage> {
    
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
                    
                    Align(alignment: Alignment.centerLeft, child: Text("Register",style: TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),)),
                    SizedBox(height: 10,),
                    CustomTextFormFeild(hintText: "Name",onChanged: (data) {
                    email=data;
                    },),
                    SizedBox(height: 10,),
                    CustomTextFormFeild(hintText: "Email",onChanged: (data) {
                    email=data;
                    },),
                    SizedBox(height: 10,),
                    CustomTextFormFeild(hintText: "Phone Number",onChanged: (data) {
                    email=data;
                    },),
                    SizedBox(height: 10,),
                    CustomTextFormFeild(hintText: "Password",onChanged: (data) {
                    pass=data;
                    },),
                    
                    
                    SizedBox(height: 20,),
                    CustomButtonWidget(text: "Sign Up",onTap: () {
                    
                    },),
                    SizedBox(height: 10,),
                    Text("OR Sign Up with"),
                    SizedBox(height: 10,),
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
                        Text("Already have an account?"),
                        GestureDetector( onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>(Loginpage())));
                        }, child: Text(" Login",style: TextStyle(color: KButtonsColor),)),
                    ],
                    )
                ],
                ),
            ),
            ),
        ),
        );
    }

    // Future<void> RegisterMethod() async {
    //     UserCredential user=await FirebaseAuth.instance.
    //     createUserWithEmailAndPassword(email: email!, password: pass!);
    // }
    }