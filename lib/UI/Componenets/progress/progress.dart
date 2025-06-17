import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/btn.dart';
import 'package:finance/UI/Componenets/progress/progress-item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// class GradientTranslation extends GradientTransform {
//   final double dx;
//   final double dy;
//
//   const GradientTranslation(this.dx, this.dy);
//
//   @override
//   Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
//     return Matrix4.translationValues(dx, dy, 0);
//   }
// }
//
// class CombinedGradientTransform extends GradientTransform {
//   final List<GradientTransform> transforms;
//
//   const CombinedGradientTransform(this.transforms);
//
//   @override
//   Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
//     var matrix = Matrix4.identity();
//     for (final transform in transforms) {
//       matrix = transform.transform(bounds, textDirection: textDirection)! * matrix;
//     }
//     return matrix;
//   }
// }

class MultiColorProgressBar extends StatefulWidget {
  List<ProgressItem> items;
  double? height;
  double? width;
  double borderRadius;
  Color backgroundColor;

  MultiColorProgressBar({
    required this.items,
    this.height = 20.0,
    this.width,
    this.borderRadius = 10.0,
    this.backgroundColor = color38,
  });

  @override
  State<MultiColorProgressBar> createState() => _MultiColorProgressBarState();
}

class _MultiColorProgressBarState extends State<MultiColorProgressBar>with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  // late Animation<double> _animation;
  // @override
  // void initState() {
  //   super.initState();
  //   _controller = AnimationController(
  //     duration: const Duration(seconds: 2),
  //     vsync: this,
  //   )..repeat();
  //   _animation = Tween(begin: 0.0, end: 1.0).animate(
  //     CurvedAnimation(
  //       parent: _controller,
  //       curve: Curves.linear,
  //     ),
  //   )..addListener(() {
  //     if (_animation.status == AnimationStatus.completed) {
  //       _controller.forward(from: 0.0);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Color? backgroundColor(btnType segment){
      if(segment == btnType.primary){
        return colorBtn;
      }
      else if(segment == btnType.secondary){
        return secondry;
      }
      else if(segment == btnType.success){
        return success;
      }
      else if(segment == btnType.danger){
        return danger;
      }
      else if(segment == btnType.warning){
        return warning;
      }
      else if(segment == btnType.info){
        return info;
      }
      else if(segment == btnType.light){
        return light;
      }
      else if(segment == btnType.dark){
        return dark;
      }
      else if(segment == btnType.link){
        return Colors.transparent;
      }
    }
    Color contentColor(btnType segment){
      if(segment == btnType.primary || segment == btnType.secondary ||
          segment == btnType.success || segment == btnType.danger || segment == btnType.dark){
        return whiteColor;
      }
      else if(segment == btnType.warning || segment == btnType.info || segment == btnType.light){
        return blackColor;
      }
      else if(segment == btnType.link){
        return colorBtn;
      }
      return dark;
    }
    BorderRadius _getBorderRadius(ProgressItem segment, List<ProgressItem> allSegments , int i , double totalWidth) {
      double accumulatedWidth = 0;
      for (int j = 0; j <= i; j++) {
        accumulatedWidth += (totalWidth * (widget.items[j].value / 100));
      }
      bool isAtEnd = (accumulatedWidth + widget.items[i].value) >= totalWidth;

      return BorderRadius.only(
          topRight: Radius.circular(i==0 ?widget.borderRadius:0),
          bottomRight: Radius.circular(i==0 ?widget.borderRadius:0),
          topLeft: Radius.circular(isAtEnd ? widget.borderRadius : 0),
          bottomLeft: Radius.circular(isAtEnd ? widget.borderRadius : 0)
      );
    }

    return LayoutBuilder(builder: (context, constraints){
      final totalWidth = constraints.maxWidth;
      return Container(
        height: widget.height,
        width: widget.width != null ? widget.width : size.width,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Row(
          children: [
            for(var i=0;i<widget.items.length;i++)
              SizedBox(
                width: totalWidth * (widget.items[i].value / 100),
                child: ClipRRect(
                  borderRadius: _getBorderRadius(widget.items[i] , widget.items , i , totalWidth),
                  child: Container(
                    // color: widget.items[i].progressBarolor,
                    color: backgroundColor(widget.items[i].type),
                    child: Semantics(
                      value: '${widget.items[i].value}%',
                      child:widget.items[i].showLabel ? Center(
                        child: Txt(
                          '${widget.items[i].value}%',
                          // color: widget.items[i].labelColor,
                          color: contentColor(widget.items[i].type),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ): Container(),
                    ),
                  ),
                ),
              )
          ],
        ),
      );
    });
  }
// Widget box(int i , double totalWidth , [double animationValue = 0]){
//   var size = MediaQuery.of(context).size;
//   double accumulatedWidth = 0;
//   for (int j = 0; j < i; j++) {
//     accumulatedWidth += widget.items[j].value;
//   }
//   bool isAtEnd = (accumulatedWidth + widget.items[i].value) >= totalWidth;
//
//   return Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.only(
//           topRight: Radius.circular(i==0 ?widget.borderRadius:0),
//           bottomRight: Radius.circular(i==0 ?widget.borderRadius:0),
//           topLeft: Radius.circular(isAtEnd ? widget.borderRadius : 0),
//           bottomLeft: Radius.circular(isAtEnd ? widget.borderRadius : 0)
//       ),
//       color: widget.items[i].progressBarolor,
//       gradient: widget.items[i].hasStriped == true
//           ?  LinearGradient(
//         begin: Alignment.topLeft,
//         end: Alignment(-0.4, -0.8),
//         stops: [0.0, 0.5, 0.5, 1],
//         colors: [
//           whiteColor.withOpacity(0.01),
//           whiteColor.withOpacity(0.01),
//           widget.items[i].progressBarolor,
//           widget.items[i].progressBarolor,
//
//         ],
//         tileMode: TileMode.repeated,
//         transform: widget.items[i].hasAnimated!
//             ?  CombinedGradientTransform([
//           GradientRotation(0.785),
//           GradientTranslation(animationValue * 20, 0),
//         ])
//             : GradientRotation(0.785),
//       )
//           : null,
//     ),
//     width: widget.items[i].value,
//     height: widget.height,
//   );
// }
// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }
}
