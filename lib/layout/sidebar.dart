import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  Sidebar({required this.selectedIndex, required this.onItemSelected});

  final items = [
    {"icon": Icons.dashboard, "title": "Dashboard"},
    {"icon": Icons.medical_services, "title": "Doctors"},
    {"icon": Icons.people, "title": "Patients"},
    {"icon": Icons.settings, "title": "Settings"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // narrow sidebar for circular buttons
      color: Color(0xFF0D1B2A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          // Logo
         
          SizedBox(height: 40),
          // Menu buttons
          ...List.generate(items.length, (index) {
            final item = items[index];
            bool isSelected = selectedIndex == index;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: GestureDetector(
                onTap: () => onItemSelected(index),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF2B6187) : Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 28,
                  ),
                ),
              ),
            );
          }),
          Spacer(),
          // Optional: Logout button at bottom
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
              onTap: () {
                print("Logout tapped");
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.logout, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}