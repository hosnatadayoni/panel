class General{
  String? tableName;
  List<dynamic>data=[];
  General(var data){
    this.data=data;
  }
  static withFormat(String type,var value){
    if(type=='string'){
      return value.toString();
    }else if(type=='Number double'){
      return double.parse(value.toString());
    }else if(type=='Number int'){
      return int.parse(value.toString());
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