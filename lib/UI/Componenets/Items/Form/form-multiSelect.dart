import 'package:finance/Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
class MultiSelectDropdown extends StatefulWidget {
  String? hintText;
  // List<String>items;
  List<DropdownMenuItem<String>>? items;
  List<String>? selectedItems= [];
  Function(List<String>)? onSelectChanged;
  String selectName;
  Map<String, List<String>> selectedItemsMap;

  var column;
  MultiSelectDropdown({this.hintText ,required this.items, this.onSelectChanged , required this.selectName ,required this.selectedItemsMap , this.column});
  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  var dropDownSelected=null;
  Rx<bool> isSelectedItem = false.obs;
  @override
  Widget build(BuildContext context) {
    if(widget.selectedItemsMap['${widget.selectName}'] == null){
      widget.selectedItemsMap['${widget.selectName}']=[];
    }
    var inputRequired;
    String? errorMessage;
    print('widget.column>>>${widget.column}');
    if(widget.column['validators'] != null){
      inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      errorMessage = inputRequired['message'];
    }
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     Container(
    //       width: size.width - 333,
    //       decoration: ShapeDecoration(
    //         shape: RoundedRectangleBorder(
    //           side: BorderSide(style: BorderStyle.solid , color: MainController.isLightMode.value ? whiteColor : primaryDark),
    //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
    //         ),
    //       ),
    //       child: DropdownButton(
    //         icon: SizedBox(width: 20),
    //         padding: EdgeInsets.all(5),
    //         underline: Container(),
    //         dropdownColor: MainController.isLightMode.value ? primaryDark : whiteColor,
    //         hint: Row(
    //           children: [
    //             Txt('${widget.hintText}', color: MainController.isLightMode.value ? whiteColor : primaryDark ,),
    //             SizedBox(width: 1090,),
    //             Icon(Icons.arrow_drop_down),
    //           ],
    //         ),
    //         items: widget.items.map((String item) {
    //           Rx<bool> isSelected = widget.selectedItemsMap['${widget.selectName}']!.contains(item).obs;
    //           return DropdownMenuItem<String>(
    //             value: item,
    //             child: Row(
    //               children: [
    //                 Container(
    //                   height: 100,
    //                   child: SizedBox(
    //                     width: 50,
    //                     height: 50,
    //                     child: Obx((){
    //                       return  Checkbox(
    //                         activeColor: Colors.blue,
    //                         value: isSelected.value,
    //                         onChanged: (text) {
    //                           setState(() {
    //                             if(text == true) {
    //                               if(!widget.selectedItemsMap['${widget.selectName}']!.contains(item)){
    //                                 widget.selectedItemsMap['${widget.selectName}']!.add(item);
    //                               }
    //                             }
    //                             else{
    //                               widget.selectedItemsMap['${widget.selectName}']!.remove(item);
    //                             }
    //                             if(widget.selectedItemsMap['${widget.selectName}']!.length == 0){
    //                               widget.hintText = 'Select Option';
    //                             }
    //                             else{
    //                               widget.hintText = '${widget.selectedItemsMap['${widget.selectName}']!.join(', ')}';
    //                             }
    //                             if(widget.onSelectChanged != null){
    //                               this.widget.onSelectChanged!(widget.selectedItemsMap['${widget.selectName}']! );
    //                             }
    //                             isSelected.value = widget.selectedItemsMap['${widget.selectName}']!.contains(item);
    //                           });
    //                         },
    //                       );
    //                     })
    //                   ),
    //                 ),
    //                 Txt(item, color: MainController.isLightMode.value ? whiteColor : primaryDark),
    //               ],
    //             ),
    //           );
    //         }).toList(),
    //         // items: widget.items,
    //         onChanged: (_) {},
    //       ),
    //     ),
    //   ],
    // );
    return  Obx((){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: <Widget>[
              Container(
                // width: size.width - 333,
                padding: EdgeInsets.only(right: 45),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0,color: MainController.isLightMode.value ? whiteColor : primaryDark),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      isExpanded: true,
                      dropdownColor: MainController.isLightMode.value ? primaryDark : whiteColor,
                      // items: widget.items.map((String item) {
                      //   print('widget.items>>>${widget.items}');
                      //   Rx<bool> isSelected = widget.selectedItemsMap['${widget.selectName}']!.contains(item).obs;
                      //   return DropdownMenuItem<String>(
                      //     value: item,
                      //     child: Row(
                      //       children: [
                      //         Container(
                      //           height: 100,
                      //           child: SizedBox(
                      //               width: 50,
                      //               height: 50,
                      //               child: Obx((){
                      //                 return  Checkbox(
                      //                   activeColor: colorBtn,
                      //                   value: isSelected.value,
                      //                   onChanged: (text) {
                      //                     setState(() {
                      //                       this.isSelectedItem.value = true;
                      //                       if(text == true) {
                      //                         if(!widget.selectedItemsMap['${widget.selectName}']!.contains(item)){
                      //                           if(item == '${AppController.of(context)!.value('has been selected')}'){
                      //                             widget.selectedItemsMap['${widget.selectName}']!.remove(item);
                      //                           }
                      //                           else{
                      //                             widget.selectedItemsMap['${widget.selectName}']!.add(item);
                      //                           }
                      //                         }
                      //                       }
                      //                       else{
                      //                         widget.selectedItemsMap['${widget.selectName}']!.remove(item);
                      //                       }
                      //                       print('widget.selectedItemsMap[${widget.selectName}]!>>>${widget.selectedItemsMap['${widget.selectName}']!}');
                      //                       if(widget.selectedItemsMap['${widget.selectName}']!.length == 0){
                      //                         widget.hintText = '${AppController.of(context)!.value('has been selected')}';
                      //                         dropDownSelected = widget.hintText;
                      //                       }
                      //                       else{
                      //                         widget.hintText = '${widget.selectedItemsMap['${widget.selectName}']!.join(', ')}';
                      //                         dropDownSelected = widget.hintText;
                      //                       }
                      //                       if(widget.onSelectChanged != null){
                      //                         this.widget.onSelectChanged!(widget.selectedItemsMap['${widget.selectName}']! );
                      //                       }
                      //                       isSelected.value = widget.selectedItemsMap['${widget.selectName}']!.contains(item);
                      //                     });
                      //                   },
                      //                 );
                      //               })
                      //           ),
                      //         ),
                      //         Txt(item, color: MainController.isLightMode.value ? whiteColor : primaryDark),
                      //       ],
                      //     ),
                      //   );
                      // }).toList(),
                      items:widget.items,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 13 , right: 45),
                child: Txt('${dropDownSelected == null ? widget.hintText:dropDownSelected}', color: MainController.isLightMode.value ? whiteColor : primaryDark ,),
              ),
            ],
          ),
          SizedBox(height: 5,),
          if(inputRequired != null)
            if(inputRequired['type'] == 'required')
              ViewController.isClickedCreateBtn.value == true && this.isSelectedItem.value == false?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
        ],
      );
    });
  }
}

