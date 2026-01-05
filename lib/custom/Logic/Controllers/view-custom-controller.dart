import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
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
import 'package:finance/custom/UI/Components/Items/Forms/form-txt-field-order-item-edit-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/order/form-txt-price.dart';
import 'package:finance/custom/UI/Components/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:uuid/uuid.dart';
import '../../../Admin/Logic/Controllers/record-controller.dart';
import '../../../Admin/Public/styles.dart';
import '../../../Admin/UI/Componenets/General/txt.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-file.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-time.dart';
import '../../../Admin/Logic/Models/db.dart';
import '../../../Admin/UI/Componenets/Popups/snackbar.dart';
import '../../UI/Components/Items/Forms/thousand-separatorInput-formatter.dart';
import '../Models/order-item.dart';

class ViewCustomController extends GetxController{
  static Map<String, dynamic> order = {};
  static Map<String, dynamic> orderItem = {};
  static RxMap<String, Widget> containers = <String, Widget>{}.obs;
  static RxMap<String, Widget> editContainers = <String, Widget>{}.obs;
  static RxList<dynamic> allOrderDetailsSelected = [].obs;
  static RxMap<String, bool> checkboxStatus = <String, bool>{}.obs;


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
  static Widget generateEditFileBox(
      var data, var column, Rx<bool>? isSeletedFile) {
    String name = column['name'];
    String type = column['type'];
    RxString file = data != null && data[name] != null ? '${data[name]}'.obs : ''.obs;

    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column['name']}'] == null) {
      selectedFilesMap['${column['name']}'] = [];
    }
    // ViewController.request[name] =   data != null && data[name+'_name'] != null ? '${data[name+'_name']}' : '';
    List<dynamic> filesSelectedList = [];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(
            '${column['title']}',
            color:
            MainController.isLightMode.value == true ? whiteColor : color2,
          ),
          SizedBox(
            height: 10,
          ),
          file.value != ''
              ? IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : background,
                    width: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Image.network(
                            type == 'file'
                                ? baseUrl + '${file}'
                                : baseUrlPvFile + '${file}',
                            width: 40,
                            height: 40,
                            fit: BoxFit.fill,
                            errorBuilder: (BuildContext context, Object error,
                                StackTrace? stackTrace) {
                              return Image.asset(
                                fileImage,
                                width: 40,
                                height: 40,
                              ); // عکس جایگزین
                            },
                          ),
                          Txt(
                            '${data[name + '_name']}',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          ),
                        ],
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: IconButton(
                        color: redColor,
                        onPressed: () async {
                          ViewController.widgetDeletePopup(onChange: () async {
                            var status =
                            await MainController.deleteFileInChunks(
                                data[name + '_name'],
                                recordId: data['_id'],
                                record: json
                                    .encode({name: null}).toString());
                            if (status == true) {
                              file.value = '';
                              Navigator.pop(Get.context!);
                            }
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 25,
                          color: redColor,
                        ),
                      ))
                ],
              ),
            ),
          )
              : FormFile(
            columnName: column['title'],
            onChanged: (selecetdFiles) {
              print('selecetdFiles file of picture>>>${selecetdFiles}');
              data = selecetdFiles;
            },
            filesSelected: selectedFilesMap,
            // selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
            selectedFilesTxt: '',
            isSeletedFile: isSeletedFile,
            column: column,
            fileInfo: fileInfo,
          ),
        ],
      );
    });
  }
  static Future<Widget> getOrderItems(var data) async {
    List<dynamic> orderDetailItems = await ViewCustomController.getDataOrderDetailList('${data['_id']}');
    List<dynamic> productItems= await DB('Product').getRecords();

    for(var item in orderDetailItems){
      OrderItem.orderItemsList.value[item['_id']]=item;
    }
    return Column(
      children: [
          FormEditOrderItemCustom(productItems , orderDetailItems , data),
      ],
    );
  }

  //order item
  static  addContainer(BuildContext context , List<dynamic> productItems) {
      var Id = Uuid().v4();
      String newKey = Id;
      ViewCustomController.containers[newKey] = buildContainer(newKey , context ,productItems);
      ViewCustomController.containers.refresh();
      OrderItem.orderItemsList.value[newKey] = {...ViewCustomController.orderItem};
      OrderItem.orderItemsList.refresh();
  }
  static Widget buildContainer(String key , BuildContext context , List<dynamic> productItems) {
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();
    final formatter = NumberFormat('#,###');
    print('key of row>>>${key}');

    if(OrderItem.orderItemsList[key] == null){
      OrderItem.orderItemsList[key] = {};
    }
    final priceController = TextEditingController(text: formatter.format(
      ViewCustomController.getProductPrice(
        productItems, OrderItem.orderItemsList[key]!['Product_Name'] ?? productItems.first['_id'],) ?? 0,
    ));
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
                            final newPrice = ViewCustomController.getProductPrice(productItems, OrderItem.orderItemsList[key]!['Product_Name']) ?? 0;
                            priceController.text = formatter.format(newPrice);
                          } else {
                            OrderItem.orderItemsList[key]!['Product_Name'] = '';
                          }
                          OrderItem.orderItemsList.refresh();
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
                 Obx((){
                   return  Container(
                     width: 100,
                     child: FormPriceTextField(
                       name: 'قیمت',
                       hint: 'قیمت',
                       lable: '',
                       controller: priceController,
                       height: 40,
                       column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                       onChange: (text) {
                         if (text != null && text != '') {
                           String cleanText = text.replaceAll(',', '');
                           int value = int.tryParse(cleanText) ?? 0;
                           OrderItem.orderItemsList[key]!['Price'] = value;
                           String formatted = formatter.format(value);
                           if (formatted != text) {
                             _controller.value = TextEditingValue(
                               text: formatted,
                               selection: TextSelection.collapsed(offset: formatted.length),
                             );
                           }
                         }
                         OrderItem.orderItemsList.refresh();
                       },
                     ),
                   );
                 })
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx((){
                          return Txt('${ViewCustomController.getCalculateTotalArea((OrderItem.orderItemsList[key]?['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                              (OrderItem.orderItemsList[key]?['Second_Dimension'] as num?)?.toDouble() ?? 0.0)}',
                            color: MainController.isLightMode.value == true ? whiteColor : color2,);
                        }),
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
                        else{
                          OrderItem.orderItemsList[key]!['Quantity'] = 0;
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx((){
                            return Txt('${ViewCustomController.getCalculateTotalPrice(
                                ViewCustomController.getProductPrice(
                                  productItems, OrderItem.orderItemsList[key]?['Product_Name'] ?? productItems.first['_id'],),
                                (OrderItem.orderItemsList[key]?['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                (OrderItem.orderItemsList[key]?['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                                OrderItem.orderItemsList[key]?['Quantity'] ?? 0
                            )}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
                          }),
                        ],
                      ),
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
    containers.remove(key);
    OrderItem.orderItemsList.remove(key);
  }
  //end order item

  static Future<int> calculateTotalQuantity(String orderId) async {
    int sum = 0;

    var orderDetailsList = await ViewCustomController.getDataOrderDetailList(orderId);

    for (var item in orderDetailsList) {
      sum += int.tryParse(item['Quantity']?.toString() ?? '0') ?? 0;
    }

    return sum;
  }
  static Future<double> calculateTotalArea(String orderId) async {
    double sum = 0.0;

    var orderDetailsList = await ViewCustomController.getDataOrderDetailList(orderId);

    for (var item in orderDetailsList) {
      double firstDim = double.tryParse('${item['First_Dimension'] ?? 0}') ?? 0.0;
      double secondDim = double.tryParse('${item['Second_Dimension'] ?? 0}') ?? 0.0;
      sum += ViewCustomController.getCalculateTotalArea(firstDim , secondDim);
    }

    return double.parse(sum.toStringAsFixed(2));
  }
  static getDataOrderDetailList(String parentId) async {
    List<dynamic> orderDetailList = await DB('Order_Details').parent(parentTable: 'Orders', parentId: '${parentId}').getRecords();
    for (var item in orderDetailList) {
      if (item['First_Dimension'] != null) {
        item['First_Dimension'] =
            (item['First_Dimension'] as num).toDouble();
      }

      if (item['Second_Dimension'] != null) {
        item['Second_Dimension'] =
            (item['Second_Dimension'] as num).toDouble();
      }
    }
    return orderDetailList;
  }
  static getProductPrice(List<dynamic> productItems , String productId) {
    for(var product in productItems){
      if(product['_id'] == productId){
        return product['Price'];
      }
    }
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
    final priceController = TextEditingController(text: formatter.format(
      ViewCustomController.getProductPrice(
        productItems, OrderItem.orderItemsList2[key]?['Product_Name']['_id'] ?? productItems.first['_id'],) ?? 0,
    ));
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
                        if (value != '') {
                          OrderItem.orderItemsList2[key]?['Product_Name']  = value;
                          final newPrice = ViewCustomController.getProductPrice(productItems, OrderItem.orderItemsList2[key]!['Product_Name']) ?? 0;
                          priceController.text = formatter.format(newPrice);
                        } else {
                          OrderItem.orderItemsList2[key]?['Product_Name']  = '';
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
                Obx((){
                  return  Container(
                    width: 100,
                    child: FormPriceTextField(
                      name: 'قیمت',
                      hint: 'قیمت',
                      lable: '',
                      controller: priceController,
                      height: 40,
                      column: MainController.getDetailsOfField('Order_Details' , 'Price'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          String cleanText = text.replaceAll(',', '');
                          int value = int.tryParse(cleanText) ?? 0;
                          OrderItem.orderItemsList2[key]!['Price'] = value;
                          String formatted = formatter.format(value);
                          if (formatted != text) {
                            _controller.value = TextEditingValue(
                              text: formatted,
                              selection: TextSelection.collapsed(offset: formatted.length),
                            );
                          }
                        }
                        OrderItem.orderItemsList2.refresh();
                      },
                    ),
                  );
                })
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
                  child: FormTextFieldOrderItemEditCustom(
                    name: 'بعد اول',
                    hint: 'بعد اول',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    keyOrderItem: key,
                    column: MainController.getDetailsOfField('Order_Details' , 'First_Dimension'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]!['First_Dimension'] = double.tryParse('${text}');
                      }
                      else {
                        OrderItem.orderItemsList2[key]!['First_Dimension'] = null;
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
                  child: FormTextFieldOrderItemEditCustom(
                    name: 'بعد دوم',
                    hint: 'بعد دوم',
                    lable: '',
                    height: 40,
                    isNumberInt:true,
                    keyOrderItem: key,
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
                     Obx((){
                       return  Txt('${ViewCustomController.getCalculateTotalArea(OrderItem.orderItemsList2[key]?['First_Dimension'] ?? 0,
                           OrderItem.orderItemsList2[key]?['Second_Dimension'] ?? 0)}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
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
                    initValue: '${OrderItem.orderItemsList2[key]?['Quantity'] ?? ''}',
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]?['Quantity'] = int.tryParse('${text}');
                      }
                      else{
                        OrderItem.orderItemsList2[key]?['Quantity'] = 0;
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
                                  fontSize: 13,
                                );
                              }),
                              value: item['value']),
                      ],
                      initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
                      onChanged: (value) async {
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
                                  fontSize: 13,
                                );
                              }),
                              value: item['value']),
                      ],
                      initalValue: '${MainController.getDetailsOfField('Order_Details' , 'Cut_Pattern')['items'].first['value']}',
                      onChanged: (value) async {
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx((){

                          return Txt('${ViewCustomController.getCalculateTotalPrice(ViewCustomController.getProductPrice(
                              productItems, OrderItem.orderItemsList2[key]!['Product_Name'] ?? productItems.first['_id']),
                              (OrderItem.orderItemsList2[key]?['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                              (OrderItem.orderItemsList2[key]?['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                              OrderItem.orderItemsList2[key]?['Quantity'] ?? 0
                          )}', color: MainController.isLightMode.value == true ? whiteColor : color2,);
                        })
                      ],
                    ),
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
        OrderItem.orderItemsList.refresh();
      }
      ViewCustomController.editContainers.remove(key);
      OrderItem.orderItemsList2.remove(key);
      // ViewCustomController.editContainers.refresh();
      // OrderItem.orderItemsList2.refresh();
  }
