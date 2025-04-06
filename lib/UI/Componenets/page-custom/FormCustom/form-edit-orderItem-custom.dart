import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/validator-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-file.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/UI/Componenets/page-custom/TableCustom/table-custom-page.dart';
import 'package:finance/UI/Views/table-page.dart';
import 'package:finance/boxes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../../../Logic/Controllers/app-controller.dart';
import 'package:finance/Logic/Controllers/dataController.dart';

class FormEditOrderItemCustom extends StatefulWidget {

  FormEditOrderItemCustom({required this.index , this.data});
  DataModel? data;
  int index;

  @override
  State<FormEditOrderItemCustom> createState() => _FormEditOrderItemCustomState();
}

class _FormEditOrderItemCustomState extends State<FormEditOrderItemCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};
  var getDataTable = ViewCustomController.getDataTable('order-items');

  void initState() {
    super.initState();
    _loadData();
  }
  void _loadData() {
    var getDataTable = ViewCustomController.getDataTable('order-items');
    for (var j = 0; j < getDataTable['columns'].length; j++) {
      String columnName = getDataTable['columns'][j]['name'];
      if (getDataTable['columns'][j]['type'] == 'select' ||
          getDataTable['columns'][j]['type'] == 'radiobutton') {
        _future['${columnName}'] = ViewCustomController.getSelectBoxData(getDataTable['columns'][j]);
      }
      else if(getDataTable['columns'][j]['type'] == 'multiSelect'){
        _future['${columnName}'] = ViewCustomController.getMultiSelectBoxData(getDataTable['columns'][j]);

      }
    }
  }
  List<Widget> containers = [];

  void _addContainer() {
    setState(() {
      containers.add(buildContainer());
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Rx<bool> isHoverBtnBack = false.obs;

    return Column(
      children: [
        if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] != 'order')
          Container(
            padding: EdgeInsets.all(10),
            width: size.width,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.end,
              alignment: WrapAlignment.end,
              children: [
                MouseRegion(
                  onEnter: (_){
                    isHoverBtnBack.value = true;
                  },
                  onExit: (_){
                    isHoverBtnBack.value = false;
                  },
                  child: InkWell(
                    onTap: (){
                      print('widget.data!.data>>>${widget.data!.data}');
                      MainController.isClickedItem.value = true;
                      Get.to(() => TableCustomPage());
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: colorBtn , width: 1),
                        color: isHoverBtnBack.value == false ? Colors.transparent : colorBtn,
                      ),
                      child: Txt('${AppController.of(context)!.value('back')}' , color:isHoverBtnBack.value == false ? colorBtn : whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                InkWell(
                  onTap: ()async{
                    ViewController.isClickedEditBtn.value = true;
                    final data = DataModel(
                      id: widget.data!.id,
                      data: ViewController.request,
                    );
                    print('xxxx>>>${ViewController.request}');
                    bool isValidator;
                    List<bool> isValidatorList=[];
                    for (var j = 0; j < getDataTable['columns'].length; j++) {
                      isValidator = await ValidatorController.checkInputValidation(j,data.data , tableData: getDataTable);
                      isValidatorList.add(isValidator);
                    }
                    print('isValidatorList>>>${isValidatorList}');
                    bool isExsistsValidation = isValidatorList.contains(false);
                    print('isExsistsValidation>>>${isExsistsValidation}');
                    if(isExsistsValidation){
                      isValidatorList=[];
                    }
                    else{
                      await MainController.loadData(tableData: getDataTable);
                      dataController.allData.value[widget.index] =  data;
                      MainController.tableData.value[widget.index] = data;
                      // await box.putAt(widget.index,data);
                      Box orderItemBox = await ViewController.getBox('order-items');
                      await orderItemBox.putAt(widget.index,data);

                      Box orderBox = await ViewController.getBox('order');
                      await orderBox.putAt(widget.index,data);

                      print('dataController.allData.value[widget.index]>>>${dataController.allData.value[widget.index].data}');
                      print('MainController.tableData.value[widget.index]>>>>${MainController.tableData.value[widget.index]}');
                      MainController.isClickedItem.value = true;
                      ViewController.isClickedEditBtn.value = false;
                      Get.to(() => TableCustomPage());
                    }


                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: colorBtn,
                    ),
                    child: Txt('${AppController.of(context)!.value('edit')}' , color:whiteColor, fontSize: 16, fontWeight: FontWeight.w400,),
                  ),
                ),
              ],
            )
          ),
          SizedBox(height: 20,),
          Container(
          padding: EdgeInsets.all(20),
          decoration:  BoxDecoration(
              border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
              borderRadius:  BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      _addContainer();
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.orange,),
                      child: Center(child: Txt('${AppController.of(context)!.value('surcharge')}')),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Container(
                width: size.width,

                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // runSpacing: 5,
                    // spacing: 20,
                    children: [
                      for (var j = 0; j < getDataTable['columns'].length; j++)
                        if(getDataTable['columns'][j]['is-show-store'] == true || getDataTable['columns'][j]['is-show-store'] == null)
                          if (getDataTable['columns'][j]['type'] == 'string' ||
                              getDataTable['columns'][j]['type'] == 'number' ||
                              getDataTable['columns'][j]['type'] == 'mobile' ||
                              getDataTable['columns'][j]['type'] == 'email')
                            Row(
                              children: [
                                Container(
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        return Txt(
                                          '${getDataTable['columns'][j]['title']}',
                                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                                        );
                                      }),
                                      SizedBox(height: 10),
                                      FormTextField(
                                        name: '${getDataTable['columns'][j]['title']}',
                                        hint: '${getDataTable['columns'][j]['title']}',
                                        lable: '',
                                        initValue: '${ViewController.request['${getDataTable['columns'][j]['name']}'] != null ? ViewController.request['${getDataTable['columns'][j]['name']}'] : ''}',
                                        isNumber: getDataTable['columns'][j]['type'] == 'number' ? true : false,
                                        isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                                        isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                                        onChange: (text) {
                                          ViewController.request['${getDataTable['columns'][j]['name']}'] = text;
                                          print('getDataTable>>>${getDataTable}');
                                        },
                                        column: getDataTable['columns'][j],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: 20,)
                              ],
                            )
                          else if (getDataTable['columns'][j]['type'] == 'checkbox')
                            Row(
                              children: [
                                CheckBox(
                                  checkBoxName: '${getDataTable['columns'][j]['title']}',
                                  checkBoxTitle: '${getDataTable['columns'][j]['title']}',
                                  defaultValue: ViewController.request['${getDataTable['columns'][j]['name']}'],
                                  onChange: (text) {
                                    ViewController.request['${getDataTable['columns'][j]['name']}'] = text;
                                  },
                                  column: getDataTable['columns'][j],
                                ),
                                SizedBox(width: 20,)
                              ],
                            )
                          else if (getDataTable['columns'][j]['type'] == 'color')
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        return Txt(
                                          '${getDataTable['columns'][j]['title']}',
                                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                                        );
                                      }),
                                      SizedBox(height: 10),
                                      Container(
                                        child: ColorPickerBox(
                                          selectedColor: ViewController.request['${getDataTable['columns'][j]['name']}'] != null
                                              ? Color(int.parse('${ViewController.request['${getDataTable['columns'][j]['name']}']}'))
                                              : Colors.blue,
                                          onChanged: (color) {
                                            colorChanged = color;
                                            String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                                            ViewController.request['${getDataTable['columns'][j]['name']}'] = hexColor;
                                          },
                                          column: getDataTable['columns'][j],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20,)
                                ],
                              )
                            else if (getDataTable['columns'][j]['type'] == 'date')
                                Row(
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Obx(() {
                                            return Txt(
                                              '${getDataTable['columns'][j]['title']}',
                                              color: MainController.isLightMode.value == true ? whiteColor : color2,
                                            );
                                          }),
                                          SizedBox(height: 10),
                                          ViewController.request['${getDataTable['columns'][j]['name']}'] != null
                                              ? DateBox(
                                            selectedDate: ViewCustomController.parseDate(ViewController.request['${getDataTable['columns'][j]['name']}']),
                                            onDateChanged: (date) {
                                              ViewController.request['${getDataTable['columns'][j]['name']}'] = date;
                                            },
                                            column: getDataTable['columns'][j],
                                          )
                                              : DateBox(
                                            selectedDate: Jalali.now(),
                                            onDateChanged: (date) {
                                              ViewController.request['${getDataTable['columns'][j]['name']}'] = date;
                                            },
                                            column: getDataTable['columns'][j],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 20,)
                                  ],
                                )
                              else if (getDataTable['columns'][j]['type'] == 'select')
                                 Row(
                                   children: [
                                     FutureBuilder(
                                       future: _future[getDataTable['columns'][j]['title']],
                                       builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                         if (snapshot.connectionState == ConnectionState.waiting) {
                                           return CircularProgressIndicator();
                                         } else if (snapshot.hasError) {
                                           if (snapshot.data != null) {
                                             return Txt('${AppController.of(context)!.value('error')}');
                                           } else {
                                             return Container();
                                           }
                                         } else {
                                           if (snapshot.hasData) {
                                             var data = snapshot.data!;
                                             if (data['items'] == null || data['items'].isEmpty) {
                                               return Container();
                                             } else {
                                               return Container(
                                                 width:getDataTable['columns'][j]['name'] == 'نام کالا'  ? 150:80,
                                                 // width: 150,
                                                 // height: 100,
                                                 child: Column(
                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                   children: [
                                                     Obx(() {
                                                       return Txt(
                                                         '${getDataTable['columns'][j]['title']}',
                                                         color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                       );
                                                     }),
                                                     SizedBox(height: 10),
                                                     SelectBox(
                                                       name: '${getDataTable['columns'][j]['title']}',
                                                       column: getDataTable['columns'][j],
                                                       items: data['items'].map<DropdownMenuItem<String>>((item) {
                                                         return DropdownMenuItem<String>(
                                                           value: item['value'].toString(),
                                                           child: Obx(() {
                                                             return Txt(
                                                               '${item['title']}',
                                                               color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                                                             );
                                                           }),
                                                         );
                                                       }).toList(),
                                                       initalValue: data['initValue'],
                                                       onChanged: (value) async {
                                                         print('selected item ${value}');
                                                         for (var item in data['items']) {
                                                           if (item['title'] == value) {
                                                             if (item['value'] == '-1') {
                                                               value = null;
                                                             }
                                                           }
                                                         }
                                                         if (value != '-1') {
                                                           ViewController.request[getDataTable['columns'][j]['name']] = value;
                                                         } else {
                                                           ViewController.request[getDataTable['columns'][j]['name']] = '';
                                                         }
                                                       },
                                                       hintText: data['hint'],
                                                       isSeleted: ViewController.request[getDataTable['columns'][j]['name']] == '' || ViewController.request[getDataTable['columns'][j]['name']] == null ? false.obs : true.obs,
                                                       selectedValue: '',
                                                     ),
                                                   ],
                                                 ),
                                               );
                                             }
                                           } else {
                                             return Container();
                                           }
                                         }
                                       },
                                     ),
                                     SizedBox(width: 20,)
                                   ],
                                 )
                                else if (getDataTable['columns'][j]['type'] == 'multiSelect')
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Txt(
                                                '${getDataTable['columns'][j]['title']}',
                                                color: MainController.isLightMode.value == true ? whiteColor : color2,
                                              );
                                            }),
                                            SizedBox(height: 10),
                                            FutureBuilder(
                                              future: _future[getDataTable['columns'][j]['title']],
                                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  if (snapshot.data != null) {
                                                    return Txt('${AppController.of(context)!.value('error')}');
                                                  } else {
                                                    return Container();
                                                  }
                                                } else {
                                                  var data = snapshot.data!;
                                                  return data['items'].length != 0
                                                      ? Obx(() {
                                                    return Container(
                                                      width: 150,
                                                      child: MultiSelectDropdown(
                                                        items: [
                                                          for (var item in data['items'])
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
                                                                        child: Checkbox(
                                                                          activeColor: colorBtn,
                                                                          value: data['selectedItemsList'].contains(item['value']),
                                                                          onChanged: (isChecked) {
                                                                            if (isChecked != null) {
                                                                              if (!data['selectedItemsList'].contains(item['value'])) {
                                                                                data['selectedItemsList'].add(item['value']);
                                                                              } else {
                                                                                data['selectedItemsList'].remove(item['value']);
                                                                              }
                                                                              if (item['value'] == '-1') {
                                                                                data['selectedItemsList'].remove(item['value']);
                                                                              }
                                                                              if (data['selectedItemsList'].isEmpty) {
                                                                                data['isSelectedItem'].value = false;
                                                                              } else {
                                                                                data['isSelectedItem'].value = true;
                                                                              }
                                                                              data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
                                                                              ViewController.request[getDataTable['columns'][j]['name']] = data['selectedItemsList'];
                                                                            }
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                                                  ],
                                                                );
                                                              }),
                                                            ),
                                                        ],
                                                        hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
                                                        selectedItems: data['selectedItemsList'],
                                                        isSelectedItem: data['isSelectedItem'],
                                                        onChanged: (selectedList) {
                                                          data['selectedItemsList'].value = selectedList;
                                                          ViewController.request[getDataTable['columns'][j]['name']] = selectedList;
                                                          data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
                                                        },
                                                        column: getDataTable['columns'][j],
                                                      ),
                                                    );
                                                  })
                                                      : Container();
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                        SizedBox(width: 20,)
                                      ],
                                    )
                                  else if (getDataTable['columns'][j]['type'] == 'radiobutton')
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Obx(() {
                                                return Txt(
                                                  '${getDataTable['columns'][j]['title']}',
                                                  color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                );
                                              }),
                                              SizedBox(height: 10),
                                              FutureBuilder(
                                                future: _future[getDataTable['columns'][j]['title']],
                                                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                                    return CircularProgressIndicator();
                                                  } else if (snapshot.hasError) {
                                                    if (snapshot.data != null) {
                                                      return Txt('${AppController.of(context)!.value('error')}');
                                                    } else {
                                                      return Container();
                                                    }
                                                  } else {
                                                    var data = snapshot.data!;
                                                    return Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Obx(() {
                                                          return Txt(
                                                            '${getDataTable['columns'][j]['title']}',
                                                            color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                          );
                                                        }),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          width:150,
                                                          child: RadioButton(
                                                            name: '',
                                                            radioButtonItems: [
                                                              for (var radioButtonItem in data['items'])
                                                                FormBuilderChipOption(
                                                                  value: '${radioButtonItem['value']}',
                                                                  child: Obx(() {
                                                                    return Txt(
                                                                      '${radioButtonItem['title']}',
                                                                      color: MainController.isLightMode.value ? whiteColor : primaryDark,
                                                                    );
                                                                  }),
                                                                ),
                                                            ],
                                                            onChanged: (text) {
                                                              ViewController.request[getDataTable['columns'][j]['name']] = text;
                                                            },
                                                            initalValue: data['initValue'],
                                                            column: getDataTable['columns'][j],
                                                            isSelectedItem: ViewController.request[getDataTable['columns'][j]['name']] == '' ? false.obs : true.obs,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 20,)
                                        ],
                                      )
                                    else if (getDataTable['columns'][j]['type'] == 'file')
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Obx(() {
                                                  return Txt(
                                                    '${getDataTable['columns'][j]['title']}',
                                                    color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                  );
                                                }),
                                                SizedBox(height: 10),
                                                Container(
                                                  width: 500,
                                                  child: FormFile(
                                                    columnName: getDataTable['columns'][j]['title'],
                                                    onChanged: (selecetdFiles) {
                                                      ViewController.request[getDataTable['columns'][j]['name']] = selecetdFiles;
                                                    },
                                                    filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                                                    selectedFilesTxt: ViewController.request[getDataTable['columns'][j]['name']],
                                                    column: getDataTable['columns'][j],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 20,)
                                          ],
                                        )
                    ],
                  ),
                ),
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: containers.length,
                  itemBuilder: (context, index) {
                    return containers[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget buildContainer() {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          // runSpacing: 5,
          // spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var j = 0; j < getDataTable['columns'].length; j++)
              if(getDataTable['columns'][j]['is-show-store'] == true || getDataTable['columns'][j]['is-show-store'] == null)
                if (getDataTable['columns'][j]['type'] == 'string' ||
                    getDataTable['columns'][j]['type'] == 'number' ||
                    getDataTable['columns'][j]['type'] == 'mobile' ||
                    getDataTable['columns'][j]['type'] == 'email')
                  Row(
                    children: [
                      Container(
                        width: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Txt(
                                '${getDataTable['columns'][j]['title']}',
                                color: MainController.isLightMode.value == true ? whiteColor : color2,
                              );
                            }),
                            SizedBox(height: 10),
                            FormTextField(
                              name: '${getDataTable['columns'][j]['title']}',
                              hint: '${getDataTable['columns'][j]['title']}',
                              lable: '',
                              initValue: '${ViewController.request['${getDataTable['columns'][j]['name']}'] != null ? ViewController.request['${getDataTable['columns'][j]['name']}'] : ''}',
                              isNumber: getDataTable['columns'][j]['type'] == 'number' ? true : false,
                              isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                              isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                              onChange: (text) {
                                ViewController.request['${getDataTable['columns'][j]['name']}'] = text;
                              },
                              column: getDataTable['columns'][j],
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 20,)
                    ],
                  )
                else if (getDataTable['columns'][j]['type'] == 'checkbox')
                  Row(
                    children: [
                      CheckBox(
                        checkBoxName: '${getDataTable['columns'][j]['title']}',
                        checkBoxTitle: '${getDataTable['columns'][j]['title']}',
                        defaultValue: ViewController.request['${getDataTable['columns'][j]['name']}'],
                        onChange: (text) {
                          ViewController.request['${getDataTable['columns'][j]['name']}'] = text;
                        },
                        column: getDataTable['columns'][j],
                      ),
                      SizedBox(width: 20,)
                    ],
                  )
                else if (getDataTable['columns'][j]['type'] == 'color')
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Txt(
                                '${getDataTable['columns'][j]['title']}',
                                color: MainController.isLightMode.value == true ? whiteColor : color2,
                              );
                            }),
                            SizedBox(height: 10),
                            Container(
                              child: ColorPickerBox(
                                selectedColor: ViewController.request['${getDataTable['columns'][j]['name']}'] != null
                                    ? Color(int.parse('${ViewController.request['${getDataTable['columns'][j]['name']}']}'))
                                    : Colors.blue,
                                onChanged: (color) {
                                  colorChanged = color;
                                  String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                                  ViewController.request['${getDataTable['columns'][j]['name']}'] = hexColor;
                                },
                                column: getDataTable['columns'][j],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20,)
                      ],
                    )
                  else if (getDataTable['columns'][j]['type'] == 'date')
                      Row(
                        children: [
                          Container(
                            width: 120,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return Txt(
                                    '${getDataTable['columns'][j]['title']}',
                                    color: MainController.isLightMode.value == true ? whiteColor : color2,
                                  );
                                }),
                                SizedBox(height: 10),
                                ViewController.request['${getDataTable['columns'][j]['name']}'] != null
                                    ? DateBox(
                                  selectedDate: ViewCustomController.parseDate(ViewController.request['${getDataTable['columns'][j]['name']}']),
                                  onDateChanged: (date) {
                                    ViewController.request['${getDataTable['columns'][j]['name']}'] = date;
                                  },
                                  column: getDataTable['columns'][j],
                                )
                                    : DateBox(
                                  selectedDate: Jalali.now(),
                                  onDateChanged: (date) {
                                    ViewController.request['${getDataTable['columns'][j]['name']}'] = date;
                                  },
                                  column: getDataTable['columns'][j],
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: 20,)
                        ],
                      )
                    else if (getDataTable['columns'][j]['type'] == 'select')
                        Row(
                          children: [
                            FutureBuilder(
                              future: _future[getDataTable['columns'][j]['title']],
                              builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  if (snapshot.data != null) {
                                    return Txt('${AppController.of(context)!.value('error')}');
                                  } else {
                                    return Container();
                                  }
                                } else {
                                  if (snapshot.hasData) {
                                    var data = snapshot.data!;
                                    if (data['items'] == null || data['items'].isEmpty) {
                                      return Container();
                                    } else {
                                      return Container(
                                        width:getDataTable['columns'][j]['name'] == 'نام کالا'  ? 150:80,
                                        // height: 100,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Txt(
                                                '${getDataTable['columns'][j]['title']}',
                                                color: MainController.isLightMode.value == true ? whiteColor : color2,
                                              );
                                            }),
                                            SizedBox(height: 10),
                                            SelectBox(
                                              name: '${getDataTable['columns'][j]['title']}',
                                              column: getDataTable['columns'][j],
                                              items: data['items'].map<DropdownMenuItem<String>>((item) {
                                                return DropdownMenuItem<String>(
                                                  value: item['value'].toString(),
                                                  child: Obx(() {
                                                    return Txt(
                                                      '${item['title']}',
                                                      color: MainController.isLightMode.value == true ? whiteColor : primaryDark,
                                                    );
                                                  }),
                                                );
                                              }).toList(),
                                              initalValue: data['initValue'],
                                              onChanged: (value) async {
                                                print('selected item ${value}');
                                                for (var item in data['items']) {
                                                  if (item['title'] == value) {
                                                    if (item['value'] == '-1') {
                                                      value = null;
                                                    }
                                                  }
                                                }
                                                if (value != '-1') {
                                                  ViewController.request[getDataTable['columns'][j]['name']] = value;
                                                } else {
                                                  ViewController.request[getDataTable['columns'][j]['name']] = '';
                                                }
                                              },
                                              hintText: data['hint'],
                                              isSeleted: ViewController.request[getDataTable['columns'][j]['name']] == '' || ViewController.request[getDataTable['columns'][j]['name']] == null ? false.obs : true.obs,
                                              selectedValue: '',
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  } else {
                                    return Container();
                                  }
                                }
                              },
                            ),
                            SizedBox(width: 20,)
                          ],
                        )
                      else if (getDataTable['columns'][j]['type'] == 'multiSelect')
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(() {
                                    return Txt(
                                      '${getDataTable['columns'][j]['title']}',
                                      color: MainController.isLightMode.value == true ? whiteColor : color2,
                                    );
                                  }),
                                  SizedBox(height: 10),
                                  FutureBuilder(
                                    future: _future[getDataTable['columns'][j]['title']],
                                    builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        if (snapshot.data != null) {
                                          return Txt('${AppController.of(context)!.value('error')}');
                                        } else {
                                          return Container();
                                        }
                                      } else {
                                        var data = snapshot.data!;
                                        return data['items'].length != 0
                                            ? Obx(() {
                                          return Container(
                                            width: 150,
                                            child: MultiSelectDropdown(
                                              items: [
                                                for (var item in data['items'])
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
                                                              child: Checkbox(
                                                                activeColor: colorBtn,
                                                                value: data['selectedItemsList'].contains(item['value']),
                                                                onChanged: (isChecked) {
                                                                  if (isChecked != null) {
                                                                    if (!data['selectedItemsList'].contains(item['value'])) {
                                                                      data['selectedItemsList'].add(item['value']);
                                                                    } else {
                                                                      data['selectedItemsList'].remove(item['value']);
                                                                    }
                                                                    if (item['value'] == '-1') {
                                                                      data['selectedItemsList'].remove(item['value']);
                                                                    }
                                                                    if (data['selectedItemsList'].isEmpty) {
                                                                      data['isSelectedItem'].value = false;
                                                                    } else {
                                                                      data['isSelectedItem'].value = true;
                                                                    }
                                                                    data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
                                                                    ViewController.request[getDataTable['columns'][j]['name']] = data['selectedItemsList'];
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
                                                        ],
                                                      );
                                                    }),
                                                  ),
                                              ],
                                              hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
                                              selectedItems: data['selectedItemsList'],
                                              isSelectedItem: data['isSelectedItem'],
                                              onChanged: (selectedList) {
                                                data['selectedItemsList'].value = selectedList;
                                                ViewController.request[getDataTable['columns'][j]['name']] = selectedList;
                                                data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
                                              },
                                              column: getDataTable['columns'][j],
                                            ),
                                          );
                                        })
                                            : Container();
                                      }
                                    },
                                  )
                                ],
                              ),
                              SizedBox(width: 20,)
                            ],
                          )
                        else if (getDataTable['columns'][j]['type'] == 'radiobutton')
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Txt(
                                        '${getDataTable['columns'][j]['title']}',
                                        color: MainController.isLightMode.value == true ? whiteColor : color2,
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    FutureBuilder(
                                      future: _future[getDataTable['columns'][j]['title']],
                                      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator();
                                        } else if (snapshot.hasError) {
                                          if (snapshot.data != null) {
                                            return Txt('${AppController.of(context)!.value('error')}');
                                          } else {
                                            return Container();
                                          }
                                        } else {
                                          var data = snapshot.data!;
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Obx(() {
                                                return Txt(
                                                  '${getDataTable['columns'][j]['title']}',
                                                  color: MainController.isLightMode.value == true ? whiteColor : color2,
                                                );
                                              }),
                                              SizedBox(height: 10),
                                              Container(
                                                width:150,
                                                child: RadioButton(
                                                  name: '',
                                                  radioButtonItems: [
                                                    for (var radioButtonItem in data['items'])
                                                      FormBuilderChipOption(
                                                        value: '${radioButtonItem['value']}',
                                                        child: Obx(() {
                                                          return Txt(
                                                            '${radioButtonItem['title']}',
                                                            color: MainController.isLightMode.value ? whiteColor : primaryDark,
                                                          );
                                                        }),
                                                      ),
                                                  ],
                                                  onChanged: (text) {
                                                    ViewController.request[getDataTable['columns'][j]['name']] = text;
                                                  },
                                                  initalValue: data['initValue'],
                                                  column: getDataTable['columns'][j],
                                                  isSelectedItem: ViewController.request[getDataTable['columns'][j]['name']] == '' ? false.obs : true.obs,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(width: 20,)
                              ],
                            )
                          else if (getDataTable['columns'][j]['type'] == 'file')
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Obx(() {
                                        return Txt(
                                          '${getDataTable['columns'][j]['title']}',
                                          color: MainController.isLightMode.value == true ? whiteColor : color2,
                                        );
                                      }),
                                      SizedBox(height: 10),
                                      Container(
                                        width: 500,
                                        child: FormFile(
                                          columnName: getDataTable['columns'][j]['title'],
                                          onChanged: (selecetdFiles) {
                                            ViewController.request[getDataTable['columns'][j]['name']] = selecetdFiles;
                                          },
                                          filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                                          selectedFilesTxt: ViewController.request[getDataTable['columns'][j]['name']],
                                          column: getDataTable['columns'][j],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20,)
                                ],
                              )
          ],
        ),
      ),
    );
  }
