import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class SelectBox extends StatefulWidget {
  String? name;
  List<DropdownMenuItem<String>>? items;
  String? hintText;
  String? selectedValue;
   Function(String?)? onChanged;
   String? initalValue;
  var column;
  Rx<bool>? isSeleted = false.obs;
  SelectBox({
     this.name,
    this.items,
     this.hintText,
     this.selectedValue,
    this.onChanged,
    this.initalValue,
    this.column,
    this.isSeleted,
  });

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column!=null)
    if(widget.column['validators'] != null && widget.column['validators'].length!=0){
       inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
       errorMessage = inputRequired['message'];
    }
    return widget.items!.isNotEmpty? FormBuilder(
      child: Obx((){
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderDropdown(
              name: widget.name!,
              dropdownColor: MainController.isLightMode.value ? primaryDark : whiteColor,
              isExpanded: true,
              decoration: InputDecoration(
                // contentPadding: EdgeInsets.only(right: 40),
                contentPadding:EdgeInsets.only(right: 10 , top: 21,bottom: 21),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MainController.isLightMode.value ? whiteColor : primaryDark, width: 0),
                ),
                border: OutlineInputBorder(),
                constraints: BoxConstraints(minHeight: 60),
                labelStyle: TextStyle(color: MainController.isLightMode.value ? whiteColor : primaryDark),
              ),
              hint: Txt(widget.hintText??'', color: MainController.isLightMode.value ? whiteColor : primaryDark),
              initialValue: widget.initalValue,
              items: widget.items!,
              onChanged: (value) {
              setState(() {
                 widget.isSeleted!.value = true;
                  widget.selectedValue = value!.toString();
                  if (widget.onChanged != null) {
                    widget.onChanged!(value.toString());
                  }
                });
              },
            ),
            SizedBox(height: 5,),
            if(inputRequired != null)
              if(inputRequired['type'] == 'required')
                ViewController.isClickedBtn.value == true && widget.isSeleted!.value == false ||  ViewController.isClickedEditBtn.value == true && widget.isSeleted!.value == false?
                Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
          ],
        );
      })
    ):Container();
  }
}
