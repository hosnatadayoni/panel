class RouteModel{
  String? id;
  String? title;
  String? view;
  String? address;
  RouteModel();
  RouteModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    title = json['title'];
    view = json['view'];
    address = json['address'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['view'] = this.view;
    data['address'] = this.address;
    return data;
  }
}