import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/ProfileAdminPage.dart';

class DashboardAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(
        color: KTextFieldColor2,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ]
      ),
      child: Row(
        children: [

          if(MediaQuery.of(context).size.width < 900)
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),

          Text(
            "Admin Dashboard",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          ),

          Spacer(),

          Icon(Icons.notifications_none),

          SizedBox(width: 10),

IconButton(
            icon: const Icon(Icons.person_rounded, size: 26),
            tooltip: "Profile", // يظهر لما يحط الماوس فوقه (على الويب)
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfilePage(),
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}