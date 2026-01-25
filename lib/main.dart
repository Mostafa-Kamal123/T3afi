import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/AIcheckPage.dart';
import 'package:t3afy/pages/dailyCheckInPage.dart';
import 'package:t3afy/pages/forgotPassword1.dart';
import 'package:t3afy/pages/forgotPassword2.dart';
import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/loginPage.dart';
import 'package:t3afy/pages/onboardingScreens.dart';
import 'package:t3afy/pages/registerPage.dart';

void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        Loginpage.id:(context)=>Loginpage(),
        Registerpage.id:(context)=>Registerpage(),
        ForgotPassword1.id:(context)=>ForgotPassword1(),
        ForgotPassword2.id:(context)=>ForgotPassword2(),
        Homepage.id:(context)=>Homepage(),
        HOmeScreen.id:(context)=>HOmeScreen(),
        Dailycheckinpage.id:(context)=>Dailycheckinpage(),
        Aicheckpage.id:(context)=>Aicheckpage(),
      },
      debugShowCheckedModeBanner: false,
      home: Onboardingscreens(),
    );
  }
}

class HOmeScreen extends StatefulWidget {
  const HOmeScreen({super.key});
static String id='home screen';
  @override
  State<HOmeScreen> createState() => _HOmeScreenState();
}

class _HOmeScreenState extends State<HOmeScreen> {
  
  int currentIdx=0;
  final List<Widget> screens=[
    Homepage(),
    Container(color: Colors.green, child: Center(child: Text('News'))),

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIdx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIdx,
        onTap: (index){
          setState(() {
            currentIdx=index;
          });
        },
        selectedItemColor: KButtonsColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        
        backgroundColor:KPrimaryColor ,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,),
          label: "Home"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
        ]),
    );
  }
}