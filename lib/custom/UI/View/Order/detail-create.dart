import 'package:finance/Custom/UI/Cumponent/Inputs/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Admin/Logic/Controllers/main-controller.dart';
import '../../../Logic/controller.dart';

class DetailCreate extends StatefulWidget {
  final String ky;
  final List<Map<String, dynamic>> products;

  DetailCreate({
    required this.ky,
    required this.products,
  });

  @override
  State<DetailCreate> createState() => _DetailCreateState();
}

class _DetailCreateState extends State<DetailCreate> {
  RxMap<String, String> selectedProduct = <String, String>{}.obs;
  RxMap<String, String> selectedPattern = <String, String>{}.obs;
  RxMap<String, String> selectedHardness = <String, String>{}.obs;
  var patterns = [];
  var hardnesses = [];
  RxMap<String, int> priceProduct = <String, int>{}.obs;
  RxMap<String, double> metrage = <String, double>{}.obs;
  RxMap<String, int> priceDetail = <String, int>{}.obs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print('_DetailCreateState.initState pat>>${MainController.getDetailsOfField('order_detail', 'hardness')}>>>${MainController.getDetailsOfField('order_detail', 'pattern')}');
      patterns = MainController.getDetailsOfField('order_detail', 'pattern') !=
              null
          ? MainController.getDetailsOfField('order_detail', 'pattern').items
          : [];
      hardnesses =
          MainController.getDetailsOfField('order_detail', 'hardness') != null
              ? MainController.getDetailsOfField(
                  'order_detail', 'hardness').items
              : [];

      final oldData = CustomController.orderDetailRequest[widget.ky] ?? {};
      if (oldData.length != 0) {
        if (oldData['product'] != null) {
          priceProduct[widget.ky] = int.parse(oldData['product']['price'].toString());
          priceControllers.putIfAbsent(widget.ky, () => TextEditingController(),);

          // ست قیمت داخل input
          priceControllers[widget.ky]!.text = oldData['product']['price'].toString();
          selectedProduct[widget.ky] = oldData['product']['_id'];
        }
        selectedHardness[widget.ky] = oldData['hardness'] != null
            ? oldData['hardness']['value']
            : hardnesses.first['value'];
        selectedPattern[widget.ky] = oldData['pattern'] != null
            ? oldData['pattern']['value']
            : patterns.first['value'];
      }

      CustomController.orderDetailRequest[widget.ky] = {
        ...oldData,
        'dimension1': oldData['dimension1'] ?? 0.0,
        'dimension2': oldData['dimension2'] ?? 0.0,
        'count': oldData['count'] ?? 1,
        'product': oldData['product']!=null?  oldData['product']['_id']:null,
        'pattern': oldData['pattern']!=null?  oldData['pattern']['value']:null,
        'hardness': oldData['hardness']!=null?  oldData['hardness']['value']:null,
      };
      // CustomController.orderDetailRequest[widget.ky] = {
      //     'dimension1': CustomController.orderDetailRequest[widget.ky]!.length != 0 && CustomController.orderDetailRequest[widget.ky]!['dimension1'] != null
      //         ? CustomController.orderDetailRequest[widget.ky]!['dimension1']
      //         : 0,
      //     'dimension2': CustomController.orderDetailRequest[widget.ky]!.length != 0 && CustomController.orderDetailRequest[widget.ky]!['dimension2'] != null
      //         ? CustomController.orderDetailRequest[widget.ky]!['dimension2']
      //         : 0,
      //   ...CustomController.orderDetailRequest[widget.ky]
      // };

