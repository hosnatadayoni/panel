import 'package:hive/hive.dart';
import '../Controllers/main-controller.dart';
import 'dataModel.dart';

class General{
  String? tableName;
  List<dynamic>data=[];
  General(var tableName){
    this.tableName=tableName;
  }
   withFormat(String type,var value,var cloumnName) async {
    if (value == '') {
       return null;
     } else {
       if (type == 'string') {
         return value.toString();
       }
       else if (type == 'Number double') {
         return double.parse(value.toString());
       }
       else if (type == 'Number int') {
         return int.parse(value.toString());
       }
       else if (type == 'checkbox') {
         if (value == 'true' || value == true) {
           return true;
         } else {
           return false;
         }
       }
       else if (type == 'select' || type == 'radiobutton') {
         List<dynamic> dataBox = [];
         var data;
         var dataItem ;
         List<dynamic> columnList = MainController.getColumnsTable(
             '${this.tableName}');
         for (var column in columnList) {
           Box box2;
           if (column['name'] == cloumnName) {
             if (column['sourceItems'] == 'table') {
              box2 = await Hive.openBox<DataModel>('${column['sourceTable']}');
              dataBox = box2.values.toList();
              if (dataBox.length != 0) {
                for (int i = 0; i < dataBox.length; i++) {
                  if (dataBox[i].id == value) {
                    dataBox[i].data.addAll({"_id": dataBox[i].id});
                    dataItem=(dataBox[i].data);
                    data = dataItem.length != 0 ? dataItem : value;
                  }
                  else{

                  }

                }
              }
            } else {
              for (var item in column['items'])
                if (item['value'] == value) {
                  data = item;
                }
            }
          }
        }

         return data;
       }
       else if (type == 'multiSelect') {
         if (value is List) {
           List<dynamic> dataBox = [];
           var data;
           List<dynamic> multiSelectedTitleList = [];
           List<dynamic> columnList = MainController.getColumnsTable('${this.tableName}');
           for (var column in columnList) {
             Box box2;
             if (column['name'] == cloumnName)
               if (column['sourceItems'] == 'table') {
                 box2 = (await Hive.openBox<DataModel>('${column['sourceTable']}'));
                 dataBox = box2.values.toList();
                 if (dataBox.length != 0)
                   for (var i = 0; i < dataBox.length; i++) {
                     for (var val in value) {
                       if (dataBox[i].id == val) {
                         dataBox[i].data.addAll({"_id": dataBox[i].id});
                         multiSelectedTitleList.add(dataBox[i].data);
                       }
                     }
                   }
                 data = multiSelectedTitleList.length != 0
                     ? multiSelectedTitleList
                     : '';
               } else {
                 List<dynamic>items=[];
                 for (var item in column['items']) {
                   print('General.withFormat>>>${item}>>>${value}');
                   for(var val in value) {
                  if (item['value'] == val) {
                    print('General.withFormat2>>>${val}>>${item['value']}>>$item');
                    items.add(item);
                  }
                }
              }
                 data=items;
               }
           }
           return data;
         }
         else {
           return value;
         }
       }
       else {
         return value;
       }
     }
   }
}