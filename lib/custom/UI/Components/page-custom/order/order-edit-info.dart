import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Controllers/helper-controller.dart';
import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/Logic/Models/order-item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderEditInfo extends StatefulWidget {
  OrderEditInfo({this.table , this.data});

  var table;
  List<dynamic>? productItems;
  var data;

  @override
  State<OrderEditInfo> createState() => _OrderEditInfoState();
}

class _OrderEditInfoState extends State<OrderEditInfo> {
  RxString customerTitle = ''.obs;
  RxString typeTitle = ''.obs;
  RxMap<String, String> productTitles = <String, String>{}.obs;
  RxList productItems = [].obs;
  Map<String, dynamic> result = {};


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTitle();
      _loadProductItems();
    });
  }

  Future<void> _loadTitle() async {
    String customerId = widget.data['Customer']['_id'];
    String typeId = widget.data['Type']['value'];
    String resultCustomer = await ViewCustomController.getTitleSelectedItem(
      'Customer',
      customerId,
      MainController.getDetailsOfField('Orders', 'Customer'),
    );
    String resultType = await ViewCustomController.getTitleSelectedItem(
      'Type',
      typeId,
      MainController.getDetailsOfField('Orders', 'Type'),
    );
    for (var orderItem in OrderItem.orderItemsList.values.toList()) {
      String productId = orderItem['Product_Name']['_id'];
      String resultProduct = await ViewCustomController.getTitleSelectedItem(
        'Product',
        productId,
        MainController.getDetailsOfField('Order_Details', 'Product_Name'),
      );
      productTitles[productId] = resultProduct ?? '';
    }
    customerTitle.value = resultCustomer?.toString() ?? '';
    typeTitle.value = resultType?.toString() ?? '';
  }

  Future<void> _loadProductItems() async {
    ViewCustomController.getAllReocord('Product');
    productItems.value = await DB('Product').getRecords();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    result.addAll(OrderItem.orderItemsList.value);
    result.addAll(OrderItem.orderItemsList2.value);
    final formatter = NumberFormat('#,###');

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: backgroundLight,
        ),
        padding: const EdgeInsets.all(30),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 50,
                runSpacing: 20,
                children: [
                  Txt(
                    'کد ورودی: ${widget.data['Input_Code'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'شماره نقشه: ${widget.data['Drawing_Number'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'شماره نقشه (مشتری): ${widget.data['Drawing_Number(customer)'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'نوع: ${typeTitle.value}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'مشتری: ${customerTitle.value}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'تاریخ: ${widget.data['Date'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Row(
                    children: [
                      Txt(
                        'عکس:',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color2,
                      ),
                      widget.data['Picture2'] != null
                          ? ViewCustomController.generateEditCellFileBox(widget.data)
                          : Container(),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  for (var i = 0; i < result.values.toList().length; i++)
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'نام کالا: ${result.values.toList()[i]['Product_Name'] is Map
                                  ? productTitles[result.values.toList()[i]['Product_Name']['_id']] ?? ''
                                  : productTitles[result.values.toList()[i]['Product_Name']] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'قیمت: ${formatter.format(result.values.toList()[i]['Price'] ?? '')}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'بعد اول: ${result.values.toList()[i]['First_Dimension'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'بعد دوم: ${result.values.toList()[i]['Second_Dimension'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'تعداد: ${result.values.toList()[i]['Quantity'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'جمع متراژ: ${ViewCustomController.getCalculateTotalArea(
                                (result.values.toList()[i]['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                (result.values.toList()[i]['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                              )}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: productItems.value.isNotEmpty
                                ? Txt(
                              'جمع مبلغ: ${ViewCustomController.getCalculateTotalPrice(
                                result.values.toList()[i]['Price'],
                                (result.values.toList()[i]['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                (result.values.toList()[i]['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                                result.values.toList()[i]['Quantity'] ?? 1,
                              )}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            )
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final route = ModalRoute.of(context);
                  if (route != null) {
                    Navigator.of(context).removeRoute(route);
                  }
                  if(MainController.infoSchema.value.schema.name == 'Customer'){
                    for (var i = 0; i < MainController.dataRecord.length; i++){
                      ViewCustomController.goTableCustom(table: MainController.tableName.value,index: i);
                    }
                  }
                  else if(MainController.infoSchema.value.schema.name == 'Orders'){
                    HelperController.goToTablePage(widget.table);
                  }
                  ViewController.isClickedBtn.value = false;
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: colorBtn, width: 1),
                    color: colorBtn,
                  ),
                  child: Txt(
                    AppController.of(context)!.value('back'),
                    color: whiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
