import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Dashboard/bar-chart2.dart';
import 'package:flutter/material.dart';
class VisitorsChart extends StatelessWidget {
   VisitorsChart({Key? key}) : super(key: key);
  String allVisitors= '98425';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt('${AppController.of(context)!.value('visitors')}' , fontSize: 24, fontWeight: FontWeight.w500, color: color20,),
          SizedBox(height: 10,),
          Wrap(
            spacing: 10,
            runSpacing: 20,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Txt('${MainController.formatNumber(allVisitors)}' , fontSize: 45, fontWeight: FontWeight.w400, color: color21,),
              SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Txt('+ 2.5%' , fontSize: 16, fontWeight: FontWeight.w200, color: color20,),
                  Txt('${AppController.of(context)!.value('Compared to last week')}' , fontSize: 16, fontWeight: FontWeight.w200, color: color20,),
                ],
              )
            ],
          )

        ],
      ),
        SizedBox(height: 20,),
        MainBarChart2(allVisistors: allVisitors),
      ],
    );
  }
}
