import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/chat_page.dart';
import 'package:t3afy/pages/dailyCheckInPage.dart';
import 'package:t3afy/pages/homePage.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static String id='home screen';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
int currentIdx=0;
Map<String, dynamic>? userData;
Future<void> getUserData() async {
  var doc = await FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .get();

  setState(() {
    userData = doc.data();
  });
}
@override
void initState() {
  super.initState();
  getUserData();
}

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
      final List pages=[
  Homepage(name: data!['name'],),
  Dailycheckinpage(),
  ChatScreen()
  
];
print(data['name']);
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
          bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentIdx,
                onTap: (value) {
                  setState(() {
                    currentIdx=value;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    
                    icon: FaIcon(FontAwesomeIcons.home),
                    label: "Home",
                    ),
                    BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.person),
                    label: "Profile",
                    ),
                    BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.barsProgress),
                    label: "Progress",
                    ),
        
                ]),
        
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
              body: pages[currentIdx],
        );
      
      }
    );
  }
}