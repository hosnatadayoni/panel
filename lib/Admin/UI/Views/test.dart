import 'package:flutter/material.dart';

import '../Componenets/form/file-form.dart';
import '../Componenets/form/input-form.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      FileForm(lable: 'Large file input example' ,size: InputSize.large),
    ],);
  }
}
