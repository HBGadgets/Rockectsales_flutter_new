class Get_Task_Model {
  String? sId;
  String? taskDescription;
  String? status;
  String? deadline;
  String? assignedTo;
  CompanyId? companyId;
  BranchId? branchId;
  SupervisorId? supervisorId;
  String? address;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Get_Task_Model(
      {this.sId,
      this.taskDescription,
      this.status,
      this.deadline,
      this.assignedTo,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.address,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Get_Task_Model.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    taskDescription = json['taskDescription'];
    status = json['status'];
    deadline = json['deadline'];
    assignedTo = json['assignedTo'];
    companyId = json['companyId'] != null
        ? new CompanyId.fromJson(json['companyId'])
        : null;
    branchId = json['branchId'] != null
        ? new BranchId.fromJson(json['branchId'])
        : null;
    supervisorId = json['supervisorId'] != null
        ? new SupervisorId.fromJson(json['supervisorId'])
        : null;
    address = json['address'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['taskDescription'] = this.taskDescription;
    data['status'] = this.status;
    data['deadline'] = this.deadline;
    data['assignedTo'] = this.assignedTo;
    if (this.companyId != null) {
      data['companyId'] = this.companyId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    if (this.supervisorId != null) {
      data['supervisorId'] = this.supervisorId!.toJson();
    }
    data['address'] = this.address;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
