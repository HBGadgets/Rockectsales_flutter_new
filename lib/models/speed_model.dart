class SpeedModel {
  String? message;
  Data? data;

  SpeedModel({this.message, this.data});

  SpeedModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? supervisorId;
  int? speedLimit;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.supervisorId,
      this.speedLimit,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    supervisorId = json['supervisorId'];
    speedLimit = json['speedLimit'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['supervisorId'] = this.supervisorId;
    data['speedLimit'] = this.speedLimit;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
