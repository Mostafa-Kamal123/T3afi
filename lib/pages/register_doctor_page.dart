import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/services/auth_service.dart';
import 'package:t3afy/services/firestore_service.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';

class RegisterDoctorPage extends StatefulWidget {
  const RegisterDoctorPage({super.key});
  static const String id = 'registerDoctorPage';

  @override
  State<RegisterDoctorPage> createState() => _RegisterDoctorPageState();
}

class _RegisterDoctorPageState extends State<RegisterDoctorPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();

  String? _name, _email, _phone, _password, _specialization,license;
  int? _years,generatedDoctorId;

  bool _isLoading = false;

  Future<void> _registerDoctor() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    // 1. Register account in Authentication
    final result = await _authService.registerWithEmail(
      email: _email!.trim(),
      password: _password!.trim(),
    );

    final user = result.user;
    if (user == null) throw Exception('Failed to create user');

    // 2. Send verification email
    if (!user.emailVerified) {
      await user.sendEmailVerification();

      // Show message to the user (dialog is better than SnackBar here)
      if (!mounted) return;

      await showDialog(
        context: context,
        barrierDismissible: false, // don't close except by button
        builder: (context) => AlertDialog(
          title: const Text("Registration Successful!"),
          content: Text(
            "A verification link has been sent to $_email\n\n"
            "Please check your email (including Spam / Junk / Promotions folder)\n"
            "and click the link to verify your account.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to previous page or login
                // Or: Navigator.pushReplacementNamed(context, LoginPage.id);
              },
              child: const Text("OK", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    }

    // 3. Save doctor data in Firestore
    await _firestoreService.createDoctor(
      uid: user.uid,
      customId: generatedDoctorId?? 0,
        licenseNumber: license!.trim(),
      name: _name!.trim(),
      email: _email!.trim(),
      phone: _phone!.trim(),
      specialization: _specialization!.trim(),
      yearsOfExperience: _years ?? 0,
    );

    // Optional success message after dialog
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Doctor account created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } on FirebaseAuthException catch (e) {
    String msg = 'An error occurred';

    switch (e.code) {
      case 'weak-password':
        msg = 'The password is too weak';
        break;
      case 'email-already-in-use':
        msg = 'The email is already in use';
        break;
      case 'invalid-email':
        msg = 'The email is invalid';
        break;
      default:
        msg = e.message ?? 'Unexpected error';
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 60),

                          Image.asset(
                            KLogo,
                            // width: logoWidth,
                          ),

                          const SizedBox(height: 48),

                          Text(
                            "Doctor Registeration",
                            style: TextStyle(
                              color: Colors.black,
                              // fontSize: isNarrowScreen ? 28 : 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 32),
                CustomTextFormFeild(
                  hintText: 'Name',
                  onChanged: (v) => _name = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                   SizedBox(height: 20,),
                CustomTextFormFeild(
                  hintText: 'Email',
                  onChanged: (v) => _email = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20,),
                CustomTextFormFeild(
                  hintText: 'Phone',
                  onChanged: (v) => _phone = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20,),
                CustomTextFormFeild(
                  hintText: 'Password',
                  onChanged: (v) => _password = v,
                  obscureText: true,
                  validator: (v) =>
                      v != null && v.length >= 6 ? null : 'Min 6 chars',
                ),
                SizedBox(height: 20,),
                CustomTextFormFeild(
                  hintText: 'Specialization',
                  onChanged: (v) => _specialization = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 20,),
                CustomTextFormFeild(
                  hintText: 'Years of Experience',
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _years = int.tryParse(v),
                  validator: (v) =>
                      v == null || int.tryParse(v) == null ? 'Required' : null,
                ),
                SizedBox(height: 20,),
                CustomTextFormFeild(
  hintText: "Medical License Number",
  onChanged: (value) => license = value,
  validator: (value) =>
      value == null || value.isEmpty ? 'License number is required' : null,
),

                const SizedBox(height: 24),
                CustomButtonWidget(
                  text: 'Register',
                  onTap: _registerDoctor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
