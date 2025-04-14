import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/myDivider.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class DashboardInfo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String count;
  final String description;

  const DashboardInfo({
    Key? key,
    required this.icon,
    required this.color,
    required this.count,
    required this.description,
  }) : super(key: key);

  String _formatNumber(String number) {
    try {
      final num value = num.tryParse(number) ?? 0;
      return NumberFormat.decimalPattern().format(value);
    } catch (e) {
      return number;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      // width: 200,
      width:size.width > 800 ?  size.width / 4: size.width,
      height: 150,
      decoration: BoxDecoration(
        boxShadow: shadow
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: whiteColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Txt(
                          _formatNumber(count),
                          fontSize: 16,
                          fontWeight: FontWeight.w200,
                          color: color1,
                        ),
                      ),
                    ),
                  ),
                  MyDivider(),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Txt(
                          description,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 100,
            color: color,
            child: Center(
              child: Icon(icon, size: 32, color: whiteColor),
            ),
          ),
        ],
      ),
    );
  }
}