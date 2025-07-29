import 'package:panel/Admin/Public/styles.dart';
import 'package:flutter/animation.dart';

import '../btn.dart';

class ProgressItem {
  double value;
  // Color progressBarolor;
  // Color labelColor;
  bool showLabel;
  bool? hasStriped;
  bool? hasAnimated;
  btnType type;

  ProgressItem({
    required this.value,
    // this.progressBarolor = colorBtn,
    // this.labelColor = whiteColor,
    this.showLabel = false,
    this.hasStriped = false,
    this.hasAnimated =  false,
    this.type = btnType.primary,
  });
}