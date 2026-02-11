import 'dart:math';

import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/services/auth_service.dart';
import 'package:t3afy/services/firestore_service.dart';
import 'package:t3afy/widgets/customButtonWidget.dart';
import 'package:t3afy/widgets/customTextformfield.dart';

class RegisterPatientPage extends StatefulWidget {
  const RegisterPatientPage({super.key});
  static const String id = 'registerPatientPage';

  @override
  State<RegisterPatientPage> createState() => _RegisterPatientPageState();
}

class _RegisterPatientPageState extends State<RegisterPatientPage> {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _phone;
  String? _password;
  String? _riskLevel;

  int? _doctorCustomId;
  int? _patientCustomId;

  bool _isLoading = false;

  int _generatePatientId() {
    return 1000 + Random().nextInt(4000);
  }

  Future<void> _registerPatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final bool validDoctor =
          await _firestoreService.isDoctorValid(_doctorCustomId!);

      if (!validDoctor) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Doctor ID not found or not approved'),
          ),
        );
        return;
      }

      final result = await _authService.registerWithEmail(
        email: _email!,
        password: _password!,
      );

      final user = result.user!;

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }

      _patientCustomId = _generatePatientId();

      await _firestoreService.createPatient(
        uid: user.uid,
        customId: _patientCustomId!,
        name: _name!,
        email: _email!,
        phone: _phone!,
        riskLevel: _riskLevel!,
        doctorCustomId: _doctorCustomId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registered successfully. Please verify your email.'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Patient')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Image.asset(KLogo),
                const SizedBox(height: 20),
                const Text(
                  "Recoveree Registration",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomTextFormFeild(
                  hintText: 'Name',
                  onChanged: (v) => _name = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) => _email = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  hintText: 'Phone',
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => _phone = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  hintText: 'Password',
                  obscureText: true,
                  onChanged: (v) => _password = v,
                  validator: (v) =>
                      v != null && v.length >= 6
                          ? null
                          : 'Min 6 chars',
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  hintText: 'Risk Level',
                  onChanged: (v) => _riskLevel = v,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 20),
                CustomTextFormFeild(
                  hintText: 'Doctor ID',
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      _doctorCustomId = int.tryParse(v),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 24),
                CustomButtonWidget(
                  text: _isLoading ? 'Loading...' : 'Register',
                  onTap: _isLoading ? null : _registerPatient,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
