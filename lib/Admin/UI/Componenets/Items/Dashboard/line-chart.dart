import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class WeeklyChart extends StatefulWidget {
  const WeeklyChart({Key? key}) : super(key: key);

  @override
  _WeeklyChartState createState() => _WeeklyChartState();
}

class _WeeklyChartState extends State<WeeklyChart> {

  List<String> getWeekDaysStartingFromTomorrow() {
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE', 'fa').format(now);

    const allDays = ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنج‌شنبه', 'جمعه'];
    final currentIndex = allDays.indexWhere((day) => day == currentDay);

    return [
      ...allDays.sublist((currentIndex + 1) % allDays.length),
      ...allDays.sublist(0, (currentIndex + 1) % allDays.length),
    ];
  }
  @override
  Widget build(BuildContext context) {
    final weekDays = getWeekDaysStartingFromTomorrow();
    final spots = [
      FlSpot(0.05, 2),
      FlSpot(1, 1),
      FlSpot(2, 1),
      FlSpot(3, 2),
      FlSpot(4, 1),
      FlSpot(5, 1),
      FlSpot(6, 1),
    ];
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 1,
          verticalInterval: 2,
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
            left: BorderSide.none,
            right: BorderSide.none,
            top: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < weekDays.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Txt(weekDays[value.toInt()], color:Colors.grey,  fontSize: 10,),
                  );
                }
                return  Txt('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value % 2 == 0) {
                  return Txt(value.toInt().toString(), color:Colors.grey ,  fontSize: 10,);
                }
                return  Txt('');
              },
              interval: 2,
              reservedSize: 30,
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${weekDays[spot.x.toInt()]}\n ${spot.y.toStringAsFixed(1)}',
                  const TextStyle(color: Colors.white),
                );
              }).toList();
            },
          ),
          handleBuiltInTouches: true,
        ),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 10,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: itemColor13,
            barWidth: 2,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: blackColor,
                );
              },
            ),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}