import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class Doctorprofile extends StatelessWidget {
  const Doctorprofile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  body: SingleChildScrollView(
    child: Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // الكونتينر الكافيه
            Container(
                height: 340,
              padding: const EdgeInsets.fromLTRB(26, 40, 16, 60),
              decoration: BoxDecoration(
                color: KTextFieldColor2,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + Title
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "Doctor Detail",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  // Doctor Info
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Beaufort Leclair",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              "General Physician",
                              style: TextStyle(color: Colors.white70),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 18),
                                SizedBox(width: 4),
                                Text("4.5",
                                    style:
                                        TextStyle(color: Colors.white)),
                              ],
                            )
                          ],
                        ),
                      ),
                     
                    ],
                  ),
                ],
              ),
            ),

            // Experience + Patients
            Positioned(
              bottom: -55,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 36),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("Experience",
                            style:
                           TextStyle(color:KButtonsColor, fontSize: 20,fontWeight: FontWeight.bold)),
                        Text("15 Years",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Patients",
                            style:
                                TextStyle( fontSize: 20,color:KButtonsColor, fontWeight: FontWeight.bold)),
                        Text("2000+",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 17)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 150),
        Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [
         ListTile(
        leading: Icon(Icons.edit, color: KButtonsColor),
        title: Text(
          "edit",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("edit clicked");
        },
      ),
    Divider(),

      ListTile(
        leading: Icon(Icons.settings, color: KButtonsColor),
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("Settings clicked");
        },
      ),
      Divider(),

      ListTile(
        leading: Icon(Icons.logout, color: Colors.red),
        title: Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        onTap: () {
          print("Logout clicked");
        },
      ),
    ],
  ),
),

      ],
    ),
  ),
);

  }

  // 🔹 small card
  Widget _infoCard(String title, String value) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: TextStyle(color:KButtonsColor,fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
