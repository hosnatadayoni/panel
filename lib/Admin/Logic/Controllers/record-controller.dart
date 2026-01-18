import 'package:finance/Admin/Logic/Controllers/validator-controller.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../Models/dataModel.dart';
import 'main-controller.dart';
import 'package:finance/Admin/boxes.dart';

class RecordController extends GetxController {
  static Future<bool> validate(String tableName, var newData,var dataTable) async {

    bool isValidator;
    List<bool> isValidatorList = [];
    var columns = MainController.getColumnsTable(tableName);

    for (var j = 0; j < columns.length; j++) {
      isValidator = await ValidatorController.checkInputValidation(j, newData,tableData: dataTable);
      isValidatorList.add(isValidator);
    }
    bool isExsistsValidation = isValidatorList.contains(false);
    if (isExsistsValidation) {
      isValidatorList = [];
      return true;
    } else {
      return false;
    }
  }

  static updateRecordByEcel(
      var excelJson, var recordIndex, var primeColumn) async {
    DataModel existingData = MainController.dataRecord.value[recordIndex];
    existingData.data = excelJson;
    await box.putAt(recordIndex, existingData);
    // dataController.allData.value[recordIndex] = existingData;
  }

  static storeRecordByEcel(var excelJson) async {
    var id = Uuid().v4();
    excelJson.remove('id');
    DataModel newData = DataModel(
      id: '${id}',
      data: excelJson,
    );
    await box.add(newData);
    // dataController.allData.value.add(newData);
    await MainController.loadData();
    // MainController.renderPagination();
  }
  static syncFunction(var status){
    Map<String,dynamic>d={};
    if(status==true)
      d={
      "sync":'true',
        "server error":"",
      };
    else{
      d={
        "sync":'false',
        "server error":"Dont sync this record!",
      };

    }
    return d;
  }
}
