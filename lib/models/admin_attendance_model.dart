class Admin_attendance_model {
  bool? success;
  List<Data>? data;

  Admin_attendance_model({this.success, this.data});

  Admin_attendance_model.fromJson(Map<String, dynamic> json) {
    success = json['success'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? profileImgUrl;
  String? attendenceStatus;
  SalesmanId? salesmanId;
  CompanyId? companyId;
  BranchId? branchId;
  String? supervisorId;
  String? createdAt;
  int? iV;
  double? startLat;
  double? startLong;
  String? checkOutTime;
  double? endLat;
  double? endLong;

  //salesman phone coming in future
  String? salesmanPhone;

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
      this.startLat,
      this.startLong,
      this.checkOutTime,
      this.endLat,
      this.endLong,
      this.salesmanPhone});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImgUrl = json['profileImgUrl'];
    //
    salesmanPhone = json['salesmanPhone'];
    //
    attendenceStatus = json['attendenceStatus'];
    salesmanId = json['salesmanId'] != null
        ? SalesmanId.fromJson(json['salesmanId'])
        : null;
    companyId = json['companyId'] != null
        ? CompanyId.fromJson(json['companyId'])
        : null;
    branchId =
        json['branchId'] != null ? BranchId.fromJson(json['branchId']) : null;
    supervisorId = json['supervisorId'];
    createdAt = json['createdAt'];
    iV = json['__v'];

    /// ✅ Safe conversion here
    startLat =
        json['startLat'] != null ? (json['startLat'] as num).toDouble() : null;
    startLong = json['startLong'] != null
        ? (json['startLong'] as num).toDouble()
        : null;
    checkOutTime = json['checkOutTime'];
    endLat = json['endLat'] != null ? (json['endLat'] as num).toDouble() : null;
    endLong =
        json['endLong'] != null ? (json['endLong'] as num).toDouble() : null;
  }

  get attendanceStatus => this.attendenceStatus;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profileImgUrl'] = this.profileImgUrl;
    data['attendenceStatus'] = this.attendenceStatus;
    if (this.salesmanId != null) {
      data['salesmanId'] = this.salesmanId!.toJson();
    }
    if (this.companyId != null) {
      data['companyId'] = this.companyId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    data['supervisorId'] = this.supervisorId;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['startLat'] = this.startLat;
    data['startLong'] = this.startLong;
    data['checkOutTime'] = this.checkOutTime;
    data['endLat'] = this.endLat;
    data['endLong'] = this.endLong;

    //
    data['salesmanPhone'] = this.salesmanPhone;
    return data;
  }
}

class SalesmanId {
  String? sId;
  String? salesmanName;
  String? salesmanPhone;

  SalesmanId({this.sId, this.salesmanName, this.salesmanPhone});

  SalesmanId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    salesmanName = json['salesmanName'];
    salesmanPhone = json['salesmanPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['salesmanName'] = this.salesmanName;
    data['salesmanPhone'] = this.salesmanPhone;
    return data;
  }
}

class CompanyId {
  String? sId;
  String? companyName;

  CompanyId({this.sId, this.companyName});

  CompanyId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['companyName'] = this.companyName;
    return data;
  }
}

class BranchId {
  String? sId;
  String? branchName;

  BranchId({this.sId, this.branchName});

  BranchId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['branchName'] = this.branchName;
    return data;
  }
}
