class PageInfo {
  int start=0;
  int end=0;
  int totalRecords=0;
  int totalPage=1;
  PageInfo(
      {
        this.start=0,
        this.end=0,
        this.totalRecords=0,
        this.totalPage=1
      });
  @override
  String toString() {
    return 'PageInfo(start: $start, end: $end, totalRecords: $totalRecords, totalPage: $totalPage)';
  }
  // factory  PageInfo.fromJson(Map<String, dynamic> json) {
  //   start = json['start'];
  //   end = json['end'];
  //   totalRecords = json['totalRecords'];
  //   totalPage = json['totalPage'];
  // }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['title'] = this.title;
  //   data['province_id'] = this.provinceId;
  //   data['city_id'] = this.cityId;
  //   data['place'] = this.place;
  //   data['lat'] = this.lat;
  //   data['long'] = this.long;
  //   return data;
  // }
}
