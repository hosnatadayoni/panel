import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Logic/Models/order-item.dart';
import 'package:finance/Public/styles.dart';
import 'package:finance/UI/Componenets/General/column-scroll.dart';
import 'package:finance/UI/Componenets/General/txt.dart';
import 'package:finance/UI/Componenets/Items/Form/form-checkBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-color.dart';
import 'package:finance/UI/Componenets/Items/Form/form-date.dart';
import 'package:finance/UI/Componenets/Items/Form/form-file.dart';
import 'package:finance/UI/Componenets/Items/Form/form-multiSelect.dart';
import 'package:finance/UI/Componenets/Items/Form/form-radio-button.dart';
import 'package:finance/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../Logic/Controllers/app-controller.dart';

class FormCreateOrderItemCustom extends StatefulWidget {

  FormCreateOrderItemCustom();

  @override
  State<FormCreateOrderItemCustom> createState() => _FormCreateOrderItemCustomState();
}

class _FormCreateOrderItemCustomState extends State<FormCreateOrderItemCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};
  var getDataTable = ViewCustomController.getDataTable('order-items');

  void initState() {
    super.initState();
    _loadData();
  }
  void _loadData() {
    if(getDataTable['columns'].length!=0)
    for (var j = 0; j < getDataTable['columns'].length; j++) {
      String columnName = getDataTable['columns'][j]['title'];
      if (getDataTable['columns'][j]['type'] == 'select' ||
          getDataTable['columns'][j]['type'] == 'radiobutton') {
        _future['${columnName}'] = ViewCustomController.getSelectBoxOrderItemData(getDataTable['columns'][j] , null);
      }
      else if(getDataTable['columns'][j]['type'] == 'multiSelect'){
        _future['${columnName}'] = ViewCustomController.getMultiSelectBoxOrderItemData(getDataTable['columns'][j] , null);

      }
    }
  }
  // List<Widget> containers = [];
  Map<String, Widget> containers = {};

  void _addContainer() {
    // setState(() {
    //   var Id =Uuid().v4();
    //   String newKey = Id;
    //   containers[newKey] = buildContainer(newKey);
    //   print('containers map>>>${containers}');
    //
    //   if(ViewController.request2.isNotEmpty){
    //     print('ViewController.request2 is not empty');
    //     OrderItem.orderItemsList[newKey]= ViewController.request2;
    //   }
    //    ViewController.request2= {};
    // });
    setState(() {
      var Id = Uuid().v4();
      String newKey = Id;
      containers[newKey] = buildContainer(newKey);
      OrderItem.orderItemsList[newKey] = {};
    });
  }
  void _removeContainer(String key) {
    setState(() {
      containers.remove(key);
      OrderItem.orderItemsList.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
            children: [
              if(MainController.selectedSubItem.value != -1)
                if(MainController.SubMenuList[MainController.selectedSubItem.value]['table-name'] != 'order')
                  SizedBox(height: 20,),
                Obx((){
                  return Container(
                    padding: EdgeInsets.all(20),
                    decoration:  BoxDecoration(
                        border: Border.all(width: 2,color: MainController.isLightMode.value == true ? whiteColor:primaryDark),
                        borderRadius:  BorderRadius.circular(10)
                    ),
                    child: ColumnScroll(
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
                          child: Column(
                            children: [
                              for (var key in containers.keys)
                                containers[key]!,
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                })
            ],
          );
  }
  Widget buildContainer(String key) {
    var size = MediaQuery.of(context).size;
    return Container(
      key: ValueKey(key),
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
                                '${getDataTable['columns'][j]['title']} ',
                                color: MainController.isLightMode.value == true ? whiteColor : color2,
                              );
                            }),
                            SizedBox(height: 10),
                            FormTextField(
                              name: '${getDataTable['columns'][j]['title']}',
                              hint: '${getDataTable['columns'][j]['title']}',
                              lable: '',
                              initValue: OrderItem.orderItemsList[key]?['${getDataTable['columns'][j]['name']}'] ?? '',
                              // initValue: '${ViewController.request2['${getDataTable['columns'][j]['name']}'] != null ? ViewController.request2['${getDataTable['columns'][j]['name']}'] : ''}',
                              isNumber: getDataTable['columns'][j]['type'] == 'number' ? true : false,
                              isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                              isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                              onChange: (text) {
                                // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                                // print('getDataTabl>>>>>>>>>>>${getDataTable['columns'][j]['name']}>>>${ViewController.request2['${getDataTable['columns'][j]['name']}']}');
                                OrderItem.orderItemsList[key] ??= {};
                                OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = text;
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
                        defaultValue: OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'],
                        onChange: (text) {
                          OrderItem.orderItemsList[key] ??= {};
                          OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = text;
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
                                selectedColor: OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] != null
                                    ? Color(int.parse('${OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}']}'))
                                    : Colors.blue,
                                onChanged: (color) {
                                  colorChanged = color;
                                  String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                                  OrderItem.orderItemsList[key] ??= {};
                                  OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = hexColor;
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
                                OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] != null
                                    ? DateBox(
                                  selectedDate: ViewCustomController.parseDate(OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}']),
                                  onDateChanged: (date) {
                                    OrderItem.orderItemsList[key] ??= {};
                                    OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = date;
                                  },
                                  column: getDataTable['columns'][j],
                                )
                                    : DateBox(
                                  selectedDate: Jalali.now(),
                                  onDateChanged: (date) {
                                    OrderItem.orderItemsList[key] ??= {};
                                    OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = date;
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
                                                '${getDataTable['columns'][j]['title']} ',
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
                                                OrderItem.orderItemsList[key] ??= {};
                                                for (var item in data['items']) {
                                                  if (item['title'] == value) {
                                                    if (item['value'] == '-1') {
                                                      value = null;
                                                    }
                                                  }
                                                }
                                                if (value != '-1') {
                                                  // ViewController.request2[getDataTable['columns'][j]['name']] = value;
                                                  OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = value;
                                                } else {
                                                  // ViewController.request2[getDataTable['columns'][j]['name']] = '';
                                                  OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = '';
                                                }
                                              },
                                              hintText: data['hint'],
                                              isSeleted: OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] == '' || OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] == null ? false.obs : true.obs,
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
                                                                  OrderItem.orderItemsList[key] ??= {};
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
                                                                    OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = data['selectedItemsList'];
                                                                    // ViewController.request2[getDataTable['columns'][j]['name']] = data['selectedItemsList'];
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
                                                OrderItem.orderItemsList[key] ??= {};
                                                OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = selectedList;
                                                // ViewController.request2[getDataTable['columns'][j]['name']] = selectedList;
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
                                                    // ViewController.request2[getDataTable['columns'][j]['name']] = text;
                                                    OrderItem.orderItemsList[key] ??= {};
                                                    OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = text;
                                                  },
                                                  initalValue: data['initValue'],
                                                  column: getDataTable['columns'][j],
                                                  isSelectedItem: OrderItem.orderItemsList[key]![getDataTable['columns'][j]['name']] == '' ? false.obs : true.obs,
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
                                            // ViewController.request2[getDataTable['columns'][j]['name']] = selecetdFiles;
                                            OrderItem.orderItemsList[key] ??= {};
                                            OrderItem.orderItemsList[key]!['${getDataTable['columns'][j]['name']}'] = selecetdFiles;
                                          },
                                          filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                                          selectedFilesTxt: OrderItem.orderItemsList[key]![getDataTable['columns'][j]['name']],
                                          column: getDataTable['columns'][j],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20,)
                                ],
                              ),
            Column(
              children: [
                Obx((){
                  return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                }),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    print('key delete>>>${key}');
                    _removeContainer(key);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                    child: Txt('${AppController.of(context)!.value('remove')} '),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}