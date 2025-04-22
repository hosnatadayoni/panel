import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {
   BarChartSample2({required this.allVisistors});
  String allVisistors;

  @override
  _BarChartSample2State createState() => _BarChartSample2State();
}

class _BarChartSample2State extends State<BarChartSample2> {
  int? hoveredIndex;
  final List<String> weekDays = ['جمعه', 'پنج شنبه', 'چهارشنبه', 'سه‌شنبه', 'دوشنبه', 'یکشنبه', 'شنبه'];
  final List<int> values = [40, 31, 40, 10, 40, 36, 32];
  final Color defaultColor = lightPurple;
  final Color hoverColor = purpleColor;

  double calculatePercentage(int value) {
    int total = values.reduce((a, b) => a + b);
    return (value / total) * 100;
  }

  BarChartGroupData generateGroupData(int x, int y) {
    final isHovered = hoveredIndex == x;
    return BarChartGroupData(
      x: x,
      showingTooltipIndicators: isHovered ? [0] : [],
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          fromY: 0,
          color: isHovered ? hoverColor : defaultColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
          width: 22,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    var size = MediaQuery.of(context).size;

    return Container(
      height: 200,
      width: size.width,
      child: AspectRatio(
        aspectRatio: 2.5,
        child: BarChart(
          BarChartData(
            barGroups: List.generate(
              weekDays.length,
                  (index) => generateGroupData(index, values[index]),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              touchCallback: (event, response) {
                if (response != null && response.spot != null) {
                  final x = response.spot!.touchedBarGroup.x;
                  if (event is FlPointerHoverEvent) {
                    setState(() => hoveredIndex = x);
                  } else if (event is FlPointerExitEvent) {
                    setState(() => hoveredIndex = null);
                  }
                } else if (event is FlPointerExitEvent) {
                  setState(() => hoveredIndex = null);
                }
              },
              mouseCursorResolver: (event, response) {
                return SystemMouseCursors.click;
              },
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: lightBlackColor,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  double percentage = calculatePercentage(values[group.x.toInt()]);
                  return BarTooltipItem(
                    '',
                    TextStyle(color: lightBlueColor , fontSize: 14 , fontWeight: FontWeight.w200),
                    children: [
                      TextSpan(
                        text: '${percentage.toStringAsFixed(1)}%\n',
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: '${AppController.of(context)!.value('visitors')} : ${rod.toY.toInt()}',
                        style: TextStyle(
                          color: lightBlueColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ]
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: Transform.rotate(
                      angle: isPortrait ? -0.4 :0,
                      child: Txt(
                        weekDays[value.toInt()],
                        fontSize: 12,
                      ),
                    ),
                    );
                  },
                  reservedSize: 40,
                ),
              ),
              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }
}