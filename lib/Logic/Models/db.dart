class DB {
  String? tableName;
  List<Where> list=[];

  DB(String tableName) {
    this.tableName = tableName;

  }

  where(String? fieldName, String? oprator, var value) {
    Where l = Where(fieldName, oprator, value);
    this.list.add(l);
    return this;
  }
}

class Where {
  String? fieldName;
  String? oprator;
  var value;

  Where(String? fieldName, String? oprator, var value) {
    this.value = value;
    this.oprator = oprator;
    this.fieldName = fieldName;
    this;
  }
}
