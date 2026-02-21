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
    print(
        '_DetailCreateState.initState pat>>${MainController.getDetailsOfField('order_detail', 'hardness')}>>>${MainController.getDetailsOfField('order_detail', 'pattern')}');
    patterns = MainController.getDetailsOfField('order_detail', 'pattern') !=
            null
        ? MainController.getDetailsOfField('order_detail', 'pattern')['items']
        : [];
    hardnesses = MainController.getDetailsOfField('order_detail', 'hardness') !=
            null
        ? MainController.getDetailsOfField('order_detail', 'hardness')['items']
        : [];
    CustomController.orderDetailRequest[widget.ky] = {
      'dimension1': 0.0,
      'dimension2': 0.0,
    };
    metrage[widget.ky]=0;
    priceDetail[widget.ky]=0;
  }
  Map<String, TextEditingController> priceControllers = {};

  @override
  Widget build(BuildContext context) {
    print('_DetailCreateState.build>>${widget.products}');
    return Obx(() {
      return Container(
        key: ValueKey(widget.ky),
        child: Wrap(
          children: [
            Input(
              width: 100,
              lable: 'بعد اول',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['dimension1'] = value;
                metrage.value[widget.ky]=CustomController.Meterage(d1: CustomController.orderDetailRequest[widget.ky]!['dimension1'],d2: CustomController.orderDetailRequest[widget.ky]!['dimension2']);
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
              width: 100,
              lable: 'بعد دوم',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['dimension2'] = value;
                metrage[widget.ky]=CustomController.Meterage(d1: CustomController.orderDetailRequest[widget.ky]!['dimension1'],d2: CustomController.orderDetailRequest[widget.ky]!['dimension2']);

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
        '${metrage[widget.ky]}',
          ),
        // }),
            SizedBox(
              width: 10,
            ),
            Input(
              width: 100,
              lable: 'تعداد',
              isNumber: true,
              onChange: (value) {
                CustomController.orderDetailRequest[widget.ky]!['count'] = value;
              },
            ),
            SizedBox(
              width: 10,
            ),
            Input(
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
                CustomController.orderDetailRequest[widget.ky]!['product'] = newId;

                final product = widget.products.firstWhere(
                      (item) => item['_id'] == newId,
                );

                // ساخت controller در صورت نبودن
                priceControllers.putIfAbsent(
                  widget.ky,
                      () => TextEditingController(),
                );

                // ست قیمت داخل input
                priceControllers[widget.ky]!.text = product['price'].toString();

                CustomController.orderDetailRequest[widget.ky]!['price_product'] = product['price'];
                priceDetail[widget.ky]=CustomController.priceDetail(count: CustomController.orderDetailRequest[widget.ky]!['count'] ,metrage:metrage[widget.ky]! ,priceProduct:  CustomController.orderDetailRequest[widget.ky]!['price_product'] );
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
                  CustomController.orderDetailRequest[widget.ky]!['price_product'] = value;
                  priceDetail[widget.ky]=CustomController.priceDetail(count: CustomController.orderDetailRequest[widget.ky]!['count'] ,metrage:metrage[widget.ky]! ,priceProduct:  CustomController.orderDetailRequest[widget.ky]!['price_product'] );

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
              },
            ),
            SizedBox(
              width: 10,
            ),
            DropdownButton<String>(
              hint: Text('یک گزینه انتخاب کنید'),
              value: !selectedPattern.containsKey(widget.ky)
                  ? null
                  : selectedPattern[widget.ky],
              items: patterns.map<DropdownMenuItem<String>>((option) {
                return DropdownMenuItem<String>(
                  value: option['value'],
                  // این مقداری هست که وقتی انتخاب شد برمی‌گرده
                  child:
                      Text(option['title']!), // این متنی هست که نمایش داده میشه
                );
              }).toList(),
              onChanged: (value) {
                CustomController.orderDetailRequest[widget.ky]!['pattern'] =
                    value;
              },
            ),
          ],
        ),
      );
    });
  }
}
