class Task {
  String id;
  String taskDescription;
  String status;
  DateTime deadline;
  String assignedTo;
  String companyName;
  String branchName;
  String supervisorName;
  String address;
  ShopGeofence? shopGeofence;
  DateTime createdAt;
  DateTime updatedAt;

  Task({
    required this.id,
    required this.taskDescription,
    required this.status,
    required this.deadline,
    required this.assignedTo,
    required this.companyName,
    required this.branchName,
    required this.supervisorName,
    required this.address,
    required this.shopGeofence,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['_id'] ?? '',
      taskDescription: json['taskDescription'] ?? '',
      status: json['status'] ?? 'Pending',
      deadline: DateTime.parse(json['deadline']),
      assignedTo: json['assignedTo']['salesmanName'] ?? '',
      companyName: json['companyId']['companyName'] ?? '',
      branchName: json['branchId']['branchName'] ?? '',
      supervisorName: json['supervisorId']['supervisorName'] ?? '',
      address: json['address'] ?? '',
      shopGeofence: json['shopGeofenceId'] != null
          ? ShopGeofence.fromJson(json['shopGeofenceId'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'taskDescription': taskDescription,
      'status': status,
      'deadline': deadline.toIso8601String(),
      'assignedTo': assignedTo,
      'companyId': {'companyName': companyName},
      'branchId': {'branchName': branchName},
      'supervisorId': {'supervisorName': supervisorName},
      'address': address,
      'shopGeofenceId': shopGeofence?.toJson(),
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
    ShopGeofence? shopGeofence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      taskDescription: taskDescription ?? this.taskDescription,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      assignedTo: assignedTo ?? this.assignedTo,
      companyName: companyName ?? this.companyName,
      branchName: branchName ?? this.branchName,
      supervisorName: supervisorName ?? this.supervisorName,
      address: address ?? this.address,
      shopGeofence: shopGeofence ?? this.shopGeofence,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ShopGeofence {
  final String id;
  final double latitude;
  final double longitude;
  final double radius;
  final String shopName;

  ShopGeofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.shopName,
  });

  factory ShopGeofence.fromJson(Map<String, dynamic> json) {
    return ShopGeofence(
      id: json['_id'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      radius: (json['radius'] ?? 0).toDouble(),
      shopName: json['shopName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'latitude': latitude,
      'longitude': longitude,
      'radius': radius,
      'shopName': shopName,
    };
  }
}
