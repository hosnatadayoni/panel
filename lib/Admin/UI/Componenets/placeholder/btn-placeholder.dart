import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/placeholder/content-placeholder.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../btn.dart';

class ButtonPlaceholder extends StatelessWidget {
  double? width;
  double? height;
  // Color? baseColor;
  Color? highlightColor;
  PlaceholderAnimationType? animationType;
  btnType type;



  ButtonPlaceholder({
    this.width,
    // this.baseColor,
    this.height,
    this.animationType,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return IgnorePointer(
      ignoring: true,
      child: _buildAnimatedPlaceholder(
        width: this.width ??size.width,
        height: this.height ?? 40,
        animationType: this.animationType,
        // baseColor: this.baseColor != null ? this.baseColor : color37,
        highlightColor:this.highlightColor != null ? this.highlightColor! : Colors.grey[100]!,
      ),
    );
  }
  Widget _buildAnimatedPlaceholder({
    double? width,
    double? height,
    PlaceholderAnimationType? animationType,
    Color? baseColor,
    Color? highlightColor,
  }) {
    switch (animationType) {
      case PlaceholderAnimationType.glow:
        return Shimmer.fromColors(
          baseColor: baseColor!,
          highlightColor: highlightColor!,
          period: const Duration(milliseconds: 1500),
          child: box(width! , height!),
        );
      case PlaceholderAnimationType.wave:
        return Shimmer(
          gradient: LinearGradient(
            colors: [
              baseColor!,
              highlightColor!,
              baseColor,
            ],
            stops: const [0.1, 0.5, 0.9],
          ),
          period: const Duration(milliseconds: 2000),
          child: box(width! , height!),
        );
      default:
        return box(width! , height!);
    }
  }
  Widget box(double width , double height){
    // return Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     color: baseColor,
    //   ),
    //   width: width,
    //   height: height,
    // );
    return Btn(type: this.type,width: width,height: height,disabled: true,content: Container(),);
  }
}