     CustomController.orderDetailRequest[widget.ky]!['metrage'] = CustomController.Meterage(
          d1: CustomController.orderDetailRequest[widget.ky]!['dimension1'],
          d2: CustomController.orderDetailRequest[widget.ky]!['dimension2']);
      priceDetail[widget.ky] = CustomController.priceDetail(
          metrage:CustomController.orderDetailRequest[widget.ky]!['metrage'] ?? 0,
          count: CustomController.orderDetailRequest[widget.ky]!['count'],
          priceProduct: priceProduct[widget.ky] ?? 0);
    });
  }

  Map<String, TextEditingController> priceControllers = {};

  @override
  Widget build(BuildContext context) {
    print('_DetailCreateState.build>>${widget.products}');
    return Obx(() {
      Map<String, dynamic> value =
          CustomController.orderDetailRequest[widget.ky] ?? {};
      return Container(
        key: ValueKey(widget.ky),
        child: Wrap(
          children: [
            Input(
              controller: TextEditingController(
                text: value['dimension1']?.toString() ?? '',
              ),
              width: 100,
              lable: 'بعد اول',

              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['dimension1'] = double.parse(value);
               CustomController.orderDetailRequest[widget.ky]!['metrage'] = CustomController.Meterage(
                    d1: CustomController.orderDetailRequest[widget.ky]!['dimension1'],
                    d2: CustomController.orderDetailRequest[widget.ky]!['dimension2']);

                priceDetail[widget.ky]= CustomController.priceDetail(
                    metrage:CustomController.orderDetailRequest[widget.ky]!['metrage'] ?? 0,
                    count: CustomController.orderDetailRequest[widget.ky]!['count'],
                    priceProduct: priceProduct[widget.ky] ?? 0);
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
              controller: TextEditingController(
                text: value['dimension2']?.toString() ?? '',
              ),              width: 100,
              lable: 'بعد دوم',
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['dimension2'] =
                    double.parse(value);
                CustomController.orderDetailRequest[widget.ky]!['metrage'] = CustomController.Meterage(
                    d1: CustomController.orderDetailRequest[widget.ky]!['dimension1'],
                    d2: CustomController.orderDetailRequest[widget.ky]!['dimension2']);
                print('CustomController.orderDetailRequest[widget.ky]>>>${CustomController.orderDetailRequest[widget.ky]!['metrage']}');
                priceDetail[widget.ky]= CustomController.priceDetail(
                    metrage:CustomController.orderDetailRequest[widget.ky]!['metrage'] ?? 0,
                    count: CustomController.orderDetailRequest[widget.ky]!['count'],
                    priceProduct: priceProduct[widget.ky] ?? 0);
              },
            ),

            SizedBox(
              width: 10,
            ),
            // Obx(() {
            //   final d1 = CustomController.orderDetailRequest[widget.ky]!['dimension1']!.value;
            //   final d2 = CustomController.orderDetailRequest[widget.ky]!['dimension2']!.value;
            //   print('_DetailCreateState.build d1>>${d1}');
            //       return
            Text(
              '${CustomController.orderDetailRequest[widget.ky]!['metrage']}',
            ),
            // }),
            SizedBox(
              width: 10,
            ),
            Input(
              controller: TextEditingController(
                text: value['count']?.toString() ?? '1',
              ),              width: 100,
              lable: 'تعداد',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['count'] =
                    value;
                priceDetail[widget.ky]= CustomController.priceDetail(
                    metrage:CustomController.orderDetailRequest[widget.ky]!['metrage'] ?? 0,
                    count: CustomController.orderDetailRequest[widget.ky]!['count'],
                    priceProduct: priceProduct[widget.ky] ?? 0);
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
              controller: TextEditingController(
      text: value['block']?.toString() ?? '',
      ),
              width: 100,
              lable: 'بلوک',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['block'] =
                    value;
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
              controller: TextEditingController(
                text: value['floor']?.toString() ?? '',
              ),
              width: 100,
              lable: 'طبقه',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['floor'] =
                    value;
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
              controller: TextEditingController(
                text: value['unit']?.toString() ?? '',
              ),
              width: 100,
              lable: 'واحد',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['unit'] = value;
              },
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              hint: const Text("یک گزینه انتخاب کنید"),
              value: selectedProduct[widget.ky],
              items: widget.products.map<DropdownMenuItem<String>>((item) {
                return DropdownMenuItem<String>(
                  value: item['_id'],
                  child: Text(item['title'] ?? 'انتخاب نشده'),
                );
              }).toList(),
              onChanged: (String? newId) {
                if (newId == null) return;

                selectedProduct[widget.ky] = newId;
                CustomController.orderDetailRequest[widget.ky]!['product'] =
                    newId;

                final product = widget.products.firstWhere(
                  (item) => item['_id'] == newId,
                );

                // ساخت controller در صورت نبودن
                priceControllers.putIfAbsent(widget.ky, () => TextEditingController(),);

                // ست قیمت داخل input
                priceControllers[widget.ky]!.text = product['price'].toString();

                CustomController
                        .orderDetailRequest[widget.ky]!['price_product'] =
                    product['price'];
                priceDetail[widget.ky] = CustomController.priceDetail(
                    count: CustomController
                        .orderDetailRequest[widget.ky]!['count'],
                    metrage:CustomController.orderDetailRequest[widget.ky]!['metrage']!,
                    priceProduct: CustomController
                        .orderDetailRequest[widget.ky]!['price_product']);
              },
            ),

            const SizedBox(width: 10),

            if (selectedProduct[widget.ky] != null)
              Input(
                controller: priceControllers[widget.ky],
                width: 100,
                lable: 'قیمت محصول',
                isNumber: true,
                onChange: (value) {
                  priceControllers[widget.ky]!.text = value.toString();
                  CustomController
                      .orderDetailRequest[widget.ky]!['price_product'] = value;
                  priceDetail[widget.ky] = CustomController.priceDetail(
                      count: CustomController
                          .orderDetailRequest[widget.ky]!['count'],
                      metrage:CustomController.orderDetailRequest[widget.ky]!['metrage']!,
                      priceProduct: CustomController
                          .orderDetailRequest[widget.ky]!['price_product']);
                },
              ),
            const SizedBox(width: 10),
            Text(
              '${priceDetail[widget.ky]}',
            ),
            const SizedBox(width: 10),
            DropdownButton<String>(
              hint: Text('یک گزینه انتخاب کنید'),
              value: !selectedHardness.containsKey(widget.ky)
                  ? null
                  : selectedHardness[widget.ky],
              items: hardnesses.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  // این مقداری هست که وقتی انتخاب شد برمی‌گرده
                  child:
                      Text(option['title']!), // این متنی هست که نمایش داده میشه
                );
              }).toList(),
              onChanged: (value) {
                CustomController.orderDetailRequest[widget.ky]!['hardness'] =
                    value;
                selectedHardness[widget.ky]=value!;
              },
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              hint: Text('یک گزینه انتخاب کنید'),
              value: !selectedPattern.containsKey(widget.ky) ? null : selectedPattern[widget.ky],
              items: patterns.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  // این مقداری هست که وقتی انتخاب شد برمی‌گرده
                  child:
                      Text(option['title']!), // این متنی هست که نمایش داده میشه
                );
              }).toList(),
              onChanged: (value) {
                CustomController.orderDetailRequest[widget.ky]!['pattern'] = value;
                selectedPattern[widget.ky]=value!;
              },
            ),
          ],
        ),
      );
    });
  }
}
