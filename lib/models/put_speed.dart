class PutSpeedModel {
  String? message;
  Data? data;

  PutSpeedModel({this.message, this.data});

  PutSpeedModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? supervisorId;
  int? speedLimit;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.supervisorId,
      this.speedLimit,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    supervisorId = json['supervisorId'];
    speedLimit = json['speedLimit'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['supervisorId'] = this.supervisorId;
    data['speedLimit'] = this.speedLimit;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
