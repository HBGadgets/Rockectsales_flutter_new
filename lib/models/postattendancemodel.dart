class postAttendanceModel {
  bool? success;
  String? message;
  Data? data;

  postAttendanceModel({this.success, this.message, this.data});

  postAttendanceModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  Null? profileImgUrl;
  String? attendenceStatus;
  String? salesmanId;
  String? companyId;
  String? branchId;
  String? supervisorId;
  double? startLat;
  double? startLong;
  String? sId;
  String? createdAt;
  int? iV;

  Data(
      {this.profileImgUrl,
      this.attendenceStatus,
      this.salesmanId,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.startLat,
      this.startLong,
      this.sId,
      this.createdAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    profileImgUrl = json['profileImgUrl'];
    attendenceStatus = json['attendenceStatus'];
    salesmanId = json['salesmanId'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    supervisorId = json['supervisorId'];
    startLat = json['startLat'];
    startLong = json['startLong'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImgUrl'] = this.profileImgUrl;
    data['attendenceStatus'] = this.attendenceStatus;
    data['salesmanId'] = this.salesmanId;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['supervisorId'] = this.supervisorId;
    data['startLat'] = this.startLat;
    data['startLong'] = this.startLong;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}
