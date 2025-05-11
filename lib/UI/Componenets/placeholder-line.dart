import 'package:finance/Public/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
enum PlaceholderAnimationType {
  glow,
  wave,
  none,
}
class PlaceholderLine extends StatelessWidget {
  double? width;
  double? height;
  Color? baseColor;
  Color? circleColor;
  Color? circleColorActive;
  PlaceholderAnimationType animationType;

  PlaceholderLine({
    this.width,
    this.height,
    this.baseColor = darkBackground,
    this.circleColor = colorBtn,
    this.circleColorActive = Colors.blue ,
    this.animationType = PlaceholderAnimationType.glow,
  });

  @override
  Widget build(BuildContext context) {
    final hoverPosition = Rx<Offset?>(null);
    var size = MediaQuery.of(context).size;
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
                baseColor: this.baseColor!,
                highlightColor:Colors.grey[100]!,
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
            color: Colors.white,
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
            color: Colors.white,
          ),
        );
      case PlaceholderAnimationType.none:
      default:
        return Container(
          width: width,
          height: height,
          color: baseColor,
        );
    }
  }
}
