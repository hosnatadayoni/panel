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
  List<DropdownMenuItem<dynamic>>? items;
  RxList<String>? selectedItems = <String>[].obs;
  // Function(List<String>)? onSelectChanged;
  Function(List<String>)? onChanged;
  // Map<String, List<String>> selectedItemsMap;
  Rx<bool>? isSelectedItem = false.obs;

  var column;
  MultiSelectDropdown({this.hintText ,required this.items , this.column , this.onChanged,this.selectedItems , this.isSelectedItem});
  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  var dropDownSelected=null;


  @override
  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column['validators'] != null){
      inputRequired = widget.column['validators'].firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
      errorMessage = inputRequired['message'];
    }
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
                      items:widget.items,
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            if (!widget.selectedItems!.value.contains(value)) {
                              widget.selectedItems!.value.add(value);
                            } else {
                              widget.selectedItems!.value.remove(value);
                            }
                            if(value == '-1'){
                              widget.selectedItems!.value.remove(value);
                            }
                            if (widget.onChanged != null) {
                              widget.onChanged!(widget.selectedItems!.value);
                            }
                            print('widget.selectedItems!.value>>>${widget.selectedItems!.value}');
                            if(widget.selectedItems!.value.length ==0 ){
                              widget.isSelectedItem?.value = false;
                            }
                            else{
                              widget.isSelectedItem?.value = true;
                            }
                          }
                        });
                      },
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
              ViewController.isClickedBtn.value == true && widget.selectedItems!.value.length == 0  || widget.selectedItems!.value.length == 0 && ViewController.isClickedEditBtn.value == true ?
              Txt('${errorMessage != null ? errorMessage:''}' , color: errorColor,):Container(),
        ],
      );
    });
  }
}

