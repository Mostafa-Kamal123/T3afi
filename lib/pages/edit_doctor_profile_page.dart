import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class EditDoctorProfilePage extends StatefulWidget {
  const EditDoctorProfilePage({super.key});

  @override
  State<EditDoctorProfilePage> createState() => _EditDoctorProfilePageState();
}

class _EditDoctorProfilePageState extends State<EditDoctorProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _specializationController;
  late TextEditingController _experienceController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _aboutController;

  bool _isLoading = false;

  // ── Label Styles ──
  static const TextStyle labelStyle = TextStyle(
    fontSize: 15.5,
    fontWeight: FontWeight.w700,          // bold دائمًا
    color: Color(0xFF2C2C2C),
    height: 1.35,
    letterSpacing: 0.15,
  );

  static const TextStyle floatingLabelStyle = TextStyle(
    fontSize: 16.2,
    fontWeight: FontWeight.w800,
    color: KButtonsColor,
    letterSpacing: 0.25,
  );

  // Input text style
  static const TextStyle inputTextStyle = TextStyle(
    fontSize: 16.5,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _specializationController = TextEditingController();
    _experienceController = TextEditingController();
    _clinicAddressController = TextEditingController();
    _aboutController = TextEditingController();

    _loadCurrentDoctorData();
  }

  Future<void> _loadCurrentDoctorData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          _nameController.text = data['name']?.toString() ?? '';
          _phoneController.text = data['phone']?.toString() ?? '';
          _emailController.text = data['email']?.toString() ?? '';
          _specializationController.text = data['specialization']?.toString() ?? '';
          _experienceController.text = data['yearsOfExperience']?.toString() ?? '0';
          _clinicAddressController.text = data['clinicAddress']?.toString() ?? '';
          _aboutController.text = data['about']?.toString() ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to load profile: $e")),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(),
        'specialization': _specializationController.text.trim(),
        'yearsOfExperience': int.tryParse(_experienceController.text.trim()) ?? 0,
        'clinicAddress': _clinicAddressController.text.trim(),
        'about': _aboutController.text.trim(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving profile: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _clinicAddressController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Doctor Profile",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 21.5,
            letterSpacing: 0.4,
          ),
        ),
        backgroundColor: KTextFieldColor2,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withOpacity(0.18),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 32, 28, 60),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile picture section
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 74,
                            backgroundColor: KTextFieldColor2.withOpacity(0.5),
                            child: Icon(
                              Icons.person_rounded,
                              size: 88,
                              color: KButtonsColor.withOpacity(0.85),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: KButtonsColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.22),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      icon: Icons.person_outline_rounded,
                      validator: (v) => v?.trim().isEmpty ?? true ? "Name is required" : null,
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_rounded,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final val = v?.trim() ?? '';
                        if (val.isEmpty) return "Phone number is required";
                        if (val.length < 10) return "Phone number is too short";
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Email is required";
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                          return "Invalid email format";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _specializationController,
                      label: "Specialization",
                      icon: Icons.medical_information_rounded,
                      validator: (v) => v?.trim().isEmpty ?? true ? "Specialization is required" : null,
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _experienceController,
                      label: "Years of Experience",
                      icon: Icons.calendar_today_rounded,
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        final val = v?.trim() ?? '';
                        if (val.isEmpty) return "Experience is required";
                        if (int.tryParse(val) == null) return "Please enter a valid number";
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _clinicAddressController,
                      label: "Clinic / Workplace Address",
                      icon: Icons.location_on_rounded,
                      validator: null,
                    ),
                    const SizedBox(height: 32),

                    _buildTextField(
                      controller: _aboutController,
                      label: "About (optional)",
                      icon: Icons.info_rounded,
                      maxLines: 5,
                      validator: null,
                    ),

                    const SizedBox(height: 72),

                    FilledButton.icon(
                      onPressed: _isLoading ? null : _saveProfile,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 26,
                              height: 26,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3.2,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 28),
                      label: Text(
                        _isLoading ? "Saving..." : "Save Changes",
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: KButtonsColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                        elevation: 8,
                        shadowColor: KButtonsColor.withOpacity(0.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int? maxLines,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      validator: validator,
      style: inputTextStyle,
      cursorColor: KButtonsColor,
      cursorWidth: 2.2,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: labelStyle,
        floatingLabelStyle: floatingLabelStyle,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(icon, color: KButtonsColor.withOpacity(0.85), size: 26),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: KButtonsColor, width: 2.4),
        ),
        filled: true,
        fillColor: KTextFieldColor,
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 20, 20),
      ),
    );
  }
}