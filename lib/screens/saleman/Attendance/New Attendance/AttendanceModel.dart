class Attendance {
  final int presentCount;
  final int absentCount;
  final int onLeaveCount;
  final int totalDaysInMonth;
  final String presentPercentage;
  final String totalAbsentPercentage;
  final String unplannedLeavePercentage;
  final String plannedLeavePercentage;
  final List<AttendanceDetail> attendanceDetails;

  Attendance({
    required this.presentCount,
    required this.absentCount,
    required this.onLeaveCount,
    required this.totalDaysInMonth,
    required this.presentPercentage,
    required this.totalAbsentPercentage,
    required this.unplannedLeavePercentage,
    required this.plannedLeavePercentage,
    required this.attendanceDetails,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      presentCount: json['presentCount'] ?? 0,
      absentCount: json['absentCount'] ?? 0,
      onLeaveCount: json['onLeaveCount'] ?? 0,
      totalDaysInMonth: json['totalDaysInMonth'] ?? 0,
      presentPercentage: json['presentPercentage'] ?? '',
      totalAbsentPercentage: json['totalAbsentPercentage'] ?? '',
      unplannedLeavePercentage: json['unplannedLeavePercentage'] ?? '',
      plannedLeavePercentage: json['plannedLeavePercentage'] ?? '',
      attendanceDetails: (json['attendanceDetails'] as List<dynamic>? ?? [])
          .map((e) => AttendanceDetail.fromJson(e))
          .toList(),
    );
  }

  Attendance copyWith({
    int? presentCount,
    int? absentCount,
    int? onLeaveCount,
    int? totalDaysInMonth,
    String? presentPercentage,
    String? totalAbsentPercentage,
    String? unplannedLeavePercentage,
    String? plannedLeavePercentage,
    List<AttendanceDetail>? attendanceDetails,
  }) {
    return Attendance(
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
      onLeaveCount: onLeaveCount ?? this.onLeaveCount,
      totalDaysInMonth: totalDaysInMonth ?? this.totalDaysInMonth,
      presentPercentage: presentPercentage ?? this.presentPercentage,
      totalAbsentPercentage:
          totalAbsentPercentage ?? this.totalAbsentPercentage,
      unplannedLeavePercentage:
          unplannedLeavePercentage ?? this.unplannedLeavePercentage,
      plannedLeavePercentage:
          plannedLeavePercentage ?? this.plannedLeavePercentage,
      attendanceDetails: attendanceDetails ?? this.attendanceDetails,
    );
  }
}

class AttendanceDetail {
  final String status;
  final String createdAt;

  AttendanceDetail({
    required this.status,
    required this.createdAt,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    return AttendanceDetail(
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  AttendanceDetail copyWith({
    String? status,
    String? createdAt,
  }) {
    return AttendanceDetail(
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
