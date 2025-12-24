class UserModel{
  String? id;
  String? name;
  String? username;
  String? password;
  String? passwordOld;
  UserModel();
  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    password = json['password'];
    passwordOld = json['passwordOld'];
    name = json['name'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['username'] = this.username;
    data['password'] = this.password;
    data['passwordOld'] = this.passwordOld;
    return data;
  }
}
