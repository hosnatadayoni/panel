import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class RowScroll extends StatelessWidget {
  List<Widget> children;
  RowScroll({required this.children});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
          scrollbars: false
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
