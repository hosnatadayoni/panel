
import 'package:shared_preferences/shared_preferences.dart';


class Token{
  static Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    String token=prefs.getString('full-token')??'';
    if(!token.isEmpty){
      return "Bearer " + token;
    }else{
      return null;
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

}