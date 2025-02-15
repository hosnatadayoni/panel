import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class RadioButton extends StatelessWidget {
  String? name;
  List<FormBuilderChipOption>?  radioButtonItems;
  // List<Map<String, dynamic>>? radioButtonItems;
  Function(String?)? onChanged;
  String? initalValue;
  GlobalKey<FormBuilderState>? fbKey = GlobalKey<FormBuilderState>();
  var column;
   RadioButton({this.name , this.radioButtonItems , this.initalValue , this.fbKey , this.onChanged , this.column});

  @override
  Widget build(BuildContext context) {
    print('radioButtonItems>>>${radioButtonItems}');
    var inputRequired;
    String? errorMessage;
    Rx<bool> isSelectedItem = false.obs;
    if(this.column['validators'] != null){
      inputRequired = this.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      errorMessage = inputRequired['message'];
    }
    return Obx((){
      print('${isSelectedItem.value}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilderRadioGroup(
            name: '${this.name}',
            activeColor: primary2,
            decoration: InputDecoration(border: InputBorder.none),
            initialValue: this.initalValue,
            options: this.radioButtonItems!,
            onChanged: (text){
              isSelectedItem.value = true;
              if(this.onChanged!=null)
                this.onChanged!(text);
            },
          ),
          SizedBox(height: 5,),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedCreateBtn.value == true &&  isSelectedItem.value == false?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
        ],
      );
    });
  }
}
