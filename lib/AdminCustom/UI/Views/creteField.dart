import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Logic/Models/db.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:panel/Admin/UI/Componenets/Popups/snackbar.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';

class CretePageField extends StatefulWidget {
  String tableName;

  CretePageField(this.tableName);

  @override
  State<CretePageField> createState() => _CretePageFieldState();
}

class _CretePageFieldState extends State<CretePageField> {
  RxMap<String, RxList<dynamic>> selectItems = <String, RxList<dynamic>>{}.obs;
  RxMap<String, Widget> selectWidgets = <String, Widget>{}.obs;

  // static RxMap<String, dynamic> requestCustomData = {
  //   'custom_data': <Map<String, dynamic>>[]
  // }.obs;
  //select custom
  RxList<dynamic> sourceItemList = [].obs;
  RxList<dynamic> sourceTable = [].obs;
  Rx<String> initailValueType = ''.obs;
  Rx<String> initailValueSourceItems = ''.obs;
  Rx<String> initailValueSourceTable = ''.obs;
  Rx<String> hintText = ''.obs;
  Rx<bool> isSeletedSelectBox = false.obs;

  //end selectcustom

  //multiSelect custom
  RxList<Map<String,dynamic>> sourceTableItems = <Map<String,dynamic>>[].obs;
  List<dynamic> selectedId = [];
  Rx<String> hintTxt = RxString('');
  RxList<dynamic> selectedItemsList = [].obs;
  Rx<bool> isSelectedItem = false.obs;


  //end multi select custom

  Rx<String> sourceItem = ''.obs;
  Rx<String> sourceSelected = ''.obs;
  Rx<String> selectedType = ''.obs;
  RxList<dynamic> typeItems = [].obs;
  List<String> listTitle=[];
  Future<void> loadItems() async {
    typeItems.value = [];
    sourceTableItems.value = [];
    for (var j = 0; j < MainController.tableInfo['columns'].length; j++) {
      final column = MainController.tableInfo['columns'][j];
      if (column['type'] == 'select') {
        var items = await ViewController.itemsList(column);
        selectItems[column['name']] = items.obs;
        selectWidgets[column['name']] = ViewController.generateStoreFormSelectBox(column, items, '', '', false.obs);
        if (column['name'] == 'source_table') {
          sourceTable.value = items;
        }
        else if (column['name'] == 'source_items') {
          sourceItemList.value = await ViewController.itemsList(column);
        }
        else if (column['name'] == 'type') {
          typeItems.value = await ViewController.itemsList(column);
        }
      }
      else if (column['type'] == 'multiSelect') {
        print('_CretePageFieldState.loadItems multiSelect>>${column['name']}');
        if (column['name'] == 'source_table') {
          sourceTableItems.value = await ViewController.itemsList(column) as List<Map<String,dynamic>>;
        }
      }
    }
  }
  static RxMap<String, dynamic> requestCustomData = <String, dynamic>{}.obs;
  RxMap<String, Widget> rows = <String, Widget>{}.obs;

