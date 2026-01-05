import 'package:finance/Admin/Logic/Controllers/main-controller.dart';
import 'package:finance/Admin/Logic/Controllers/view-controller.dart';
import 'package:finance/custom/Logic/Controllers/view-custom-controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class MainCustomController extends GetxController {
  static RxString searchQuery = ''.obs;
  static Future<void> searchOutPutOrder(String query , List<dynamic> orderList) async {
    List<Map<String, dynamic>> allData = [];
    for (var item in orderList) {
      if (item is Map) {
        allData.add(Map<String, dynamic>.from(item));
      }
    }
    searchQuery.value = query;
    if (query.isEmpty) {
      orderList = MainController.allData.value;
    } else {
      List<dynamic> list = [];
      MainController.tableInfo['currentPage'] = 1;
      for (Map<String, dynamic> data in allData) {
        bool flag = true;
        for (var key in data.keys) {
          if (key != '_id') {
            if (data[key] != null) {
              var type = MainController.getTypeOfField(
                  MainController.tableInfo['schema']['name'], key);

              if (type == 'select' ||
                  type == 'multiSelect' ||
                  type == 'radiobutton') {
                var column = MainController.getDetailsOfField(
                    MainController.tableInfo['schema']['name'], key);
                data[key] =
                    ViewController.itemsShowSelectItem(data[key], column);
              }

              var val = data[key];
              if (val
                  .toString()
                  .toLowerCase()
                  .contains(query.toString().toLowerCase())) {
                flag = true;
                break;
              } else {
                flag = false;
              }
            } else {
              flag = false;
            }
          } else {
            flag = false;
          }
        }
        if (flag == true) {
          list.add(data);
        }
      }
      orderList = list;
    }
  }
}