class Salesman_model {
  List<Salesmandata>? salesmandata;

  Salesman_model({this.salesmandata});

  Salesman_model.fromJson(Map<String, dynamic> json) {
    if (json['salesmandata'] != null) {
      salesmandata = <Salesmandata>[];
      json['salesmandata'].forEach((v) {
        salesmandata!.add(new Salesmandata.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salesmandata != null) {
      data['salesmandata'] = this.salesmandata!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Salesmandata {
  String? sId;
  String? salesmanName;
  String? salesmanEmail;
  String? salesmanPhone;
  String? username;
  String? password;
  int? role;
  CompanyId? companyId;
  BranchId? branchId;
  SupervisorId? supervisorId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  bool? isLoggedIn;

  Salesmandata(
      {this.sId,
      this.salesmanName,
      this.salesmanEmail,
      this.salesmanPhone,
      this.username,
      this.password,
      this.role,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.isLoggedIn});

  Salesmandata.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    salesmanName = json['salesmanName'];
    salesmanEmail = json['salesmanEmail'];
    salesmanPhone = json['salesmanPhone'];
    username = json['username'];
    password = json['password'];
    role = json['role'];
    companyId = json['companyId'] != null
        ? new CompanyId.fromJson(json['companyId'])
        : null;
    branchId = json['branchId'] != null
        ? new BranchId.fromJson(json['branchId'])
        : null;
    supervisorId = json['supervisorId'] != null
        ? new SupervisorId.fromJson(json['supervisorId'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    isLoggedIn = json['isLoggedIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['salesmanName'] = this.salesmanName;
    data['salesmanEmail'] = this.salesmanEmail;
    data['salesmanPhone'] = this.salesmanPhone;
    data['username'] = this.username;
    data['password'] = this.password;
    data['role'] = this.role;
    if (this.companyId != null) {
      data['companyId'] = this.companyId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    if (this.supervisorId != null) {
      data['supervisorId'] = this.supervisorId!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['isLoggedIn'] = this.isLoggedIn;
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

class SupervisorId {
  String? sId;
  String? supervisorName;

  SupervisorId({this.sId, this.supervisorName});

  SupervisorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    supervisorName = json['supervisorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['supervisorName'] = this.supervisorName;
    return data;
  }
}