// @override
// Widget build(BuildContext context){
//   var size = MediaQuery.of(context).size;
//
//   return  Container(
//     width: size.width,
//     child: Wrap(
//       runSpacing: 5,
//       spacing: 20,
//       children: [
//         for (var j = 0; j < subMenu['columns'].length; j++)
//           if (subMenu['columns'][j]['type'] == 'string' ||
//               subMenu['columns'][j]['type'] == 'number' ||
//               subMenu['columns'][j]['type'] == 'mobile'||
//               subMenu['columns'][j]['type'] == 'email'
//
//           )
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Obx(() {
//                   return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                 }),
//                 SizedBox(height: 10,),
//                 Container(
//                   width: 300,
//                   height: 100,
//                   child: FormTextField(
//                     name: '${subMenu['columns'][j]['name']}',
//                     hint: '${subMenu['columns'][j]['name']}',
//                     lable: '',
//                     initValue: '${ViewController.request['${subMenu['columns'][j]['name']}'] != null ?
//                     ViewController.request['${subMenu['columns'][j]['name']}']:
//                     ''}',
//                     isNumber:subMenu['columns'][j]['type'] == 'number' ? true : false ,
//                     isEmail:subMenu['columns'][j]['type'] == 'email' ? true:false,
//                     isMobile: subMenu['columns'][j]['type'] == 'mobile' ? true : false,
//                     onChange: (text) {
//                       ViewController.request['${subMenu['columns'][j]['name']}'] = text;
//                     },
//                     column: subMenu['columns'][j],
//                   ),
//                 )
//               ],
//             )
//           else if(subMenu['columns'][j]['type'] == 'checkbox')
//             CheckBox(
//               checkBoxName: '${subMenu['columns'][j]['name']}',
//               checkBoxTitle: '${subMenu['columns'][j]['name']}',
//               defaultValue: ViewController.request['${subMenu['columns'][j]['name']}'],
//               onChange: (text) {
//                 ViewController.request['${subMenu['columns'][j]['name']}'] = text;
//               },
//               column: subMenu['columns'][j],
//
//             )
//           else if(subMenu['columns'][j]['type'] == 'color')
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Obx(() {
//                     return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                   }),
//                   SizedBox(height: 10,),
//                   Container(
//                     child: ColorPickerBox(
//                       selectedColor: ViewController.request['${subMenu['columns'][j]['name']}'] != null
//                           ? Color(int.parse('${ViewController.request['${subMenu['columns'][j]['name']}']}'))
//                           : Colors.blue,
//                       onChanged: (color) {
//                         colorChanged = color;
//                         String hexColor =
//                             '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
//                         // dataJson[columnName] = hexColor;
//                         ViewController.request['${subMenu['columns'][j]['name']}'] = hexColor;
//                       },
//                       column: subMenu['columns'][j],
//                     ),
//                   ),
//                 ],
//               )
//             else if(subMenu['columns'][j]['type'] == 'date')
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Obx(() {
//                       return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                     }),
//                     SizedBox(height: 10,),
//                     Container(
//                       width: 120,
//                       child:ViewController.request['${subMenu['columns'][j]['name']}'] != null ?  DateBox(
//                         selectedDate: ViewCustomController.parseDate(ViewController.request['${subMenu['columns'][j]['name']}']),
//                         onDateChanged: (date) {
//                           ViewController.request['${subMenu['columns'][j]['name']}'] = date;
//                         },
//                         column: subMenu['columns'][j],
//                       ):DateBox(
//                         selectedDate: Jalali.now(),
//                         onDateChanged: (date) {
//                           ViewController.request['${subMenu['columns'][j]['name']}'] = date;
//                         },
//                         column: subMenu['columns'][j],
//                       ),
//                     )
//                   ],
//                 )
//               else if(subMenu['columns'][j]['type'] == 'select')
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Obx(() {
//                         return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                       }),
//                       SizedBox(height: 10,),
//                       FutureBuilder(
//                           future: _future[subMenu['columns'][j]['name']],
//                           builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return CircularProgressIndicator();
//                             } else if (snapshot.hasError) {
//                               if(snapshot.data != null){
//                                 return Txt('${AppController.of(context)!.value('error')}');
//                               }
//                               else{
//                                 return Container();
//                               }
//                             }
//                             else{
//                               if (snapshot.hasData){
//                                 var data = snapshot.data!;
//                                 return Container(
//                                   width: 300,
//                                   height: 100,
//                                   child: SelectBox(
//                                     name: '${subMenu['columns'][j]['name']}',
//                                     column: subMenu['columns'][j],
//                                     items: data['items'].map<DropdownMenuItem<String>>((item) {
//
//                                       return DropdownMenuItem<String>(
//                                         value: item['value'].toString(),
//                                         child: Obx(() {
//                                           return Txt(
//                                             '${item['title']}',
//                                             color: MainController.isLightMode.value == true
//                                                 ? whiteColor
//                                                 : primaryDark,
//                                           );
//                                         }),
//                                       );
//                                     }).toList(),
//                                     initalValue: data['initValue'],
//                                     onChanged: (value) async {
//                                       print('selected item ${value}');
//                                       for (var item in data['items']) {
//                                         if (item['title'] == value) {
//                                           if (item['value'] == '-1') {
//                                             value = null;
//                                           }
//                                         }
//                                       }
//                                       if (value != '-1') {
//                                         ViewController.request[subMenu['columns'][j]['name']] = value;
//                                       } else {
//                                         ViewController.request[subMenu['columns'][j]['name']] = '';
//                                       }
//                                     },
//                                     hintText: data['hint'],
//                                     isSeleted: ViewController.request[subMenu['columns'][j]['name']] == '' || ViewController.request[subMenu['columns'][j]['name']] == null ? false.obs : true.obs,
//                                     selectedValue: '',
//                                   ),
//                                 );
//                               }
//                               else{
//                                 return Container();
//                               }
//                             }
//                           }
//                       )
//                     ],
//                   )
//                 else if(subMenu['columns'][j]['type'] == 'multiSelect')
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Obx(() {
//                           return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                         }),
//                         SizedBox(height: 10,),
//                         FutureBuilder(
//                           future: _future[subMenu['columns'][j]['name']],
//                           builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
//                             if (snapshot.connectionState == ConnectionState.waiting) {
//                               return CircularProgressIndicator();
//                             } else if (snapshot.hasError) {
//                               if(snapshot.data != null){
//                                 return Txt('${AppController.of(context)!.value('error')}');
//                               }
//                               else{
//                                 return Container();
//                               }
//
//                             } else {
//                               var data = snapshot.data!;
//                               return data['items'].length != 0 ? Obx(() {
//                                 return Container(
//                                   width: 300,
//                                   child: MultiSelectDropdown(
//                                     items: [
//                                       for (var item in data['items'])
//                                         DropdownMenuItem(
//                                           value: item['value'],
//                                           child: Obx(() {
//                                             return Row(
//                                               children: [
//                                                 Container(
//                                                   height: 100,
//                                                   child: SizedBox(
//                                                     width: 50,
//                                                     height: 50,
//                                                     child: Checkbox(
//                                                       activeColor: colorBtn,
//                                                       value: data['selectedItemsList'].contains(item['value']),
//                                                       onChanged: (isChecked) {
//                                                         if (isChecked != null) {
//                                                           if (!data['selectedItemsList'].contains(item['value'])) {
//                                                             data['selectedItemsList'].add(item['value']); // اضافه کردن آیتم به لیست
//                                                           } else {
//                                                             data['selectedItemsList'].remove(item['value']); // حذف آیتم از لیست
//                                                           }
//                                                           if (item['value'] == '-1') {
//                                                             data['selectedItemsList'].remove(item['value']); // حذف آیتم نامعتبر
//                                                           }
//                                                           if (data['selectedItemsList'].isEmpty) {
//                                                             data['isSelectedItem'].value = false;
//                                                           } else {
//                                                             data['isSelectedItem'].value = true;
//                                                           }
//                                                           data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], data['selectedItemsList']);
//                                                           ViewController.request[subMenu['columns'][j]['name']] = data['selectedItemsList'];
//                                                         }
//                                                       },
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 Txt(item['title'], color: MainController.isLightMode.value ? whiteColor : primaryDark),
//                                               ],
//                                             );
//                                           }),
//                                         ),
//                                     ],
//                                     hintText: data['hintTxt'].value.isNotEmpty ? data['hintTxt'].value : data['items'][0]['title'],
//                                     selectedItems: data['selectedItemsList'],
//                                     isSelectedItem: data['isSelectedItem'],
//                                     onChanged: (selectedList) {
//                                       data['selectedItemsList'].value = selectedList;
//                                       ViewController.request[subMenu['columns'][j]['name']] = selectedList;
//                                       data['hintTxt'].value = ViewController.hintMultiSelectBox(data['items'], selectedList);
//                                     },
//                                     column: subMenu['columns'][j],
//                                   ),
//                                 );
//                               }) : Container();
//                             }
//                           },
//                         )
//                       ],
//                     )
//                   else if(subMenu['columns'][j]['type'] == 'radiobutton')
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Obx(() {
//                             return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                           }),
//                           SizedBox(height: 10,),
//                           FutureBuilder(
//                               future: _future[subMenu['columns'][j]['name']],
//                               builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot){
//                                 if (snapshot.connectionState == ConnectionState.waiting) {
//                                   return CircularProgressIndicator();
//                                 } else if (snapshot.hasError) {
//                                   if(snapshot.data != null){
//                                     return Txt('${AppController.of(context)!.value('error')}');
//                                   }
//                                   else{
//                                     return Container();
//                                   }
//                                 }
//                                 else{
//                                   var data = snapshot.data!;
//                                   return Column(
//                                     children: [
//                                       RadioButton(
//                                         name: '',
//                                         radioButtonItems: [
//                                           for (var radioButtonItem in data['items'])
//                                             FormBuilderChipOption(
//                                                 value: '${radioButtonItem['value']}',
//                                                 child: Obx(() {
//                                                   return Txt(
//                                                     '${radioButtonItem['title']}',
//                                                     color: MainController.isLightMode.value
//                                                         ? whiteColor
//                                                         : primaryDark,
//                                                   );
//                                                 })),
//                                         ],
//                                         onChanged: (text) {
//                                           ViewController.request[subMenu['columns'][j]['name']] = text;
//                                           // dataJson[columnName] = selectedRadioButton.value;
//                                         },
//                                         initalValue: data['initValue'],
//                                         column: subMenu['columns'][j],
//                                         isSelectedItem: ViewController.request[subMenu['columns'][j]['name']] == '' ? false.obs : true.obs,
//                                       ),
//                                       SizedBox(height: 20),
//                                     ],
//                                   );
//                                 }
//                               }
//                           )
//                         ],
//                       )
//                     else if(subMenu['columns'][j]['type'] == 'file')
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Obx(() {
//                               return Txt('${subMenu['columns'][j]['name']}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
//                             }),
//                             SizedBox(height: 10,),
//                             Container(
//                               width: 500,
//                               child: FormFile(
//                                 columnName: subMenu['columns'][j]['name'],
//                                 onChanged: (selecetdFiles) {
//                                   ViewController.request[subMenu['columns'][j]['name']] = selecetdFiles;
//                                 },
//                                 filesSelected: ViewCustomController.getselectedFilesMap(subMenu['columns'][j]),
//                                 selectedFilesTxt: ViewController.request[subMenu['columns'][j]['name']],
//                                 column: subMenu['columns'][j],
//                               ),
//                             ),
//                           ],
//                         )
//       ],
//     ),
//   );
// }
}