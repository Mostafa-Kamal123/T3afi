import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/firebase_options.dart';
import 'package:t3afy/pages/AIcheckPage.dart';
import 'package:t3afy/pages/DoctorHome.dart';
import 'package:t3afy/pages/chat_page.dart';
import 'package:t3afy/pages/dailyCheckInPage.dart';

import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/homescreen.dart';
import 'package:t3afy/pages/loginPage.dart';
import 'package:t3afy/pages/onboardingScreens.dart';
import 'package:t3afy/pages/progress_page.dart';
import 'package:t3afy/pages/registerPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();   // ← لازم قبل أي حاجة

  await Firebase.initializeApp(                // ← await هنا مهم جدًا
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
void initState(){
 FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('=======================User is currently signed out!');
    } else {
      print('=================================User is signed in!');
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Loginpage.id:(context)=>Loginpage(),
        Registerpage.id:(context)=>Registerpage(),
        ProgressPage.id:(context)=>ProgressPage(),
        HomeScreen.id:(context)=>HomeScreen(),
        Dailycheckinpage.id:(context)=>Dailycheckinpage(),
        Aicheckpage.id:(context)=>Aicheckpage(),
        ChatScreen.id:(context)=>ChatScreen(),
      },
      debugShowCheckedModeBanner: false,
      home: Loginpage(),
    );
  }
}
