// import 'package:flutter/material.dart';
// class MainPieChart extends StatelessWidget {
//   const MainPieChart({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//
//       ],
//     );
//   }
// }

import 'package:finance/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class PieChartSample extends StatefulWidget {
  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  int touchedIndex = -1;
  OverlayEntry? _tooltipEntry;
  final data = [
    {'color': color23, 'value': 55, 'title': 'سرورهای پایین'},
    {'color': color22, 'value': 41, 'title': 'در حال اجرا'},
    {'color': purpleColor, 'value': 44, 'title': 'سرورهای ثابت'},
  ];

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _removeTooltip() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

  void _showTooltip(BuildContext context, Offset position, String text) {
    _removeTooltip();

    _tooltipEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 10,
        top: position.dy + 10,
        child: Material(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_tooltipEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(event.position);

        final pieChartData = PieChartData(
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(),
        );

        final touchedSection = _getTouchedSection(
          localPosition,
          renderBox.size,
          pieChartData,
        );

        if (touchedSection != null) {
          final index = data.indexWhere((item) => item['value'] == touchedSection.value);
          if (index != -1) {
            _showTooltip(context, event.position, data[index]['title'] as String);
          }
        } else {
          _removeTooltip();
        }
      },
      onExit: (_) => _removeTooltip(),
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sectionsSpace: 0,
          centerSpaceRadius: 40,
          sections: showingSections(),
        ),
      ),
    );
  }

  PieChartSectionData? _getTouchedSection(
      Offset localPosition,
      Size chartSize,
      PieChartData pieChartData,
      ) {
    final center = Offset(chartSize.width / 2, chartSize.height / 2);
    final radius = chartSize.width / 2;
    final distance = (localPosition - center).distance;

    if (distance > radius) return null;

    double startAngle = -90 * (3.141592653589793 / 180);

    for (var section in pieChartData.sections) {
      final sweepAngle = 360 * (section.value / 100) * (3.141592653589793 / 180);
      final angle = (localPosition - center).direction;

      if (angle >= startAngle && angle <= startAngle + sweepAngle) {
        return section;
      }

      startAngle += sweepAngle;
    }

    return null;
  }

  // List<PieChartSectionData> showingSections() {
  //   return List.generate(3, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 18.0 : 14.0;
  //     final radius = isTouched ? 60.0 : 50.0;
  //
  //     return PieChartSectionData(
  //       color: data[i]['color'] as Color,
  //       // value: data[i]['value'] as double,
  //       title: '${data[i]['value']}%',
  //       radius: radius,
  //       titleStyle: TextStyle(
  //         fontSize: fontSize,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.white,
  //       ),
  //       badgePositionPercentageOffset: .98,
  //     );
  //   });
  // }

  List<PieChartSectionData> showingSections() {
    final total = data.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());

    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      print('isTouched>>>${isTouched} ${touchedIndex} ${i}');
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final value = (data[i]['value'] as num).toDouble();
      final percentage = (value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: data[i]['color'] as Color,
        value: value,
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }
}