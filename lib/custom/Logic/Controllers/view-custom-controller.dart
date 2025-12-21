import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/dataModel.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:finance/Admin/Public/config.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/UI/Components/Items/Forms/form-text-field-custom.dart';
import 'package:finance/custom/UI/Components/Items/Forms/form-text-field-order-item-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Admin/Public/styles.dart';
import '../../../Admin/UI/Componenets/General/txt.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-file.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-time.dart';
import '../../../Admin/Logic/Models/db.dart';
import '../../UI/Components/Items/Forms/thousand-separatorInput-formatter.dart';
import '../Models/order-item.dart';

class ViewCustomController extends GetxController{
  static Map<String, dynamic> order = {};
  static Map<String, dynamic> orderItem = {};
  static RxMap<String, Widget> containers = <String, Widget>{}.obs;
  static RxMap<String, Widget> editContainers = <String, Widget>{}.obs;


  static Jalali parseDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    return Jalali(year, month, day);
  }
  static String getDate(Jalali j){
    int year = j.year;
    int month= j.month;
    int day = j.day;
    String date = '${year}/${month}/${day}';
    return date;
  }
  static TimeOfDay parseTime(String dateString){
    List<String>? TimeParts;
    int hour = TimeOfDay.now().hour;
    int minute = TimeOfDay.now().minute;
    TimeParts = dateString.split(':');
    hour = int.parse('${TimeParts![0]}');
    minute = int.parse('${TimeParts[1]}');

    return TimeOfDay(hour: hour, minute: minute);
  }
  static Map<String,dynamic> getDataTable(String tableName){
    Map<String,dynamic> dataTableName={};
    for(var subMenu in MainController.SubMenuList){
      if(subMenu['schema']['name'] == tableName){
        dataTableName = subMenu;
      }
    }
    return dataTableName;
  }
  static getCalculateTotalArea(double firsDimension , double secondDimension){
    double total = firsDimension * secondDimension;
    return double.parse(total.toStringAsFixed(2));
  }
  static getCalculateTotalPrice(int price , double firsDimension , double secondDimension , int quantity){
    final formatter = NumberFormat('#,##0', 'en_US');
    double totalPrice = getCalculateTotalArea(firsDimension, secondDimension) * price * quantity;
    double rounded = double.parse(totalPrice.toStringAsFixed(2));
    return formatter.format(rounded);
  }
  static Widget generateFileBox(String selecetdFiles, var column,
      Rx<bool>? isSeletedFile) {
    Map<String, List<dynamic>> selectedFilesMap = {};
    print('selecetdFiles>>>${selecetdFiles}');
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    List<dynamic> filesSelectedList=[];
    if (ViewCustomController.order[column['name']] != null) {
      // filesSelectedList = ViewCustomController.order[column['name']];
      filesSelectedList.add(ViewCustomController.order[column['name']]);
      for (var data in filesSelectedList) {
        selectedFilesMap['${column['name']}']!.add(data);
      }
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          );
        }),
        SizedBox(
          height: 10,
        ),
        Container(
          child: FormFile(
            fileInfo: <String, List<dynamic>>{}.obs,
            columnName: column['title'],
            onChanged: (selecetdFiles) {
              ViewCustomController.order[column['name']] = selecetdFiles;
            },
            filesSelected: selectedFilesMap,
            selectedFilesTxt: selecetdFiles,
            isSeletedFile: isSeletedFile,
            column: column,
          ),
        ),
      ],
    );
  }
  static Future<Widget> getOrderItems(var data) async {
    List<dynamic>items=await DB('Order_Details').parent(parentId:  "${data['_id']}",parentTable: 'Orders').getRecords();
    print('items as>>>${items}');
    List<dynamic> productItems= await DB('Product').getRecords();
    for(var item in items){
      OrderItem.orderItemsList[item['_id']]=item;

    }
    print('OrderItem.orderItemsList edit>>>${OrderItem.orderItemsList}');
    return Column(
      children: [
        FormEditOrderItemCustom(productItems),
      ],
    );
  }

  //order item
  static  addContainer(BuildContext context , List<dynamic> productItems) {
      var Id = Uuid().v4();
      String newKey = Id;
      ViewCustomController.containers[newKey] = buildContainer(newKey , context ,productItems);
      OrderItem.orderItemsList[newKey] = {...ViewCustomController.orderItem};
  }
  static Widget buildContainer(String key , BuildContext context , List<dynamic> productItems) {
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();
    final formatter = NumberFormat('#,###');
    return Container(
      key: ValueKey(key),
      width: size.width,
      child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(productItems.length != 0)
                 Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'نام کالا',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 250,
                    child: SelectBox(
                        name: 'نام کالا',
                        maxHeight: 38,
                        column: MainController.getDetailsOfField('Order_Details' , 'Product_Name'),
                        items: [
                          // DropdownMenuItem(
                          //     child: Obx(() {
                          //       return Txt(
                          //         '${AppController.of(Get.context!)!.value('not selected')}',
                          //         color: MainController.isLightMode.value == true
                          //             ? whiteColor
                          //             : primaryDark,
                          //         fontSize: 13,
                          //       );
                          //     }),
                          //     value: ''),
                          for (var item in productItems)
                            DropdownMenuItem(
                                child: Obx(() {
                                  return Txt(
                                    '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details' , 'Product_Name'))}',
                                    color:
                                    MainController.isLightMode.value == true
                                        ? whiteColor
                                        : primaryDark,
                                  );
                                }),
                                value: item['_id'].toString()),
                        ],
                        initalValue: '${productItems.first['_id']}',
                        onChanged: (value) async {
                          if (value != '') {
                            OrderItem.orderItemsList[key]!['Product_Name'] = value;
                          } else {
                            OrderItem.orderItemsList[key]!['Product_Name'] = '';
                          }
                        },
                        hintText: '',
                        isSeleted: true.obs,
                        selectedValue: ''),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'قیمت',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 100,
                    child: FormTextField(
                      name: 'قیمت',
                      hint: 'قیمت',
                      lable: '',
                      isNumberInt:true,
                      height: 40,
                      column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          String cleanText = text.replaceAll(',', '');
                          int value = int.tryParse(cleanText) ?? 0;
                          OrderItem.orderItemsList[key]!['Price'] = value;
                          String formatted = formatter.format(value);
                          print('formatted>>>${formatted}');
                          if (formatted != text) {
                            print('sckfd');
                            _controller.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        }
                        OrderItem.orderItemsList.refresh();
                      },
                      inputFormatters: [
                        ThousandSeparatorInputFormatter(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'بعد اول',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextFieldOrderItemCustom(
                      name: 'بعد اول',
                      hint: 'بعد اول',
                      lable: '',
                      height: 40,
                      isNumberDouble:true,
                      keyOrderItem: key,
                      column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['First_Dimension'] = double.tryParse('${text}');
                        }
                        else{
                          OrderItem.orderItemsList[key]!['First_Dimension'] = null;
                        }
                        OrderItem.orderItemsList.refresh();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'بعد دوم',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextFieldOrderItemCustom(
                      name: 'بعد دوم',
                      hint: 'بعد دوم',
                      lable: '',
                      height: 40,
                      isNumberDouble:true,
                      keyOrderItem: key,
                      column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Second_Dimension'] = double.tryParse('${text}');
                        }
                        else{
                          OrderItem.orderItemsList[key]!['Second_Dimension'] = null;
                        }
                        OrderItem.orderItemsList.refresh();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'جمع متراژ',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx((){
                          return Txt('${ViewCustomController.getCalculateTotalArea(OrderItem.orderItemsList[key]?['First_Dimension'] ?? 0,
                              OrderItem.orderItemsList[key]?['Second_Dimension'] ?? 0)}',
                            color: MainController.isLightMode.value == true ? whiteColor : color2,);
                        })
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'تعداد',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextField(
                      name: 'تعداد',
                      hint: 'تعداد',
                      lable: '',
                      height: 40,
                      isNumberInt:true,
                      column: MainController.getDetailsOfField('Order_Details' , 'Quantity'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Quantity'] = int.tryParse('${text}');
                        }
                        OrderItem.orderItemsList.refresh();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'الگوی بری',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 40,
                    child: SelectBox(
                        name: 'الگوی بری',
                        maxHeight: 38,
                        column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
                        items: [
                          for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'])
                            DropdownMenuItem(
                                child: Obx(() {
                                  return Txt(
                                    '${item['title']}',
                                    color:
                                    MainController.isLightMode.value == true
                                        ? whiteColor
                                        : primaryDark,
                                    fontSize: 13,
                                  );
                                }),
                                value: item['value']),
                        ],
                        initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
                        onChanged: (value) async {
                          print('value aaaa>>>${value}');
                          if (value != '') {
                            OrderItem.orderItemsList[key]!['Cut_Pattern'] = value;
                          } else {
                            OrderItem.orderItemsList[key]!['Cut_Pattern'] = '';
                          }
                        },
                        hintText: '',
                        isSeleted: false.obs,
                        selectedValue: ''),
                  )
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'سختی تولید',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 40,
                    child: SelectBox(
                        name: 'سختی تولید',
                        maxHeight: 38,
                        column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
                        items: [
                          for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'])
                            DropdownMenuItem(
                                child: Obx(() {
                                  return Txt(
                                    '${item['title']}',
                                    color:
                                    MainController.isLightMode.value == true
                                        ? whiteColor
                                        : primaryDark,
                                    fontSize: 13,
                                  );
                                }),
                                value: item['value']),
                        ],
                        initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'].first['value']}',
                        onChanged: (value) async {
                          print('value aaaa>>>${value}');
                          if (value != '') {
                            OrderItem.orderItemsList[key]!['Manufacturing_Difficulty'] = value;
                          } else {
                            OrderItem.orderItemsList[key]!['Manufacturing_Difficulty'] = '';
                          }
                        },
                        hintText: '',
                        isSeleted: false.obs,
                        selectedValue: ''),
                  )
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'بلوک',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextField(
                      name: 'بلوک',
                      hint: 'بلوک',
                      lable: '',
                      height: 40,
                      isNumberInt:true,
                      column: MainController.getDetailsOfField('Order_Details' , 'Block'),
                      onChange: (text) {
                        // dataJson[columnName] = text;
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
                        } else {
                          OrderItem.orderItemsList[key]!['Block']= '';

                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'طبقه',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextField(
                      name: 'طبقه',
                      hint: 'طبقه',
                      lable: '',
                      height: 40,
                      isNumberInt:true,
                      column: MainController.getDetailsOfField('Order_Details' , 'Level'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
                        } else {
                          OrderItem.orderItemsList[key]!['Level']= '';

                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'واحد',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 60,
                    child: FormTextField(
                      name: 'واحد',
                      hint: 'واحد',
                      lable: '',
                      isNumberInt:true,
                      height: 40,
                      column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
                        } else {
                          OrderItem.orderItemsList[key]!['Unit']= '';
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Txt(
                      'جمع مبلغ',
                      color:
                      MainController.isLightMode.value == true ? whiteColor : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 80,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx((){
                          return Txt('${ViewCustomController.getCalculateTotalPrice(OrderItem.orderItemsList[key]?['Price'] ?? 0 ,
                              OrderItem.orderItemsList[key]?['First_Dimension'] ?? 0,
                              OrderItem.orderItemsList[key]?['Second_Dimension'] ?? 0,
                              OrderItem.orderItemsList[key]?['Quantity'] ?? 0
                          )}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
                        })
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10,),
              Column(
                children: [
                  Obx((){
                    return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                  }),
                  SizedBox(height: 20,),
                  InkWell(
                    onTap: (){
                      ViewCustomController.removeContainer(key);
                    },
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                      padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                      child: Txt('${AppController.of(context)!.value('remove')} '),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }
  static  removeContainer(String key) {
    ViewCustomController.containers.remove(key);
    OrderItem.orderItemsList.remove(key);
  }
  //end order item

  static Future<int> calculateTotalQuantity(String orderId) async {
    int sum = 0;

    var orderDetailsList = await DB('Order_Details')
        .parent(parentId: orderId, parentTable: 'Orders')
        .getRecords();

    for (var item in orderDetailsList) {
      sum += int.tryParse(item['Quantity']?.toString() ?? '0') ?? 0;
    }

    return sum;
  }
  static Future<double> calculateTotalArea(String orderId) async {
    double sum = 0.0;

    var orderDetailsList = await DB('Order_Details')
        .parent(parentId: orderId, parentTable: 'Orders')
        .getRecords();

    for (var item in orderDetailsList) {
      double firstDim = double.tryParse('${item['First_Dimension'] ?? 0}') ?? 0.0;
      double secondDim = double.tryParse('${item['Second_Dimension'] ?? 0}') ?? 0.0;
      sum += ViewCustomController.getCalculateTotalArea(firstDim , secondDim);
    }

    return double.parse(sum.toStringAsFixed(2));
  }

  //order item edit page
  static addEditContainer(BuildContext context , List<dynamic> productItems){
        var Id = Uuid().v4();
        String newKey = Id;
        ViewCustomController.editContainers[newKey] = buildEditContainer(newKey , context ,productItems);
        OrderItem.orderItemsList2[newKey] = {};
  }
  static Widget buildEditContainer(String key , BuildContext context , List<dynamic> productItems){
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();
    final formatter = NumberFormat('#,###');
    return Container(
      width: size.width,
      key: ValueKey(key),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'نام کالا',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  child: SelectBox(
                      name: 'نام کالا',
                      maxHeight: 38,
                      column: MainController.getDetailsOfField('Order_Details' , 'Product_Name'),
                      items: [
                        for (var item in productItems)
                          DropdownMenuItem(
                              child: Obx(() {
                                return Txt(
                                  '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details' , 'Product_Name'))}',
                                  color:
                                  MainController.isLightMode.value == true
                                      ? whiteColor
                                      : primaryDark,
                                );
                              }),
                              value: item['_id'].toString()),
                      ],
                      initalValue: '${productItems.first['_id'] ?? ''}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // OrderItem.orderItemsList[key]!['Product_Name'] = value;

                          OrderItem.orderItemsList2[key]?['Product_Name']  = value;
                        } else {
                          // OrderItem.orderItemsList[key]!['Product_Name'] = '';
                          OrderItem.orderItemsList2[key]?['Product_Name']  = '';
                        }
                        // print('request of custom select>>>${OrderItem.orderItemsList[key]!['Product']}');
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'قیمت',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 100,
                  child: FormTextField(
                    name: 'قیمت',
                    hint: 'قیمت',
                    lable: '',
                    initValue: '${OrderItem.orderItemsList2[key]?['Price'] ?? ''}',
                    isNumberDouble:true,
                    height: 40,
                    column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Price'] = double.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Price']  = double.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Price']= '';
                        OrderItem.orderItemsList2[key]?['Price']  = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد اول',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextFieldOrderItemCustom(
                    name: 'بعد اول',
                    hint: 'بعد اول',
                    lable: '',
                    height: 40,
                    initValue: '${OrderItem.orderItemsList2[key]?['First_Dimension'] ?? ''}',
                    isNumberInt:true,
                    keyOrderItem: key,
                    column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]?['First_Dimension'] = double.tryParse('${text}');
                      }
                      else {
                        OrderItem.orderItemsList2[key]?['First_Dimension'] = null;
                      }
                      print('xxxxxxv>>>${OrderItem.orderItemsList2[key]?['First_Dimension']}');
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد دوم',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextFieldOrderItemCustom(
                    name: 'بعد دوم',
                    hint: 'بعد دوم',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    keyOrderItem: key,
                    initValue: '${OrderItem.orderItemsList2[key]?['Second_Dimension'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Second_Dimension'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] = double.tryParse('${text}');
                      } else {
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] = null;
                      }
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع متراژ',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('${ViewCustomController.getCalculateTotalArea(OrderItem.orderItemsList[key]?['First_Dimension'] ?? 0,
                          OrderItem.orderItemsList[key]?['Second_Dimension'] ?? 0)}', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'تعداد',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'تعداد',
                    hint: 'تعداد',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    column: MainController.getDetailsOfField('Order_Details' , 'Quantity'),
                    initValue: '${OrderItem.orderItemsList2[key]?['Quantity'] ?? ''}',
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Quantity'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Quantity'] = int.tryParse('${text}');
                      }
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'الگوی بری',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 40,
                  child: SelectBox(
                      name: 'الگوی بری',
                      maxHeight: 38,
                      column: MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern'),
                      items: [
                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'])
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
                              value: item['value']),
                      ],
                      initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // ViewController.request['Cut_Pattern'] = value;
                          OrderItem.orderItemsList2[key]?['Cut_Pattern'] = value;
                        } else {
                          // ViewController.request['Cut_Pattern'] = '';
                          OrderItem.orderItemsList2[key]?['Cut_Pattern'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                )
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'سختی تولید',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 40,
                  child: SelectBox(
                      name: 'سختی تولید',
                      maxHeight: 38,
                      column: MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty'),
                      items: [
                        for (var item in MainController.getDetailsOfField('Order_Details' , 'Manufacturing_Difficulty')['items'])
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
                              value: item['value']),
                      ],
                      initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
                      onChanged: (value) async {
                        print('value aaaa>>>${value}');
                        if (value != '') {
                          // ViewController.request['Manufacturing_Difficulty'] = value;
                          OrderItem.orderItemsList2[key]?['Manufacturing_Difficulty'] = value;
                        } else {
                          // ViewController.request['Manufacturing_Difficulty'] = '';
                          OrderItem.orderItemsList2[key]?['Manufacturing_Difficulty'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                )
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بلوک',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'بلوک',
                    hint: 'بلوک',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Block'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Block'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Block'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Block']= '';
                        OrderItem.orderItemsList2[key]?['Block'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'طبقه',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'طبقه',
                    hint: 'طبقه',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Level'] ?? ''}',
                    column: MainController.getDetailsOfField('Order_Details' , 'Level'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Level'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Level']= '';
                        OrderItem.orderItemsList2[key]?['Level'] = '';

                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'واحد',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 60,
                  child: FormTextField(
                    name: 'واحد',
                    hint: 'واحد',
                    lable: '',
                    isNumberInt:true,
                    initValue: '${OrderItem.orderItemsList2[key]?['Unit'] ?? ''}',
                    height: 40,
                    column: MainController.getDetailsOfField('Order_Details' , 'Unit'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Unit'] = int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Unit']= '';
                        OrderItem.orderItemsList2[key]?['Unit'] = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع مبلغ',
                    color:
                    MainController.isLightMode.value == true ? whiteColor : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Txt('0', color: MainController.isLightMode.value == true ? whiteColor : color2,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10,),
            Column(
              children: [
                Obx((){
                  return Txt('${AppController.of(context)!.value('remove')}' , color: MainController.isLightMode.value == true ? whiteColor : color2,);
                }),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    ViewCustomController.removeEditContainer(key);
                  },
                  child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.pinkAccent,),
                    padding: EdgeInsets.only(right: 20 , left: 20 , top: 10,bottom: 10),
                    child: Txt('${AppController.of(context)!.value('remove')} '),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
  static removeEditContainer(String key) {
      if(OrderItem.orderItemsList.containsKey(key)){
        OrderItem.orderItemsList.remove(key);
      }
      ViewCustomController.editContainers.remove(key);
      OrderItem.orderItemsList2.remove(key);
  }
// end order item edit page

}