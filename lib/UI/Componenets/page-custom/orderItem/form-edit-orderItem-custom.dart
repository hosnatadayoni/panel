import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/Logic/Models/order-item.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../../Logic/Controllers/app-controller.dart';

class FormEditOrderItemCustom extends StatefulWidget {

  FormEditOrderItemCustom();


  @override
  State<FormEditOrderItemCustom> createState() => _FormEditOrderItemCustomState();
}

class _FormEditOrderItemCustomState extends State<FormEditOrderItemCustom> {
  Color? colorChanged;
  Map<String, Future<Map<String, dynamic>>>  _future={};
  Map<String, Future<Map<String, dynamic>>>  _future2={};

  var getDataTable = ViewCustomController.getDataTable('order-items');


  void initState() {
    super.initState();
    for (var j = 0; j < getDataTable['columns'].length; j++) {
      _loadData(getDataTable['columns'][j]);
    }
    for (var j = 0; j < getDataTable['columns'].length; j++) {
      _loadDataRequest();
    }
  }
  void _loadData(var column) {
      String columnName = column['name'];
        for(var item in OrderItem.orderItemsList.values.toList()){
          String uniqueKey = '${columnName}_${item['id']}';
          if (column['type'] == 'select' ||
              column['type'] == 'radiobutton') {
          _future[uniqueKey] = ViewCustomController.getSelectBoxOrderItemData(column,item);
        }else if(column['type'] == 'multiSelect'){
            _future['${columnName}'] = ViewCustomController.getMultiSelectBoxOrderItemData(column , item);
          }
        }
  }
  void _loadDataRequest() {
    if(getDataTable['columns'].length!=0)
      for (var j = 0; j < getDataTable['columns'].length; j++) {
        String columnName = getDataTable['columns'][j]['title'];
        if (getDataTable['columns'][j]['type'] == 'select' ||
            getDataTable['columns'][j]['type'] == 'radiobutton') {
          _future2['${columnName}'] = ViewCustomController.getSelectBoxOrderItemData(getDataTable['columns'][j] , null);
        }
        else if(getDataTable['columns'][j]['type'] == 'multiSelect'){
          _future2['${columnName}'] = ViewCustomController.getMultiSelectBoxOrderItemData(getDataTable['columns'][j] , null);

        }
      }
  }

  Map<String, Widget> containers = {};

  void _addContainer() {
    setState(() {
      var Id = Uuid().v4();
      String newKey = Id;
      containers[newKey] = buildContainer(newKey);
      OrderItem.orderItemsList2[newKey] = {};
    });
  }

