class Task {
  String id;
  String taskTitle;
  String taskDescription;
  String status;
  DateTime deadline;
  String assignedTo;
  String companyName;
  String branchName;
  String supervisorName;
  String address;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.taskTitle,
    required this.taskDescription,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.companyName,
    required this.branchName,
    required this.supervisorName,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      taskTitle: json['title'] ?? 'Task Title',
      status: json['status'] ?? 'Pending',
      deadline: DateTime.parse(json['deadline']),
      assignedTo: json['assignedTo'] ?? '',
      companyName: json['companyId']['companyName'] ?? '',
      branchName: json['branchId']['branchName'] ?? '',
      supervisorName: json['supervisorId']['supervisorName'] ?? '',
      address: json['address'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': taskTitle,
      'taskDescription': taskDescription,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'assignedTo': assignedTo,
      'companyId': {'companyName': companyName},
      'branchId': {'branchName': branchName},
      'supervisorId': {'supervisorName': supervisorName},
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // CopyWith method
  Task copyWith({
    String? id,
    String? taskTitle,
    String? taskDescription,
    String? status,
    DateTime? deadline,
    String? assignedTo,
    String? companyName,
    String? branchName,
    String? supervisorName,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      taskTitle: taskTitle ?? this.taskTitle,
      taskDescription: taskDescription ?? this.taskDescription,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      assignedTo: assignedTo ?? this.assignedTo,
      companyName: companyName ?? this.companyName,
      branchName: branchName ?? this.branchName,
      supervisorName: supervisorName ?? this.supervisorName,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
