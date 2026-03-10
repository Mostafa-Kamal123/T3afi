import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/admin_dashboard_page.dart';
import 'package:t3afy/pages/admin_doctors_page.dart';
import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/DoctorProfile.dart';
import 'package:t3afy/pages/DoctorHome.dart';
import 'package:t3afy/pages/homescreen.dart';
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
  final LoginLogic loginLogic = LoginLogic();
  String? email;
  String? pass;
  bool isLoading = false;
  bool showResendVerification = false; // ← controls visibility of resend button

  final GlobalKey<FormState> formKey = GlobalKey();

  Future<void> _resetPassword() async {
    if (email == null || email!.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent! Check your inbox.'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error sending reset email')),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email resent! Please check your inbox (and spam folder).'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
          ),
        );
        setState(() => showResendVerification = false);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to resend verification email')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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

                          const SizedBox(height: 24),

                          Text(
                            "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: isNarrowScreen ? 28 : 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 40),

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
                              onPressed: _resetPassword,
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: KButtonsColor),
                              ),
                            ),
                          ),

                          if (showResendVerification) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: _resendVerificationEmail,
                                icon: const Icon(Icons.email_outlined, size: 18),
                                label: const Text(
                                  'Resend verification email',
                                  style: TextStyle(color: Colors.orangeAccent),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 32),

                          CustomButtonWidget(
                            text: "Login",
                            onTap: () async {
                              if (email == null || email!.trim().isEmpty ||
                                  pass == null || pass!.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fill all fields")),
                                );
                                return;
                              }

                              setState(() {
                                isLoading = true;
                                showResendVerification = false;
                              });

                              try {
                                final role = await loginLogic.login(
                                  email: email!.trim(),
                                  password: pass!.trim(),
                                );

                                setState(() => isLoading = false);

                                if (role == "not-verified") {
                                  setState(() => showResendVerification = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please verify your email first. You can resend the link above."),
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                } else if (role == "patient") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) =>  HomeScreen()),
                                  );
                                } else if (role == "doctor") {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const Doctorhome()),
                                  );
                                } else if (role == "admin") {
                                  // ← Add your admin page here when ready
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => DashboardScreen()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Unknown role: $role")),
                                  );
                                }
                              } catch (e) {
                                setState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Login failed: ${e.toString()}")),
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 32),

                          Center(
                            child: Text(
                              "OR Login with",
                              style: TextStyle(fontSize: isNarrowScreen ? 14 : 16),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Uncomment if you want social login later
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     PlatformButton(image: "assets/Images/facebook.png", onTap: () {}),
                          //     const SizedBox(width: 40),
                          //     PlatformButton(image: "assets/Images/google.png", onTap: () {}),
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
                                    fontWeight: FontWeight.bold,
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