  void _removeContainer(String key) {
    setState(() {
      print('index delete>>>>>>${key}');
      if(OrderItem.orderItemsList.containsKey(key)){
        OrderItem.orderItemsList.remove(key);
      }
      containers.remove(key);
      OrderItem.orderItemsList2.remove(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('getDataTable>>>${getDataTable['columns'].length}');
    for(int i=0;i<getDataTable['columns'].length;i++){
      print('getDataTable 2>>>${getDataTable['columns'][i]['type'] == 'select'}');
    }
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
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
              Column(
                children: [
                  for(int i=0;i<OrderItem.orderItemsList.values.toList().length;i++)
                    Container(
                      width: size.width,
                      key: ValueKey(OrderItem.orderItemsList.values.toList()[i]['id']),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                        Row(
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
                                              initValue: '${OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null ? OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] : ''}',
                                              isNumber: getDataTable['columns'][j]['type'] == 'number' ? true : false,
                                              isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                                              isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                                              onChange: (text) {
                                                // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                                                // print('getDataTable>>>${ViewController.request2['${getDataTable['columns'][j]['name']}']}');
                                                // OrderItem.orderItemsList[item['id']] ??= {};
                                                OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = text;
                                                print('OrderItem.orderItemsList[item>>>${ OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']}');
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
                                        defaultValue: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'],
                                        onChange: (text) {
                                          // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                                          // OrderItem.orderItemsList[item['id']] ??= {};
                                          OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = text;
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
                                                selectedColor: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null
                                                    ? Color(int.parse('${OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']}'))
                                                    : Colors.blue,
                                                onChanged: (color) {
                                                  colorChanged = color;
                                                  String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                                                  // ViewController.request2['${getDataTable['columns'][j]['name']}'] = hexColor;
                                                  // OrderItem.orderItemsList[item['id']] ??= {};
                                                  OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = hexColor;
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
                                                DateBox(
                                                  selectedDate: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] != null ? ViewCustomController.parseDate(OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}']):Jalali.now(),
                                                  onDateChanged: (date) {
                                                    // ViewController.request2['${getDataTable['columns'][j]['name']}'] = date;
                                                    // OrderItem.orderItemsList[item['id']] ??= {};
                                                    OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = date;
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
                                              future: _future['${getDataTable['columns'][j]['title']}_${OrderItem.orderItemsList.values.toList()[i]['id']}'],
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
                                                                // OrderItem.orderItemsList[item['id']] ??= {};
                                                                for (var item in data['items']) {
                                                                  if (item['title'] == value) {
                                                                    if (item['value'] == '-1') {
                                                                      value = null;
                                                                    }
                                                                  }
                                                                }
                                                                if (value != '-1') {
                                                                  OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = value;
                                                                } else {
                                                                  OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = '';
                                                                }
                                                              },
                                                              hintText: data['hint'],
                                                              isSeleted: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ||OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] == null ? false.obs : true.obs,
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
                                                                                    OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] = data['selectedItemsList'];
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
                                                                // OrderItem.orderItemsList[item['id']] ??= {};
                                                                OrderItem.orderItemsList.values.toList()[i]![getDataTable['columns'][j]['name']] = selectedList;
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
                                                                    OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = text;
                                                                  },
                                                                  initalValue: data['initValue'],
                                                                  column: getDataTable['columns'][j],
                                                                  isSelectedItem: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'] == '' ? false.obs : true.obs,
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
                                                            OrderItem.orderItemsList.values.toList()[i]!['${getDataTable['columns'][j]['name']}'] = selecetdFiles;
                                                          },
                                                          filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                                                          selectedFilesTxt: OrderItem.orderItemsList.values.toList()[i]['${getDataTable['columns'][j]['name']}'],
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
                                    print('item delete>>>${OrderItem.orderItemsList.values.toList()[i]}');
                                    _removeContainer(OrderItem.orderItemsList.values.toList()[i]['id']);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                                    child: Txt('${AppController.of(context)!.value('remove')}'),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              // Container(
              //   child: ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: containers.length,
              //     itemBuilder: (context, index) {
              //       return containers[index];
              //     },
              //   ),
              // ),
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
        ),
      ],
    );
  }
  Widget buildContainer(String key) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      key: ValueKey(key),
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
                              initValue:OrderItem.orderItemsList2[key]?['${getDataTable['columns'][j]['name']}'] ?? '',
                              isNumber: getDataTable['columns'][j]['type'] == 'number' ? true : false,
                              isEmail: getDataTable['columns'][j]['type'] == 'email' ? true : false,
                              isMobile: getDataTable['columns'][j]['type'] == 'mobile' ? true : false,
                              onChange: (text) {
                                // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                                OrderItem.orderItemsList2[key] ??= {};
                                OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = text;
                                print('OrderItem.orderItemsList[key]>>${ OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}']}>>${ OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}']}');
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
                        defaultValue: OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'],
                        onChange: (text) {
                          // ViewController.request2['${getDataTable['columns'][j]['name']}'] = text;
                          OrderItem.orderItemsList2[key] ??= {};
                          OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = text;
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
                                selectedColor: OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] != null
                                    ? Color(int.parse('${OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}']}'))
                                    : Colors.blue,
                                onChanged: (color) {
                                  colorChanged = color;
                                  String hexColor = '0x${colorChanged!.value.toRadixString(16).padLeft(8, '0')}';
                                  // ViewController.request2['${getDataTable['columns'][j]['name']}'] = hexColor;
                                  OrderItem.orderItemsList2[key] ??= {};
                                  OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = hexColor;
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
                                OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] != null
                                    ? DateBox(
                                  selectedDate: ViewCustomController.parseDate( OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}']),
                                  onDateChanged: (date) {
                                    OrderItem.orderItemsList2[key] ??= {};
                                    OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = date;
                                  },
                                  column: getDataTable['columns'][j],
                                )
                                    : DateBox(
                                  selectedDate: Jalali.now(),
                                  onDateChanged: (date) {
                                    OrderItem.orderItemsList2[key] ??= {};
                                    OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = date;
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
                              future: _future2[getDataTable['columns'][j]['title']],
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
                                      return
                                    Container(
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
                                                OrderItem.orderItemsList2[key] ??= {};
                                                for (var item in data['items']) {
                                                  if (item['title'] == value) {
                                                    if (item['value'] == '-1') {
                                                      value = null;
                                                    }
                                                  }
                                                }
                                                if (value != '-1') {
                                                  // ViewController.request2[getDataTable['columns'][j]['name']] = value;
                                                  OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = value;
                                                } else {
                                                  // ViewController.request2[getDataTable['columns'][j]['name']] = '';
                                                  OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = '';
                                                }
                                              },
                                              hintText: data['hint'],
                                              isSeleted: OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] == '' || OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] == null ? false.obs : true.obs,
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
                                                                  OrderItem.orderItemsList2[key] ??= {};
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
                                                                    // ViewController.request2[getDataTable['columns'][j]['name']] = data['selectedItemsList'];
                                                                    OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = data['selectedItemsList'];
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
                                                OrderItem.orderItemsList2[key]![getDataTable['columns'][j]['name']] = selectedList;
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
                                      future: _future2[getDataTable['columns'][j]['title']],
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
                                                    OrderItem.orderItemsList2[key] ??= {};
                                                    OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = text;
                                                  },
                                                  initalValue: data['initValue'],
                                                  column: getDataTable['columns'][j],
                                                  isSelectedItem: OrderItem.orderItemsList2[key]![getDataTable['columns'][j]['name']] == '' ? false.obs : true.obs,
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
                                            OrderItem.orderItemsList2[key] ??= {};
                                            OrderItem.orderItemsList2[key]!['${getDataTable['columns'][j]['name']}'] = selecetdFiles;
                                          },
                                          filesSelected: ViewCustomController.getselectedFilesMap(getDataTable['columns'][j]),
                                          selectedFilesTxt: OrderItem.orderItemsList2[key]![getDataTable['columns'][j]['name']],
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
                    child: Txt('${AppController.of(context)!.value('remove')}'),
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