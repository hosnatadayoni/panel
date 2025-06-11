import 'package:finance/UI/Componenets/Popups/snackbar.dart';

class General{
  String? tableName;
  List<dynamic>data=[];
  General(var data){
    this.data=data;
  }
  static withFormat(String type,var value){
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
    }else{
     return value;
    }
  }
}