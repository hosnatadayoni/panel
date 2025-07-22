import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:finance/AdminCustom/Logic/Controllers/selectFieldController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditFieldPage extends StatefulWidget {
  EditFieldPage({this.data});

  var data;

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  Rx<Widget> multiSelectWidget = Container().obs;

//multiSelect custom
  RxList<dynamic> itemsList = [].obs;
  List<dynamic> selectedId = [];
  Rx<String> hintTxt = RxString('');
  RxList<dynamic> selectedItemsList = [].obs;
  Rx<bool> isSelectedItem = false.obs;
  //end multi select custom

  Future<void> loadItems() async {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      final column = MainController.tableInfo['columns'][j];
      if (column['type'] == 'multiSelect') {
        if(widget.data['source_items'] == 'table'){
          print('ssssss>>>${widget.data['source_table']}');
          if(widget.data['items'].length != 0){
            await ConncetServerController.listField({'name': widget.data['source_table']});
            for(var data in ConncetServerController.listFieldsRes){
              if(!itemsList.contains(data['title'])){
                itemsList.add(data['title']);
              }
            }
            if (column['sourceTable'] != null) {
              for (var item in widget.data['items']) {
                selectedItemsList.add(
                    ViewController.itemsShowSelectItem(item, column));
              }
            } else {
              for (var item in widget.data['items']) {
                selectedItemsList.add(item);
              }
            }
            // hintTxt = selectedItemsList.length != 0 ? RxString(selectedItemsList.join(' , ')) : RxString('');
            hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
            multiSelectWidget.value =
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Txt(
                          '${column['title']}',
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        );
                      }),
                      Obx(() {
                        return MultiSelectDropdown(
                          items: [
                            for (var item in itemsList)
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
                                                        //   selectedId = [];
                                                        //   requestMultiSelect = item;
                                                        //   selectedItemsList.add(item);
                                                        //
                                                        // }
                                                        if(!selectedItemsList.contains(item)){
                                                          selectedId = [];
                                                          selectedItemsList.add(item);
                                                        }
                                                        else {
                                                          selectedId = [];
                                                          // requestMultiSelect.removeWhere((key,
                                                          //     value) => value == ['value']);
                                                          // var index = selectedItemsList
                                                          //     .indexWhere((map) =>
                                                          //     mapEquals(map, item));
                                                          //
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
                                                        // hintTxt.value = hintTxt.value + ',' + r;
                                                        hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
                                                        for (var r in selectedItemsList)
                                                          // selectedId.add(r['value']);
                                                          selectedId.add(r);

                                                        ViewController
                                                            .request[column['name']] =
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
                          column: column,
                        );
                      }),
                    ],
                  ),
                );
          }

        }
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
    var size = MediaQuery
        .of(context)
        .size;
    Rx<bool> isHoverBtnBack = false.obs;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MainController.isLightMode.value == true
              ? darkBackground
              : backgroundLight,
        ),
        child: Stack(
          children: [
            Obx(() {
              return Positioned(
                right: size.width > 800
                    ? MainController.isClickedItem.value == true
                    ? 300
                    : 50
                    : 50,
                child: Container(
                  width: size.width > 800
                      ? MainController.isClickedItem.value == true
                      ? (size.width) - 300
                      : (size.width) - 50
                      : (size.width) - 50,
                  height: size.height,
                  padding: EdgeInsets.all(15),
                  color: MainController.isLightMode.value == false
                      ? color6
                      : color9,
                  child: ColumnScroll(
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          for (var j = 0; j <
                              MainController.tableInfo['columns'].length; j++)
                            if (MainController.tableInfo['columns'][j]['is-show-store'] == true)
                              if (MainController.tableInfo['columns'][j]['type'] == 'string' || MainController.tableInfo['columns'][j]['type'] == 'int' ||
                                  MainController.tableInfo['columns'][j]['type'] == 'Number double' ||
                                  MainController.tableInfo['columns'][j]['type'] == 'Number int' ||
                                  MainController.tableInfo['columns'][j]['type'] == 'email' ||
                                  MainController.tableInfo['columns'][j]['type'] == 'mobile')
                                MainController.tableInfo['columns'][j]['name'] == 'title'
                                    ?
                                ViewController.generateFormTextField(
                                    GlobalKey(),
                                    MainController.tableInfo['columns'][j],
                                    MainController.tableInfo['columns'][j]['type'],
                                    '${widget.data['${MainController.tableInfo['columns'][j]['name']}'] != null ? widget.data['${MainController.tableInfo['columns'][j]['name']}'] : ''}') : Container()
                                else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
                                  widget.data['type']  == 'select' ||widget.data['type'] == 'multiSelect'  || widget.data['type'] == 'radiobutton'?
                                  widget.data['source_items'] == 'custom'?
                                  ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j],MainController.tableInfo['columns'][j]['type'], '${widget.data['${MainController.tableInfo['columns'][j]['name']}'] != null ? widget.data['${MainController.tableInfo['columns'][j]['name']}'] : ''}')
                                 :
                                  widget.data['items'].length == 0 ? Container() :Obx((){
                                    return multiSelectWidget.value;
                                  }) : Container()
                        ],
                      ),
                      if (MainController.selectedSubItem.value != -1)
                        Container(
                            padding: EdgeInsets.all(10),
                            width: size.width,
                            child: Wrap(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              alignment: WrapAlignment.end,
                              children: [
                                MouseRegion(
                                  onEnter: (_) {
                                    isHoverBtnBack.value = true;
                                  },
                                  onExit: (_) {
                                    isHoverBtnBack.value = false;
                                  },
                                  child: InkWell(
                                    onTap: () async {
                                      await MainController.goToTablePage(
                                          MainController
                                              .SubMenuList[MainController
                                              .selectedSubItem.value]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: colorBtn, width: 1),
                                        color: isHoverBtnBack.value == false
                                            ? Colors.transparent
                                            : colorBtn,
                                      ),
                                      child: Txt(
                                        '${AppController.of(context)!.value(
                                            'back')}',
                                        color: isHoverBtnBack.value == false
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
                                InkWell(
                                  onTap: () async {
                                    print('_EditFieldPageState.build>>${ViewController.request.value}');
                                    HelperController.editFunction(MainController.tableName.value, request: ViewController.request.value, id: widget.data!['_id']);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                      color: colorBtn,
                                    ),
                                    child: Txt(
                                      '${AppController.of(context)!.value(
                                          'edit')}',
                                      color: whiteColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ))
                    ],
                  ),
                ),
              );
            }),
            Header(),
            MenuBox(),
          ],
        ),
      ),
    );
  }
}