  Widget selectedItem(String key) {
    GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
    GlobalKey<FormBuilderState> _fbKey2 = GlobalKey<FormBuilderState>();
    requestCustomData[key] = {"title": '', "value": null};
    return Container(
      key: GlobalKey(debugLabel: key),
      child: new Row(
        children: [
          SizedBox(
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'عنوان',
                    color:
                    MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                FormTextField(
                  name: 'عنوان',
                  fbKey: _fbKey,
                  hint: 'عنوان',
                  lable: '',

                  onChange: (text) {
                    final currentData = requestCustomData[key] ?? {};
                    currentData['title'] = text ?? '';
                    requestCustomData[key] = currentData;
                    requestCustomData.refresh();

                    // requestCustomData[key] = {
                    //   'title': text?? '',
                    // };
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 7,),
          SizedBox(
            width: 150,
            child: Column(
              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'مقدار',
                    color:
                    MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                FormTextField(
                  name: 'مقدار',
                  fbKey: _fbKey2,
                  hint: 'مقدار',
                  lable: '',
                  onChange: (text) {
                    final currentData = requestCustomData[key] ?? {};
                    currentData['value'] = text ?? '';
                    requestCustomData[key] = currentData;
                    requestCustomData.refresh();

                    // requestCustomData[key] = {
                    //   'value': text?? '',
                    // };
                  },
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }

  void addRow() {
    var key = Uuid().v4();
    if (requestCustomData.length > 0) {
      var invalidItem = requestCustomData.values.firstWhere((
          item) => item['value'] == null, orElse: () => <String, dynamic>{},);
      if (invalidItem.isEmpty) {
        setState(() {
          rows[key] = selectedItem(key);
        });
      }
      else {
        showSnackbar(snackTypes.error, 'لطفاً ابتدا مقدار ردیف‌های قبلی را وارد کنید.');
      }
    } else {
      setState(() {
        rows[key] = selectedItem(key);
      });
    }
  }

  void removeRow(int index, String key) {
    setState(() {
      rows.remove(key);
    });
    requestCustomData.remove(key);
    print('_CretePageFieldState.removeRow>>${requestCustomData}');
  }
 bool checkExistItem(var id){
    for(var item in sourceTableItems){
      if(item['_id']==id){
        return true;
      }
    }
    return false;
  }
  @override
  void initState() {
    super.initState();

    loadItems();
    requestCustomData.value = <String, dynamic>{};
  }

  @override
  Widget build(BuildContext context) {
    var keys = rows.keys.toList();
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
            color: MainController.isLightMode.value == false ? color6 : color9,
          ),
          child: Stack(
            children: [
              Obx(() {
                return Positioned(
                    right: Directionality.of(context) == TextDirection.rtl
                        ? size.width > 800 ? MainController.isClickedItem
                        .value == true ? 300 : 50 : 50
                        : 0,
                    left: Directionality.of(context) == TextDirection.ltr ? size
                        .width > 800 ? MainController.isClickedItem.value ==
                        true ? 300 : 50 : 50 : 0,
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
                                        '${AppController.of(context)!.value(
                                            'add')}',
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
                                                  MainController.goToTablePage(
                                                      MainController
                                                          .SubMenuList[MainController
                                                          .selectedSubItem
                                                          .value]);
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
                                                    '${AppController.of(
                                                        context)!.value(
                                                        'back')}',
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
                                                  if (requestCustomData
                                                      .length != 0) {
                                                    requestCustomData
                                                        .removeWhere((key,
                                                        value) =>
                                                    value['value'] == null);
                                                    ViewController.request
                                                        .addAll(
                                                        {
                                                          "items":
                                                          requestCustomData
                                                              .values.toList()
                                                        });
                                                  }
                                                  HelperController
                                                      .createFunction(
                                                      widget.tableName);
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
                                                    '${AppController.of(
                                                        context)!.value(
                                                        'save')}',
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


                            SizedBox(height: 10,),
                            Column(
                              children: [
                                for (var j = 0; j <
                                    MainController.tableInfo['columns']
                                        .length; j++)
                                  if (MainController
                                      .tableInfo['columns'][j]['is-show-store'] ==
                                      true)
                                    if (MainController
                                        .tableInfo['columns'][j]['type'] ==
                                        'string' ||
                                        MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'int' ||
                                        MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'Number double' ||
                                        MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'Number int' ||
                                        MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'email' ||
                                        MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'mobile')
                                      ViewController.generateFormTextField(
                                          GlobalKey(), MainController
                                          .tableInfo['columns'][j],
                                          MainController
                                              .tableInfo['columns'][j]['type'],
                                          '')
                                    else
                                      if(MainController
                                          .tableInfo['columns'][j]['type'] ==
                                          'checkbox')
                                        ViewController.generateFormCheckBox(
                                            MainController
                                                .tableInfo['columns'][j],
                                            false.obs)
                                      else
                                        if(MainController
                                            .tableInfo['columns'][j]['type'] ==
                                            'date')
                                          ViewController.generateFormDateBox(
                                              MainController
                                                  .tableInfo['columns'][j],
                                              Jalali.now(), false.obs)
                                        else
                                          if(MainController
                                              .tableInfo['columns'][j]['type'] ==
                                              'color')
                                            ViewController.generateFormColorBox(
                                                MainController
                                                    .tableInfo['columns'][j],
                                                Colors.blue, false.obs)
                                          else
                                            if(MainController
                                                .tableInfo['columns'][j]['type'] ==
                                                'file' || MainController
                                                .tableInfo['columns'][j]['type'] ==
                                                'multifile')
                                              ViewController.generateFileBox('',
                                                  MainController
                                                      .tableInfo['columns'][j],
                                                  false.obs)
                                            else if(MainController.tableInfo['columns'][j]['type'] == 'time')
                                                ViewController.generateFormTimeBox(MainController.tableInfo['columns'][j], TimeOfDay.now(), false.obs)
                                            else if(MainController.tableInfo['columns'][j]['type'] == 'select')
                                                  MainController.tableInfo['columns'][j]['name'] == 'type' ?
                                                  Obx(() {
                                                    return typeItems.value.length != 0
                                                        ?
                                                    new Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Obx(() {
                                                          return Txt(
                                                            '${MainController
                                                                .tableInfo['columns'][j]['title']}',
                                                            color: MainController
                                                                .isLightMode
                                                                .value == true
                                                                ? whiteColor
                                                                : color2,
                                                          );
                                                        }),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        MainController
                                                            .tableInfo['columns'][j]['sourceItems'] !=
                                                            'custom' ?
                                                        Obx(() {
                                                          return SelectBox(
                                                              name: '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                              items: [
                                                                DropdownMenuItem(
                                                                    child: Obx(() {
                                                                      return Txt(
                                                                        '${AppController
                                                                            .of(
                                                                            Get
                                                                                .context!)!
                                                                            .value(
                                                                            'not selected')}',
                                                                        color: MainController
                                                                            .isLightMode
                                                                            .value ==
                                                                            true
                                                                            ? whiteColor
                                                                            : primaryDark,
                                                                      );
                                                                    }),
                                                                    value: ''),
                                                                for (var item in typeItems)
                                                                  DropdownMenuItem(
                                                                      child: Obx(() {
                                                                        return Txt(
                                                                          '${ViewController
                                                                              .itemsShowSelectItem(
                                                                              item,
                                                                              MainController
                                                                                  .tableInfo['columns'][j])}',
                                                                          color:
                                                                          MainController
                                                                              .isLightMode
                                                                              .value ==
                                                                              true
                                                                              ? whiteColor
                                                                              : primaryDark,
                                                                        );
                                                                      }),
                                                                      value: item['title']),
                                                              ],
                                                              initalValue: initailValueType
                                                                  .value ==
                                                                  '' ||
                                                                  initailValueType
                                                                      .value ==
                                                                      ''
                                                                  ? ""
                                                                  : initailValueType
                                                                  .value,
                                                              onChanged: (
                                                                  value) async {
                                                                sourceItem
                                                                    .value =
                                                                value!;
                                                                print(
                                                                    '_CretePageFieldState.buildsourceItem>>${sourceItem
                                                                        .value }');

                                                                // initailValue.value = value;
                                                                if (value !=
                                                                    '') {
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] =
                                                                      value;
                                                                } else {
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] =
                                                                  '';
                                                                }
                                                              },
                                                              hintText: hintText
                                                                  .value,
                                                              isSeleted: ViewController
                                                                  .request[MainController
                                                                  .tableInfo['columns'][j]['name']] ==
                                                                  '' ||
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] ==
                                                                      null
                                                                  ? false.obs
                                                                  : true.obs,
                                                              selectedValue: '');
                                                        }) : Obx(() {
                                                          return SelectBox(
                                                              name: '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                              items: [
                                                                for (var item in typeItems)
                                                                  DropdownMenuItem(
                                                                      child: Obx(() {
                                                                        return Txt(
                                                                          '${item['title']}',
                                                                          color:
                                                                          MainController
                                                                              .isLightMode
                                                                              .value ==
                                                                              true
                                                                              ? whiteColor
                                                                              : primaryDark,
                                                                        );
                                                                      }),
                                                                      value: item['value']),
                                                              ],
                                                              initalValue: initailValueType.value == '' ? typeItems.first['value'] : initailValueType.value,
                                                              onChanged: (
                                                                  value) async {
                                                                print(
                                                                    '_CretePageFieldState.build typeeee>>$value');
                                                                selectedType
                                                                    .value =
                                                                value!;
                                                                initailValueType
                                                                    .value =
                                                                    value;
                                                                if (value ==
                                                                    'Number int' ||
                                                                    value ==
                                                                        'Number double') {
                                                                  ViewController
                                                                      .request['type_field'] =
                                                                  'number';
                                                                }
                                                                if (value ==
                                                                    'select' ||
                                                                    value ==
                                                                        'radiobutton' ||
                                                                    value ==
                                                                        'multiSelect' ||
                                                                    value ==
                                                                        'string' ||
                                                                    value ==
                                                                        'multiFile' ||
                                                                    value ==
                                                                        'file' ||
                                                                    value ==
                                                                        'multiFile_pv' ||
                                                                    value ==
                                                                        'file_pv' ||
                                                                    value ==
                                                                        'checkbox' ||
                                                                    value ==
                                                                        'date'||
                                                                    value ==
                                                                        'time' ) {
                                                                  ViewController
                                                                      .request['type_field'] =
                                                                  'string';
                                                                }
                                                                for (var item in typeItems
                                                                    .value) {
                                                                  if (item['title'] ==
                                                                      value) {
                                                                    if (item['value'] ==
                                                                        '') {
                                                                      value =
                                                                      null;
                                                                    }
                                                                  }
                                                                }
                                                                if (value !=
                                                                    '') {
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] =
                                                                      value;
                                                                } else {
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] =
                                                                  '';
                                                                }
                                                              },
                                                              hintText: hintText
                                                                  .value,
                                                              isSeleted: ViewController
                                                                  .request[MainController
                                                                  .tableInfo['columns'][j]['name']] ==
                                                                  '' ||
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] ==
                                                                      null
                                                                  ? false.obs
                                                                  : true.obs,
                                                              selectedValue: '');
                                                        }),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    ) : Container();
                                                  }) :

                                                  MainController.tableInfo['columns'][j]['name'] == 'source_items'
                                                      ? selectedType.value == 'select' || selectedType.value == 'multiSelect' || selectedType.value == 'radiobutton' ||
                                                      selectedType.value == '' ? sourceItemList.value.length != 0 &&
                                                      selectedType.value == 'select' ||
                                                      selectedType.value == 'radiobutton' ||
                                                      selectedType.value == 'multiSelect' ?
                                                  new Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Obx(() {
                                                        return Txt(
                                                          '${MainController
                                                              .tableInfo['columns'][j]['title']}',
                                                          color: MainController
                                                              .isLightMode
                                                              .value == true
                                                              ? whiteColor
                                                              : color2,
                                                        );
                                                      }),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      MainController.tableInfo['columns'][j]['sourceItems'] != 'custom' ?
                                                      Obx(() {
                                                        return SelectBox(
                                                            name: '${MainController.tableInfo['columns'][j]['title']}',
                                                            column: MainController.tableInfo['columns'][j],
                                                            items: [
                                                              DropdownMenuItem(
                                                                  child: Obx(() {
                                                                    return Txt(
                                                                      '${AppController.of(Get.context!)!.value('not selected')}',
                                                                      color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                                                                    );
                                                                  }),
                                                                  value: ''),
                                                              for (var item in sourceItemList.value)
                                                                DropdownMenuItem(
                                                                    child: Obx(() {
                                                                      return
                                                                        Txt(
                                                                          '${ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j])}',
                                                                          color:
                                                                          MainController
                                                                              .isLightMode
                                                                              .value ==
                                                                              true
                                                                              ? whiteColor
                                                                              : primaryDark,
                                                                        );
                                                                    }),
                                                                    value: item['title']),
                                                            ],
                                                            initalValue: initailValueSourceItems
                                                                .value ==
                                                                ''
                                                                ? ""
                                                                : initailValueSourceItems
                                                                .value,
                                                            onChanged: (
                                                                value) async {
                                                              sourceItem.value =
                                                              value!;
                                                              print(
                                                                  '_CretePageFieldState.build>>sourceItem>>${sourceItem
                                                                      .value}');

                                                              // initailValue.value = value;
                                                              if (value != '') {
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] =
                                                                    value;
                                                              } else {
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] =
                                                                '';
                                                              }
                                                            },
                                                            hintText: hintText
                                                                .value,
                                                            isSeleted: ViewController
                                                                .request[MainController
                                                                .tableInfo['columns'][j]['name']] ==
                                                                '' ||
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] ==
                                                                    null ? false
                                                                .obs : true.obs,
                                                            selectedValue: '');
                                                      }) :
                                                      Obx(() {
                                                        return SelectBox(
                                                            name: '${MainController
                                                                .tableInfo['columns'][j]['title']}',
                                                            column: MainController
                                                                .tableInfo['columns'][j],
                                                            items: [
                                                              for (var item in sourceItemList)
                                                                DropdownMenuItem(
                                                                    child: Obx(() {
                                                                      return Txt(
                                                                        '${item['title']}',
                                                                        color:
                                                                        MainController
                                                                            .isLightMode
                                                                            .value ==
                                                                            true
                                                                            ? whiteColor
                                                                            : primaryDark,
                                                                      );
                                                                    }),
                                                                    value: item['value']),
                                                            ],
                                                            initalValue: initailValueSourceItems
                                                                .value ==
                                                                ''? sourceItemList
                                                                .first['value']
                                                                : initailValueSourceItems
                                                                .value,
                                                            onChanged: (
                                                                value) async {
                                                              sourceItem.value =
                                                              value!;
                                                              initailValueSourceItems
                                                                  .value =
                                                                  value;
                                                              print(
                                                                  '_CretePageFieldState.build>>${sourceItem.value}');
                                                              for (var item in sourceItemList.value) {
                                                                if (item['title'] == value) {
                                                                  if (item['value'] == '') {
                                                                    value = null;
                                                                  }
                                                                }
                                                              }
                                                              if (value !=
                                                                  '') {
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] =
                                                                    value;
                                                              } else {
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] =
                                                                '';
                                                              }
                                                            },
                                                            hintText: hintText
                                                                .value,
                                                            isSeleted: ViewController
                                                                .request[MainController
                                                                .tableInfo['columns'][j]['name']] ==
                                                                '' ||
                                                                ViewController
                                                                    .request[MainController
                                                                    .tableInfo['columns'][j]['name']] ==
                                                                    null
                                                                ? false.obs
                                                                : true.obs,
                                                            selectedValue: '');
                                                      }),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      if(sourceItem.value == 'custom')
                                                        Column(
                                                          children: [
                                                            IconButton(
                                                              icon: Icon(Icons
                                                                  .add_circle,
                                                                  color: Colors
                                                                      .green,
                                                                  size: 30),
                                                              onPressed: () {
                                                                addRow();
                                                              },
                                                            ),
                                                            if(rows.length != 0)
                                                              for (var i = 0; i <
                                                                  keys.length; i++)
                                                                Row(
                                                                  children: [
                                                                    rows[keys[i]]!,
                                                                    IconButton(
                                                                        icon: Icon(
                                                                            Icons
                                                                                .remove_circle,
                                                                            color: Colors
                                                                                .red,
                                                                            size: 30),
                                                                        onPressed: () =>
                                                                            removeRow(
                                                                                i,
                                                                                keys[i])

                                                                    ),
                                                                  ],
                                                                ),
                                                          ],
                                                        ),
                                                      SizedBox(width: 10),
                                                    ],
                                                  ) : Container()
                                                      : Container()
                                                      :
                                                  MainController.tableInfo['columns'][j]['name'] == 'source_table'
                                                      ? sourceItem.value == 'custom' ? Container() :
                                                  (sourceTable.value.length != 0) && (selectedType.value == 'select' || selectedType.value == 'multiSelect' || selectedType.value == 'radiobutton') ?
                                                  Obx(() {
                                                    return new Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Txt(
                                                          '${MainController
                                                              .tableInfo['columns'][j]['title']}',
                                                          color: MainController
                                                              .isLightMode
                                                              .value == true
                                                              ? whiteColor
                                                              : color2,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        MainController.tableInfo['columns'][j]['sourceItems'] !=
                                                            'custom' ?
                                                        Obx(() {
                                                          return SelectBox(
                                                              name: '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                              items: [
                                                                DropdownMenuItem(
                                                                    child: Obx(() {
                                                                      return Txt(
                                                                        '${AppController
                                                                            .of(
                                                                            Get
                                                                                .context!)!
                                                                            .value(
                                                                            'not selected')}',
                                                                        color: MainController
                                                                            .isLightMode
                                                                            .value ==
                                                                            true
                                                                            ? whiteColor
                                                                            : primaryDark,
                                                                      );
                                                                    }),
                                                                    value: ''),
                                                                for (var item in sourceTable)
                                                                  DropdownMenuItem(
                                                                      child: Obx(() {
                                                                        return Txt(
                                                                          '${ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j])}',
                                                                          color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                                                                        );
                                                                      }),
                                                                      value: item['_id']),
                                                              ],
                                                              initalValue: initailValueSourceTable.value ==
                                                                  '' ? "" : initailValueSourceTable.value,
                                                              onChanged: (value) async {
                                                                sourceTableItems.value = [];
                                                                initailValueSourceTable.value =  sourceTable.firstWhere((element) => element['_id']==value)['name'];
                                                                // initailValueSourceTable.value =  value!;
                                                                sourceSelected.value =  value!;
                                                                if (sourceSelected.value != '') {
                                                                  await ConncetServerController.listFieldByTableId({'id':value});
                                                                  for (var data in ConncetServerController.listFieldsRes) {
                                                                    if (checkExistItem(data['_id'])==false) {
                                                                      sourceTableItems.add(data);
                                                                    }
                                                                  }
                                                                }
                                                                else {
                                                                  sourceTableItems.value = [];
                                                                }
                                                                if (value != '') {
                                                                  ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                                } else {
                                                                  ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                                }
                                                                print('_CretePageFieldState.build sourceTableItems.value add>>${ ViewController.request[MainController.tableInfo['columns'][j]['name']] }');

                                                              },
                                                              hintText: hintText.value,
                                                              isSeleted: ViewController.request[MainController
                                                                  .tableInfo['columns'][j]['name']] ==
                                                                  '' ||
                                                                  ViewController
                                                                      .request[MainController
                                                                      .tableInfo['columns'][j]['name']] ==
                                                                      null
                                                                  ? false.obs
                                                                  : true.obs,
                                                              selectedValue: '');
                                                        }) : Obx(() {
                                                              return SelectBox(
                                                              name: '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                              items: [
                                                                for (var item in sourceTable.value)
                                                                  DropdownMenuItem(
                                                                      child: Obx(() {
                                                                        return Txt(
                                                                          '${item['title']}',
                                                                          color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                                                                        );
                                                                      }),
                                                                      value: item['value']),
                                                              ],
                                                              initalValue: initailValueSourceTable.value == '' ? sourceTable.value.first['value'] : initailValueSourceTable.value,
                                                              onChanged: (value) async {
                                                                for (var item in sourceTable.value) {
                                                                  if (item['title'] == value) {
                                                                    if (item['value'] == '') {
                                                                      value =
                                                                      null;
                                                                    }
                                                                  }
                                                                }
                                                                initailValueSourceTable.value = value!;
                                                                sourceSelected.value = value;
                                                                if (sourceSelected.value != '') {
                                                                  await ConncetServerController.listFieldByTableId({'id': sourceSelected.value});
                                                                  for (var data in ConncetServerController.listFieldsRes) {
                                                                    print('_CretePageFieldState.build listFieldsRes>>${data}');
                                                                    if (checkExistItem(data['_id'])==false) {
                                                                      sourceTableItems.add(data);
                                                                    }
                                                                  }
                                                                }
                                                                else {
                                                                  sourceTableItems.value = [];
                                                                }
                                                                if (value != '') {
                                                                  ViewController.request[MainController.tableInfo['columns'][j]['name']] = value;
                                                                } else {
                                                                  ViewController.request[MainController.tableInfo['columns'][j]['name']] = '';
                                                                }
                                                                print('_CretePageFieldState.build sourceTableItems.value add>>${sourceTableItems.value}');

                                                              },
                                                              hintText: hintText.value,
                                                              isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs,
                                                              selectedValue: '');
                                                        }),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                      ],
                                                    );
                                                  })
                                                      : Container()
                                                      :
                                                  Container()
                                                else
                                                  if(MainController
                                                      .tableInfo['columns'][j]['type'] ==
                                                      'multiSelect')
                                                  // sourceItem.value == 'custom' && (selectedType.value == 'select' || selectedType.value == 'multiSelect' || selectedType.value == 'radiobutton')
                                                  //     ? ViewController
                                                  //     .generateFormTextField(
                                                  //     GlobalKey(),
                                                  //     MainController
                                                  //         .tableInfo['columns'][j],
                                                  //     'string', '')
                                                  //     :
                                                    (selectedType.value == 'select' || selectedType.value == 'multiSelect' || selectedType.value == 'radiobutton' || selectedType.value == '') &&
                                                        sourceItem.value != 'custom' ?
                                                    Obx(() {
                                                      print('_CretePageFieldState.build sourceTableItems>>${sourceTableItems}');
                                                      return sourceTableItems.length != 0 ? MainController.tableInfo['columns'][j]['sourceItems'] != 'custom' ?
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Obx(() {
                                                            return Txt(
                                                              '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              color: MainController
                                                                  .isLightMode
                                                                  .value == true
                                                                  ? whiteColor
                                                                  : color2,
                                                            );
                                                          }),
                                                          Obx(() {
                                                            return MultiSelectDropdown(
                                                              items: [
                                                                for (var item in sourceTableItems)
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
                                                                                            } else {
                                                                                              selectedId = [];
                                                                                              if (selectedItemsList.contains(item['_id'])) {
                                                                                                selectedItemsList.remove(item['_id']);
                                                                                              }
                                                                                            }
                                                                                            if (selectedItemsList.value.length == 0) {
                                                                                              isSelectedItem.value = false;
                                                                                            } else {
                                                                                              isSelectedItem.value = true;
                                                                                            }
                                                                                            for (var r in selectedItemsList) {
                                                                                              var i;
                                                                                              if(item['_id']==r)
                                                                                                i=item;
                                                                                              hintTxt.value = hintTxt.value + ViewController.itemsShowSelectItem(i['name'], MainController.tableInfo['columns'][j]);
                                                                                            }
                                                                                            selectedId.add(item);
                                                                                            print('_CretePageFieldState.build selectedItemsList>>>${selectedItemsList}>>>${selectedId}');
                                                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedId;
                                                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedItemsList;
                                                                                          }
                                                                                        });
                                                                                  })),
                                                                            ),
                                                                            Txt(ViewController.itemsShowSelectItem(item, MainController.tableInfo['columns'][j]), color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                                                          ],
                                                                        );
                                                                      }))
                                                              ],
                                                              hintText: hintTxt.value != '' ? hintTxt.value : '${AppController.of(Get.context!)!.value('choice')}',
                                                              selectedItems: selectedItemsList,
                                                              isSelectedItem: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null ? false.obs : true.obs,
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                            );
                                                          }),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      )
                                                          : Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Obx(() {
                                                            return Txt(
                                                              '${MainController
                                                                  .tableInfo['columns'][j]['title']}',
                                                              color: MainController
                                                                  .isLightMode
                                                                  .value == true
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
                                                                                        value: selectedItemsList.contains(item['_id']),
                                                                                        onChanged: (isChecked) {
                                                                                          if (isChecked != null) {
                                                                                            hintTxt.value ='';

                                                                                            if (!selectedItemsList.contains(item['_id'])) {
                                                                                              selectedId = [];
                                                                                              selectedItemsList.add(item['_id']);
                                                                                              listTitle.add(item['title']);
                                                                                            } else {
                                                                                              selectedId = [];
                                                                                              if (selectedItemsList.contains(item['_id'])) {
                                                                                                selectedItemsList.remove(item['_id']);
                                                                                                listTitle.remove(item['title']);
                                                                                              }
                                                                                            }

                                                                                            if (selectedItemsList.length == 0) {
                                                                                              isSelectedItem.value =
                                                                                              false;
                                                                                            } else {
                                                                                              isSelectedItem.value =
                                                                                              true;
                                                                                            }

                                                                                            // hintTxt.value = ViewController.itemsShowSelectItem(selectedItemsList, MainController.tableInfo['columns'][j]);
                                                                                            hintTxt.value = '${listTitle.join(',')}';
                                                                                            selectedId.add(item);
                                                                                            ViewController.request[MainController.tableInfo['columns'][j]['name']] = selectedItemsList;
                                                                                          }
                                                                                          print('_CretePageFieldState.build selectedItemsList2>>${listTitle}>>>${selectedItemsList}>>>${selectedId}');

                                                                                        });
                                                                                  })),
                                                                            ),
                                                                            Txt(
                                                                                item['title'],
                                                                                color: MainController
                                                                                    .isLightMode
                                                                                    .value
                                                                                    ? whiteColor
                                                                                    : primaryDark),
                                                                          ],
                                                                        );
                                                                      }))
                                                              ],
                                                              hintText: hintTxt
                                                                  .value !=
                                                                  '' && hintTxt
                                                                  .value != null
                                                                  ? hintTxt
                                                                  .value
                                                                  : '${AppController
                                                                  .of(
                                                                  Get.context!)!
                                                                  .value(
                                                                  'choice')}',
                                                              selectedItems: selectedItemsList,
                                                              isSelectedItem: isSelectedItem,
                                                              column: MainController
                                                                  .tableInfo['columns'][j],
                                                            );
                                                          }),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      )
                                                          : Container();
                                                    })
                                                        : Container()


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
