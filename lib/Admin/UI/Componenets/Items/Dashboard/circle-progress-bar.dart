import 'package:flutter/material.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class CircleProgressBar extends StatelessWidget {
   CircleProgressBar({required this.color , required this.num});
  Color color;
  double num;

  @override
  Widget build(BuildContext context) {
    return  SimpleCircularProgressBar(
      valueNotifier: ValueNotifier(this.num),
      progressStrokeWidth: 5,
      backStrokeWidth: 5,
      maxValue: 100,
      backColor: Colors.grey,
      progressColors: [this.color],
      onGetText: (value) => Text(
        '${value.toInt()}%',
        style: TextStyle(
          fontSize: 24,
          color: this.color,
        ),
      ),
    );
  }
}

