import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:t3afy/constants.dart';
import 'package:t3afy/widgets/card_in_progress.dart';

class FeelingsInsightsPage extends StatefulWidget {
  FeelingsInsightsPage({super.key,required this.name});
final String name;
  @override
  State<FeelingsInsightsPage> createState() => _FeelingsInsightsPageState();
}

class _FeelingsInsightsPageState extends State<FeelingsInsightsPage> {

  List<Map<String, dynamic>> checkins = [];
  List<FlSpot> moodSpots = [];
double averageMood = 0;
String bestDay = '';
String lowestDay = '';
  Future<List<Map<String, dynamic>>> getWeeklyData() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;

    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("checkins")
        .orderBy("date")
        .limit(7)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void loadChartsData() async {
  var data = await getWeeklyData();

  setState(() {
    checkins = data;
    prepareChartData();
    calculateInsights();   // مهم
  });
}

  void prepareChartData() {
    moodSpots.clear();

    for (int i = 0; i < checkins.length; i++) {

      moodSpots.add(
        FlSpot(
          i.toDouble(),
          (checkins[i][widget.name] ?? 0).toDouble(),
        ),
      );

    }
  }
void calculateInsights() {
  if (checkins.isEmpty) return;

  double total = 0;

  double maxMood = -1;
  double minMood = 100;

  DateTime bestDate = DateTime.now();
  DateTime lowestDate = DateTime.now();

  for (var checkin in checkins) {

    double mood = (checkin[widget.name] ?? 0).toDouble();

    total += mood;

    if (mood > maxMood) {
      maxMood = mood;
      bestDate = (checkin['date'] as Timestamp).toDate();
    }

    if (mood < minMood) {
      minMood = mood;
      lowestDate = (checkin['date'] as Timestamp).toDate();
    }
  }

  averageMood = total / checkins.length;

  bestDay = DateFormat('EEEE').format(bestDate);
  lowestDay = DateFormat('EEEE').format(lowestDate);
}
  @override
  void initState() {
    super.initState();
    loadChartsData();
  }

  @override
  Widget build(BuildContext context) {

    if (checkins.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: KPrimaryColor,

      appBar: AppBar(
        title:  Text(widget.name+" Insights"),
        backgroundColor: KPrimaryColor,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Container(
              height: 340,
              padding: const EdgeInsets.all(16),
            
              decoration: BoxDecoration(
                color: KPrimaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            
              child: Column(
                children: [
            
                  Text(
                    "${widget.name} Trend (Last 7 Days)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            
                  const SizedBox(height: 20),
            
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
            
                      Icon(Icons.circle, color: Colors.green, size: 12),
                      SizedBox(width: 6),
                      Text("${widget.name}"),
            
                    ],
                  ),
            
                  const SizedBox(height: 20),
            
                  Expanded(
                    child: LineChart(
                      LineChartData(
            
                        minX: 0,
                        maxX: checkins.length - 1,
            
                        minY: 0,
                        maxY: 3,
            
                        gridData: FlGridData(show: true),
            
                        borderData: FlBorderData(show: false),
            
                        lineBarsData: [
                          
                          LineChartBarData(
                            spots: 
                            
                            moodSpots,
                            isCurved: true,
                            barWidth: 4,
                            color: Colors.green,
                            dotData: const FlDotData(show: true),
                          ),
            
                        ],
            
                        titlesData: FlTitlesData(
            
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              reservedSize: 30,
                            ),
                          ),
            
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
            
                              getTitlesWidget: (value, meta) {
            
                                if (value.toInt() < checkins.length) {
            
                                  Timestamp ts =
                                      checkins[value.toInt()]['date'];
            
                                  DateTime date = ts.toDate();
            
                                  String day =
                                      DateFormat('EEE').format(date);
            
                                  return Text(day);
                                }
            
                                return const Text('');
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 20,),
            ProgressCard(icon: FaIcon(FontAwesomeIcons.faceFrown,color: Colors.orange,), title: "Lowest ${widget.name}", subtitle: "${lowestDay}",onTap: (){},isTap: false,),
            ProgressCard(icon: FaIcon(FontAwesomeIcons.faceGrin,color: Colors.blue,), title: "Average ${widget.name}", subtitle: "${averageMood.toStringAsFixed(1)}",onTap: (){},isTap: false,),
            ProgressCard(icon: FaIcon(FontAwesomeIcons.faceGrinHearts,color: Colors.green,), title: "Best ${widget.name}", subtitle: "${bestDay}",onTap: (){},isTap: false,),
          ],
        
        ),
      ),
    );
  }
}