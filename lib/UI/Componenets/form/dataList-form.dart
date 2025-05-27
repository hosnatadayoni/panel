import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';

class DataListInput extends StatelessWidget {
   List<String> options;
   String label;
   String hintText;
   TextEditingController _controller = TextEditingController();
   bool? disabled;
   Color? lableColor;
   Color? disableColor;

  DataListInput({
    required this.options,
    required this.label,
    this.hintText = 'Type to search...',
    this.disabled = false,
    this.lableColor = darkBackground,
    this.disableColor = color38,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}