// end order item edit page

  static checkOrder(context,productItems) async {
  if (ViewCustomController.order['Date'] == null) {
    ViewCustomController.order['Date'] = ViewCustomController.getDate(Jalali.now());
  }
  if(ViewCustomController.order['Type'] == null){
    ViewCustomController.order['Type'] = MainController.getDetailsOfField('Orders' , 'Type')['items'].first['value'];
  }
  if(ViewCustomController.order['Customer'] == null){
    List<dynamic> customerItems= await DB('Customer').getRecords();
    ViewCustomController.order['Customer'] = customerItems.first['_id'];
  }
  var Id = Uuid().v4();
  DataModel newData = DataModel(
      id: '${Id}',
      data: ViewCustomController.order);
  bool validate = await RecordController.validate('Orders', newData , MainController.getInfoTable('Orders'));
  if(validate == false){
    ViewCustomController.addContainer(context ,productItems);
  }
  else{
    showSnackbar(snackTypes.error, 'لطفا آیتم های سفارش را تکمیل کنید...');
  }
}
  static checkEditOrder(context,productItems , {var data}) async {
    if (data['Date'] == null) {
      data['Date'] = ViewCustomController.getDate(Jalali.now());
    }
    if(data['Type'] == null){
      data['Type'] = MainController.getDetailsOfField('Orders' , 'Type')['items'].first['value'];
    }
    if(data['Customer'] == null){
      List<dynamic> customerItems= await DB('Customer').getRecords();
      data['Customer'] = customerItems.first['_id'];
    }
    var Id = Uuid().v4();
    DataModel newData = DataModel(
        id: '${Id}',
        data: data);
    bool validate = await RecordController.validate('Orders', newData , MainController.getInfoTable('Orders'));
    if(validate == false){
      ViewCustomController.addEditContainer(context ,productItems);
    }
    else{
      showSnackbar(snackTypes.error, 'لطفا آیتم های سفارش را تکمیل کنید...');
    }
  }
  static goTableCustom({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table['schema']['name'];
    if (table['schema']['view'] == 'custom') {
      var orderList=[];
      if(tableName == 'Orders'){
        print('MainController.tableData[index]>>>${MainController.tableData[index]}');
        print('table schema name>>>${table['schema']['name']}');
        orderList = await DB('${table['schema']['name']}')
            .parent(
            parentId: MainController.tableData[index]['parent_id'],
            parentTable: 'Customer')
            .getRecords();
        print('ID OF TABLE DATA>>>${MainController.tableData[index]['parent_id']}');
        print('PARENT TABLE>>>${MainController.tableInfo['schema']['name']}');
        print('orderList>>>${orderList}');

      }
      if(tableName == 'Order_Details'){
        var orderDetailsList = await ViewCustomController.getDataOrderDetailList(MainController.tableData[index]['_id']);
      }
      await MainController.goToTablePage(table,
        tableFields: MainController.getInfoTable(table['schema']['name']),);
      HelperController.pageInateFunction();
    } else {
      // DB.parentItem = {
      //   'parent_id': MainController.tableData[index]['_id'],
      //   'parent_table': MainController.tableInfo['schema']['name']
      // };
      var items = await DB('${table['schema']['name']}')
          .parent(
          parentId: MainController.tableData[index]['_id'],
          parentTable: MainController.tableInfo['schema']['name'])
          .getRecords();


      await MainController.goToTablePage(table,
          tableFields: MainController.getInfoTable(table['schema']['name']),
          tableData: items);
    }
  }
  static getDrawingNumberOrder(String orderDetailParentId , List<dynamic> orders){
   for(var order in orders){
     if(order['_id'] == orderDetailParentId){
       return order['Drawing_Number'];
     }
   }

  }

}
