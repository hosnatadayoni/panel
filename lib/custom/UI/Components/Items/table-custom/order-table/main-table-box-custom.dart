import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/table-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:get/get.dart';

class MainTableBoxCustom extends StatefulWidget {
  MainTableBoxCustom(this.table);
  var table;

  @override
  State<MainTableBoxCustom> createState() => _MainTableBoxCustomState();
}

class _MainTableBoxCustomState extends State<MainTableBoxCustom> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: MainController.isLightMode.value == true
              ? background
              : whiteColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          border: Border.all(
              color: MainController.isLightMode.value == true
                  ? background
                  : dark2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return ColumnScroll(
              children: [
                TableHeader(),
                if (MainController.infoSchema.value.schema.filters != null &&
                    MainController.infoSchema.value.schema.filters!.length != 0)
                  Container(
                    width: size.width > 800
                        ? MainController.isClickedItem.value == true
                            ? (size.width) - 300
                            : (size.width) - 50
                        : (size.width) - 50,
                    child: ViewController.filters.isEmpty
                        ? CircularProgressIndicator()
                        : Wrap(
                            crossAxisAlignment: WrapCrossAlignment.start,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (var future in ViewController.filters) future
                            ],
                          ),
                  ),
                if (MainController.infoSchema.value.schema.filters != null &&
                    MainController.infoSchema.value.schema.filters!.length != 0)
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    width: 140,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.blue),
                      onPressed: () async {
                        List<dynamic> w =
                            MainController.infoSchema.value.schema.filters!;
                        String opration = '\$eq';
                        if (ViewController.request.length != 0) {
                          var d;
                          List<dynamic> d2 = [];
                          var a = DB(
                              '${MainController.infoSchema.value.schema.name}');
                          print(
                              '_MainTableBoxState.build>>>${ViewCustomController.order}');

                          for (var filter in ViewCustomController.order.values) {
                            print(
                                '_MainTableBoxState.build>> filter ${filter}');
                            if (filter != null) {
                              var indexFilter = w.indexWhere((element) =>
                              element['column'] == filter['column']);
                              if (indexFilter != -1) {
                                if (w[indexFilter]['operator'] != null) {
                                  opration = w[indexFilter]['operator'];
                                }
                                if (filter['value'] != '' &&
                                    filter['value'] != null) {
                                  print(
                                      '_MainTableBoxState.build where where>>${filter['value']}');
                                  d = a.where('${filter['column']}',
                                      '${filter['operator']}', filter['value']);
                                }
                              } else {
                              }
                            }
                          }
                          if (d != null) {
                            d2 = await d.getRecords();
                          } else {
                            d2 = await DB(
                                    '${MainController.infoSchema.value.schema.name}')
                                .getRecords();
                          }
                          MainController.dataRecord.value = d2;
                        }
                      },
                      child: Center(
                          child: Txt(
                              '${AppController.of(context)!.value('apply')}',
                              textAlign: TextAlign.center)),
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
                if(MainController.tableName.value == 'Orders')
                    TableBoxCustom(widget.table),
                SizedBox(
                  height: 20,
                ),
                TableFooter(index: MainController.menuList.value.indexWhere((element) => element.schema.name=="Orders")),
              ],
            );
          }),
        ],
      ),
    );
  }
}
