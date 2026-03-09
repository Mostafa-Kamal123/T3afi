import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:t3afy/constants.dart';
import '../services/firebase.dart';

class PatientStatusChart extends StatefulWidget {
  @override
  _PatientStatusChartState createState() => _PatientStatusChartState();
}

class _PatientStatusChartState extends State<PatientStatusChart> {
  final FirebaseService service = FirebaseService();
  int touchedIndex = -1;

  Future<Map<String,int>> getStatusCounts() async {
    int stable = await service.countStable();
    int atRisk = await service.countRisk();
    int relapsed = await service.countRelapse();

    return {
      "Stable": stable,
      "At Risk": atRisk,
      "Relapsed": relapsed,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,int>>(
      future: getStatusCounts(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final total = data.values.fold(0, (sum, val) => sum + val);

        
  final Map<String, List<Color>> gradients = {
    "Stable": [KTextFieldColor, KTextFieldColor2],
    "At Risk": [KButtonsColor.withOpacity(0.7), KButtonsColor],
    "Relapsed": [Colors.pinkAccent.shade100, Colors.pink.shade400],
  };
        List<String> keys = data.keys.toList();

        return Container(
         padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Patient Status",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20),

              // هنا الصف اللي فيه الشارت والLegend جنب بعض
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // العمود الأول: الشارت
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40, // نص دائري وسط
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = response.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                          sections: data.entries.mapIndexed((i, entry){
                            final value = entry.value.toDouble();
                            final percent = total == 0 ? 0 : (value / total * 100);
                            final isHovered = i == touchedIndex;
                               return PieChartSectionData(
                    value: value,
                    radius: isHovered ? 85 : 70,
                    showTitle: true,
                    title: "${percent.toStringAsFixed(0)}%",
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    gradient: LinearGradient(
                      colors: gradients[entry.key]!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  );
                }).toList(),
              ),
              swapAnimationDuration: Duration(milliseconds: 800),
              swapAnimationCurve: Curves.easeInOut,
            ),
          ),),

                  SizedBox(width: 20),

                  // العمود الثاني: Legend
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.entries.map((entry){
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: LegendItem(
                            color: gradients[entry.key]![1],
                            text: "${entry.key}: ${entry.value}",
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                ],
              ),

            ],
          ),
        );
      },
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  LegendItem({required this.color, required this.text});
  @override
  Widget build(BuildContext context){
    return Row(
      children: [
        Container(width: 18, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12))),
        SizedBox(width: 6),
        Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

extension MapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int index, E e) f) sync* {
    int i = 0;
    for (var e in this) {
      yield f(i, e);
      i++;
    }
  }
}