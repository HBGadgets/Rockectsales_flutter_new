class PostTaskModel {
  String? message;
  Tasks? tasks;

  PostTaskModel({this.message, this.tasks});

  PostTaskModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    tasks = json['tasks'] != null ? new Tasks.fromJson(json['tasks']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.toJson();
    }
    return data;
  }
}

class Tasks {
  String? taskDescription;
  String? status;
  String? deadline;
  String? assignedTo;
  String? companyId;
  String? branchId;
  String? supervisorId;
  String? address;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Tasks(
      {this.taskDescription,
      this.status,
      this.deadline,
      this.assignedTo,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.address,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Tasks.fromJson(Map<String, dynamic> json) {
    taskDescription = json['taskDescription'];
    status = json['status'];
    deadline = json['deadline'];
    assignedTo = json['assignedTo'];
    companyId = json['companyId'];
    branchId = json['branchId'];
    supervisorId = json['supervisorId'];
    address = json['address'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['taskDescription'] = this.taskDescription;
    data['status'] = this.status;
    data['deadline'] = this.deadline;
    data['assignedTo'] = this.assignedTo;
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['supervisorId'] = this.supervisorId;
    data['address'] = this.address;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
