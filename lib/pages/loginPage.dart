import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/main.dart';

import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/DoctorProfile.dart';
import 'package:t3afy/pages/DoctorHome.dart';
import 'package:t3afy/pages/registerPage.dart';
import 'package:t3afy/pages/register_choice.dart';
import 'package:t3afy/services/login_logic.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});
  static String id = 'loginPage';

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final LoginLogic loginLogic=LoginLogic();
  String? email;
  String? pass;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();
Future<void> _resetPassword() async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password reset email sent! Check your inbox.'),
      ),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message ?? 'Error sending reset email')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isNarrowScreen = screenWidth < 600;

            final horizontalPadding = isNarrowScreen ? 24.0 : 48.0;
            final logoWidth = isNarrowScreen ? 240.0 : 300.0;
            final formMaxWidth = isNarrowScreen ? double.infinity : 460.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formMaxWidth),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          

                          Image.asset(
                            KLogo,
                            width: logoWidth,
                          ),

                          

                          Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isNarrowScreen ? 28 : 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 32),

                          CustomTextFormFeild(
                            hintText: "Email",
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (data) => email = data,
                          ),

                          const SizedBox(height: 16),

                          CustomTextFormFeild(
                            hintText: "Password",
                            obscureText: true,
                            onChanged: (data) => pass = data,
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
  onPressed: () {
    if (email == null || email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }
    _resetPassword();
  },
  child: const Text('Forgot Password?'),
)


                          ),

                          const SizedBox(height: 40),

                          CustomButtonWidget(
                            text: "Login",
                            onTap: () async {
                              print("Button pressed");

if (email == null || pass == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Please fill all fields")),
  );
  return;
}
try{
                              String?role=await loginLogic.login(
                                email:email!,
                                password: pass! );
                                if(role=='patient'){
                                  Navigator.push(context,
                                  MaterialPageRoute(builder: (_)=> const Homepage()));
                                }
                                else if(role=='doctor'){
                                  Navigator.push(context,MaterialPageRoute(builder: (_)=> const Doctorhome()));
                                }
                                else if(role=='not-verified'){
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Verify your email first")),
                                  );
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("user role not found")),
                                  );
                                }}
                                catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: $e")),
    );
  }
// try {
//   final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
//    email: email!.trim(),      // ← القيمة اللي المستخدم كتبها
//         password: pass!.trim(),
//   );
//   if(credential.user!.emailVerified)
//   { Navigator.push(context,MaterialPageRoute(builder: (context) => const Homepage()), );}
//    else {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: const Text('verify email.'),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('OK'),
//         ),
//       ],
//     ),
//   );
// }
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'user-not-found') {
//     print('No user found for that email.');
//   } else if (e.code == 'wrong-password') {
//     print('Wrong password provided for that user.');
//   }
// }
                              // هنا ممكن تضيف التحقق من الفورم لاحقًا
                              // if (formKey.currentState!.validate()) { ... }
                             
                            },
                          ),

                          const SizedBox(height: 32),

                          Center(
                            child: Text(
                              "OR Login with",
                              style: TextStyle(
                                fontSize: isNarrowScreen ? 14 : 16,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     PlatformButton(
                          //       image: "assets/Images/facebook.png",
                          //       onTap: () {},
                          //     ),
                          //     const SizedBox(width: 40),
                          //     PlatformButton(
                          //       image: "assets/Images/google.png",
                          //       onTap: () {},
                          //     ),
                          //   ],
                          // ),

                          const SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: isNarrowScreen ? 14 : 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const RegisterChoice()),
                                  );
                                },
                                child: Text(
                                  " Sign Up",
                                  style: TextStyle(
                                    color: KButtonsColor,
                                    fontSize: isNarrowScreen ? 14 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}