import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';

class StatCard extends StatelessWidget {

  final String title;
  final Future<int> future;
  final IconData icon;
  final Color color;

  StatCard({
    required this.title,
    required this.future,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<int>(
      future: future,

      builder: (context, snapshot) {

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: KTextFieldColor,
            borderRadius: BorderRadius.circular(16),

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0,4),
              )
            ],
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: KButtonsColor,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),

              Container(
                padding: EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              )

            ],
          ),
        );
      },
    );
  }
}