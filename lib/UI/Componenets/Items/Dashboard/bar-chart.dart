import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample extends StatelessWidget {
  const BarChartSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final barWidth = isPortrait ? 20.0 : 30.0;
    final groupsSpace = isPortrait ? 12.0 : 20.0;
    return Container(
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
           groupsSpace: groupsSpace,
          barGroups: [
            // میله هفتم
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 10,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 5, Colors.blue),
                    BarChartRodStackItem(5, 8, color18),
                    BarChartRodStackItem(8 , 10, color19),
                  ],
                ),
              ],
            ),
            // میله ششم
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 8,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 1, Colors.blue),
                    BarChartRodStackItem(1, 3, color18),
                    BarChartRodStackItem(3, 8, color19),
                  ],
                ),
              ],
            ),
            // میله بنجم
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 10,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 7, Colors.blue),
                    BarChartRodStackItem(7, 10, color18),
                  ],
                ),
              ],
            ),
            // میله چهارم
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 8,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 2, Colors.blue),
                    BarChartRodStackItem(2, 5, color18),
                    BarChartRodStackItem(5, 7, color19),
                  ],
                ),
              ],
            ),
            // میله سوم
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 8,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 4, Colors.blue),
                    BarChartRodStackItem(4, 10, color18),
                  ],
                ),
              ],
            ),
            // میله دوم
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 8,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 1, Colors.blue),
                    BarChartRodStackItem(1, 4, color18),
                    BarChartRodStackItem(4, 9, color19),
                  ],
                ),
              ],
            ),

            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: 9,
                  color: Colors.transparent,
                  width: barWidth,
                  borderRadius: BorderRadius.zero,
                  rodStackItems: [
                    BarChartRodStackItem(0, 4, Colors.blue),
                    BarChartRodStackItem(4, 6, color18),
                    BarChartRodStackItem(6, 9, color19),
                  ],
                ),
              ],
            ),
          ],
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                  interval: 2,
                getTitlesWidget: (value, meta) {
                  final labels = ['AM0', 'AM2', 'AM4', 'AM6', 'AM8', 'AM10'];
                  return Txt(labels[value ~/ 2]);
                },
                reservedSize: 40,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Transform.rotate(
                    angle: isPortrait ? -0.4 :0,
                      child: Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Txt(['شنبه', 'یکشنبه','دوشنبه','سه شنبه','چهارشنبه','پنج شنبه','جمعه'][value.toInt()],fontSize:  isPortrait ? 10 : 12,)
                      )
                  );
                },
                reservedSize: isPortrait ? 40 : 50,
              ),
            ),
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          barTouchData: BarTouchData(enabled: false),
        ),
      ),
    );
  }
}