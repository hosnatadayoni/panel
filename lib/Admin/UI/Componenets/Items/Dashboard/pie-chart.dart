import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';

class PieChartSample extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final int hoveredLegendIndex;
  final Function(int) onLegendHover;

  const PieChartSample({
    Key? key,
    required this.data,
    required this.hoveredLegendIndex,
    required this.onLegendHover,
  }) : super(key: key);

  @override
  _PieChartSampleState createState() => _PieChartSampleState();
}

class _PieChartSampleState extends State<PieChartSample> {
  int touchedIndex = -1;
  OverlayEntry? _tooltipEntry;
  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _removeTooltip() {
    _tooltipEntry?.remove();
    _tooltipEntry = null;
  }

  void _showTooltip(BuildContext context, Offset position, var data) {
    _removeTooltip();

    _tooltipEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position.dx + 10,
        top: position.dy + 10,
        child: Material(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: data['color'],
              borderRadius: BorderRadius.circular(4),
            ),
            child: Txt(
              '${data['title'] as String} : ${data['value']}',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_tooltipEntry!);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 250,
      child: MouseRegion(
        onHover: (PointerHoverEvent event) {
          if (touchedIndex != -1) {
            _showTooltip(
              context,
              event.position,
              widget.data[touchedIndex],
            );
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
                    _removeTooltip();
                    return;
                  }
                  touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            sectionsSpace: 0,
            centerSpaceRadius: 60,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final total = widget.data.fold(0.0, (sum, item) => sum + (item['value'] as num).toDouble());

    return List.generate(widget.data.length, (i) {
      final isTouched = i == touchedIndex;
      final isHovered = i == widget.hoveredLegendIndex;
      final shouldHighlight = isHovered || widget.hoveredLegendIndex == -1;
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      final value = (widget.data[i]['value'] as num).toDouble();
      final percentage = (value / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: shouldHighlight
            ? widget.data[i]['color'] as Color
            : (widget.data[i]['color'] as Color).withOpacity(0.3),
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