import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:t3afy/constants.dart';

class RecoveryScoreIndicator extends StatelessWidget {
  final double score;

  const RecoveryScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: KPrimaryColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 20,
        spreadRadius: 2,
        offset: Offset(0, 8), // shadow تحت
      ),
    ],
  ),
      child: CircularPercentIndicator(
        header: Text("Daily recovery Score",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        radius: 100,
        lineWidth: 14,
        percent: score,
        animation: true,
        animationDuration: 1200,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: Colors.grey.shade300,
        progressColor: Colors.green,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${(score * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Recovery",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}