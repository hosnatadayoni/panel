import 'package:finance/Logic/Models/db.dart';
class Records{
  static getRecords(String tableName,
      {bool condition=false, String? fieldName, String? oprator, var value}) async {

    var lo=DB('category').where('y','!=',456).where('y','>=',400).getRecords();
    // var t=MainController.getTypeOfField('category','y');
    // print('typeis>>$t');
  }

}