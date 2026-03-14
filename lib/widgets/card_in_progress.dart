import 'package:flutter/material.dart';
import 'package:t3afy/pages/feelings_insights_page.dart';

class ProgressCard extends StatelessWidget {
  // صححنا النوع لـ VoidCallback؟
  final Icon icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap; // optional

  ProgressCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap, // ممكن تسيبيها مؤقت
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: icon,
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap ??
            () {
              // مؤقت لحد ما تكملي الكود
              print("ProgressCard tapped"); 
              // لو حابة تعملي navigation:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => FeelingsInsightsPage(),
              //   ),
              // );
            },
      ),
    );
  }
}