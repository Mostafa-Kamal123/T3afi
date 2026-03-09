import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/admin_doctors_page.dart';
import 'sidebar.dart';
import 'dashboard_appbar.dart';

import '../pages/dashboard_home.dart';


class DashboardLayout extends StatefulWidget {
  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {

  int selectedIndex = 0;

  final pages = [
    DashboardHome(),
    
    AdminDoctorsPage(),
  ];

  void changePage(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(

      drawer: isMobile
          ? Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(color: KButtonsColor),
        child: Row(
          children: [
            Image.asset(KLogo, height: 50),
            SizedBox(width: 10),
            Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 20))
          ],
        ),
      ),
      ListTile(
        leading: Icon(Icons.dashboard),
        title: Text("Dashboard"),
        onTap: () {
          Navigator.pushNamed(context, '/dashboard');
        },
      ),
      ListTile(
        leading: Icon(Icons.people),
        title: Text("Patients"),
        onTap: () {
          Navigator.pushNamed(context, '/patients');
        },
      ),
      ListTile(
        leading: Icon(Icons.medical_services),
        title: Text("Doctors"),
        onTap: () {
          Navigator.pushNamed(context, '/doctors');
        },
      ),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text("Logout"),
        onTap: () {},
      ),
    ],
  ),
):null,

      body: Row(
        children: [

          if(!isMobile)
            Sidebar(
              selectedIndex: selectedIndex,
              onItemSelected: changePage,
            ),

          Expanded(
            child: Column(
              children: [

                DashboardAppBar(),

                Expanded(
                  child: pages[selectedIndex],
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}