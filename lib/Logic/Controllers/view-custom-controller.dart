import 'package:finance/Logic/Controllers/main-controller.dart';
import 'package:finance/Logic/Controllers/view-controller.dart';
import 'package:finance/Logic/Models/dataModel.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class ViewCustomController extends GetxController{
  // the function form custom page and show table

  static Jalali parseDate(String dateString) {
    List<String> dateParts = dateString.split('/');
    int year = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int day = int.parse(dateParts[2]);
    return Jalali(year, month, day);
  }

  // select order
  static Future<Map<String, dynamic>> getSelectBoxData(Map<String, dynamic> column) async {
    List<dynamic> items=[];
    var initValue;
    Map<String, dynamic> selectedItem={};
    if(column['type'] == 'select' || column['type'] == 'radiobutton'){
      items = await ViewController.itemsList(column);
      initValue = await ViewController.getInitValue(column, items);
      if(items.length != 0){
        selectedItem = items.firstWhere(
                (element) => element['value'] == ViewController.request[column['name']],
            orElse: () => items.first);
        if(selectedItem['value'] != null){
          initValue = selectedItem['value'];
        }
      }

    }

    return {
      'items': items,
      'initValue': initValue,
      'hint' :selectedItem['title']
    };
  }

  // select order item
  static Future<Map<String, dynamic>> getSelectBoxOrderItemData(Map<String, dynamic> column , var data) async {
    List<dynamic> items=[];
    var initValue;
    Map<String, dynamic> selectedItem={};
    print('data select>>>${data}');
    if(column['type'] == 'select' || column['type'] == 'radiobutton'){
      items = await ViewController.itemsList(column);
      initValue = await ViewController.getInitValue(column, items);
      if(items.length != 0){
        if(data != null){
          selectedItem = items.firstWhere(
                  (element) => element['value'] == data[column['name']],
              orElse: () => items.first);
        }
        else{
          selectedItem = items.first;
        }
        print('selectedItem select box>>>${selectedItem}');

        if(selectedItem['value'] != null){
          initValue = selectedItem['value'];
        }
      }

    }
    return {
      'items': items,
      'initValue': initValue,
      'hint' :selectedItem['title']
    };
  }

  //show table
  static Future<String> getTitleSelectBoxFormCustom(var column , DataModel dataModel) async {
    String tableName = '';
    if (column['sourceItems'] != 'custom') {
      tableName = column['sourceTable'];
    }
    String titleSelect='';

      if(dataModel.data['${column['name']}'] != null){
        titleSelect = await ViewController.getTitleSelectedItem('${tableName}',
            dataModel.data['${column['name']}'] , column);
      }

    else{
      titleSelect = dataModel.id!;
    }
    return titleSelect;
  }

  // multi select order
  static Future<Map<String, dynamic>> getMultiSelectBoxData(Map<String, dynamic> column) async{

    List<dynamic> items=[];

    var initValue;
    Map<String, dynamic> selectedItem={};

    String tableName= '';
    List<String> multiSelectedTitleList = [];
    Rx<bool> isSelectedItem = false.obs;
    Rx<String> hintTxt=''.obs;
    RxList<String> selectedItemsList = <String>[].obs;

    if(column['type'] == 'multiSelect'){

      items = await ViewController.itemsList(column);
      if (column['sourceItems'] != 'custom'){
        if(column['sourceTable'] != null){
          tableName = column['sourceTable'];
        }
      }
      if(ViewController.request[column['name']] != null){
        multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, ViewController.request[column['name']], column);
      }
      else{
        multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, [], column);
      }

      if(multiSelectedTitleList.length != 0){
        hintTxt = RxString(multiSelectedTitleList.join(','));
        selectedItemsList.value = ViewController.request[column['name']];
      }
      else{
        hintTxt = RxString('${items[0]['title']}');
      }
    }

    return {
      'items': items,
      'multiSelectedTitleList': multiSelectedTitleList,
      'isSelectedItem':isSelectedItem,
      'hintTxt':hintTxt,
      'selectedItemsList': selectedItemsList,
    };

  }

  // multi select order item
  static Future<Map<String, dynamic>> getMultiSelectBoxOrderItemData(Map<String, dynamic> column ,var data) async{

    List<dynamic> items=[];

    var initValue;
    Map<String, dynamic> selectedItem={};

    String tableName= '';
    List<String> multiSelectedTitleList = [];
    Rx<bool> isSelectedItem = false.obs;
    Rx<String> hintTxt=''.obs;
    RxList<String> selectedItemsList = <String>[].obs;

    if(column['type'] == 'multiSelect'){

      items = await ViewController.itemsList(column);
      if (column['sourceItems'] != 'custom'){
        if(column['sourceTable'] != null){
          tableName = column['sourceTable'];
        }
      }
      if(data[column['name']] != null){
        multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, data[column['name']], column);
      }
      else{
        multiSelectedTitleList = await ViewController.getTitleMultiSelectedItem(tableName, [], column);
      }

      if(multiSelectedTitleList.length != 0){
        hintTxt = RxString(multiSelectedTitleList.join(','));
        selectedItemsList.value = data[column['name']];
      }
      else{
        hintTxt = RxString('${items[0]['title']}');
      }
    }

    return {
      'items': items,
      'multiSelectedTitleList': multiSelectedTitleList,
      'isSelectedItem':isSelectedItem,
      'hintTxt':hintTxt,
      'selectedItemsList': selectedItemsList,
    };

  }


  static Future<String> getTitleMultiSelctBoxFormCustom(var column , DataModel dataModel) async {
    String tableName = '';
    if (column['sourceItems'] != 'custom') {
      tableName = column['sourceTable'];
    }
    List<String> titleMultiSelectList=[];
    if(dataModel.data['${column['name']}'] != null){
      titleMultiSelectList = await ViewController.getTitleMultiSelectedItem('${tableName}',
          dataModel.data['${column['name']}'] , column);
    }
    return titleMultiSelectList.join(',');
  }

  static Map<String, List<dynamic>> getselectedFilesMap (var column){
  Map<String, List<dynamic>> selectedFilesMap = {};
  if (selectedFilesMap['${column['name']}'] == null) {
  selectedFilesMap['${column['name']}'] = [];
  }
  List<dynamic> filesSelectedList;
  if (ViewController.request[column['name']] != null) {
  filesSelectedList = ViewController.request[column['name']];
  for (var data in filesSelectedList) {
  selectedFilesMap['${column['name']}']!.add(data);
  }
  }
  return selectedFilesMap;

  }

  static Map<String,dynamic> getDataTable(String tableName){
    Map<String,dynamic> dataTableName={};
    for(var subMenu in MainController.SubMenuList){
      if(subMenu['table-name'] == tableName){
        dataTableName = subMenu;
      }
    }
      return dataTableName;
  }

}