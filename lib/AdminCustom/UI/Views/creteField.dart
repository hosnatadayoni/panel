
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Logic/Controllers/selectFieldController.dart';

class CretePageField extends StatefulWidget {
  String tableName;
  CretePageField(this.tableName);

  @override
  State<CretePageField> createState() => _CretePageFieldState();
}

class _CretePageFieldState extends State<CretePageField> {
  RxMap<String, RxList<dynamic>> selectItems = <String, RxList<dynamic>>{}.obs;
  RxMap<String, Widget> selectWidgets = <String, Widget>{}.obs;

  //select custom
  RxList<dynamic> sourceItem=[].obs;
  RxList<dynamic> sourceTable=[].obs;
  Rx<String> initailValue=''.obs;
  Rx<String> initailValueSourceTable=''.obs;
  Rx<String> hintText = ''.obs;
  Rx<bool> isSeletedSelectBox = false.obs;
  //end selectcustom

  //multiSelect custom
  RxList<dynamic> sourceTableItems=[].obs;
  List<dynamic> selectedId = [];
  Rx<String> hintTxt = RxString('');
  RxList<dynamic> selectedItemsList =[].obs;
  Rx<bool> isSelectedItem = false.obs;
  //end multi select custom

  Rx<String> sourceItem2 = ''.obs;
   Rx<String> sourceSelected = ''.obs;
   Rx<String> selectedType = ''.obs;
  RxList<dynamic> typeItems=[].obs;
  Future<void> loadItems() async {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      final column = MainController.tableInfo['columns'][j];
      if(column['type'] == 'select'){
        var items = await ViewController.itemsList(column);
        selectItems[column['name']] = items.obs;
        selectWidgets[column['name']] = ViewController.generateStoreFormSelectBox(
            column,
            items,
            '',
            '',
            false.obs
        );
        if(column['name'] == 'source_table'){
          sourceTable.value = items;
        }
        else if(column['name'] == 'source_items'){
          sourceItem.value = await ViewController.itemsList(column);
        }
        else if(column['name'] == 'type'){
          typeItems.value = await ViewController.itemsList(column);
        }
      }
      else if(column['type'] == 'multiSelect'){
        sourceTableItems.value = await ViewController.itemsList(column);
      }
    }
  }
  @override
  void initState() {
    super.initState();
    loadItems();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;
    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: MainController.isLightMode.value == true ?darkBackground : backgroundLight,
            color: MainController.isLightMode.value == false ? color6 : color9,
          ),
          child: Stack(
            children: [
              Obx(() {
                return Positioned(
                    right: Directionality.of(context) == TextDirection.rtl ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size.width > 800 ? MainController.isClickedItem.value == true ? 300 : 50 : 50 : 0,
                    child: Container(
                        width: size.width > 800
                            ? MainController.isClickedItem.value == true
                            ? (size.width) - 300
                            : (size.width) - 50
                            : (size.width) - 50,
                        height: size.height,
                        color: MainController.isLightMode.value == false
                            ? color6
                            : color9,
                        child: ColumnScroll(
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Txt(
                                        '${AppController.of(context)!.value('add')}',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color:
                                        MainController.isLightMode.value ==
                                            true
                                            ? whiteColor
                                            : primaryDark,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Txt(
                                        '${MainController.tableInfo['title']}',
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color:
                                        MainController.isLightMode.value ==
                                            true
                                            ? whiteColor
                                            : primaryDark,
                                      ),
                                    ],
                                  ),
                                  Obx(() {
                                    return Row(
                                      children: [
                                        Row(
                                          children: [
                                            MouseRegion(
                                              onEnter: (_) {
                                                isHoverBtnBack.value = true;
                                              },
                                              onExit: (_) {
                                                isHoverBtnBack.value = false;
                                              },
                                              child: InkWell(
                                                onTap: () {
                                                  MainController.goToTablePage(MainController.SubMenuList[MainController.selectedSubItem.value]);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10)),
                                                    border: Border.all(
                                                        color: colorBtn,
                                                        width: 1),
                                                    color:
                                                    isHoverBtnBack.value ==
                                                        false
                                                        ? Colors.transparent
                                                        : colorBtn,
                                                  ),
                                                  child: Txt(
                                                    '${AppController.of(context)!.value('back')}',
                                                    color:
                                                    isHoverBtnBack.value ==
                                                        false
                                                        ? colorBtn
                                                        : whiteColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            MouseRegion(
                                              onEnter: (_) {},
                                              onExit: (_) {},
                                              child: InkWell(
                                                onTap: () async {
                                                  print('_CreatePageState.build>>>${ViewController.request}');
                                                  HelperController.createFunction(widget.tableName);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(
                                                            10)),
                                                    color: colorBtn,
                                                  ),
                                                  child: Txt(
                                                    '${AppController.of(context)!.value('save')}',
                                                    color: whiteColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    );
                                  }),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                for (var j = 0; j < MainController.tableInfo['columns'].length; j++)
                                 if (MainController.tableInfo['columns'][j]['is-show-store'] == true)
                                  if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'int' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'Number double' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'Number int' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'email' ||
                                      MainController.tableInfo['columns'][j]['type'] == 'mobile')
                                    ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j], MainController.tableInfo['columns'][j]['type'], '')
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
                                  ViewController.generateFormCheckBox(MainController.tableInfo['columns'][j], false.obs)
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'date')
                                      ViewController.generateFormDateBox(MainController.tableInfo['columns'][j], Jalali.now(), false.obs)
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'color')
                                      ViewController.generateFormColorBox(MainController.tableInfo['columns'][j], Colors.blue, false.obs)
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'file')
                                      ViewController.generateFileBox('', MainController.tableInfo['columns'][j], false.obs)
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'time')
                                      ViewController.generateFormTimeBox(MainController.tableInfo['columns'][j], TimeOfDay.now(), false.obs)
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'select')
                                            MainController.tableInfo['columns'][j]['name'] == 'type' ? Obx((){
                                              return typeItems.value.length != 0
                                                  ? new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Txt(
                                                      '${MainController.tableInfo['columns'][j]['title']}',
                                                      color: MainController.isLightMode.value == true
                                                          ? whiteColor
                                                          : color2,
                                                    );
                                                  }),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  MainController.tableInfo['columns'][j]['sourceItems'] != 'custom' ?
                                                  Obx((){
                                                    return SelectBox(
                                                        name: '${MainController.tableInfo['columns'][j]['title']}',
                                                        column: MainController.tableInfo['columns'][j],
                                                        items: [
                                                          DropdownMenuItem(
                                                              child: Obx(() {
                                                                return Txt(
                                                                  '${AppController.of(Get.context!)!.value('not selected')}',
                                                                  color: MainController.isLightMode.value == true
                                                                      ? whiteColor
                                                                      : primaryDark,
                                                                );
                                                              }),
                                                              value: ''),
                                                          for (var item in typeItems.value)
                                                            DropdownMenuItem(
                                                                child: Obx(() {
                                                                  return Txt(
                                                                    '${ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j])}',
                                                                    color:
                                                                    MainController.isLightMode.value == true
                                                                        ? whiteColor
                                                                        : primaryDark,
                                                                  );
                                                                }),
                                                                value: item['title'].toString()),
                                                        ],
                                                        initalValue: initailValue.value == '' || initailValue.value == null ?"":initailValue.value,
                                                        onChanged: (value) async {
                                                          sourceItem2.value = value!;
                                                          // initailValue.value = value;
                                                          if (value != '') {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                          } else {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                          }
                                                        },
                                                        hintText: hintText.value,
                                                        isSeleted: isSeletedSelectBox,
                                                        selectedValue: '');
                                                  })
                                                      : Obx((){
                                                    return SelectBox(
                                                        name: '${MainController.tableInfo['columns'][j]['title']}',
                                                        column: MainController.tableInfo['columns'][j],
                                                        items: [
                                                          for (var item in typeItems.value)
                                                            DropdownMenuItem(
                                                                child: Obx(() {
                                                                  return Txt(
                                                                    '${item['title']}',
                                                                    color:
                                                                    MainController.isLightMode.value == true
                                                                        ? whiteColor
                                                                        : primaryDark,
                                                                  );
                                                                }),
                                                                value: item['title']),
                                                        ],
                                                        initalValue: initailValue.value == '' || initailValue.value == null
                                                            ? sourceItem.value.first['value']
                                                            : initailValue.value,
                                                        onChanged: (value) async {
                                                          // sourceItem2.value = value!;
                                                          selectedType.value = value!;
                                                          initailValue.value = value;
                                                          for (var item in typeItems.value) {
                                                            if (item['title'] == value) {
                                                              if (item['value'] == '') {
                                                                value = null;
                                                              }
                                                            }
                                                          }
                                                          if (value != '') {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                          } else {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                          }
                                                        },
                                                        hintText: hintText.value,
                                                        isSeleted: isSeletedSelectBox,
                                                        selectedValue: '');
                                                  }),
                                                ],
                                              ) : Container();
                                            }):
                                            MainController.tableInfo['columns'][j]['name'] == 'type_field'? selectedType.value != 'multiSelect' ?  selectWidgets[MainController.tableInfo['columns'][j]['name']] ?? Container(): Container():
                                            MainController.tableInfo['columns'][j]['name'] == 'source_items' ? selectedType.value == 'select' ||selectedType.value == 'multiSelect'  || selectedType.value == 'radiobutton' ||selectedType.value == ''? Obx((){
                                              return sourceItem.value.length != 0
                                                  ? new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Txt(
                                                      '${MainController.tableInfo['columns'][j]['title']}',
                                                      color: MainController.isLightMode.value == true
                                                          ? whiteColor
                                                          : color2,
                                                    );
                                                  }),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  MainController.tableInfo['columns'][j]['sourceItems'] != 'custom' ?
                                                  Obx((){
                                                    return SelectBox(
                                                        name: '${MainController.tableInfo['columns'][j]['title']}',
                                                        column: MainController.tableInfo['columns'][j],
                                                        items: [
                                                          DropdownMenuItem(
                                                              child: Obx(() {
                                                                return Txt(
                                                                  '${AppController.of(Get.context!)!.value('not selected')}',
                                                                  color: MainController.isLightMode.value == true
                                                                      ? whiteColor
                                                                      : primaryDark,
                                                                );
                                                              }),
                                                              value: ''),
                                                          for (var item in sourceItem.value)
                                                            DropdownMenuItem(
                                                                child: Obx(() {
                                                                  return Txt(
                                                                    '${ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j])}',
                                                                    color:
                                                                    MainController.isLightMode.value == true
                                                                        ? whiteColor
                                                                        : primaryDark,
                                                                  );
                                                                }),
                                                                value: item['title'].toString()),
                                                        ],
                                                        initalValue: initailValue.value == '' || initailValue.value == null ?"":initailValue.value,
                                                        onChanged: (value) async {
                                                          sourceItem2.value = value!;
                                                          // initailValue.value = value;
                                                          if (value != '') {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                          } else {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                          }
                                                        },
                                                        hintText: hintText.value,
                                                        isSeleted: isSeletedSelectBox,
                                                        selectedValue: '');
                                                  })
                                                  : Obx((){
                                                    return SelectBox(
                                                        name: '${MainController.tableInfo['columns'][j]['title']}',
                                                        column: MainController.tableInfo['columns'][j],
                                                        items: [
                                                          for (var item in sourceItem.value)
                                                            DropdownMenuItem(
                                                                child: Obx(() {
                                                                  return Txt(
                                                                    '${item['title']}',
                                                                    color:
                                                                    MainController.isLightMode.value == true
                                                                        ? whiteColor
                                                                        : primaryDark,
                                                                  );
                                                                }),
                                                                value: item['title']),
                                                        ],
                                                        initalValue: initailValue.value == '' || initailValue.value == null
                                                            ? sourceItem.value.first['value']
                                                            : initailValue.value,
                                                        onChanged: (value) async {
                                                          sourceItem2.value = value!;
                                                          initailValue.value = value;
                                                          for (var item in sourceItem.value) {
                                                            if (item['title'] == value) {
                                                              if (item['value'] == '') {
                                                                value = null;
                                                              }
                                                            }
                                                          }
                                                          if (value != '') {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                          } else {
                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                          }
                                                        },
                                                        hintText: hintText.value,
                                                        isSeleted: isSeletedSelectBox,
                                                        selectedValue: '');
                                                  }),
                                                ],
                                              ) : Container();
                                            }) : Container():
                                            MainController.tableInfo['columns'][j]['name'] == 'source_table' ? sourceItem2.value == 'custom' ? Container() :selectedType.value == 'select' ||selectedType.value == 'multiSelect'  || selectedType.value == 'radiobutton' ||selectedType.value == '' ? Obx((){
                                              return sourceTable.value.length != 0
                                                  ? new Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Txt(
                                                      '${MainController.tableInfo['columns'][j]['title']}',
                                                      color: MainController.isLightMode.value == true
                                                          ? whiteColor
                                                          : color2,
                                                    );
                                                  }),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  MainController.tableInfo['columns'][j]['sourceItems'] != 'custom' ?
                                                  SelectBox(
                                                      name: '${MainController.tableInfo['columns'][j]['title']}',
                                                      column: MainController.tableInfo['columns'][j],
                                                      items: [
                                                        DropdownMenuItem(
                                                            child: Obx(() {
                                                              return Txt(
                                                                '${AppController.of(Get.context!)!.value('not selected')}',
                                                                color: MainController.isLightMode.value == true
                                                                    ? whiteColor
                                                                    : primaryDark,
                                                              );
                                                            }),
                                                            value: ''),
                                                        for (var item in sourceTable.value)
                                                          DropdownMenuItem(
                                                              child: Obx(() {
                                                                return Txt(
                                                                  '${ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j])}',
                                                                  color:
                                                                  MainController.isLightMode.value == true
                                                                      ? whiteColor
                                                                      : primaryDark,
                                                                );
                                                              }),
                                                              value: item['title'].toString()),
                                                      ],
                                                      initalValue: initailValueSourceTable.value == '' || initailValueSourceTable.value == null ?"":initailValueSourceTable.value,
                                                      onChanged: (value) async {
                                                        initailValueSourceTable.value =  value!;
                                                        sourceSelected.value = value!;
                                                        if(sourceSelected.value != ''){
                                                          await ConncetServerController.listField({'name': sourceSelected.value});
                                                          for(var data in MainController.allData.value){
                                                            if(!sourceTableItems.contains(data['title'])){
                                                              sourceTableItems.add(data['title']);
                                                            }
                                                          }
                                                        }
                                                        else{
                                                          sourceTableItems.value = [];
                                                        }

                                                        if (value != '') {
                                                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                        } else {
                                                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                        }
                                                      },
                                                      hintText: hintText.value,
                                                      isSeleted: isSeletedSelectBox,
                                                      selectedValue: '')
                                                      : SelectBox(
                                                      name: '${MainController.tableInfo['columns'][j]['title']}',
                                                      column: MainController.tableInfo['columns'][j],
                                                      items: [
                                                        for (var item in sourceTable.value)
                                                          DropdownMenuItem(
                                                              child: Obx(() {
                                                                return Txt(
                                                                  '${item['title']}',
                                                                  color:
                                                                  MainController.isLightMode.value == true
                                                                      ? whiteColor
                                                                      : primaryDark,
                                                                );
                                                              }),
                                                              value: item['title']),
                                                      ],
                                                      initalValue: initailValueSourceTable.value == '' || initailValueSourceTable.value == null
                                                          ? sourceTable.value.first['value']
                                                          : initailValueSourceTable.value,
                                                      onChanged: (value) async {
                                                        for (var item in sourceTable.value) {
                                                          if (item['title'] == value) {
                                                            if (item['value'] == '') {
                                                              value = null;
                                                            }
                                                          }
                                                        }
                                                        initailValueSourceTable.value =  value!;
                                                        sourceSelected.value = value!;
                                                        if(sourceSelected.value != ''){
                                                          await ConncetServerController.listField({'name': sourceSelected.value});
                                                          for(var data in MainController.allData.value){
                                                            if(!sourceTableItems.contains(data['title'])){
                                                              sourceTableItems.add(data['title']);
                                                            }
                                                          }
                                                        }
                                                        else{
                                                          sourceTableItems.value = [];
                                                        }
                                                        if (value != '') {
                                                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                        } else {
                                                          ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                        }
                                                      },
                                                      hintText: hintText.value,
                                                      isSeleted: isSeletedSelectBox,
                                                      selectedValue: ''),
                                                ],
                                              ) : Container();
                                            }) :Container() :
                                            Container()
                                  else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
                                                sourceItem2.value == 'custom'?ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j], 'string', '') :
                                                selectedType.value == 'select' ||selectedType.value == 'multiSelect'  || selectedType.value == 'radiobutton' ||selectedType.value == '' ? Obx((){
                                              return  sourceTableItems.value.length != 0
                                                  ? MainController.tableInfo['columns'][j]['sourceItems'] != 'custom'
                                                  ? Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Txt(
                                                      '${MainController.tableInfo['columns'][j]['title']}',
                                                      color: MainController.isLightMode.value == true
                                                          ? whiteColor
                                                          : color2,
                                                    );
                                                  }),
                                                  Obx(() {
                                                    return MultiSelectDropdown(
                                                      items: [
                                                        for (var item in sourceTableItems.value)
                                                          DropdownMenuItem(
                                                              value: item,
                                                              child: Obx(() {
                                                                return Row(
                                                                  children: [
                                                                    Container(
                                                                      height: 100,
                                                                      child: SizedBox(
                                                                          width: 50,
                                                                          height: 50,
                                                                          child: Obx(() {
                                                                            return Checkbox(
                                                                                activeColor: colorBtn,
                                                                                // value: selectedItemsList.any(
                                                                                //         (map) =>
                                                                                //         mapEquals(map, item)),
                                                                                value:selectedItemsList.contains(item),
                                                                                onChanged: (isChecked) {
                                                                                  if (isChecked != null) {
                                                                                    hintTxt.value = '';
                                                                                    // if (!selectedItemsList.any(
                                                                                    //         (map) =>
                                                                                    //         mapEquals(
                                                                                    //             map, item))) {
                                                                                    if(!selectedItemsList.contains(item)){
                                                                                      selectedId = [];
                                                                                      // ViewController.requestMultiSelect = item;
                                                                                      selectedItemsList
                                                                                          .add(item);

                                                                                    } else {
                                                                                      selectedId = [];
                                                                                      // ViewController.requestMultiSelect
                                                                                      //     .removeWhere((key,
                                                                                      //     value) =>
                                                                                      // value == ['_id']);
                                                                                      // var index =
                                                                                      // selectedItemsList
                                                                                      //     .indexWhere(
                                                                                      //         (map) =>
                                                                                      //         mapEquals(
                                                                                      //             map,
                                                                                      //             item));
                                                                                      //
                                                                                      // selectedItemsList
                                                                                      //     .removeAt(index);
                                                                                      if(selectedItemsList.contains(item)){
                                                                                        selectedItemsList.remove(item);
                                                                                      }

                                                                                    }
                                                                                    if (item['_id'] == '') {}
                                                                                    if (selectedItemsList
                                                                                        .value.length ==
                                                                                        0) {
                                                                                      isSelectedItem.value =
                                                                                      false;
                                                                                    } else {
                                                                                      isSelectedItem.value =
                                                                                      true;
                                                                                    }
                                                                                    for (var r
                                                                                    in selectedItemsList)
                                                                                      hintTxt.value = hintTxt
                                                                                          .value +
                                                                                          ViewController.itemsShowSelectItem(r,
                                                                                              MainController.tableInfo['columns'][j]);


                                                                                    // for (var r
                                                                                    // in selectedItemsList)
                                                                                    //   selectedId.add(r['_id']);
                                                                                      selectedId.add(item);
                                                                                    print('hintTxt.value e>>>${hintTxt.value}');
                                                                                    ViewController.request[MainController.tableInfo['columns'][j]['name']]= selectedId;
                                                                                    ViewController.request[MainController.tableInfo['columns'][j]['name']]= selectedItemsList;

                                                                                  }
                                                                                });
                                                                          })),
                                                                    ),
                                                                    Txt(
                                                                        ViewController.itemsShowSelectItem(
                                                                            item, MainController.tableInfo['columns'][j]),
                                                                        color: MainController.isLightMode.value
                                                                            ? whiteColor
                                                                            : primaryDark),
                                                                  ],
                                                                );
                                                              }))
                                                      ],
                                                      hintText: hintTxt.value != '' && hintTxt.value != null
                                                          ? hintTxt.value
                                                          : '${AppController.of(Get.context!)!.value('choice')}',
                                                      selectedItems: selectedItemsList,
                                                      isSelectedItem: isSelectedItem,
                                                      column: MainController.tableInfo['columns'][j],
                                                    );
                                                  }),
                                                ],
                                              )
                                                  : Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Obx(() {
                                                    return Txt(
                                                      '${MainController.tableInfo['columns'][j]['title']}',
                                                      color: MainController.isLightMode.value == true
                                                          ? whiteColor
                                                          : color2,
                                                    );
                                                  }),
                                                  Obx(() {
                                                    return MultiSelectDropdown(
                                                      items: [
                                                        for (var item in sourceTableItems.value)
                                                          DropdownMenuItem(
                                                              value: item,
                                                              child: Obx(() {
                                                                return Row(
                                                                  children: [
                                                                    Container(
                                                                      height: 100,
                                                                      child: SizedBox(
                                                                          width: 50,
                                                                          height: 50,
                                                                          child: Obx(() {
                                                                            return Checkbox(
                                                                                activeColor: colorBtn,
                                                                                // value: selectedItemsList.any((map) =>
                                                                                //     mapEquals(map, item)),
                                                                                value: selectedItemsList.contains(item),
                                                                                onChanged: (isChecked) {
                                                                                  if (isChecked != null) {


                                                                                    hintTxt.value = '';
                                                                                    // if (!selectedItemsList.any((map) =>
                                                                                    //     mapEquals(map, item))) {
                                                                                    if(!selectedItemsList.contains(item)){
                                                                                      selectedId = [];
                                                                                      // ViewController.requestMultiSelect = item;
                                                                                      selectedItemsList.add(item);

                                                                                    } else {
                                                                                      selectedId = [];
                                                                                      // ViewController.requestMultiSelect.removeWhere((key,
                                                                                      //     value) => value == ['value']);
                                                                                      // var index = selectedItemsList
                                                                                      //     .indexWhere((map) =>
                                                                                      //     mapEquals(map, item));
                                                                                      // selectedItemsList.removeAt(index);
                                                                                      if(selectedItemsList.contains(item)){
                                                                                        selectedItemsList.remove(item);
                                                                                      }
                                                                                    }

                                                                                    if (selectedItemsList.value.length ==
                                                                                        0) {
                                                                                      isSelectedItem.value = false;
                                                                                    } else {
                                                                                      isSelectedItem.value = true;
                                                                                    }
                                                                                    // for (var r in selectedItemsList)
                                                                                       // hintTxt.value = hintTxt.value + r['title'];
                                                                                    hintTxt = selectedItemsList.length != 0 ? RxString(selectedItemsList.join(' , ')) : RxString('');
                                                                                    // for (var r in selectedItemsList)
                                                                                    //   selectedId.add(r['value']);
                                                                                    selectedId.add(item);

                                                                                    ViewController
                                                                                        .request[MainController.tableInfo['columns'][j]['name']] =
                                                                                        selectedId;
                                                                                    ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedItemsList;
                                                                                  }
                                                                                });
                                                                          })),
                                                                    ),
                                                                    Txt(item,
                                                                        color: MainController.isLightMode.value
                                                                            ? whiteColor
                                                                            : primaryDark),
                                                                  ],
                                                                );
                                                              }))
                                                      ],
                                                      hintText: hintTxt.value != '' && hintTxt.value != null
                                                          ? hintTxt.value
                                                          : '${AppController.of(Get.context!)!.value('choice')}',
                                                      selectedItems: selectedItemsList,
                                                      isSelectedItem: isSelectedItem,
                                                      column: MainController.tableInfo['columns'][j],
                                                    );
                                                  }),
                                                ],
                                              )
                                                  : Container();
                                            }) : Container()


                              ],
                            ),
                          ],
                        )));
              }),
              Header(),
              MenuBox(),
            ],
          )),
    );
  }
}
