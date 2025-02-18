import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
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

  SelectBox({
     this.name,
    this.items,
     this.hintText,
     this.selectedValue,
    this.onChanged,
    this.initalValue,
    this.column
  });

  @override
  State<SelectBox> createState() => _SelectBoxState();
}

class _SelectBoxState extends State<SelectBox> {
  String? _errorText='';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Rx<bool>? isSeleted = false.obs;

  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column['validators'] != null){
       inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
       errorMessage = inputRequired['message'];
    }
    // String? initialValue = widget.initalValue;
    // bool initialValueExists = widget.items!.any((item) => item.value == initialValue);
    return widget.items!.isNotEmpty? FormBuilder(
      child: Obx((){
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Txt('${widget.column['name']}' , fontSize: 16, fontWeight: FontWeight.w200, color: MainController.isLightMode.value == true ? whiteColor:primaryDark,),
            // SizedBox(height: 10,),
            FormBuilderDropdown(
              name: widget.name!,
              dropdownColor: MainController.isLightMode.value ? primaryDark : whiteColor,
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(right: 40),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MainController.isLightMode.value ? whiteColor : primaryDark, width: 0),
                ),
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: MainController.isLightMode.value ? whiteColor : primaryDark),
              ),
              hint: Txt(widget.hintText??'', color: MainController.isLightMode.value ? whiteColor : primaryDark),
              initialValue: widget.initalValue,

              items: widget.items!,
              onChanged: (value) {
              setState(() {
                this.isSeleted!.value = true;
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
                ViewController.isClickedCreateBtn.value == true && this.isSeleted!.value == false?
                Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
          ],
        );
      })
    ):Container();
  }
}

// class SelectBox extends StatefulWidget {
//   String? name;
//   List<DropdownMenuItem<String>> items;
//   String? hintText;
//   Rx<String>? selectedValue;
//    Function(String?)? onChanged;
//    String? initalValue;
//   var column;
//   SelectBox({
//      this.name,
//     required this.items,
//      this.hintText,
//      this.selectedValue,
//     this.onChanged,
//     this.initalValue,
//     this.column
//   });
//   @override
//   _SelectBoxState createState() => _SelectBoxState();
// }
//
// class _SelectBoxState extends State<SelectBox> {
//   // final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
//   String? selectedValue;
//   var column;
//
//   @override
//   Widget build(BuildContext context) {
//     return FormBuilder(
//       key:MainController.fbKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           FormBuilderDropdown<String>(
//             name: 'dropdown',
//             decoration: InputDecoration(labelText: 'یک گزینه انتخاب کنید'),
//             items: ['گزینه 1', 'گزینه 2', 'گزینه 3']
//                 .map((option) =>
//                 DropdownMenuItem(
//                   value: option,
//                   child: Text(option),
//                 ))
//                 .toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedValue = value; // ذخیره مقدار انتخاب شده
//               });
//             },
//             validator: (value) {
//               if (value == null) {
//                 return 'لطفاً یک گزینه انتخاب کنید.';
//               }
//               return null;
//             },
//           ),
//           SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }