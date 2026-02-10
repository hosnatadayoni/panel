import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Admin/Logic/Controllers/main-controller.dart';
import '../../Admin/Logic/Models/db.dart';

class CustomController extends GetxController {
  static RxMap<String, dynamic> orderRequest = <String, dynamic> {}.obs;
  static RxMap<String, Map<String, dynamic>> orderDetailRequest = <String, Map<String, dynamic>>{}.obs;
  static int Meterage({int? d1, int? d2}) {
    if (d1 != null && d2 != null) {
      return d1 * d2;
    }
    return  0;
  }
  static int priceDetail({int metrage=0, int count=0, int priceProduct=0}){
    return metrage*count*priceProduct;

  }
  static addColumnOrderTable() async {
    bool checkMetarge=MainController.tableInfo['columns'].any((element) => element['name'] == 'metrage');
    bool checkCountJum=MainController.tableInfo['columns'].any((element) => element['name'] == 'jum_count');
    print('HelperController.goToTablePage check>>${checkCountJum}>>>${checkMetarge}');
    if(checkMetarge==false){
      MainController.tableInfo['columns'].add({
        "name":"metrage",
        "title":"جمع متراژ",
        "type": "Number int",
        "type_field": "number",
        "is_show_table": true,
        "is_show_edit": false,
        "is_show_store": false,
      });
    }
    if(checkCountJum==false){
      MainController.tableInfo['columns'].add({
        "name":"jum_count",
        "title":"تعداد جام",
        "type": "Number int",
        "type_field": "number",
        "is_show_table": true,
        "is_show_edit": false,
        "is_show_store": false,
      });
    }
    if(MainController.tableData.isNotEmpty) {
      int sumMetrage=0;
      int jumCount=0;
      int price=0;
      for (int i=0; i<MainController.tableData.length;i++) {
        var details = await DB('order_detail').parent(parentTable: 'order', parentId: MainController.tableData[i]['_id']).getRecords();
        if (details.isNotEmpty) {
          for (var det in details) {
            sumMetrage += CustomController.Meterage(d1:det['dimension1'],d2:det['dimension2']);
            jumCount +=det['count']!=null? int.parse(det['count'].toString()):1;
            // price +=CustomController.priceDetail(priceProduct:det['price_product']??1,metrage: CustomController.Meterage(d1:det['dimension1'],d2:det['dimension2']),count:det['count']!=null? int.parse(det['count'].toString()):1  );
          }
        }
        MainController.tableData[i].addAll({
          "jum_count":jumCount,
          "metrage":sumMetrage
        });

      }
    }
  }
  static Jalali parseJalali(String input) {
    final parts = input.split('/');
    return Jalali(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}