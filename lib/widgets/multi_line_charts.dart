import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MultiLineCharts extends StatefulWidget {
  const MultiLineCharts({super.key});

  @override
  State<MultiLineCharts> createState() => _MultiLineChartsState();
}

class _MultiLineChartsState extends State<MultiLineCharts> {
  List<Map<String, dynamic>> checkins = [];
  List<FlSpot> moodSpoots = [];
  List<FlSpot> sleepSpoots = [];
  List<FlSpot> stressSpoots = [];
  List<FlSpot> cravingSpoots = [];

  Future<List<Map<String, dynamic>>> getWeeklyData() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("checkins")
        .orderBy("date", descending: false) // تغيير إلى تصاعدي للترتيب الصحيح
        .limit(7)
        .get();
    
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void loadChartsData() async {
    var data = await getWeeklyData();
    setState(() {
      checkins = data;
      _prepareChartData();
    });
  }

  void _prepareChartData() {
    moodSpoots.clear();
    sleepSpoots.clear();
    stressSpoots.clear();
    cravingSpoots.clear();

    for (int i = 0; i < checkins.length; i++) {
      moodSpoots.add(
        FlSpot(i.toDouble(), (checkins[i]['Feelings'] ?? 0).toDouble())
      );

      sleepSpoots.add(
        FlSpot(i.toDouble(), (checkins[i]['Sleep'] ?? 0).toDouble())
      );

      stressSpoots.add(
        FlSpot(i.toDouble(), (checkins[i]['Stress'] ?? 0).toDouble())
      );

      cravingSpoots.add(
        FlSpot(i.toDouble(), (checkins[i]['Craving'] ?? 0).toDouble())
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadChartsData();
  }

  @override
  Widget build(BuildContext context) {
    if (checkins.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      width: double.infinity,
      height: 300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LineChart(
            
            LineChartData(
              minX: 0,
              maxX: checkins.isEmpty ? 0 : checkins.length - 1.0, // ديناميكية
              minY: 0,
              maxY: 3,
              
              lineBarsData: [
                // المزاج
                LineChartBarData(
                  spots: moodSpoots,
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                ),
                // النوم
                LineChartBarData(
                  spots: sleepSpoots,
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                ),
                // التوتر
                LineChartBarData(
                  spots: stressSpoots,
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                ),
                // الرغبة
                LineChartBarData(
                  spots: cravingSpoots,
                  isCurved: true,
                  color: Colors.orange,
                  barWidth: 4,
                  dotData: const FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                
                leftTitles: AxisTitles(
                  
                  sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const FaIcon(FontAwesomeIcons.faceFrown,color: Colors.grey,);
                        case 1:
                          return const FaIcon(FontAwesomeIcons.faceGrimace,color: Colors.orange,);
                        case 2:
                          return const FaIcon(FontAwesomeIcons.faceGrin,color: Colors.blue,);
                        case 3:
                          return const FaIcon(FontAwesomeIcons.faceGrinHearts,color: Colors.green,);
                        default:
                          return Text(value.toString());
                      }
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    reservedSize: 30,
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < checkins.length) {
                        // يمكنك عرض التاريخ هنا إذا أردت
                        return Text('Day ${value.toInt() + 1}');
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ),
    );
  }
}