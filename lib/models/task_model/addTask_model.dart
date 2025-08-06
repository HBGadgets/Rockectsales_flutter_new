class Geofence {
  final String id;
  final double latitude;
  final double longitude;
  final int radius;
  final String shopName;
  final Company companyId;
  final Branch branchId;
  final Supervisor supervisorId;
  final String? assignedToId;

  Geofence({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.shopName,
    required this.companyId,
    required this.branchId,
    required this.supervisorId,
    this.assignedToId,
  });

  factory Geofence.fromJson(Map<String, dynamic> json) {
    return Geofence(
      id: json['_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      radius: json['radius'],
      shopName: json['shopName'],
      companyId: Company.fromJson(json['companyId']),
      branchId: Branch.fromJson(json['branchId']),
      supervisorId: Supervisor.fromJson(json['supervisorId']),
      assignedToId: json['assignedToId'], // optional, use based on your backend
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Geofence && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Company {
  final String id;
  final String companyName;

  Company({required this.id, required this.companyName});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      companyName: json['companyName'],
    );
  }
}

class Branch {
  final String id;
  final String branchName;

  Branch({required this.id, required this.branchName});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      id: json['_id'],
      branchName: json['branchName'],
    );
  }
}

class Supervisor {
  final String id;
  final String supervisorName;

  Supervisor({required this.id, required this.supervisorName});

  factory Supervisor.fromJson(Map<String, dynamic> json) {
    return Supervisor(
      id: json['_id'],
      supervisorName: json['supervisorName'],
    );
  }
}
