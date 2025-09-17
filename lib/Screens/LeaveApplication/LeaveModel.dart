class Leave {
  final String salesmanId;
  final String leaveStartdate;
  final String leaveEnddate;
  final String reason;
  final String status;

  Leave(
      {required this.salesmanId,
        required this.leaveStartdate,
        required this.leaveEnddate,
        required this.reason,
        required this.status});

  factory Leave.fromJson(Map<String, dynamic> json) {
    return Leave(
      salesmanId: json['salesmanId']?.toString() ?? '',
      leaveStartdate: json['leaveStartdate']?.toString() ?? '',
      leaveEnddate: json['leaveEnddate']?.toString() ?? '',
      reason: json['reason'] ?? '',
      status: json['leaveRequestStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "salesmanId": salesmanId,
      "leaveStartdate": leaveStartdate,
      "leaveEnddate": leaveEnddate,
      "reason": reason,
      "leaveRequestStatus": status,
    };
  }
}
