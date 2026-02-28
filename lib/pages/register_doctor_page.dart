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

  String? _name, _email, _phone, _password, _specialization, _license;
  int? _years, _generatedDoctorId;

  bool _isLoading = false;

  Future<void> _registerDoctor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // الحصول على الـ ID الجديد أولاً
      final int doctorCustomId = await _firestoreService.getNextDoctorId();

      // 1. إنشاء حساب في Authentication
      final result = await _authService.registerWithEmail(
        email: _email!.trim(),
        password: _password!.trim(),
      );

      final user = result.user;
      if (user == null) throw Exception('فشل إنشاء الحساب');

      // 2. إرسال إيميل التحقق + عرض رسالة للمستخدم
      if (!user.emailVerified) {
        try {
          await user.sendEmailVerification();

          if (mounted) {
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text("Verify Your Email"),
                content: const Text(
                  "A verification link has been sent to your email address.\n\n"
                  "Please check your inbox (and spam/junk folder) and click the link to verify your account.\n\n"
                  "You will not be able to fully use the app until your email is verified.",
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("OK"),
                  ),
                ],
              ),
            );
          }

          // للـ debug: اطبع في الـ console عشان تتأكد إن الطلب تم
          debugPrint("Verification email requested for: ${_email!.trim()}");
        } catch (e) {
          debugPrint("Error sending verification email: $e");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل إرسال إيميل التحقق: $e'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }

      // 3. حفظ بيانات الدكتور في Firestore
      await _firestoreService.createDoctor(
        uid: user.uid,
        customId: doctorCustomId,
        licenseNumber: _license!.trim(),
        name: _name!.trim(),
        email: _email!.trim(),
        phone: _phone!.trim(),
        specialization: _specialization!.trim(),
        yearsOfExperience: _years ?? 0,
      );

      // رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'تم إنشاء حساب الدكتور بنجاح!\n'
              'رقم الدكتور: $doctorCustomId\n'
              'يرجى التحقق من الإيميل للمتابعة.',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 6),
          ),
        );

        // اختياري: Navigator.pop(context); أو توجيه لصفحة أخرى
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'الإيميل مستخدم من قبل.';
          break;
        case 'weak-password':
          message = 'كلمة المرور ضعيفة جدًا.';
          break;
        case 'invalid-email':
          message = 'صيغة الإيميل غير صحيحة.';
          break;
        default:
          message = e.message ?? 'خطأ في المصادقة';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e'), backgroundColor: Colors.red),
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    Image.asset(
                      KLogo,
                      // width: 150,   ← لو عايز تحدد عرض اللوجو
                    ),

                    const SizedBox(height: 40),

                    const Text(
                      "Doctor Registration",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 40),

                    CustomTextFormFeild(
                      hintText: 'Full Name',
                      onChanged: (v) => _name = v,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (v) => _email = v,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      onChanged: (v) => _phone = v,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: 'Password',
                      obscureText: true,
                      onChanged: (v) => _password = v,
                      validator: (v) => v != null && v.length >= 6
                          ? null
                          : 'كلمة المرور يجب أن تكون 6 أحرف على الأقل',
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: 'Specialization',
                      onChanged: (v) => _specialization = v,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'مطلوب' : null,
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: 'Years of Experience',
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _years = int.tryParse(v ?? ''),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'مطلوب';
                        if (int.tryParse(v) == null) return 'أدخل رقم صحيح';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextFormFeild(
                      hintText: "Medical License Number",
                      onChanged: (value) => _license = value,
                      validator: (value) => value == null || value.trim().isEmpty
                          ? 'رقم الترخيص مطلوب'
                          : null,
                    ),

                    const SizedBox(height: 40),

                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButtonWidget(
                            text: 'Register',
                            onTap: _registerDoctor,
                          ),

                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}