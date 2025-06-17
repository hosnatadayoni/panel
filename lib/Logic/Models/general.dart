import 'package:finance/UI/Componenets/Popups/snackbar.dart';
import 'package:hive/hive.dart';

import '../Controllers/view-controller.dart';
import 'dataModel.dart';

class General{
  String? tableName;
  List<dynamic>data=[];
  General(var tableName){
    this.tableName=tableName;
  }
   withFormat(String type,var value,var cloumnName) async {
     print('General.withFormat withFormat>>${type}>>>${cloumnName}>>${value}');

     if(type=='string' || type == 'time' || type == 'date'){

      return value.toString();
    }else if(type=='Number double'){
       if(value != ''){
         try{
           return double.parse(value.toString());
         }
         catch(e){
           showSnackbar(snackTypes.error, 'عملیات با خطا مواجه شد...');
         }

       }
    }else if(type=='Number int'){
       if(value != ''){
         try{
           return double.parse(value.toString());
         }
         catch(e){
           showSnackbar(snackTypes.error, 'عملیات با خطا مواجه شد...');
         }
       }
    }else if(type=='checkbox'){
      if(value=='true'|| value==true){
        return true;
      }else{
        return false;
      }
    }
    else if(type=='select' || type=='radiobutton'){
      print('General.withFormat select>>${value}');
      List<dynamic> dataBox=[];
      String data='';
      List<dynamic> dataItem = [];
      List<dynamic> columnList = ViewController.getColumnList('${this.tableName}');
      // print('General.withFormat columnList >>${columnList}' );

      for(var column in columnList) {
        Box box2;
        print('General.withFormat column >>${cloumnName}' );
        if(column['name']==cloumnName )
          if ( column['sourceItems'] == 'table') {
            box2 = (await Hive.openBox<DataModel>('${column['sourceTable']}'));
            dataBox = box2.values.toList();
            if(dataBox.length!=0)
          for (int i = 0; i < dataBox.length; i++) {
            print('General.withFormat data box>>>${dataBox[i].id}>>>${value}');
            if(dataBox[i].id==value)
              for (var field in column['items']) {
                dataItem.add(dataBox[i].data[field]);
              }
              data=dataItem.length!=0?dataItem.join('&'):value;

            }
          }

      }
      return data;
    }
    else if(type=='multiSelect') {
       if (value is List) {
         print('General.withFormat multiSelect>>${value}');
         List<dynamic> dataBox = [];
         String data = '';
         List<dynamic> multiSelectedTitleList = [];
         List<dynamic> columnList = ViewController.getColumnList(
             '${this.tableName}');
         for (var column in columnList) {
           Box box2;
           if (column['name'] == cloumnName)
             if (column['sourceItems'] == 'table') {
               box2 =
               (await Hive.openBox<DataModel>('${column['sourceTable']}'));
               dataBox = box2.values.toList();
               if (dataBox.length != 0)
                 for (var i = 0; i < dataBox.length; i++) {
                   List<dynamic> items = column['items'];
                   for (var val in value) {
                     if (dataBox[i].id == val) {
                       for (var item in items) {
                         multiSelectedTitleList.add(dataBox[i].data['${item}']);
                       }
                     }
                   }
                 }
               data = multiSelectedTitleList.length != 0 ? multiSelectedTitleList.join('&') : value.toString();
             }
         }
         return data;
       }
      else{
        return value;
      }
    }
    // }
    // else if(type=='multiSelect'){
    //   if(value=='true'|| value==true){
    //     return true;
    //   }else{
    //     return false;
    //   }
    // }
    else{
     return value;
    }
  }
}