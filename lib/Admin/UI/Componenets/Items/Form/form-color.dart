import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
class ColorPickerBox extends StatefulWidget {
  Color selectedColor = Colors.blue;
  Function(Color)? onChanged;
  var column;
  Rx<bool>? isSeletedColor = false.obs;

  ColorPickerBox({this.onChanged , required this.selectedColor , this.column , this.isSeletedColor});
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
            // pickerColor:selectedColor,
              pickerColor:widget.selectedColor,
            onColorChanged: (Color color) {
              setState(() {
                // selectedColor = color;
                // MainController.selectedColor = selectedColor;
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
    var inputRequired;
    String? errorMessage;
    if(widget.column != null){
      if(widget.column.validators != null){
        inputRequired = widget.column.validators.firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
        errorMessage = inputRequired['message'];
      }
    }

    return Obx((){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: (){
                  openColorPicker(context);
                  setState(() {
                    widget.isSeletedColor!.value = true;
                    errorMessage='';
                  });

                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  color: colorSelected == null ?widget.selectedColor:colorSelected,
                  // color: MainController.selectedColor,
                  child: Center(child: Txt('${AppController.of(context)!.value('Pick a Color')}', textAlign: TextAlign.center,)),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedBtn.value== true && widget.isSeletedColor!.value == false ||ViewController.isClickedEditBtn.value== true && widget.isSeletedColor!.value == false ?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
        ],
      );
    });
  }
}