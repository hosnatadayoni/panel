import 'package:hive/hive.dart';
part'user.g.dart';

@HiveType(typeId: 1)
class User {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? userName;

  @HiveField(2)
  String? password;


  User({required this.id , required this.userName , required this.password});

  User.fromJson(Map<String, dynamic> json){
    id = json['id'];
    userName = json['userName'];
    password = json['password'];
  }

  Map<String, dynamic> toJson()  {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['userName']= userName;
    data['password']= password;
    return data;
  }
}
