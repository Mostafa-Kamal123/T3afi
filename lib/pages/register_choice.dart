import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/register_doctor_page.dart';
import 'package:t3afy/pages/register_patient_page.dart'; // لو عندك ألوان ثابتة هناك

class RegisterChoice extends StatelessWidget {
  const RegisterChoice({super.key});

  static const String id = 'register_choice';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KTextFieldColor, // أو KPrimaryColor إذا أردتِ
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final isSmallScreen = screenWidth < 600; // موبايل صغير
            final isMediumScreen = screenWidth < 900; // موبايل كبير / تابلت صغير

            final horizontalPadding = isSmallScreen ? 24.0 : 48.0;
            final cardMaxWidth = isSmallScreen ? double.infinity : 500.0;
            final imageSize = isSmallScreen ? 80.0 : 100.0;
            final titleFontSize = isSmallScreen ? 28.0 : 36.0;
            final subtitleFontSize = isSmallScreen ? 16.0 : 18.0;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: cardMaxWidth),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // العنوان
                      Text(
                        "Choose your role",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color:KButtonsColor,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "below",
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: KButtonsColor,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 32 : 48),

                      // السهم
                      Icon(
                        Icons.arrow_downward_rounded,
                        size: isSmallScreen ? 40 : 56,
                        color: KButtonsColor,
                      ),

                      SizedBox(height: isSmallScreen ? 32 : 48),

                      // كارد Doctor
                      _ResponsiveRoleCard(
                        title: "Doctor",
                        subtitle: "Medical professional",
                        imagePath: "assets/Images/doctor.png",
                        imageSize: imageSize,
                        onTap: () { 
                           Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterDoctorPage(),),);
                         },
                      ),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      Text(
                        "or",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // كارد Recoveree
                      _ResponsiveRoleCard(
                        title: "Recoveree",
                        subtitle: "Patient / In recovery",
                        imagePath: "assets/images/patient.png",
                        imageSize: imageSize,
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => RegisterPatientPage(),),);
                        },
                      ),

                      SizedBox(height: isSmallScreen ? 48 : 80),

                      // زرار Get started (اختياري)
                    
                      SizedBox(height: isSmallScreen ? 32 : 48),
                    ],
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

// الكارد الريسبونسيف
class _ResponsiveRoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double imageSize;
  final VoidCallback onTap;

  const _ResponsiveRoleCard({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.imageSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(imageSize / 4), // padding نسبي
        decoration: BoxDecoration(
          color: KTextFieldColor2,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: KTextFieldColor2,
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red),
                  );
                },
              ),
            ),

            SizedBox(width: imageSize / 4),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: imageSize / 3.5, // نسبي لحجم الصورة
                      fontWeight: FontWeight.bold,
                      color:KButtonsColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: imageSize / 5.5,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color: KButtonsColor,
              size: imageSize / 3,
            ),
          ],
        ),
      ),
    );
  }
}