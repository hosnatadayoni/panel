import 'dart:convert';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/connect-server-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/tableModel.dart';
import 'package:finance/Admin/Public/api-urls.dart';
import 'package:finance/Admin/Public/config.dart';
import 'package:finance/Admin/Public/images.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-selectBox.dart';
import 'package:finance/Admin/UI/Componenets/Items/Form/form-text-field.dart';
import 'package:finance/custom/UI/Components/Items/Forms/OrderItem/form-text-field-order-item-custom.dart';
import 'package:finance/custom/UI/Components/Items/Forms/OrderItem/form-txt-field-order-item-edit-custom.dart';
import 'package:finance/custom/UI/Components/page-custom/order/form-txt-price.dart';
import 'package:finance/custom/UI/Components/page-custom/orderItem/form-edit-orderItem-custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
// import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../../Admin/Logic/Controllers/record-controller.dart';
import '../../../Admin/Public/styles.dart';
import '../../../Admin/UI/Componenets/General/txt.dart';
import '../../../Admin/UI/Componenets/Items/Form/form-file.dart';
import '../../../Admin/Logic/Models/db.dart';
import '../../../Admin/UI/Componenets/Popups/snackbar.dart';
import '../Models/order-item.dart';

class ViewCustomController extends GetxController {
  static Map<String, dynamic> order = {};
  static Map<String, dynamic> orderItem = {};
  static RxMap<String, Widget> containers = <String, Widget>{}.obs;
  static RxMap<String, Widget> editContainers = <String, Widget>{}.obs;
  static RxMap<String, Map> total = <String, Map>{}.obs;
  static RxBool isShowAlert = false.obs;

  // order output and order detail output table
  static RxMap<String, Map> orderDetailsSelected = <String, Map>{}.obs;
  static RxMap<String, List<dynamic>> ordersSelected =
      <String, List<dynamic>>{}.obs;
  static RxMap<String, bool> status = <String, bool>{}.obs;
  static RxMap<String, bool> statusOrderDetails = <String, bool>{}.obs;
  static Rx<int> OrderItemOutPutCurrentPage = 1.obs;
  static Rx<int> OrderItemOutPutCountShowRow = 10.obs;
  static RxList allOrdersSelected = [].obs;

  //end order output and order detail output table

  static Rx<bool> isClickedBtnRegister = false.obs;
  static Rx<String> customerId=''.obs;
  static Map<String, dynamic> outPut = {};

