import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/main.dart';
import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/loginPage.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';
import 'package:t3afy/widgets/platformButton.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({super.key});
  static String id = 'registerPage';

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  String? name;
  String? email;
  String? phone;
  String? password;

  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            final bool isSmallScreen = screenWidth < 600; // mobile
            final double horizontalPadding = isSmallScreen ? 24 : 60;
            final double logoWidth = isSmallScreen ? 220 : 300;
            final double formMaxWidth = isSmallScreen ? double.infinity : 480;

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
                        children: [
                          SizedBox(height: isSmallScreen ? 40 : 80),

                          Image.asset(
                            KLogo,
                            width: logoWidth,
                          ),

                          SizedBox(height: isSmallScreen ? 40 : 60),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: isSmallScreen ? 28 : 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 32),

                          CustomTextFormFeild(
                            hintText: "Name",
                            onChanged: (data) => name = data,
                          ),

                          SizedBox(height: 16),

                          CustomTextFormFeild(
                            hintText: "Email",
                            onChanged: (data) => email = data,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          SizedBox(height: 16),

                          CustomTextFormFeild(
                            hintText: "Phone Number",
                            onChanged: (data) => phone = data,
                            keyboardType: TextInputType.phone,
                          ),

                          SizedBox(height: 16),

                          CustomTextFormFeild(
                            hintText: "Password",
                            onChanged: (data) => password = data,
                            obscureText: true, // مهم جدًا هنا
                          ),

                          SizedBox(height: isSmallScreen ? 40 : 60),

                          SizedBox(
                            width: double.infinity,
                            child: CustomButtonWidget(
                              text: "Sign Up",
                              onTap: () async {
                                try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
email: email!.trim(),      // ← القيمة اللي المستخدم كتبها
        password: password!.trim(),
  );
  FirebaseAuth.instance.currentUser!.sendEmailVerification();
   Navigator.push(context,MaterialPageRoute(builder: (context) => Loginpage(),),
   );
}
  // الكود بتاعك
 on FirebaseAuthException catch (e) {
  // معالجة كود الخطأ (weak-password, email-already-in-use, ...)
} on Exception catch (e) {
  // لأي exception تاني
  print('Exception: $e');
} catch (e, stack) {
  // للـ TypeError ده تحديدًا
  print('Unexpected error: $e\nStack: $stack');
}
                                // هنا هتحط لاحقًا منطق التسجيل الحقيقي
                                // مثال:
                                // if (formKey.currentState!.validate()) {
                                //   setState(() => isLoading = true);
                                //   // await register with Firebase...
                                //   setState(() => isLoading = false);
                                // }
                              },
                            ),
                          ),

                          SizedBox(height: 32),

                          Text(
                            "OR Sign Up with",
                            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                          ),

                          SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlatformButton(
                                image: "assets/Images/facebook.png",
                                onTap: () {},
                              ),
                              const SizedBox(width: 40),
                              PlatformButton(
                                image: "assets/Images/google.png",
                                onTap: () {},
                              ),
                            ],
                          ),

                          SizedBox(height: 32),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Loginpage.id);
                                  // أو Navigator.pushNamed لو عايز ترجع للـ back
                                },
                                child: Text(
                                  " Login",
                                  style: TextStyle(
                                    color: KButtonsColor,
                                    fontSize: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 40 : 80),
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