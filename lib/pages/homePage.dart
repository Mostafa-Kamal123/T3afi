import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/helpers/motivation_quotes.dart';
import 'package:t3afy/pages/chat_page.dart';
import 'package:t3afy/pages/dailyCheckInPage.dart';
import 'package:t3afy/widgets/customCardWidget.dart';
import 'package:t3afy/widgets/newsSection.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});
static String id='home page';
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
      builder: (context, asyncSnapshot) {
        if(!asyncSnapshot.hasData){
          return CircularProgressIndicator();
        }
        var data=asyncSnapshot.data!.data();
      
        return Scaffold(
          appBar: AppBar(
            backgroundColor: KTextFieldColor,
            elevation: 0,
            leading: Builder(
              builder: (context) {
                return IconButton(onPressed: (){
                  Scaffold.of(context).openDrawer();
                }, 
                icon: Icon(Icons.menu),
                );
              }
            ),
          ),
          drawer: Drawer(
            backgroundColor:KPrimaryColor,
            child: ListView(
              children: [
                Container(
                  height: 100,
                  child: Center(
                    child: Text(
                      "Menu",
                      style: TextStyle(color: KButtonsColor,fontSize: 24,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                  title: Text("Logout"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Settings"),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              
                KTextFieldColor,
                KPrimaryColor,
              ])
            ),
            child: ListView(
        
              children: [
        
                SizedBox(height: 20,),
                Align(
                  
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Hello ${data!['name']}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                  )),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    
                    width: double.infinity,
                  padding: EdgeInsets.all(8),
                  
                  
                  decoration: BoxDecoration(
                    color:KPrimaryColor ,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: Offset(0,5),
                      )
                    ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Days of Sobriety",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("172 ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                          Text("days"),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_outward_sharp,color: Colors.green,),
                          Text("14 day streak",style: TextStyle(color: Colors.green),),
                        ],
                      )
                    ],
                  ),
                            ),
                ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Customcardwidget(
                    ontap: (){
                      Navigator.pushNamed(context, Dailycheckinpage.id);
                    },
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Daily Check-in",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Icon(Icons.calendar_today_outlined,color: KButtonsColor,size: 40,),
                      SizedBox(height: 10,),
                      Text("log your day"),
                    ],
                  )),
                  Customcardwidget(
                    ontap: (){
                      Navigator.pushNamed(context, ChatScreen.id);
                    },
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Therapist",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Icon(Icons.chat_bubble_outline_rounded,color: KButtonsColor,size: 40,),
                      SizedBox(height: 10,),
                      Text("Chat Now"),
                    ],
                  )),
                ],
              ),
              SizedBox(height: 30,),
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                  
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: KPrimaryColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius:20,
                        spreadRadius: 2,
                        offset: Offset(0, 8),
                      )
                      ],
                  ),
                  child: Text(getTodayMessage(),style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text("Discover",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  )),
                Expanded(child: NewsSection())
              ],
            ),
          )
        );
      }
    );
  }
String getTodayMessage(){
  int day =DateTime.now().day;
  int index =(day-1)%MotivationalMessages.messages.length;

  return MotivationalMessages.messages[index];
}


}