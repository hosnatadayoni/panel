import 'package:panel/Admin/Public/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData});

  final bool isShowingMainData;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      isShowingMainData ? sampleData1 : sampleData2,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get sampleData1 => LineChartData(
    lineTouchData: lineTouchData1,
    gridData: gridData,
    titlesData: titlesData1,
    borderData: borderData,
    lineBarsData: lineBarsData1,
    minX: 0,
    maxX: 12,
    minY: 0,
    maxY: 75,
  );

  LineChartData get sampleData2 => LineChartData(
    lineTouchData: lineTouchData2,
    gridData: gridData,
    titlesData: titlesData2,
    borderData: borderData,
    lineBarsData: lineBarsData2,
    minX: 0,
    maxX: 12, // 0 تا 9 برای 10 مقدار زمانی
    minY: 0,
    maxY: 75,
  );

  LineTouchData get lineTouchData1 => LineTouchData(
    handleBuiltInTouches: true,
    touchTooltipData: LineTouchTooltipData(
      tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
    ),
  );

  FlTitlesData get titlesData1 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData1 => [
    lineChartBarData1_1,
    lineChartBarData1_2,

  ];

  LineTouchData get lineTouchData2 =>  LineTouchData(
    enabled: false,
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    bottomTitles: AxisTitles(
      sideTitles: bottomTitles,
    ),
    rightTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles:  AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    leftTitles: AxisTitles(
      sideTitles: leftTitles(),
    ),
  );

  List<LineChartBarData> get lineBarsData2 => [
    lineChartBarData2_1,
    lineChartBarData2_2,

  ];

  // Widget leftTitleWidgets(double value, TitleMeta meta) {
  //   const style = TextStyle(
  //     fontWeight: FontWeight.bold,
  //     fontSize: 14,
  //   );
  //   if (value == 0 || value == 25 || value == 50 || value == 75) {
  //     return Text(
  //       value.toInt().toString(),
  //       style: style,
  //       textAlign: TextAlign.center,
  //     );
  //   }
  //
  //   return Text(
  //     text,
  //     style: style,
  //     textAlign: TextAlign.center,
  //   );
  // }
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
      color: color14,
    );

    if (value == 0 || value == 25 || value == 50 || value == 75) {
      return Text(
        value.toInt().toString(),
        style: style,
        textAlign: TextAlign.center,
      );
    }
    return Container();
  }

  SideTitles leftTitles() => SideTitles(
    getTitlesWidget: leftTitleWidgets,
    showTitles: true,
    interval: 25,
    reservedSize: 40,
  );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: color14
    );


    final times = [
      '14:00', '14:10', '14:20', '14:30', '14:40',
      '14:50', '14:50' , '15:00', '15:10', '15:20', '15:30'
    ];

    final index = value.toInt();
    if (index >= 0 && index < times.length) {
      return Text(times[index], style: style);
    }
    return const Text('');
  }

  SideTitles get bottomTitles => SideTitles(
    showTitles: true,
    reservedSize: 32,
    interval: 2,
    getTitlesWidget: bottomTitleWidgets,
  );

  FlGridData get gridData =>  FlGridData(show: true);

  FlBorderData get borderData => FlBorderData(
    show: true,
    border: Border(
      bottom: BorderSide(
        color: color15, // رنگ را اصلاح کنید
        width: 2,
      ),
      left: BorderSide(
        color: color15, // رنگ را اصلاح کنید
        width: 2,
      ),
      right: BorderSide(
        color: color15, // رنگ را اصلاح کنید
        width: 2,
      ),
      top: BorderSide(
        color:color15, // رنگ را اصلاح کنید
        width: 2,
      ),
    ),
  );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: color16,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData:  FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(0, 23), // 14:00
      FlSpot(1, 11), // 14:10
      FlSpot(2, 22), // 14:20
      FlSpot(3, 27), // 14:30
      FlSpot(4, 13), // 14:40
      FlSpot(5, 22), // 14:50
      FlSpot(6, 37), // 15:00
      FlSpot(7, 21), // 15:10
      FlSpot(8, 44), // 15:20
      FlSpot(9, 22),
      FlSpot(9, 30),
      FlSpot(9, 45), // 15:30
    ],
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: color17,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData:  FlDotData(show: false),
    belowBarData: BarAreaData(
      show: false,
      // color: AppColors.contentColorPink.withValues(alpha: 0),
    ),
    spots: const [
      FlSpot(0, 30), // 14:00
      FlSpot(1, 25), // 14:10
      FlSpot(2, 36), // 14:20
      FlSpot(3, 30), // 14:30
      FlSpot(4, 45), // 14:40
      FlSpot(5, 35), // 14:50
      FlSpot(6, 64), // 15:00
      FlSpot(7, 52), // 15:10
      FlSpot(8, 59), // 15:20
      FlSpot(9, 36),
      FlSpot(9, 39),
      FlSpot(9, 51),
    ],
  );



  LineChartBarData get lineChartBarData2_1 => LineChartBarData(
    isCurved: true,
    curveSmoothness: 0,
    // color: AppColors.contentColorGreen.withValues(alpha: 0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData:  FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 4),
      FlSpot(5, 1.8),
      FlSpot(7, 5),
      FlSpot(10, 2),
      FlSpot(12, 2.2),
      FlSpot(13, 1.8),
    ],
  );

  LineChartBarData get lineChartBarData2_2 => LineChartBarData(
    isCurved: true,
    // color: AppColors.contentColorPink.withValues(alpha: 0.5),
    barWidth: 4,
    isStrokeCapRound: true,
    dotData:  FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      // color: AppColors.contentColorPink.withValues(alpha: 0.2),
    ),
    spots: const [
      FlSpot(1, 1),
      FlSpot(3, 2.8),
      FlSpot(7, 1.2),
      FlSpot(10, 2.8),
      FlSpot(12, 2.6),
      FlSpot(13, 3.9),
    ],
  );


}

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  late bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // return AspectRatio(
    //   aspectRatio: 1.0,
    //   child: Stack(
    //     children: <Widget>[
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.stretch,
    //         children: <Widget>[
    //           const SizedBox(
    //             height: 37,
    //           ),
    //           const SizedBox(
    //             height: 37,
    //           ),
    //           Expanded(
    //             child: Padding(
    //               padding: const EdgeInsets.all(16.0),
    //               child: _LineChart(isShowingMainData: isShowingMainData),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    return Container(

      width:size.width > 600 ? size.width/2 : size.width,
      padding: const EdgeInsets.all(16.0),
      child: _LineChart(isShowingMainData: isShowingMainData),
    );
  }
}
