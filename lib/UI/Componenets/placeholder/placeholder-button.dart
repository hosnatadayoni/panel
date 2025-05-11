import 'package:finance/Public/styles.dart';
import 'package:flutter/material.dart';

class PlaceholderButton extends StatelessWidget {
   double widthFraction;
   double height;
   Color primaryColor;


   PlaceholderButton({

    this.widthFraction = 200,
    this.primaryColor = color37,
     this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        width: this.widthFraction,
        height: this.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor.withOpacity(0.6),
        ),

      ),
    );
  }
}