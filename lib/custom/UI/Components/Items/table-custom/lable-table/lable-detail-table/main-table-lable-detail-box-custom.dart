import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/Admin/Public/styles.dart';
import 'package:finance/Admin/UI/Componenets/General/column-scroll.dart';
import 'package:finance/Admin/UI/Componenets/General/txt.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-footer.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table-header.dart';
import 'package:finance/Admin/UI/Componenets/Items/Table/table.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/lable-detail-table/table-lable-detail-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/lable-table/table-lable-custom.dart';
import 'package:finance/custom/UI/Components/Items/table-custom/order-table/table-custom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance/Admin/Logic/Controllers/app-controller.dart';
import 'package:finance/Admin/Logic/Models/db.dart';
import 'package:get/get.dart';

class MainTableLableDetailBoxCustom extends StatefulWidget {
  MainTableLableDetailBoxCustom(this.index);
  String index;

  @override
  State<MainTableLableDetailBoxCustom> createState() => _MainTableLableDetailBoxCustomState();
}

class _MainTableLableDetailBoxCustomState extends State<MainTableLableDetailBoxCustom> {
  TextEditingController fromController = TextEditingController(text: '1');
  TextEditingController toController = TextEditingController(text: '1');
  List<dynamic> orderDetailsListLocal = [];
  Future<void> loadData() async {
    orderDetailsListLocal = await ViewCustomController.getDataOrderDetailList(widget.index);
  }
  Future<void> selectRangeRows() async {
    int? from = int.tryParse(fromController.text);
    int? to = int.tryParse(toController.text);

    if (from == null || to == null) return;

    if (from < 1) from = 1;

    if (to > orderDetailsListLocal.length) {
      to = orderDetailsListLocal.length;
    }
    ViewCustomController.lableDetailSelected.clear();
    int start = (from ?? 1);
    int end = (to ?? orderDetailsListLocal.length);
    for (int i = start - 1; i < end; i++) {
      var row = orderDetailsListLocal[i];
      ViewCustomController.lableDetailSelected.add(row);
    }
    ViewCustomController.lableDetailSelected.refresh();
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
  }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Txt('لیست سفارش ها' , color: MainController.isLightMode.value == true
                    ? whiteColor
                    : dark2),
                  ],
                ),
                SizedBox(height: 20,),
                Center(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing:10,
                    runSpacing:10,
                    children: [
                      IntrinsicWidth(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                MainController.isLightMode.value
                                    ? whiteColor
                                    : primaryDark,
                              ),
                              child: Obx((){
                                return Checkbox(
                                  value: ViewCustomController.lableDetailSelected.length ==
                                      MainController.dataRecord.value.length &&
                                      MainController.dataRecord.value.isNotEmpty,
                                  onChanged: (val) async {
                                    if (val == true) {
                                      ViewCustomController.lableDetailSelected.assignAll(orderDetailsListLocal);
                                    } else {
                                      ViewCustomController.lableDetailSelected.clear();
                                    }
                                    ViewCustomController.lableDetailSelected.refresh();
                                  },
                                  activeColor: colorBtn,
                                  checkColor: whiteColor,
                                  side: BorderSide(
                                      color:
                                      MainController.isLightMode.value
                                          ? whiteColor
                                          : primaryDark,
                                      width: 2),
                                  // border
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {},
                              child: Txt(
                                'همه موارد',
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: MainController.isLightMode.value
                                    ? whiteColor
                                    : color2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IntrinsicWidth(child: Row(
                        children: [
                          Txt('از', color: MainController.isLightMode.value ? whiteColor : dark2),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              controller: fromController,
                              readOnly: true,
                              style: TextStyle(
                                color: MainController.isLightMode.value ? whiteColor : dark2,
                              ),
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.transparent,
                                contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                suffixIcon: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        int current = int.tryParse(fromController.text) ?? 1;
                                        current++;
                                        fromController.text = current.toString();
                                        await selectRangeRows();
                                      },
                                      child:  Icon(Icons.arrow_drop_up, size: 20 , color: MainController.isLightMode.value ? whiteColor : dark2,),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        int current = int.tryParse(fromController.text) ?? 1;
                                        current = (current > 1) ? current - 1 : 1;
                                        fromController.text = current.toString();
                                        await selectRangeRows();
                                      },
                                      child:  Icon(Icons.arrow_drop_down, size: 20 , color: MainController.isLightMode.value ? whiteColor : dark2),
                                    ),
                                  ],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:  BorderSide(color: MainController.isLightMode.value ? whiteColor : dark2, width: 1.0), // Border پیش‌فرض خاکستری
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:  BorderSide(color: MainController.isLightMode.value ? whiteColor : dark2, width: 1.0),
                                ),
                              ),
                              onChanged: (value) {
                              },
                            ),
                          ),
                        ],
                      ),),
                      IntrinsicWidth(child: Row(
                        children: [
                          Txt('تا', color: MainController.isLightMode.value ? whiteColor : dark2),
                          const SizedBox(width: 5),
                          SizedBox(
                              width: 70,
                              child: TextFormField(
                                controller:toController,
                                readOnly: true,
                                style: TextStyle(
                                  color: MainController.isLightMode.value ? whiteColor : dark2,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8), // کمی padding اضافه
                                  suffixIcon: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          int current = int.tryParse(toController.text) ?? 1;
                                          current++;
                                          toController.text = current.toString();
                                          await selectRangeRows();
                                        },
                                        child:  Icon(Icons.arrow_drop_up, size: 20 , color: MainController.isLightMode.value ? whiteColor : dark2),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          int current = int.tryParse(toController.text) ?? 1;
                                          current = (current > 1) ? current - 1 : 1;
                                          toController.text = current.toString();
                                          await selectRangeRows();
                                        },
                                        child:  Icon(Icons.arrow_drop_down, size: 20 , color: MainController.isLightMode.value ? whiteColor : dark2),
                                      ),
                                    ],
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:  BorderSide(color: MainController.isLightMode.value ? whiteColor : dark2, width: 1.0), // Border پیش‌فرض خاکستری
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide:  BorderSide(color: MainController.isLightMode.value ? whiteColor : dark2, width: 1.0), // Border در حالت غیرفعال
                                  ),
                                ),
                                onChanged: (value) {
                                  int? parsedValue = int.tryParse(value);
                                  if (parsedValue != null) {

                                  }
                                },
                              )
                          ),
                        ],
                      ),),
                      IntrinsicWidth(child: InkWell(
                        onTap: () async {},
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: notCheckedOutBtnColor,
                              ),
                              child: Txt('چاپ برچسب بزرگ' , color: whiteColor,),
                            ),
                          ),
                        ),
                      ),)

                    ],
                  ),
                ),
                TableHeader(),
                if(MainController.tableName.value == 'lable')
                  TableLableDetailBoxCustom(widget.index),
                SizedBox(
                  height: 20,
                ),
                TableFooter(index: MainController.menuList.value.indexWhere((element) => element.schema.name=="Order_Details")),
              ],
            );
          }),
        ],
      ),
    );
  }
}
