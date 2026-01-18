import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:panel/Admin/Logic/Controllers/app-controller.dart';
import 'package:panel/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:panel/Admin/Logic/Controllers/helper-controller.dart';
import 'package:panel/Admin/Logic/Controllers/main-controller.dart';
import 'package:panel/Admin/Logic/Controllers/view-controller.dart';
import 'package:panel/Admin/Logic/Models/db.dart';
import 'package:panel/Admin/Public/styles.dart';
import 'package:panel/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:panel/Admin/UI/Componenets/General/txt.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:panel/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:panel/Admin/UI/Componenets/Items/Header/header.dart';
import 'package:panel/Admin/UI/Componenets/Items/Menu/menu.dart';

class CreateValidator extends StatefulWidget {
  String tableName;
  CreateValidator(this.tableName);

  @override
  State<CreateValidator> createState() => _CreateValidatorState();
}

class _CreateValidatorState extends State<CreateValidator> {



  //file or multiFile
  RxList<dynamic> itemsListFileType=[].obs;
  Rx<String> initailValueFileType=''.obs;
  Rx<String> hintTextFileType = ''.obs;
  Rx<String> selectedFileType = ''.obs;
  //end file or multiFile
  //number
  RxList<dynamic> itemsListValueNumberType=[].obs;
  Rx<String> initailValueNumberType=''.obs;
  Rx<String> hintTextNumberType = ''.obs;
  Rx<String> selectedNumberType = ''.obs;
  //end number
  RxList<dynamic> itemsList=[].obs;
  Rx<String> initailValueType=''.obs;
  Rx<String> hintText = ''.obs;
  Rx<String> selectedType = ''.obs;
  Rx<String> type = ''.obs;
  Rx<String> numberVal = ''.obs;
  Future<void> loadItems() async {
    Map<String, dynamic> parent = await DB.parentItem;
    int i = ConncetServerController.listFieldsRes.indexWhere((element) => element['_id']==parent['parent_id']);
    type.value = ConncetServerController.listFieldsRes[i]['type'];
      if(type.value == 'file' || type.value == 'multiFile'){
        itemsListFileType.value = MainController.tableInfo['columns'][0]['items'] ?? [];
      }
      else if(type.value == 'Number int' || type.value == 'Number double'||type.value=='string'){
        itemsListValueNumberType.value = MainController.tableInfo['columns'][0]['items'] ?? [];
      }
      else{
        print('_CreateValidatorState.loadItems>>${ MainController.tableInfo['columns'][0]['items']}');
        itemsList.value = MainController.tableInfo['columns'][0]['items'] ?? [];
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
    print('hhhhhhhh>>>${MainController.tableInfo}');
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
                                    Column(
                                      children: [
                                        if (MainController.tableInfo['columns'][j]['is-show-store'] == true)
                                          if (MainController.tableInfo['columns'][j]['type'] == 'string' ||
                                              MainController.tableInfo['columns'][j]['type'] == 'int' ||
                                              MainController.tableInfo['columns'][j]['type'] == 'Number double' ||
                                              MainController.tableInfo['columns'][j]['type'] == 'Number int' ||
                                              MainController.tableInfo['columns'][j]['type'] == 'email' ||
                                              MainController.tableInfo['columns'][j]['type'] == 'mobile')
                                            ViewController.generateFormTextField(GlobalKey(), MainController.tableInfo['columns'][j], MainController.tableInfo['columns'][j]['type'], ''),
                                        if(MainController.tableInfo['columns'][j]['type'] == 'select')
                                          Obx((){
                                            return type.value == 'file' || type.value == 'multiFile' ?
                                            itemsListFileType.value.length !=0 ?Column(
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
                                                Obx((){
                                                  return SelectBox(
                                                      name: '${MainController.tableInfo['columns'][j]['title']}',
                                                      column: MainController.tableInfo['columns'][j],
                                                      items: [
                                                        for (var item in itemsListFileType.value)
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
                                                              value:item['value']),
                                                      ],
                                                      initalValue: initailValueFileType.value == '' ? itemsListFileType.first['value'] : initailValueFileType.value,
                                                      onChanged: (value) async {
                                                        selectedFileType.value = value!;
                                                        initailValueFileType.value = value;

                                                        for (var item in itemsList.value) {
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
                                                      hintText: hintTextFileType.value,
                                                      isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null? false.obs : true.obs,
                                                      selectedValue: '');
                                                }),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ):Container():
                                            type.value == 'Number int' || type.value == 'Number double' || type.value == 'string' ?
                                            itemsListValueNumberType.length !=0 ?
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
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Obx((){
                                                  return SelectBox(
                                                      name: '${MainController.tableInfo['columns'][j]['title']}',
                                                      column: MainController.tableInfo['columns'][j],
                                                      items: [
                                                        for (var item in itemsListValueNumberType.value)
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
                                                              value:item['value']),
                                                      ],
                                                      initalValue: initailValueNumberType.value == '' || initailValueNumberType.value == null
                                                          ? itemsListValueNumberType.value.first['value']
                                                          : initailValueNumberType.value,
                                                      onChanged: (value) async {
                                                        print('value qyuu>>>${value}');
                                                        // sourceItem2.value = value!;
                                                        initailValueNumberType.value = value!;
                                                        selectedNumberType.value = value;
                                                        numberVal.value = value;
                                                        for (var item in itemsList.value) {
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
                                                      hintText: hintTextNumberType.value,
                                                      isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null? false.obs : true.obs,
                                                      selectedValue: '');
                                                }),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ) : Container() :
                                            itemsList.length != 0 ? Column(
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
                                                Obx((){
                                                  return SelectBox(
                                                      name: '${MainController.tableInfo['columns'][j]['title']}',
                                                      column: MainController.tableInfo['columns'][j],
                                                      items: [
                                                        for (var item in itemsList)
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
                                                              value:item['value']),
                                                      ],
                                                      initalValue: initailValueType.value == '' ? itemsList.first['value'] : initailValueType.value,
                                                      onChanged: (value) async {
                                                        selectedType.value = value!;
                                                        initailValueType.value = value;
                                                        if(value == 'multiSelect'){
                                                          ViewController.request['type_field'] = 'string';
                                                        }
                                                        for (var item in itemsList.value) {
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
                                                      isSeleted: ViewController.request[MainController.tableInfo['columns'][j]['name']] == '' || ViewController.request[MainController.tableInfo['columns'][j]['name']] == null? false.obs : true.obs,
                                                      selectedValue: '');
                                                }),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ) : Container()
                                            ;
                                          }),
                                      ],
                                    ),
                                if (numberVal.value == 'min' || numberVal.value == 'max'|| numberVal.value == 'max_count'|| numberVal.value == 'min_count'|| numberVal.value == 'only_count')
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        return Txt(
                                          'value',
                                          color:
                                          MainController.isLightMode.value == true ? whiteColor : color2,
                                        );
                                      }),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FormTextField(
                                        name: 'value',
                                        fbKey: GlobalKey(),
                                        hint: 'value',
                                        lable: '',
                                        // initValue: initValue.toString(),
                                        onChange: (text) {
                                          // dataJson[columnName] = text;
                                          if (text != null && text != '') {
                                            if (type.value == 'Number int') {
                                              ViewController.request['value']= int.parse('${text}');
                                            } else if (type.value == 'Number double') {
                                              ViewController.request['value']= double.parse('${text}');
                                            } else {
                                              ViewController.request['value']= text;
                                            }
                                          } else {
                                            ViewController.request['value']= '';

                                          }
                                        },
                                        isMobile: type == 'mobile' ? true : false,
                                        isNumberInt: type == 'Number int' ? true : false,
                                        isNumberDouble: type == 'Number double' ? true : false,
                                        isEmail: type == 'email' ? true : false,
                                      ),
                                    ],
                                  )
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
