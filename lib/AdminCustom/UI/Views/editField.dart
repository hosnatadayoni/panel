import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-text-field.dart';
import '../../../Admin/UI/Componenets/Popups/snackbar.dart';

class EditFieldPage extends StatefulWidget {
  EditFieldPage({this.data});

  var data;

  @override
  State<EditFieldPage> createState() => _EditFieldPageState();
}

class _EditFieldPageState extends State<EditFieldPage> {
  Rx<Widget> multiSelectWidget = Container().obs;

  RxList<dynamic> itemsList = [].obs;
  List<dynamic> selectedId = [];
  Rx<String> hintTxt = RxString('');
  RxList<dynamic> selectedItemsList = [].obs;
  Rx<bool> isSelectedItem = false.obs;
  bool checkExistItem(var id){
    for(var item in itemsList){
      if(item['_id']==id){
        return true;
      }
    }
    return false;
  }
  List<String> titleSelect=[];

  Future<void> loadItems() async {
    print('_EditFieldPageState.loadItems widget.data[>>${widget.data['items']}');
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      final column = MainController.tableInfo['columns'][j];
      if (column['type'] == 'multiSelect') {
        if (widget.data['source_items'] == 'table') {
          if (widget.data['items'].length != 0) {
            await ConncetServerController.listFieldByTableId({'id': widget.data['source_table']});
            for (var data in ConncetServerController.listFieldsRes) {
              if (checkExistItem(data['_id'])==false) {
                itemsList.add(data);
              }
            }
            if (column['sourceTable'] != null) {
              for (var item in widget.data['items']) {
                selectedItemsList.add(ViewController.itemsShowSelectItem(item, column));
                print('_EditFieldPageState.loadItems selectedItemsList1>>${selectedItemsList}');
              }
            } else {
              for (var item in widget.data['items']) {
                selectedItemsList.add(item['value']);
                print('_EditFieldPageState.loadItems selectedItemsList2>>>>>${selectedItemsList}');
              }
            }
            // hintTxt = selectedItemsList.length != 0 ? RxString(selectedItemsList.join(' , ')) : RxString('');
            // hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
            for (var item in itemsList)
              if(selectedItemsList.contains(item['_id']))
                titleSelect.add(item['title']);

            hintTxt.value ='${titleSelect.join(', ')}';
            multiSelectWidget.value = Container(
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
                              value: item['_id'],
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
                                                value: selectedItemsList.contains(item['_id']),
                                                onChanged: (isChecked) {

                                                  if (isChecked != null) {
                                                    hintTxt.value = '';
                                                    if (!selectedItemsList.contains(item['_id'])) {
                                                      selectedId = [];
                                                      selectedItemsList.add(item['_id']);
                                                      titleSelect.add(item['title']);
                                                    } else {
                                                      selectedId = [];
                                                      if (selectedItemsList.contains(item['_id'])) {
                                                        selectedItemsList.remove(item['_id']);
                                                        titleSelect.remove(item['title']);
                                                        print(
                                                            '_EditFieldPageState.loadItems titleSelect>>${selectedItemsList}');
                                                      }
                                                    }

                                                    if (selectedItemsList.value.length == 0) {
                                                      isSelectedItem.value = false;
                                                    } else {
                                                      isSelectedItem.value = true;
                                                    }
                                                    hintTxt.value = '${titleSelect.join(', ')}';

                                                    // for (var r in selectedItemsList)
                                                    //   selectedId.add(r);


                                                    ViewController.request['items'] = selectedItemsList;
                                                    print('_EditFieldPageState.loadItems request>>%${column['name']}>>${selectedItemsList}>>%${ViewController.request[column['name']]}');

                                                  }
                                                });
                                          })),
                                    ),
                                    Txt(item['title'],
                                        color: MainController.isLightMode.value
                                            ? whiteColor
                                            : primaryDark),
                                  ],
                                );
                              }))
                      ],
                      hintText: hintTxt.value != '' ? hintTxt.value : '${AppController.of(Get.context!)!.value('choice')}',
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

  RxList<Map<String, dynamic>> items = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    loadItems();
    // print('_EditFieldPageState.initState>>>${widget.data['items']}');
    if (widget.data['items'] != null) {
      print('_EditFieldPageState.initState>>>${widget.data['items']}');

      for(int i=0;i<widget.data['items'].length;i++){

        // if(widget.data['items'][i] is Map) {
          print('_EditFieldPageState.initState widget.data runtimeType');
          widget.data['items'][i] = {
            'title': widget.data['items'][i],
            'value': widget.data['items'][i],
          };
        // }
      }
      print('_EditFieldPageState.initState>>>items>>${widget.data['items']}');
      items.value = List<Map<String, dynamic>>.from(widget.data['items']) ;
    }
  }

  void addRow() {
    bool hasEmptyValue = items.any((item) => item['value'] == null || item['value']!.isEmpty);
    if (hasEmptyValue) {
      showSnackbar(snackTypes.error, 'لطفاً ابتدا مقدار ردیف‌های قبلی را وارد کنید.');
      return;
    }
    items.add({'title': '', 'value': ''});
  }

  void removeRow(int index) {
    if (index >= 0 && index < items.length) {
      items.removeAt(index);
    }
  }

  List<Map<String, dynamic>> getFinalItems() {
    return items.toList();
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
                          for (var j = 0;
                              j < MainController.tableInfo['columns'].length;
                              j++)
                            if (MainController.tableInfo['columns'][j]
                                    ['is-show-store'] ==
                                true)
                              if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                                  MainController.tableInfo['columns'][j]['type'] ==
                                      'int' ||
                                  MainController.tableInfo['columns'][j]['type'] ==
                                      'Number double' ||
                                  MainController.tableInfo['columns'][j]['type'] ==
                                      'Number int' ||
                                  MainController.tableInfo['columns'][j]['type'] ==
                                      'email' ||
                                  MainController.tableInfo['columns'][j]['type'] ==
                                      'mobile')
                                MainController.tableInfo['columns'][j]['name'] == 'title'
                                    ? ViewController.generateFormTextField(
                                        GlobalKey(),
                                        MainController.tableInfo['columns'][j],
                                        MainController.tableInfo['columns'][j]
                                            ['type'],
                                        '${widget.data['${MainController.tableInfo['columns'][j]['name']}'] != null ? widget.data['${MainController.tableInfo['columns'][j]['name']}'] : ''}')
                                    : Container()
                              else if (MainController.tableInfo['columns'][j]['type'] ==
                                  'multiSelect')
                                widget.data['source_items'] == 'custom' &&
                                        (widget.data['type'] == 'select' ||
                                            widget.data['type'] == 'multiSelect' ||
                                            widget.data['type'] == 'radiobutton')
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.add_circle,
                                                color: Colors.green, size: 30),
                                            onPressed: addRow,
                                          ),
                                          SizedBox(height: 15,),
                                          Obx(() => Column(
                                                children: [
                                                  for (var i = 0;
                                                      i < items.length;
                                                      i++)
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 150,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              FormTextField(
                                                                name: 'عنوان',
                                                                lable: 'عنوان',
                                                                initValue: items[
                                                                    i]['title'],
                                                                onChange:
                                                                    (text) {
                                                                  items[i][
                                                                          'title'] =
                                                                      text ??
                                                                          '';
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 7),
                                                        SizedBox(
                                                          width: 150,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              FormTextField(
                                                                name: 'مقدار',
                                                                lable: 'مقدار',
                                                                initValue: items[
                                                                    i]['value'],
                                                                onChange:
                                                                    (text) {
                                                                  items[i][
                                                                          'value'] =
                                                                      text ??
                                                                          '';
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color: Colors.red,
                                                              size: 30),
                                                          onPressed: () =>
                                                              removeRow(i),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              )),
                                        ],
                                      )

                                    // ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j],MainController.tableInfo['columns'][j]['type'], '${widget.data['${MainController.tableInfo['columns'][j]['name']}'] != null ? widget.data['${MainController.tableInfo['columns'][j]['name']}'] : ''}')
                                    : widget.data['type'] == 'select' || widget.data['type'] == 'multiSelect' || widget.data['type'] == 'radiobutton'
                                        ? widget.data['items']!=null && widget.data['items'].length == 0
                                            ? Container()
                                            : Obx(() {
                                                return multiSelectWidget.value;
                                              })
                                        : Container()
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
                                          MainController.SubMenuList[
                                              MainController
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
                                        '${AppController.of(context)!.value('back')}',
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
                                    // if(items.isNotEmpty) {
                                    //   var index = items.indexWhere((item) =>
                                    //   item['value'] == null ||
                                    //       item['value']!.isEmpty);
                                    //   if (index != -1) {
                                    //     items.removeAt(index);
                                    //   }
                                    //   ViewController.request.addAll({'items':items});
                                    // }
                                    print(
                                        '_EditPageSate.build>>>${ViewController.request}>>>${MainController.tableName.value}');
                                    HelperController.editFunction(MainController.tableName.value, request:  ViewController.request, id: widget.data!['_id']);
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
                                      '${AppController.of(context)!.value('edit')}',
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
