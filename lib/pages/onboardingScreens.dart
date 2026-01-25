import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/loginPage.dart';
import 'package:t3afy/widgets/onboardingStyle.dart';

class Onboardingscreens extends StatefulWidget {
  Onboardingscreens({super.key});

  @override
  State<Onboardingscreens> createState() => _OnboardingscreensState();
}

class _OnboardingscreensState extends State<Onboardingscreens> {
  final PageController controller= PageController();
  int currentIdx=0;
final List<Onboardingstyle> pages=[
  Onboardingstyle(image:"assets/Images/onboarding1.png" ),
  Onboardingstyle(image:"assets/Images/onboarding2.png" ),
  Onboardingstyle(image:"assets/Images/onboarding3.png" ),
  Onboardingstyle(image:"assets/Images/onboarding4.png" ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KPrimaryColor,
      body:Column(

        children: [
          SizedBox(height: 50,),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(onPressed: (){
              controller.jumpToPage(pages.length-1);
            }, child: Text("Skip",style: TextStyle(color: KButtonsColor),)),
          ),
          SizedBox(height: 60,),
          SizedBox(
            height: 400,
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              onPageChanged: (value){
                setState(() {
                  currentIdx=value;
                });
              },
              itemBuilder: (context,index){
                return Onboardingstyle(image: pages[index].image);
              }),
          ),
          SizedBox(height: 30,),
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length, 
                (index)=>AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 6),
                  height: 10,
                  width: currentIdx== index?22:10,
                  decoration: BoxDecoration(
                    color: currentIdx==index?Colors.blue:Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  )),
            ),
          ),
            SizedBox(height: 30,),
            SizedBox(
              height: 50,
              width: 120,
              child: ElevatedButton(
                style: ButtonStyle(
                  
                  backgroundColor:WidgetStatePropertyAll(KButtonsColor),
                ),
                onPressed: (){
                if(currentIdx==pages.length-1){
                  Navigator.pushNamed(context, Loginpage.id);
                }
                else{
                  controller.nextPage(
                    duration: Duration(milliseconds: 300), 
                    curve: Curves.easeInOut);
                }
              }, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(currentIdx==pages.length-1?"Start":"Next",style: TextStyle(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Icon( Icons.arrow_forward,
                    color: Colors.white,
                    ),
                  )
                ],
              )),
            ),


        ],
      ) ,
    );
  }
}