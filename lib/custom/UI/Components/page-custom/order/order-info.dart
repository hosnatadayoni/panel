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

class OrderInfo extends StatefulWidget {
  OrderInfo({this.table});

  var table;
  List<dynamic>? productItems;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}

class _OrderInfoState extends State<OrderInfo> {
  RxString customerTitle = ''.obs;
  RxString typeTitle = ''.obs;
  RxMap<String, String> productTitles = <String, String>{}.obs;
  RxList productItems = [].obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTitle();
      _loadProductItems();
    });
  }

  Future<void> _loadTitle() async {
    String customerId = ViewCustomController.order['Customer'];
    String typeId = ViewCustomController.order['Type'];
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
      String productId = orderItem['Product_Name'];
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
                    'کد ورودی: ${ViewCustomController.order['Input_Code'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'شماره نقشه: ${ViewCustomController.order['Drawing_Number'] ?? ''}',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: color2,
                  ),
                  Txt(
                    'شماره نقشه (مشتری): ${ViewCustomController.order['Drawing_Number(customer)'] ?? ''}',
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
                    'تاریخ: ${ViewCustomController.order['Date'] ?? ''}',
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
                      ViewCustomController.order['Picture2'] != null
                          ? ViewCustomController.generateCellFileBox()
                          : Container(),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  for (var orderItem in OrderItem.orderItemsList.values.toList())
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'نام کالا: ${productTitles[orderItem['Product_Name']] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'قیمت: ${formatter.format(orderItem['Price']) ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'بعد اول: ${orderItem['First_Dimension'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'بعد دوم: ${orderItem['Second_Dimension'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'تعداد: ${orderItem['Quantity'] ?? ''}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: color2,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Txt(
                              'جمع متراژ: ${ViewCustomController.getCalculateTotalArea(
                                (orderItem['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                (orderItem['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
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
                                orderItem['Price'],
                                (orderItem['First_Dimension'] as num?)?.toDouble() ?? 0.0,
                                (orderItem['Second_Dimension'] as num?)?.toDouble() ?? 0.0,
                                orderItem['Quantity'] ?? 1,
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
                  if (MainController.infoSchema.value.schema.name ==
                      'Customer') {
                    for (var i = 0; i < MainController.dataRecord.length; i++) {
                      await ViewCustomController.goTableCustom(
                        table: MainController.tableName.value,
                        index: i,
                      );
                    }
                  } else if (MainController.infoSchema.value.schema.name ==
                      'Orders') {
                    await HelperController.goToTablePage(widget.table);
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
