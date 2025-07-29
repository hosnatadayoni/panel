class Project {
  String? name;
  String? apiKey;
  String? id;
  Project.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    apiKey = json['api_key'];
    name = json['name'];
  }
}