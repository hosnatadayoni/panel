import 'package:panel/Admin/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../btn.dart';
enum PlaceholderAnimationType {
  glow,
  wave,
}
class ContentPlaceholder extends StatelessWidget {
  double? width;
  double? height;
  // Color? baseColor;
  Color? circleColor;
  Color? circleColorActive;
  Color? highlightColor;
  Color? boxColor;
  PlaceholderAnimationType? animationType;
  btnType? type;

  ContentPlaceholder({
    this.width,
    this.height,
    // this.baseColor,
    this.circleColor = colorBtn,
    this.circleColorActive = Colors.blue ,
    this.highlightColor,
    this.boxColor = whiteColor,
    this.animationType,
    this.type,
  });


  @override
  Widget build(BuildContext context) {
    final hoverPosition = Rx<Offset?>(null);
    var size = MediaQuery.of(context).size;
    Color backgroundColor(){
      if(this.type == btnType.primary){
        return colorBtn;
      }
      else if(this.type == btnType.secondary){
        return secondry;
      }
      else if(this.type == btnType.success){
        return success;
      }
      else if(this.type == btnType.danger){
        return danger;
      }
      else if(this.type == btnType.warning){
        return warning;
      }
      else if(this.type == btnType.info){
        return info;
      }
      else if(this.type == btnType.light){
        return light;
      }
      else if(this.type == btnType.dark){
        return dark;
      }
      else if(this.type == btnType.link){
        return Colors.transparent;
      }
      return dark;
    }
    return  SizedBox(
      height: this.height ?? 20,
      child: Obx(() {
        return MouseRegion(
          onHover: (details) => hoverPosition.value = details.localPosition,
          onExit: (_) => hoverPosition.value = null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Shimmer.fromColors(
              //   baseColor: line.baseColor!,
              //   highlightColor: Colors.grey[100]!,
              //   child: Container(
              //     width: line.width ?? size.width,
              //     height: line.height ?? 20,
              //     color: Colors.white,
              //   ),
              // ),
              _buildAnimatedPlaceholder(
                width: this.width ??size.width,
                height: this.height ?? 20,
                animationType: this.animationType,
                // baseColor: this.baseColor != null ? this.baseColor! : Colors.grey[300]!,
                baseColor:  backgroundColor().withOpacity(0.6),
                highlightColor:this.highlightColor != null ? this.highlightColor! : Colors.grey[100]!,
              ),
              if (hoverPosition.value != null)
                Positioned(
                  left: hoverPosition.value!.dx - 10,
                  top: -5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(this.circleColorActive!),
                      backgroundColor: this.circleColor,
                      strokeWidth: 5,
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
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
          child: Container(
            width: width,
            height: height,
            color: this.boxColor,
          ),
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
          child: Container(
            width: width,
            height: height,
            color: this.boxColor,
          ),
        );
      default:
        return Container(
          width: width,
          height: height,
          color: baseColor,
        );
    }
  }
}
