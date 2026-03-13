import 'package:flutter/material.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/pages/feelings_insights_page.dart';

class ProgressCard extends StatelessWidget {
  ProgressCard({super.key, required this.icon, required this.title, required this.subtitle, required this.onTap});
final Icon icon;
final String title;
final String subtitle;
final()  onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: KPrimaryColor,
  child: ListTile(
    
    leading: icon,
    title: Text(title,style: TextStyle(fontSize: 13),),
    subtitle: Text(subtitle,style: TextStyle(fontSize: 11),),
    trailing: Icon(Icons.arrow_forward_ios,size: 15,),
    onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FeelingsInsightsPage(),
        ),
      );
    },
  ),
);
  }
}