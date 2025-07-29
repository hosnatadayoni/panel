import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
class CheckBox extends StatefulWidget {
  String? checkBoxName;
  String? checkBoxTitle;
  bool? defaultValue;
  Function? onChange;
  int? index;
  var column;
  Rx<bool>? isClickedBtn = false.obs;
  CheckBox({this.checkBoxName,
    this.checkBoxTitle ,
    this.defaultValue ,
    this.onChange ,
    this.index ,
    this.column,
    this.isClickedBtn
  });

  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {

  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column != null){
      if(widget.column['validators'] != null){
        inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
        errorMessage = inputRequired['message'];
      }
    }
    return  Obx((){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilderCheckbox(
            key: Key('${widget.index}'),
            name: '${widget.checkBoxName}',
            decoration: InputDecoration(border: InputBorder.none),
            activeColor: colorBtn,
            title: Txt('${widget.checkBoxTitle}', color: MainController.isLightMode.value == true?  whiteColor:color2),
            initialValue: widget.defaultValue,
            side:  BorderSide(
                color: MainController.isLightMode.value ? whiteColor : primaryDark,
                width: 1.5,
                strokeAlign: 2.5
            ),
            onChanged: (text){
              widget.isClickedBtn?.value = true;
              if(widget.onChange!=null)
                this.widget.onChange!(text);
            },

          ),
          SizedBox(height: 5,),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedBtn.value == true && widget.isClickedBtn?.value == false || ViewController.isClickedEditBtn.value == true && widget.isClickedBtn?.value == false?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
        ],
      );
    });
  }
}