  static Jalali parseDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    return Jalali(year, month, day);
  }

  static String getDate(Jalali j) {
    int year = j.year;
    int month = j.month;
    int day = j.day;
    String date = '${year}/${month}/${day}';
    return date;
  }

  static TimeOfDay parseTime(String dateString) {
    List<String>? TimeParts;
    int hour = TimeOfDay.now().hour;
    int minute = TimeOfDay.now().minute;
    TimeParts = dateString.split(':');
    hour = int.parse('${TimeParts![0]}');
    minute = int.parse('${TimeParts[1]}');

    return TimeOfDay(hour: hour, minute: minute);
  }

  // static Map<String, dynamic> getDataTable(String tableName) {
  //   Map<String, dynamic> dataTableName = {};
  //   for (var subMenu in MainController.menuList.value) {
  //     if (subMenu.schema.name == tableName) {
  //       dataTableName = subMenu;
  //     }
  //   }
  //   return dataTableName;
  // }

  static getCalculateTotalArea(double firsDimension, double secondDimension) {
    double total = firsDimension * secondDimension;
    return double.parse(total.toStringAsFixed(2));
  }

  static getCalculateTotalPrice(
      int price, double firsDimension, double secondDimension, int quantity) {
    final formatter = NumberFormat('#,##0', 'en_US');
    double totalPrice = getCalculateTotalArea(firsDimension, secondDimension) *
        price *
        quantity;
    double rounded = double.parse(totalPrice.toStringAsFixed(2));
    return formatter.format(rounded);
  }

  static Widget generateFileBox(
      String selecetdFiles, var column) {
    final RxBool isSelectedFile =
        (selecetdFiles != null && selecetdFiles!='').obs;
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column.name}'] == null) {
      selectedFilesMap['${column.name}'] = [];
    }
    List<dynamic> filesSelectedList = [];
    if (ViewCustomController.order[column.name] != null) {
      // filesSelectedList = ViewCustomController.order[column['name']];
      filesSelectedList.add(ViewCustomController.order[column.name]);
      for (var data in filesSelectedList) {
        selectedFilesMap['${column.name}']!.add(data);
      }
    }
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Txt(
            '${column.title}',
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
            columnName: column.title,
            onChanged: (selecetdFiles) {
              ViewCustomController.order[column.name] = selecetdFiles;
            },
            filesSelected: selectedFilesMap,
            selectedFilesTxt: selecetdFiles,
            isSeletedFile: isSelectedFile,
            column: column,
          ),
        ),
      ],
    );
  }

  static Widget generateEditFileBox(
      var data, var column) {
    String name = column.name;
    String type = column.type;
    RxString file =
        data != null && data[name] != null ? '${data[name]}'.obs : ''.obs;
    print('file.value>>>${file.value}');

    final RxBool isSelectedFile = (data != null && data!.isNotEmpty).obs;
    Map<String, List<dynamic>> selectedFilesMap = {};
    if (selectedFilesMap['${column.name}'] == null) {
      selectedFilesMap['${column.name}'] = [];
    }
    // ViewController.request[name] =   data != null && data[name+'_name'] != null ? '${data[name+'_name']}' : '';
    List<dynamic> filesSelectedList = [];
    RxMap<String, List<dynamic>> fileInfo = <String, List<dynamic>>{}.obs;
    return Obx(() {
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt(
            '${column.title}',
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
                                ViewController.widgetDeletePopup(
                                    onChange: () async {
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
                  columnName: column.title,
                  onChanged: (selecetdFiles) {
                    data[name] = selecetdFiles;
                    // ViewCustomController.order[name] = selecetdFiles;
                  },
                  filesSelected: selectedFilesMap,
                  // selectedFilesTxt: column['type'] == 'file' ? selecetdFiles:filesSelectedList,
                  selectedFilesTxt: '',
                  isSeletedFile: isSelectedFile,
                  column: column,
                  fileInfo: fileInfo,
                ),
        ],
      );
    });
  }

  static Future<Widget> getOrderItems(var data) async {
    List<dynamic> orderDetailItems =
        await ViewCustomController.getDataOrderDetailList('${data['_id']}');
    ViewCustomController.getAllReocord('Product');
    List<dynamic> productItems = await DB('Product').getRecords();

    for (var item in orderDetailItems) {
      OrderItem.orderItemsList.value[item['_id']] = item;
    }
    return Column(
      children: [
        FormEditOrderItemCustom(productItems, orderDetailItems, data),
      ],
    );
  }

  //order item
  static addContainer(BuildContext context, List<dynamic> productItems) {
    var Id = Uuid().v4();
    String newKey = Id;
    ViewCustomController.containers[newKey] =
        buildContainer(newKey, context, productItems);
    ViewCustomController.containers.refresh();
    OrderItem.orderItemsList.value[newKey] = {
      ...ViewCustomController.orderItem
    };
    OrderItem.orderItemsList.refresh();
  }

  static Widget buildContainer(
      String key, BuildContext context, List<dynamic> productItems) {
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();
    final formatter = NumberFormat('#,###');
    print('key of row>>>${key}');

    if (OrderItem.orderItemsList[key] == null) {
      OrderItem.orderItemsList[key] = {};
    }
    final productName = OrderItem.orderItemsList[key]?['Product_Name'] ?? '';

    final price =
        ViewCustomController.getProductPrice(productItems, productName);

    final priceController = TextEditingController(
      text: price == null ? '' : formatter.format(price),
    );


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
                          column: MainController.getDetailsOfField(
                              'Order_Details', 'Product_Name'),
                          items: [
                            DropdownMenuItem(
                              enabled: false,
                                child: Obx(() {
                                  return Txt(
                                    'لطفا یکی از موارد زیر را انتخاب کنید',
                                    color:
                                    MainController.isLightMode.value == true
                                        ? whiteColor
                                        : primaryDark,
                                  );
                                }),
                                value: ''),
                            for (var item in productItems)
                              DropdownMenuItem(
                                  child: Obx(() {
                                    return Txt(
                                      '${ViewController.itemsShowSelectItem(
                                          item,
                                          MainController.getDetailsOfField(
                                              'Order_Details',
                                              'Product_Name'))}',
                                      color:
                                      MainController.isLightMode.value == true
                                          ? whiteColor
                                          : primaryDark,
                                    );
                                  }),
                                  value: item['_id'].toString()),
                          ],
                          // initalValue: '${productItems.first['_id']}',
                          onChanged: (value) async {
                            if (value != '') {
                              OrderItem.orderItemsList[key]!['Product_Name'] =
                                  value;
                              final newPrice = ViewCustomController
                                  .getProductPrice(productItems, OrderItem
                                  .orderItemsList[key]!['Product_Name']) ?? 0;
                              priceController.text = formatter.format(newPrice);
                            } else {
                              OrderItem.orderItemsList[key]!['Product_Name'] =
                              '';
                            }
                            OrderItem.orderItemsList.refresh();
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return Container(
                      width: 100,
                      child: FormPriceTextField(
                        name: 'قیمت',
                        hint: 'قیمت',
                        lable: '',
                        controller: priceController,
                        height: 40,
                        column: MainController.getDetailsOfField(
                            'Order_Details', 'Price'),
                        onChange: (text) async {
                          if (text != null && text != '') {
                            String cleanText = text.replaceAll(',', '');
                            int value = int.tryParse(cleanText) ?? 0;
                            OrderItem.orderItemsList[key]!['Price'] = value;
                          }
                          else{
                            OrderItem.orderItemsList[key]!['Price'] = 0;
                          }
                          OrderItem.orderItemsList.refresh();
                          ViewCustomController.isShowAlert.value =
                          await ViewCustomController.showAlret();
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                      isNumberDouble: true,
                      keyOrderItem: key,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'First_Dimension'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['First_Dimension'] =
                              double.tryParse('${text}');
                        }
                        else {
                          OrderItem.orderItemsList[key]!['First_Dimension'] =
                          null;
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                      isNumberDouble: true,
                      keyOrderItem: key,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Second_Dimension'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Second_Dimension'] =
                              double.tryParse('${text}');
                        }
                        else {
                          OrderItem.orderItemsList[key]!['Second_Dimension'] =
                          null;
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                        Obx(() {
                          return Txt('${ViewCustomController
                              .getCalculateTotalArea((OrderItem
                              .orderItemsList[key]?['First_Dimension'] as num?)
                              ?.toDouble() ?? 0.0,
                              (OrderItem
                                  .orderItemsList[key]?['Second_Dimension'] as num?)
                                  ?.toDouble() ?? 0.0)}',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,);
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                      isNumberInt: true,
                      initValue: '1',
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Quantity'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Quantity'] =
                              int.tryParse('${text}');
                        }
                        else {
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
                        column: MainController.getDetailsOfField(
                            'Order_Details', 'Cut_Pattern'),
                        items: [
                          for (var item in MainController.getDetailsOfField(
                              'Order_Details', 'Cut_Pattern').items)
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
                        initalValue: '${MainController.getDetailsOfField(
                            'Order_Details', 'Cut_Pattern').items
                            .first['value']}',
                        onChanged: (value) async {
                          if (value != '') {
                            OrderItem.orderItemsList[key]!['Cut_Pattern'] =
                                value;
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
                        column: MainController.getDetailsOfField(
                            'Order_Details', 'Manufacturing_Difficulty'),
                        items: [
                          for (var item in MainController.getDetailsOfField(
                              'Order_Details',
                              'Manufacturing_Difficulty').items)
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
                        initalValue: '${MainController.getDetailsOfField(
                            'Order_Details',
                            'Manufacturing_Difficulty').items
                            .first['value']}',
                        onChanged: (value) async {
                          if (value != '') {
                            OrderItem
                                .orderItemsList[key]!['Manufacturing_Difficulty'] =
                                value;
                          } else {
                            OrderItem
                                .orderItemsList[key]!['Manufacturing_Difficulty'] =
                            '';
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                      isNumberInt: true,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Block'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Block'] =
                              int.parse('${text}');
                        } else {
                          OrderItem.orderItemsList[key]!['Block'] = '';
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                      isNumberInt: true,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Level'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          OrderItem.orderItemsList[key]!['Level'] =
                              int.parse('${text}');
                        } else {
                          OrderItem.orderItemsList[key]!['Level'] = '';
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Focus(
                    autofocus: true,
                    onKeyEvent: (node, event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.tab) {

                        String lastKey =
                        ViewCustomController.containers.keys.last.toString();

                        if (key == lastKey) {
                          ViewCustomController.addContainer(context, productItems);
                          return KeyEventResult.ignored;
                        }
                      }
                      return KeyEventResult.ignored;
                    },
                    child: Container(
                      width: 60,
                      child: FormTextField(
                        name: 'واحد',
                        hint: 'واحد',
                        lable: '',
                        isNumberInt: true,
                        height: 40,
                        column: MainController.getDetailsOfField(
                            'Order_Details', 'Unit'),
                        onChange: (text) {
                          if (text != null && text != '') {
                            OrderItem.orderItemsList[key]!['Unit'] =
                                int.parse('${text}');
                          } else {
                            OrderItem.orderItemsList[key]!['Unit'] = '';
                          }
                        },
                        onEditingComplete: (){
                          ViewCustomController.addContainer(context, productItems);
                        },

                      ),
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
                      MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,
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
                          Obx(() {
                            return Txt(
                              '${ViewCustomController.getCalculateTotalPrice(
                                OrderItem.orderItemsList[key]!['Price'] == null ? OrderItem.orderItemsList[key]!['Product_Name'] ==null ? 0 :ViewCustomController.getProductPrice(
                                    productItems, OrderItem
                                      .orderItemsList[key]?['Product_Name'],):OrderItem.orderItemsList[key]!['Price'],
                                  (OrderItem
                                      .orderItemsList[key]?['First_Dimension'] as num?)
                                      ?.toDouble() ?? 0.0,
                                  (OrderItem
                                      .orderItemsList[key]?['Second_Dimension'] as num?)
                                      ?.toDouble() ?? 0.0,
                                  OrderItem.orderItemsList[key]?['Quantity'] ??
                                      1
                              )}',
                              color: MainController.isLightMode.value == true
                                  ? whiteColor
                                  : color2,);
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
                  Obx(() {
                    return Txt('${AppController.of(context)!.value('remove')}',
                      color: MainController.isLightMode.value == true
                          ? whiteColor
                          : color2,);
                  }),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: () async {
                      ViewCustomController.removeContainer(key);
                      ViewCustomController.isShowAlert.value = await ViewCustomController.showAlret();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.pinkAccent,),
                      padding: EdgeInsets.only(
                          right: 20, left: 20, top: 10, bottom: 10),
                      child: Txt(
                          '${AppController.of(context)!.value('remove')} '),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );

  }

  static removeContainer(String key) {
    containers.remove(key);
    OrderItem.orderItemsList.remove(key);
  }

  //end order item

  static Future<Map<String, dynamic>> calculateTotalItems(String orderId) async {
    int sumQuantity = 0;
    double sumArea =0.0;

    var orderDetailsList =
        await ViewCustomController.getDataOrderDetailList(orderId);

    for (var item in orderDetailsList) {
      sumQuantity += int.tryParse(item['Quantity']?.toString() ?? '0') ?? 0;
      double firstDim =
          double.tryParse('${item['First_Dimension'] ?? 0}') ?? 0.0;
      double secondDim =
          double.tryParse('${item['Second_Dimension'] ?? 0}') ?? 0.0;
      sumArea += ViewCustomController.getCalculateTotalArea(firstDim, secondDim);
    }

    return  {
      'sumQuantity': sumQuantity,
      'sumArea': double.parse(sumArea.toStringAsFixed(2)),
    };
  }

  // static Future<double> calculateTotalArea(String orderId) async {
  //   double sum = 0.0;
  //
  //   var orderDetailsList =
  //       await ViewCustomController.getDataOrderDetailList(orderId);
  //
  //   for (var item in orderDetailsList) {
  //     double firstDim =
  //         double.tryParse('${item['First_Dimension'] ?? 0}') ?? 0.0;
  //     double secondDim =
  //         double.tryParse('${item['Second_Dimension'] ?? 0}') ?? 0.0;
  //     sum += ViewCustomController.getCalculateTotalArea(firstDim, secondDim);
  //   }
  //
  //   return double.parse(sum.toStringAsFixed(2));
  // }

  static getDataOrderDetailList(String parentId) async {
    List<dynamic> orderDetailList = await DB('Order_Details')
        .parent(parentTable: 'Orders', parentId: '${parentId}')
        .getRecords();
    for (var item in orderDetailList) {
      if (item['First_Dimension'] != null) {
        item['First_Dimension'] = (item['First_Dimension'] as num).toDouble();
      }

      if (item['Second_Dimension'] != null) {
        item['Second_Dimension'] = (item['Second_Dimension'] as num).toDouble();
      }
    }
    print('orderDetailList>>>${orderDetailList}');
    return orderDetailList;
  }

  static getProductPrice(List<dynamic> productItems, String? productId) {
    if (productItems.isEmpty) return null;
    for (var product in productItems) {
      if (product['_id'] == productId) {
        return product['Price'];
      }
    }
  }

  //order item edit page
  static addEditContainer(BuildContext context, List<dynamic> productItems , String customerId) {
    var Id = Uuid().v4();
    String newKey = Id;
    print('customerId>>>${customerId}');
    ViewCustomController.editContainers[newKey] =
        buildEditContainer(newKey, context, productItems , customerId);
    OrderItem.orderItemsList2[newKey] = {};
  }

  static Widget buildEditContainer(
      String key, BuildContext context, List<dynamic> productItems, String customerId) {
    var size = MediaQuery.of(context).size;
    final TextEditingController _controller = TextEditingController();
    final formatter = NumberFormat('#,###');
    final productName = OrderItem.orderItemsList2[key]?['Product_Name'] ?? '';

    final price =
        ViewCustomController.getProductPrice(productItems, productName);

    final priceController = TextEditingController(
      text: price == null ? '' : formatter.format(price),
    );
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
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Product_Name'),
                      items: [
                        DropdownMenuItem(
                            enabled: false,
                            child: Obx(() {
                              return Txt(
                                'لطفا یکی از موارد زیر را انتخاب کنید',
                                color:
                                MainController.isLightMode.value == true
                                    ? whiteColor
                                    : primaryDark,
                              );
                            }),
                            value: ''),
                        for (var item in productItems)
                          DropdownMenuItem(
                              child: Obx(() {
                                return Txt(
                                  '${ViewController.itemsShowSelectItem(item, MainController.getDetailsOfField('Order_Details', 'Product_Name'))}',
                                  color:
                                      MainController.isLightMode.value == true
                                          ? whiteColor
                                          : primaryDark,
                                );
                              }),
                              value: item['_id'].toString()),
                      ],
                      // initalValue: '${productItems.first['_id'] ?? ''}',
                      onChanged: (value) async {
                        if (value != '') {
                          OrderItem.orderItemsList2[key]?['Product_Name'] =
                              value;
                          final newPrice = ViewCustomController.getProductPrice(
                                  productItems,
                                  OrderItem
                                      .orderItemsList2[key]!['Product_Name']) ??
                              0;
                          priceController.text = formatter.format(newPrice);
                        } else {
                          OrderItem.orderItemsList2[key]?['Product_Name'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: true.obs,
                      selectedValue: ''),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'قیمت',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Obx(() {
                  return Container(
                    width: 100,
                    child: FormPriceTextField(
                      name: 'قیمت',
                      hint: 'قیمت',
                      lable: '',
                      controller: priceController,
                      height: 40,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Price'),
                      onChange: (text) async {
                        if (text != null && text != '') {
                          String cleanText = text.replaceAll(',', '');
                          int value = int.tryParse(cleanText) ?? 0;
                          OrderItem.orderItemsList2[key]!['Price'] = value;
                        }
                        OrderItem.orderItemsList2.refresh();
                        ViewCustomController.isShowAlert.value =
                            await ViewCustomController.showAlretEditOrder(customerId);
                      },
                    ),
                  );
                })
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد اول',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                    isNumberInt: true,
                    keyOrderItem: key,
                    column: MainController.getDetailsOfField(
                        'Order_Details', 'First_Dimension'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]!['First_Dimension'] =
                            double.tryParse('${text}');
                      } else {
                        OrderItem.orderItemsList2[key]!['First_Dimension'] =
                            null;
                      }
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بعد دوم',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                    isNumberInt: true,
                    keyOrderItem: key,
                    column: MainController.getDetailsOfField(
                        'Order_Details', 'Second_Dimension'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] =
                            double.tryParse('${text}');
                      } else {
                        OrderItem.orderItemsList2[key]?['Second_Dimension'] =
                            null;
                      }
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع متراژ',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                      Obx(() {
                        return Txt(
                          '${ViewCustomController.getCalculateTotalArea(OrderItem.orderItemsList2[key]?['First_Dimension'] ?? 0, OrderItem.orderItemsList2[key]?['Second_Dimension'] ?? 0)}',
                          color: MainController.isLightMode.value == true
                              ? whiteColor
                              : color2,
                        );
                      })
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'تعداد',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                    isNumberInt: true,
                    column: MainController.getDetailsOfField(
                        'Order_Details', 'Quantity'),
                    initValue:
                        '${OrderItem.orderItemsList2[key]?['Quantity'] ?? '1'}',
                    onChange: (text) {
                      if (text != null && text != '') {
                        OrderItem.orderItemsList2[key]?['Quantity'] =
                            int.tryParse('${text}');
                      } else {
                        OrderItem.orderItemsList2[key]?['Quantity'] = 0;
                      }
                      OrderItem.orderItemsList2.refresh();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
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
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Cut_Pattern'),
                      items: [
                        for (var item in MainController.getDetailsOfField(
                                'Order_Details', 'Cut_Pattern')
                            .items)
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
                      initalValue:
                          '${MainController.getDetailsOfField('Order_Details', 'Cut_Pattern').items.first['value']}',
                      onChanged: (value) async {
                        if (value != '') {
                          // ViewController.request['Cut_Pattern'] = value;
                          OrderItem.orderItemsList2[key]?['Cut_Pattern'] =
                              value;
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
            SizedBox(
              width: 10,
            ),
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
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Manufacturing_Difficulty'),
                      items: [
                        for (var item in MainController.getDetailsOfField(
                                'Order_Details', 'Manufacturing_Difficulty')
                            .items)
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
                      initalValue:
                          '${MainController.getDetailsOfField('Order_Details', 'Cut_Pattern').items.first['value']}',
                      onChanged: (value) async {
                        if (value != '') {
                          // ViewController.request['Manufacturing_Difficulty'] = value;
                          OrderItem.orderItemsList2[key]
                              ?['Manufacturing_Difficulty'] = value;
                        } else {
                          // ViewController.request['Manufacturing_Difficulty'] = '';
                          OrderItem.orderItemsList2[key]
                              ?['Manufacturing_Difficulty'] = '';
                        }
                      },
                      hintText: '',
                      isSeleted: false.obs,
                      selectedValue: ''),
                )
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'بلوک',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                    isNumberInt: true,
                    initValue:
                        '${OrderItem.orderItemsList2[key]?['Block'] ?? ''}',
                    column: MainController.getDetailsOfField(
                        'Order_Details', 'Block'),
                    onChange: (text) {
                      // dataJson[columnName] = text;
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Block'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Block'] =
                            int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Block']= '';
                        OrderItem.orderItemsList2[key]?['Block'] = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'طبقه',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                    isNumberInt: true,
                    initValue:
                        '${OrderItem.orderItemsList2[key]?['Level'] ?? ''}',
                    column: MainController.getDetailsOfField(
                        'Order_Details', 'Level'),
                    onChange: (text) {
                      if (text != null && text != '') {
                        // OrderItem.orderItemsList[key]!['Level'] = int.parse('${text}');
                        OrderItem.orderItemsList2[key]?['Level'] =
                            int.parse('${text}');
                      } else {
                        // OrderItem.orderItemsList[key]!['Level']= '';
                        OrderItem.orderItemsList2[key]?['Level'] = '';
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'واحد',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                Focus(
                  autofocus: true,
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.tab) {

                      String lastKey =
                      ViewCustomController.editContainers.keys.last.toString();

                      if (key == lastKey) {
                        ViewCustomController.addEditContainer(context, productItems , customerId);
                        return KeyEventResult.ignored;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: Container(
                    width: 60,
                    child: FormTextField(
                      name: 'واحد',
                      hint: 'واحد',
                      lable: '',
                      isNumberInt: true,
                      initValue:
                          '${OrderItem.orderItemsList2[key]?['Unit'] ?? ''}',
                      height: 40,
                      column: MainController.getDetailsOfField(
                          'Order_Details', 'Unit'),
                      onChange: (text) {
                        if (text != null && text != '') {
                          // OrderItem.orderItemsList[key]!['Unit'] = int.parse('${text}');
                          OrderItem.orderItemsList2[key]?['Unit'] =
                              int.parse('${text}');
                        } else {
                          // OrderItem.orderItemsList[key]!['Unit']= '';
                          OrderItem.orderItemsList2[key]?['Unit'] = '';
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Txt(
                    'جمع مبلغ',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
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
                        Obx(() {
                          return Txt(
                            '${ViewCustomController.getCalculateTotalPrice(OrderItem.orderItemsList2[key]!['Price'] == null ?OrderItem.orderItemsList2[key]!['Product_Name'] == null ? 0 : ViewCustomController.getProductPrice(productItems, OrderItem.orderItemsList2[key]!['Product_Name'] ?? productItems.first['_id']): OrderItem.orderItemsList2[key]!['Price'], (OrderItem.orderItemsList2[key]?['First_Dimension'] as num?)?.toDouble() ?? 0.0, (OrderItem.orderItemsList2[key]?['Second_Dimension'] as num?)?.toDouble() ?? 0.0, OrderItem.orderItemsList2[key]?['Quantity'] ?? 1)}',
                            color: MainController.isLightMode.value == true
                                ? whiteColor
                                : color2,
                          );
                        })
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              children: [
                Obx(() {
                  return Txt(
                    '${AppController.of(context)!.value('remove')}',
                    color: MainController.isLightMode.value == true
                        ? whiteColor
                        : color2,
                  );
                }),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    ViewCustomController.removeEditContainer(key);
                    ViewCustomController.isShowAlert.value = await ViewCustomController.showAlretEditOrder(ViewCustomController.order['Customer'] == null ? customerId : ViewCustomController.order['Customer']);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pinkAccent,
                    ),
                    padding: EdgeInsets.only(
                        right: 20, left: 20, top: 10, bottom: 10),
                    child:
                        Txt('${AppController.of(context)!.value('remove')} '),
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
    if (OrderItem.orderItemsList.containsKey(key)) {
      OrderItem.orderItemsList.remove(key);
      OrderItem.orderItemsList.refresh();
    }
    ViewCustomController.editContainers.remove(key);
    OrderItem.orderItemsList2.remove(key);
  }

// end order item edit page

  static checkOrder(context, productItems) async {
    if (ViewCustomController.order['Date'] == null) {
      ViewCustomController.order['Date'] =
          ViewCustomController.getDate(Jalali.now());
    }
    if (ViewCustomController.order['Type'] == null) {
      ViewCustomController.order['Type'] =
      MainController.getDetailsOfField('Orders', 'Type').items
          .first['value'];
    }

    bool validate = await RecordController.validate('Orders',
        ViewCustomController.order, MainController.getInfoTable('Orders'));

    if (validate == false) {
      if (productItems.length != 0) {
        if (ViewCustomController.isShowAlert.value == false) {
          ViewCustomController.addContainer(context, productItems);
        }
      } else {
        showSnackbar(snackTypes.error, 'کالایی ثبت نشده');
      }
    } else {
      showSnackbar(snackTypes.error,
          '${AppController.of(Get.context!)!.value('Please complete the order items')}');
    }
  }

  static checkEditOrder(context, productItems, {var data}) async {
    if (data['Date'] == null) {
      data['Date'] = ViewCustomController.getDate(Jalali.now());
    }
    if (data['Type'] == null) {
      data['Type'] = MainController.getDetailsOfField('Orders', 'Type')
          .items
          .first['value'];
    }

    bool validate = await RecordController.validate(
        'Orders', data, MainController.getInfoTable('Orders'));
    if (validate == false) {
      if (ViewCustomController.isShowAlert.value == false) {
        ViewCustomController.addEditContainer(context, productItems , ViewCustomController.order['Customer'] == null ? data['Customer']['_id'] : ViewCustomController.order['Customer']);
      }
    } else {
      showSnackbar(snackTypes.error,
          '${AppController.of(Get.context!)!.value('Please complete the order items')}');
    }
  }

  static goTableCustom({var table = null, var index}) async {
    table = MainController.getInfoTable('${MainController.tableName.value}');
    var tableName = table.schema.name;
    if (table.schema.view == 'custom') {
      var orderList = [];
      if (tableName == 'Orders') {
        print(
            'MainController.tableData[index]>>>${MainController.dataRecord[index]}');
        print('table schema name>>>${table.schema.name}');
        orderList = await DB('${table.schema.name}')
            .parent(
                parentId: MainController.dataRecord[index]['parent_id'],
                parentTable: 'Customer')
            .getRecords();
      }
      if (tableName == 'Order_Details') {
        var orderDetailsList =
            await ViewCustomController.getDataOrderDetailList(
                MainController.dataRecord[index]['_id']);
      }
      await HelperController.goToTablePage(
        table,
        tableFields: MainController.getInfoTable(table.schema.name),
      );
      HelperController.pageInateFunction();
    } else {
      var items = await DB('${table.schema.name}')
          .parent(
              parentId: MainController.dataRecord[index]['_id'],
              parentTable: MainController.infoSchema.value.schema.name)
          .getRecords();

      await HelperController.goToTablePage(table,
          tableFields: MainController.getInfoTable(table.schema.name),
          tableData: items);
    }
  }

  //order output
  static getDrawingNumberOrder(String orderDetailParentId) async {
    List<dynamic> ordersList = await DB('Orders').getRecords();
    for (var order in ordersList) {
      if (order['_id'] == orderDetailParentId) {
        return order['Drawing_Number'];
      }
    }
  }

  static calculateTotalAreaOrderDetail(
      double firstDimension, double secondDimension) {
    double result = firstDimension * secondDimension;
    return double.parse(result.toStringAsFixed(3));
  }

  static calculateTotalPriceOrderDetail(
      double firstDimension, double secondDimension, int quantity, int price) {
    final formatter = NumberFormat('#,##0', 'en_US');
    double totlalAreaOrderDetail =
        ViewCustomController.calculateTotalAreaOrderDetail(
            firstDimension, secondDimension);
    double totalPrice = totlalAreaOrderDetail * quantity * price;
    double rounded = double.parse(totalPrice.toStringAsFixed(2));
    return formatter.format(rounded);
  }

  static registerCheckout() async {
    for (var orderDetail in ViewCustomController.orderDetailsSelected.entries) {
      await DB('out_order_detail').storeRecord({
        'order_id': orderDetail.value['parent_id'],
        'order_item_id': orderDetail.value['_id'],
      });
    }
    ViewCustomController.orderDetailsSelected.value = {};
    ViewCustomController.ordersSelected.value = {};
    ViewCustomController.allOrdersSelected.value = [];
    ViewCustomController.isClickedBtnRegister.value = false;
    MainController.infoSchema.value.schema.currentPage = 1;
    ViewCustomController.getAllReocord('Orders');
    List<dynamic> ordersList = await DB('Orders').getRecords();
    await ViewCustomController.getStatusOutPutOrders(ordersList);
    MainController.dataRecord.value = await DB('Orders').paginate();
    MainController.allData.value = MainController.dataRecord.value;
  }

  static getOrderOutPut(String orderId) async {
    List filterOrder = await DB('out_order_detail')
        .where('order_id', '\$eq', orderId)
        .getRecords();
    return filterOrder;
  }

  static getOrderDetailOutPut(String orderDetailId) async {
    List filterOrderDetail = await DB('out_order_detail')
        .where('order_item_id', '\$eq', orderDetailId)
        .getRecords();
    return filterOrderDetail;
  }

  static Future<bool> getStatusOrders(String orderId) async {
    List<dynamic> orderOutPut = await getOrderOutPut(orderId);
    List<dynamic> orderDetails =
        await ViewCustomController.getDataOrderDetailList(orderId);
    if (orderOutPut.length == orderDetails.length) {
      return true;
    }
    return false;
  }

  static Future<bool> getStatusOrderDetail(String orderDetailId) async {
    List<dynamic> orderDetailOutPut = await getOrderDetailOutPut(orderDetailId);
    if (orderDetailOutPut.length != 0) {
      return true;
    }
    return false;
  }

  static getStatusOutPutOrders(List orderList) async {
    for (var order in orderList) {
      ViewCustomController.status['${order['_id']}'] =
          await ViewCustomController.getStatusOrders(order['_id']);
      print(
          'ViewCustomController.status>>>${ViewCustomController.status['${order['_id']}']}');
    }
  }

  static List getOrderDetailsOrderSelectedList() {
    RxList<dynamic> orderDetailsList = [].obs;
    for (var orderSelected in ViewCustomController.ordersSelected.entries) {
      for (var orderDetail in orderSelected.value) {
        orderDetailsList.add(orderDetail);
      }
    }
    return orderDetailsList;
  }

  static List<dynamic> paginate() {
    int currentPage = MainController.infoSchema.value.schema.currentPage ?? 1;
    int perPage = MainController.infoSchema.value.schema.countShowRow ?? 10;
    List<dynamic> records =
        ViewCustomController.getOrderDetailsOrderSelectedList();
    int start = (currentPage - 1) * perPage;
    int totalRecords =
        ViewCustomController.getOrderDetailsOrderSelectedList().length;
    MainController.pageInfo['Order_Details']?.start = start;
    var end = start + perPage;
    var endBycondition = end >= totalRecords ? totalRecords : end;
    MainController.pageInfo['Order_Details']?.end = endBycondition;
    return records.skip(start).take(perPage).toList();
  }

  static int getTotalPage() {
    var countShowRow = MainController.infoSchema.value.schema.countShowRow;
    int perPage = countShowRow != null ? countShowRow : 10;

    int totalRecords =
        ViewCustomController.getOrderDetailsOrderSelectedList().length;

    return (totalRecords / perPage).ceil();
  }

  static getStartIndexOutPutOrderItem() {
    int currentPage = MainController.infoSchema.value.schema.currentPage ?? 1;
    int perPage = MainController.infoSchema.value.schema.countShowRow ?? 10;
    int start = (currentPage - 1) * perPage;
    return start;
  }

  static getEndIndexOutPutOrderItem() {
    int perPage = MainController.infoSchema.value.schema.countShowRow ?? 10;
    var end = ViewCustomController.getStartIndexOutPutOrderItem() + perPage;
    int totalRecords =
        ViewCustomController.getOrderDetailsOrderSelectedList().length;
    var endBycondition = end >= totalRecords ? totalRecords : end;
    end = endBycondition;
    return end;
  }

  static updatePagenationInOutPutOrderItems() {
    int indexTable = MainController.menuList.value
        .indexWhere((element) => element.schema.name == "Order_Details");
    MainController.infoSchema.value = MainController.menuList[indexTable];
    MainController.pageInfo[MainController.menuList[indexTable].schema.name!]
        ?.start = ViewCustomController.getStartIndexOutPutOrderItem();
    MainController.pageInfo[MainController.menuList[indexTable].schema.name!]
        ?.end = ViewCustomController.getEndIndexOutPutOrderItem();
    MainController.pageInfo[MainController.menuList[indexTable].schema.name!]
            ?.totalRecords =
        ViewCustomController.getOrderDetailsOrderSelectedList().length;
    MainController.pageInfo[MainController.menuList[indexTable].schema.name!]
        ?.totalPage = ViewCustomController.getTotalPage();
    print(
        'total page>>>${MainController.pageInfo[MainController.menuList[indexTable].schema.name!]?.totalPage}');
    MainController.dataRecord.value = ViewCustomController.paginate();
  }
  //end order output


  static int generateCustomerCode() {
    final total = MainController
            .pageInfo[MainController.infoSchema.value.schema.name]
            ?.totalRecords ??
        0;

    return 1000 + total;
  }

  static String getDatePart(Jalali date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    String lastDigitOfYear = (year % 10).toString();
    String monthTwoDigits = month.toString().padLeft(2, '0');
    String dayTwoDigits = day.toString().padLeft(2, '0');

    return '$lastDigitOfYear$monthTwoDigits$dayTwoDigits';
  }

  static Future<int> generateOrderCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt('orderCounter') ?? 1000;
    return counter;
  }

  static Future<int> getNextOrderCounter() async {
    int counter = await generateOrderCounter();
    counter++;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('orderCounter', counter);
    return counter;
  }

  static Future<int> generateOrderCode(Jalali date) async {
    int counter = await generateOrderCounter();
    int datePart = int.parse(await getDatePart(date));
    int orderCode = int.parse('$datePart$counter');
    await getNextOrderCounter();
    return orderCode;
  }

  static Future<int> saveOrderCode(Jalali date) async {
    int counter = await generateOrderCounter();
    counter -= 1;
    int datePart = int.parse(await getDatePart(date));
    int orderCode = int.parse('$datePart$counter');
    return orderCode;
  }

  static Future<int> generateDrawingNumber() async {
    int counter = await generateOrderCounter();
    await getNextOrderCounter();
    return counter;
  }

  static Future<int> calculateAllpriceOrderItem() async {
    int totalPrice = 0;

    for (var orderItem in OrderItem.orderItemsList.value.values) {
      final price = orderItem['Price'];

      if (price != null) {
        totalPrice += (price as num).toInt();
      }
    }

    return totalPrice;
  }

  static Future<bool> showAlret() async {
    var customers = await DB('Customer')
        .where('_id', '\$eq', ViewCustomController.order['Customer'])
        .getRecords();
    int totlaPrice = await calculateAllpriceOrderItem();
    for (var customer in customers) {
      if(customer['Credit_Limit'] != null){
        if (totlaPrice < customer['Credit_Limit']) {
          return false;
        }
        else {
          return true;
        }
      }

    }
    return false;
  }

  static Future<int> calculateAllpriceEditOrderItem() async {
    int totalPrice = 0;
    Map<String, dynamic> result = {};
    result.addAll(OrderItem.orderItemsList.value);
    result.addAll(OrderItem.orderItemsList2.value);

    for (var orderItem in result.values) {
      final price = orderItem['Price'];

      if (price != null) {
        totalPrice += (price as num).toInt();
      }
    }
    return totalPrice;
  }
  static Future<bool> showAlretEditOrder(String customerId) async {
    var customers = await DB('Customer')
        .where('_id', '\$eq', customerId)
        .getRecords();
    int totlaPrice = await calculateAllpriceEditOrderItem();
    for (var customer in customers) {
      if (totlaPrice < customer['Credit_Limit']) {
        return false;
      } else {
        return true;
      }
    }
    return false;
  }
  static getAllReocord(String tableName) async {
    TableModel pageInfo = await MainController.getInfoTable('${tableName}');
    pageInfo.schema.currentPage = 0;
    pageInfo.schema.countShowRow = 0;
  }
  static Future<String> getTitleSelectedItem(
      String tableName, String selectedId, var column) async {
    String selectedTitle = '';
    var sourceItem = column.sourceItems;
    if (sourceItem != 'custom') {
      if (selectedId != '') {
        var object =
        (await DB(tableName).where('_id', '\$eq', selectedId).getRecords());
        if (object.length == 0) {
          selectedTitle =
          '${AppController.of(Get.context!)!.value('Uncertain')}';
        } else {
          for(var data in object){
            if(tableName == 'Customer'){
              selectedTitle = data['Name_and_lastName'];
            }
            else{
              selectedTitle = data['Title'];
            }
          }
        }
      } else {
        selectedTitle = '';
      }
    } else {
      if (selectedId != '') {
        Map<String, dynamic> selectedItem = column.items.firstWhere(
                (element) => element['value'] == selectedId,
            orElse: () => {'error': ''});
        if (selectedItem['title'] != null) {
          selectedTitle = selectedItem['title'];
        } else {
          selectedTitle = selectedItem['error'];
        }
      } else {
        selectedTitle = '';
      }
    }
    return selectedTitle;
  }
  static Widget generateCellFileBox() {
    return Column(
      children: [
        Center(
            child: Image.network(
              '$baseUrl/storage/696ca25717c593e594ee637b/Orders/files/${ViewCustomController.order['Picture2']}',
              width: 60,
              height: 60,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return Image.asset(
                  fileImage,
                  width: 60,
                  height: 60,
                ); // عکس جایگزین
              },
            )
        ),
      ],
    );
  }
  static Widget generateEditCellFileBox(var data) {
    String url = '';
    if(data['Picture2'].contains('/storage/696ca25717c593e594ee637b/Orders/files/')){
      url = baseUrl + data['Picture2'];
    }
    else{
      url = '$baseUrl/storage/696ca25717c593e594ee637b/Orders/files/${data['Picture2']}';
    }
    return Column(
      children: [
        Center(
            child: Image.network(
              url,
              width: 60,
              height: 60,
              fit: BoxFit.fill,
              errorBuilder: (BuildContext context, Object error,
                  StackTrace? stackTrace) {
                return Image.asset(
                  fileImage,
                  width: 60,
                  height: 60,
                ); // عکس جایگزین
              },
            )
        ),
      ],
    );
  }

//end order & orderdetail



}
