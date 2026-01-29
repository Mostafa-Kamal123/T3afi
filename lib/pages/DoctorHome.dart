import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/DoctorProfile.dart';
import 'package:t3afy/widgets/customCardWidget.dart';
import 'package:t3afy/widgets/newsSection.dart';

class Doctorhome extends StatelessWidget {
  const Doctorhome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: KPrimaryColor,
        child: ListView(
          children: [
            Container(
              height: 100,
              child: Center(
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
              title: Text("Logout"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // الخلفية
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    KTextFieldColor,
                    KPrimaryColor,
                  ]),
            ),
          ),

          // AppBar عالي
          Container(
            height: 180,
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            color: KTextFieldColor2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: Icon(Icons.menu, color: Colors.black),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Doctor",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.chat, color: Colors.black),
                      onPressed: () {
                        print("Chat clicked");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.account_circle_rounded,
                          color: Colors.black),
                      onPressed: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => Doctorprofile()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // الكارت فوق AppBar
          Positioned(
            top:135,
            left: 16,
            right: 16,
            child: Customcardwidget(
              width: double.infinity,
              height: 180,
              ontap: () {
                print("Card clicked!");
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "View Patients",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
             
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white24,
                        ),
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.people,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Check your Patients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                      ),
                    
                ],
              ),
            ),
          ),

          // باقي الـ body تحت الكارت
          Padding(
            padding: EdgeInsets.only(top: 300),
            child: ListView(
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Discover",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                NewsSection(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0, // افتراضي على Home
  selectedItemColor:  KButtonsColor,
  unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.group),
      label: 'Community',
    ),
  ],
  onTap: (index) {
    // مؤقتًا ممكن تخلي print أو Navigator لصفحة جديدة
    print("Tapped index: $index");
  },
),

    );
  }
}
