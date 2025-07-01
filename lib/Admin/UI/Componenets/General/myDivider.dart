import 'package:flutter/material.dart';

import '../../../Public/styles.dart';

class MyDivider extends StatelessWidget {
  double padding;
  MyDivider({this.padding=0});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: itemColor25,
      margin: EdgeInsets.only(left: padding,right: padding),
    );
  }
}
