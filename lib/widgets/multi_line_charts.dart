import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';

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
      width: double.infinity,
      height: 340,
      child: Column(
        children: [
          Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildLegendItem(Colors.green, "Mood"),
          buildLegendItem(Colors.blue, "Sleep"),
          buildLegendItem(Colors.red, "Stress"),
          buildLegendItem(Colors.orange, "Craving"),
        ],
      ),
      SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
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
                            if (value.toInt() < checkins.length) {
              
                Timestamp ts = checkins[value.toInt()]['date'];
              
                DateTime date = ts.toDate();
              
                String day = DateFormat('EEE').format(date); 
                // Sat Sun Mon
              
                return Text(day);
              }
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
        ],
      ),
    );
  }
}

Widget buildLegendItem(Color color, String text) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 6),
      Text(text),
    ],
  );
}