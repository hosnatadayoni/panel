import 'package:finance/Admin/Logic/Models/columnModel.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../../Admin/Logic/Controllers/main-controller.dart';
import '../../Admin/Logic/Models/db.dart';

class CustomController extends GetxController {
  static RxMap<String, dynamic> orderRequest = <String, dynamic> {}.obs;
  static RxMap<String, Map<String, dynamic>> orderDetailRequest = <String, Map<String, dynamic>>{}.obs;
  static double Meterage({double? d1, double? d2}) {
    if (d1 != null && d2 != null) {
      return d1 * d2;
    }
    return  0;
  }
  static int priceDetail({double metrage=0.0, int count=0, int priceProduct=0}){
    return (metrage*count*priceProduct).toInt();

  }
  static addColumnOrderTable() async {
    bool checkMetarge=MainController.infoSchema.value.columns.any((element) => element.name== 'metrage');
    bool checkCountJum=MainController.infoSchema.value.columns.any((element) => element.name == 'jum_count');
    print('HelperController.goToTablePage check>>${checkCountJum}>>>${checkMetarge}');
    if(checkMetarge==false){
      MainController.infoSchema.value.columns.add(ColumnModel(
        name:"metrage",
        title:"جمع متراژ",
        type: "Number int",
        typeField: "number",
        isShowTable: true,
        isShowEdit: false,
        isShowStore: false,
      )
      );
    }
    if(checkCountJum==false){
      MainController.infoSchema.value.columns.add(
          ColumnModel(
        name:"jum_count",
        title:"تعداد جام",
        type: "Number int",
        typeField: "number",
        isShowTable: true,
        isShowEdit: false,
        isShowStore: false,
      ));
    }
    if(MainController.dataRecord.isNotEmpty) {
      double sumMetrage=0;
      int jumCount=0;
      int price=0;
      for (int i=0; i<MainController.dataRecord.length;i++) {
        var details = await DB('order_detail').parent(parentTable: 'order', parentId: MainController.dataRecord[i]['_id']).getRecords();
        if (details.isNotEmpty) {
          for (var det in details) {
            sumMetrage += CustomController.Meterage(d1:det['dimension1'],d2:det['dimension2']);
            jumCount +=det['count']!=null? int.parse(det['count'].toString()):1;
            // price +=CustomController.priceDetail(priceProduct:det['price_product']??1,metrage: CustomController.Meterage(d1:det['dimension1'],d2:det['dimension2']),count:det['count']!=null? int.parse(det['count'].toString()):1  );
          }
        }
        MainController.dataRecord[i].addAll({
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