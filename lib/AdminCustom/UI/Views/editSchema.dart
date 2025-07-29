
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EditSchemaPage extends StatefulWidget {
  EditSchemaPage({this.data});
  var data;
  @override
  State<EditSchemaPage> createState() => _EditSchemaPageState();
}
class _EditSchemaPageState extends State<EditSchemaPage> {

  Rx<String> hintTxt = RxString('');
  RxList<dynamic> selectedItemsList = [].obs;
  Rx<bool> isSelectedItem = false.obs;
  List<dynamic> selectedId = [];

  Future<void> loadItems() async {
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      final column = MainController.tableInfo['columns'][j];
      if (column['type'] == 'multiSelect') {
        // await ConncetServerController.listSchema();
        // var index = MainController.SubMenuList.indexWhere((
        //     element) => element['table-name'] == 'schema');
        // if (index != -1) {
        //   if(widget.data['relations'] != null){
        //     if(widget.data['relations'].length != 0){
        //       print('ConncetServerController.listSchemaRes>>>${ConncetServerController.listSchemaRes}');
        //       for (var field in ConncetServerController.listSchemaRes) {
        //         print('HelperController.createPageFunction222${ MainController
        //             .tableInfo['columns']}');
        //         MainController.tableInfo['columns'][6]['items']
        //             .add({"title": field['name'], "value": field['name']});
        //         print('mnhjhxdd>>>${MainController.tableInfo['columns'][6]['items']}');
        //         if(!items.contains({"title": field['name'], "value": field['name']})){
        //           items.add({"title": field['name'], "value": field['name']});
        //         }
        //
        //       }
        //
        //       if (column['sourceTable'] != null) {
        //         for (var item in widget.data['relations']) {
        //           selectedItemsList.add(
        //               ViewController.itemsShowSelectItem(item, column));
        //         }
        //       } else {
        //         for (var item in widget.data['relations']) {
        //           selectedItemsList.add(item);
        //         }
        //       }
        //       hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
        //       print('items list edit schema>>>${items}');
        //     }
        //   }
        //
        // }
        if(widget.data['relations'] != null){
          if (column['sourceTable'] != null) {
            for (var item in widget.data['relations']) {
              selectedItemsList.add(
                  ViewController.itemsShowSelectItem(item, column));
            }
          } else {
            for (var item in widget.data['relations']) {
              selectedItemsList.add(item);
            }
          }
        }
         hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
      }
    }
    setState(() {});
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
                                ViewController.generateFormTextField(
                                    GlobalKey(),
                                    MainController.tableInfo['columns'][j],
                                    MainController
                                        .tableInfo['columns'][j]['type'],
                                    '${widget.data['${MainController
                                        .tableInfo['columns'][j]['name']}'] !=
                                        null
                                        ? widget.data['${MainController
                                        .tableInfo['columns'][j]['name']}']
                                        : ''}')
                              else if(MainController.tableInfo['columns'][j]['type'] == 'checkbox')
                                ViewController.generateFormCheckBox(MainController.tableInfo['columns'][j], widget.data[MainController.tableInfo['columns'][j]['name']] == '' || widget.data[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs, defultValue: widget.data[MainController.tableInfo['columns'][j]['name']])
                              else if(MainController.tableInfo['columns'][j]['type'] == 'multiSelect')
                                  Column(
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
                                            for (var item in  MainController.tableInfo['columns'][6]['items'])
                                              DropdownMenuItem(
                                                  value: item['value'],
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
                                                                    value: selectedItemsList.contains(item['value']),
                                                                    onChanged: (isChecked) {
                                                                      if (isChecked != null) {

                                                                        hintTxt.value = '';
                                                                        // if (!selectedItemsList.any((element) => element['value']==item['value'])) {
                                                                        // requestMultiSelect = item;
                                                                        if(!selectedItemsList.contains(item['value'])){
                                                                          selectedItemsList.add(item['value']);
                                                                          // selectedItemId.add(item['value']);
                                                                        } else {
                                                                          // requestMultiSelect.removeWhere((key, value) => value == ['_id']);
                                                                          // selectedItemsList.removeWhere( (element) => element['value']==item['value']);
                                                                          // selectedItemId.remove(item['value']);
                                                                          if(selectedItemsList.contains(item['value'])){
                                                                            selectedItemsList.remove(item['value']);
                                                                          }

                                                                        }
                                                                        if (selectedItemsList.value.length ==
                                                                            0) {
                                                                          isSelectedItem.value = false;
                                                                        } else {
                                                                          isSelectedItem.value = true;
                                                                        }
                                                                        // for (var r in selectedItemsList)
                                                                        //   hintTxt.value = hintTxt.value + ViewController.itemsShowSelectItem(r, MainController.tableInfo['columns'][j]);
                                                                        hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
                                                                        // ViewController.request[MainController.tableInfo['columns'][j]['name']]= selectedItemId;
                                                                        // ViewController
                                                                        //     .request[MainController.tableInfo['columns'][j]['name']] =
                                                                        //     selectedId;
                                                                        ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedItemsList;
                                                                      }
                                                                    });
                                                              })),
                                                        ),
                                                        Txt(ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j]),
                                                            color: MainController.isLightMode.value
                                                                ? whiteColor
                                                                : primaryDark),
                                                      ],
                                                    );
                                                  }))
                                          ],
                                          hintText: hintTxt.value != '' || hintTxt.value != null
                                              ? hintTxt.value
                                              : '${AppController.of(Get.context!)!.value('choice')}',
                                          selectedItems: selectedItemsList,
                                          isSelectedItem: isSelectedItem,
                                          column: MainController.tableInfo['columns'][j],
                                        );
                                      }),
                                    ],
                                  )
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
                                    print(
                                        '_EditPageSate.build>>>${ViewController
                                            .request}>>>${MainController
                                            .tableName.value}');
                                    HelperController.editFunction(
                                        MainController.tableName.value,
                                        request: ViewController.request,
                                        id: widget.data!['_id']);
                                    if (ViewController.isClickedBtn.value ==
                                        false) {}
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
