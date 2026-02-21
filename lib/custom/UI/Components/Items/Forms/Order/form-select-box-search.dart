import 'package:finance/Admin/Logic/Models/columnModel.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class SelectBoxSearch extends StatefulWidget {
  String? name;
  List<dynamic>? items;
  String? hintText;
  String? selectedValue;
  Function(String?)? onChanged;
  String? initalValue;
  ColumnModel? column;
  Rx<bool>? isSeleted = false.obs;
  double? maxHeight;
  SelectBoxSearch({
    this.name,
    this.items,
    this.hintText,
    this.selectedValue,
    this.onChanged,
    this.initalValue,
    this.column,
    this.isSeleted,
    this.maxHeight,
  });

  @override
  State<SelectBoxSearch> createState() => _SelectBoxSearchState();
}

class _SelectBoxSearchState extends State<SelectBoxSearch> {
  final TextEditingController _searchController = TextEditingController();
  RxList<Map<String, dynamic>> visibleItems = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    visibleItems.value = widget.items!.cast<Map<String, dynamic>>();
    _searchController.addListener(() {
      final text = _searchController.text.trim().toLowerCase();

      if (text.isEmpty) {
        visibleItems.value = widget.items!
            .cast<Map<String, dynamic>>()
            .where((item) => item['_id'] != '__hint__')
            .toList();
      } else {
        visibleItems.value = widget.items!
            .cast<Map<String, dynamic>>()
            .where((item) {
          if (item['_id'] == '__hint__') return false;
          final name =
          (item['Name_and_lastName'] ?? '').toString().toLowerCase();
          return name.contains(text);
        })
            .toList();
      }
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var inputRequired;
    String? errorMessage;
    if(widget.column!=null)
      if(widget.column!.validators.length!=0){
        inputRequired = widget.column!.validators.firstWhere((validator) => validator['type'] == 'required', orElse: () => null);
        errorMessage = inputRequired['message'];
      }
    return widget.items!.isNotEmpty? Obx((){
      return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownSearch<Map<String, dynamic>>(
            items: visibleItems.value,
            itemAsString: (item) => item['Name_and_lastName'] ?? '',
            selectedItem: widget.initalValue == null ||
                widget.initalValue!.isEmpty
                ? null
                : widget.items!
                .cast<Map<String, dynamic>>()
                .where((item) =>
            item['_id'].toString() ==
                widget.initalValue)
                .cast<Map<String, dynamic>?>()
                .firstWhere(
                  (item) => item != null,
              orElse: () => null,
            ),
            dropdownButtonProps: DropdownButtonProps(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 26,
                color: Colors.grey, // آیکون طوسی
              ),
            ),
            popupProps: PopupProps.menu(
              showSearchBox: true,
              disabledItemFn: (item) => item['_id'] == '__hint__',
              emptyBuilder: (context, searchEntry) {
                return Container(
                  height: 35,
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: Txt(
                      'موردی یافت نشد',
                        color: MainController.isLightMode.value == true
                            ? whiteColor
                            : primaryDark , // رنگ دلخواه
                        fontSize: 14,
                    ),
                  ),
                );
              },
              itemBuilder: (context, item, isSelected) {
                if (_searchController.text.trim().isNotEmpty && item['_id'] == '__hint__') {
                  return Container(); // یا SizedBox.shrink()
                }
                return Container(
                  padding:  EdgeInsets.all(12),
                  color: isSelected
                      ? Colors.blue.withOpacity(0.15)
                      : Colors.transparent,
                  child: Txt(
                    item['Name_and_lastName'],
                      color: MainController.isLightMode.value
                          ? Colors.white
                          : primaryDark,
                  ),
                );
              },
              menuProps: MenuProps(
                backgroundColor: MainController.isLightMode.value
                    ? primaryDark
                    : whiteColor,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: MainController.isLightMode.value
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                  ),
                ),
              ),
              searchFieldProps: TextFieldProps(
                controller: _searchController,
                style: TextStyle(
                  color: MainController.isLightMode.value ? whiteColor : primaryDark,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "جستجو...",
                  hintStyle: TextStyle(color: MainController.isLightMode.value ? whiteColor : primaryDark),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: MainController.isLightMode.value ? whiteColor : primaryDark,
                      width: 0,
                    ),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              fit: FlexFit.loose,
            ),

            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: MainController.isLightMode.value ? whiteColor : primaryDark,
                    width: 0,
                  ),
                ),
              ),
            ),

            dropdownBuilder: (context, selectedItem) {
              if (selectedItem == null || selectedItem['_id'] == '__hint__') {
                return Txt(
                  widget.hintText ?? 'لطفاً یکی از موارد را انتخاب کنید', // hint خاکستری
                );
              }
              return Txt(
                '${selectedItem['Name_and_lastName']}',
                  color: MainController.isLightMode.value == true
                                  ? whiteColor
                                  : primaryDark ,
              );
            },
            onChanged: (value) {
              setState(() {
                widget.isSeleted!.value = true;
                widget.selectedValue = value?['_id']?.toString();
                if (widget.onChanged != null) {
                  widget.onChanged!(value?['_id']?.toString());
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
    }):Container();
  }

}

