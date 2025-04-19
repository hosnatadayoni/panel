import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/pie-chart.dart';
import 'package:flutter/material.dart';

class MainPieChart extends StatefulWidget {
  const MainPieChart({Key? key}) : super(key: key);

  @override
  State<MainPieChart> createState() => _MainPieChartState();
}

class _MainPieChartState extends State<MainPieChart> {
  int hoveredLegendIndex = -1;
  final data = [
    {'color': color23, 'value': 55, 'title': 'سرورهای پایین'},
    {'color': color22, 'value': 41, 'title': 'در حال اجرا'},
    {'color': purpleColor, 'value': 44, 'title': 'سرورهای ثابت'},
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Txt('${AppController.of(context)!.value('Summary of the chart')}', fontSize: 24, fontWeight: FontWeight.w500, color: color20,)),
            InkWell(
                onTap: (){},
                child: Txt('${AppController.of(context)!.value('Download the report')}', fontSize: 24, fontWeight: FontWeight.w600, color: purpleColor,)),
          ],
        ),
        // SizedBox(height: 10,),
        PieChartSample(data: data, hoveredLegendIndex: hoveredLegendIndex, onLegendHover: (index) {
          setState(() {
            hoveredLegendIndex = index;
          });
        }),
        SizedBox(height: 10,),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 10,
          children: [
            for(var i=0;i<data.length;i++)
              MouseRegion(
                onEnter: (_) => setState(() => hoveredLegendIndex = i),
                onExit: (_) => setState(() => hoveredLegendIndex = -1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      color: data[i]['color'] as Color,
                    ),
                    SizedBox(width: 5),
                    Txt('${data[i]['title']} : ${data[i]['value']}', fontSize: 14, color: color20)
                  ],
                ),
              )
          ],
        )
      ],
    );
  }
}
