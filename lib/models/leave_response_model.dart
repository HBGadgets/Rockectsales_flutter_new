class LeaveResponse {
  bool? success;
  String? message;
  List<Data>? data;

  LeaveResponse({this.success, this.message, this.data});

  LeaveResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  SalesmanId? salesmanId;
  String? leaveRequestStatus;
  String? leaveStartdate;
  String? leaveEnddate;
  String? reason;
  Null? companyId;
  Null? branchId;
  String? supervisorId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.salesmanId,
      this.leaveRequestStatus,
      this.leaveStartdate,
      this.leaveEnddate,
      this.reason,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    salesmanId = json['salesmanId'] != null
        ? new SalesmanId.fromJson(json['salesmanId'])
        : null;
    leaveRequestStatus = json['leaveRequestStatus'];
    leaveStartdate = json['leaveStartdate'];
    leaveEnddate = json['leaveEnddate'];
    reason = json['reason'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    supervisorId = json['supervisorId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.salesmanId != null) {
      data['salesmanId'] = this.salesmanId!.toJson();
    }
    data['leaveRequestStatus'] = this.leaveRequestStatus;
    data['leaveStartdate'] = this.leaveStartdate;
    data['leaveEnddate'] = this.leaveEnddate;
    data['reason'] = this.reason;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['supervisorId'] = this.supervisorId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class SalesmanId {
  String? sId;
  String? salesmanName;

  SalesmanId({this.sId, this.salesmanName});

  SalesmanId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    salesmanName = json['salesmanName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['salesmanName'] = this.salesmanName;
    return data;
  }
}
