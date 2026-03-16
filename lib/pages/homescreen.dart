import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/chat_page.dart';
import 'package:t3afy/pages/communityScreen.dart';

import 'package:t3afy/pages/dailyCheckInPage.dart';
import 'package:t3afy/pages/homePage.dart';
import 'package:t3afy/pages/patient_profile.dart';
import 'package:t3afy/pages/progress_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static String id = 'home screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIdx = 0;

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
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),

        builder: (context, asyncSnapshot) {

          if (!asyncSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var data = asyncSnapshot.data!.data();

          final List pages = [

            Homepage(
              name: data!['name'],
            ),

            ProgressPage(),

          ];

          return Scaffold(

            /// APP BAR
            appBar: AppBar(
              backgroundColor: KTextFieldColor,
              elevation: 0,

              leading: Builder(
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu),
                    );
                  }
              ),

              /// PROFILE ICON فوق يمين
              actions: [

                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.comments),
                  onPressed: () {

                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommunityScreen(
                            currentUserId: user.uid,
                          ),
                        ),
                      );
                    }

                  },
                ),

                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.circleUser),
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PatientProfile(),
                      ),
                    );

                  },
                ),

              ],
            ),

            /// BOTTOM NAV BAR
            bottomNavigationBar: BottomNavigationBar(

                currentIndex: currentIdx,

                onTap: (value) {

                  if (value == 2) {

                    final user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CommunityScreen(
                            currentUserId: user.uid,
                          ),
                        ),
                      );
                    }

                  } else {

                    setState(() {
                      currentIdx = value;
                    });

                  }

                },

                items: const [

                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.houseChimney),
                    label: "Home",
                  ),

                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.barsProgress),
                    label: "Progress",
                  ),

                  BottomNavigationBarItem(
                    icon: FaIcon(FontAwesomeIcons.users),
                    label: "Community",
                  ),

                ]),

            /// DRAWER
            drawer: Drawer(
              backgroundColor: KPrimaryColor,
              child: ListView(
                children: [

                  Container(
                    height: 100,
                    child: const Center(
                      child: Text(
                        "Menu",
                        style: TextStyle(
                            color: KButtonsColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  ListTile(
                    title: const Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  ListTile(
                    title: const Text("Settings"),
                    onTap: () {
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