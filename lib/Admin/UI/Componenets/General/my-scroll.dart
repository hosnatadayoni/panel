import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MyScroll extends StatelessWidget {
  Widget child;
  MyScroll({Key? key,required this.child}) : super(key: key);
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return Scrollbar(
        interactive: true,
        thickness: 10,
        thumbVisibility: size.width<500?false:true,
        trackVisibility: size.width<500?false:true,
        controller: _scrollController,

        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                },
                scrollbars: false
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: child,
            )))
    ;
  }
}
