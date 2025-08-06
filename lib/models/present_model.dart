class PresentModel {
  bool? success;
  String? message;
  Data? data;

  PresentModel({this.success, this.message, this.data});

  PresentModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? profileImgUrl;
  String? attendenceStatus;
  String? salesmanId;
  String? companyId;
  String? branchId;
  String? supervisorId;
  String? createdAt;
  int? iV;
  String? checkOutTime;

  Data(
      {this.sId,
        this.profileImgUrl,
        this.attendenceStatus,
        this.salesmanId,
        this.companyId,
        this.branchId,
        this.supervisorId,
        this.createdAt,
        this.iV,
        this.checkOutTime});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImgUrl = json['profileImgUrl'];
    attendenceStatus = json['attendenceStatus'];
    salesmanId = json['salesmanId'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    supervisorId = json['supervisorId'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    checkOutTime = json['checkOutTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profileImgUrl'] = this.profileImgUrl;
    data['attendenceStatus'] = this.attendenceStatus;
    data['salesmanId'] = this.salesmanId;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['supervisorId'] = this.supervisorId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['checkOutTime'] = this.checkOutTime;
    return data;
  }
}