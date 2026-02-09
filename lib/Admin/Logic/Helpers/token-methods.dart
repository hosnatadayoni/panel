import 'package:shared_preferences/shared_preferences.dart';

class Token{

  static Future<String> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    String token=prefs.getString('full-token')??'';
    if(!token.isEmpty){
      return token;
    }else{
      return '';
    }
  }

  static setToken(String token) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('full-token', token);
  }

  static Future<bool> removeToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('full-token');
  }

  // static Future<String?> getTokenData() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   String token=prefs.getString('token-data')??'';
  //   if(!token.isEmpty){
  //     return token;
  //   }else{
  //     return null;
  //   }
  // }
  //
  // static setTokenData(String token) async{
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString('token-data', token);
  // }
  //
  // static Future<bool> removeTokenData() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.remove('token-data');
  // }

  static Future<String?> getName() async{
    final prefs = await SharedPreferences.getInstance();
    String name=prefs.getString('table-parent-name')??'';
    if(!name.isEmpty){
      return name;
    }else{
      return null;
    }
  }

  static setName(String name) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('table-parent-name', name);
  }

  static Future<bool> removeName() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('table-parent-name');
  }

}