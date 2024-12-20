class ListOfStores {
  String? msg;
  List<Data>? data;

  ListOfStores({this.msg, this.data});

  ListOfStores.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? code;
  String? storeLocation;
  String? latitude;
  String? longitude;
  String? storeAddress;
  String? timezone;
  double? distance;
  int? isNearestStore;
  String? dayOfWeek;
  String? startTime;
  String? endTime;

  Data(
      {this.code,
      this.storeLocation,
      this.latitude,
      this.longitude,
      this.storeAddress,
      this.timezone,
      this.distance,
      this.isNearestStore,
      this.dayOfWeek,
      this.startTime,
      this.endTime});

  Data.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    storeLocation = json['storeLocation'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    storeAddress = json['storeAddress'];
    timezone = json['timezone'];
    distance = json['distance'];
    isNearestStore = json['isNearestStore'];
    dayOfWeek = json['dayOfWeek'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['storeLocation'] = storeLocation;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['storeAddress'] = storeAddress;
    data['timezone'] = timezone;
    data['distance'] = distance;
    data['isNearestStore'] = isNearestStore;
    data['dayOfWeek'] = dayOfWeek;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
