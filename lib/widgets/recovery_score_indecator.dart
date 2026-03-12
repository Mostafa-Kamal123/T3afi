import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class RecoveryScoreIndicator extends StatelessWidget {
  final double score;

  const RecoveryScoreIndicator({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      
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
    );
  }
}