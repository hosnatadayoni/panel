import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:flutter/material.dart';

class TooltipWidget extends StatefulWidget {
  final Widget content;
  final Widget btn;

  const TooltipWidget({
    required this.content,
    required this.btn,
  });

  @override
  State<TooltipWidget> createState() => _TooltipWidgetState();
}

class _TooltipWidgetState extends State<TooltipWidget> {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
