import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class ColorPickerBox extends StatefulWidget {
Color selectedColor = Colors.blue;
Function(Color)? onChanged;
String? lable;
Color? lableColor;
bool? disabled;
Color? disabledBoxColor;
Color? borderColor;

ColorPickerBox({
  this.onChanged ,
  required this.selectedColor ,
  this.lable = 'Color Picker',
  this.lableColor = darkBackground,
  this.disabled =false,
  this.disabledBoxColor = color38,
  this.borderColor =  color5,
});
@override
_ColorPickerBoxState createState() => _ColorPickerBoxState();
}

class _ColorPickerBoxState extends State<ColorPickerBox> {
  // Color selectedColor = Colors.blue;
  var colorSelected = null;


  void openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Txt('${AppController.of(context)!.value('Please choose the color you want')}'),
          content: ColorPicker(
            pickerColor:widget.selectedColor,
            onColorChanged: (Color color) {
              setState(() {
                widget.selectedColor = color;
                colorSelected = color;
                if (widget.onChanged != null) {
                  widget.onChanged!(color);
                }
              });
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
          actions: <Widget>[
            TextButton(
              child: Txt('${AppController.of(context)!.value('save')}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: widget.disabled! ? null :(){
            openColorPicker(context);
          },
            child: Txt(widget.lable! , fontSize: 16, fontWeight: FontWeight.w400,color: widget.lableColor, )),
        SizedBox(height: 10,),
        InkWell(
          onTap: widget.disabled! ? null :(){
            openColorPicker(context);

          },
          child: Container(
            width: 48,
            height: 38,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: widget.borderColor!),
              borderRadius: BorderRadius.circular(5),
              color: widget.disabled! ?widget.disabledBoxColor : Colors.transparent
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: widget.selectedColor,
                ),

              ),
            ),
          ),
        ),
      ],
    );
  }
}
