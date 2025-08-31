import 'package:intl/intl.dart';

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
      attendanceDetails: (json['attendanceDetails'] as List?)
              ?.map((item) =>
                  AttendanceDetail.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AttendanceDetail {
  final String status;
  final DateTime? createdAt;
  final double startLat;
  final double startLong;
  final String salesmanName;

  AttendanceDetail(
      {required this.status,
      required this.createdAt,
      required this.startLat,
      required this.startLong,
      required this.salesmanName});

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['createdAt'] != null && json['createdAt'] != '') {
      try {
        parsedDate = DateFormat("dd-MM-yyyy").parse(json['createdAt']);
      } catch (e) {
        parsedDate = null;
      }
    }

    return AttendanceDetail(
      status: json['status']?.toString() ?? '',
      createdAt: parsedDate,
      startLat: (json['startLat'] as num?)?.toDouble() ?? 0.0,
      startLong: (json['startLong'] as num?)?.toDouble() ?? 0.0,
      salesmanName: json['salesmanName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "createdAt": createdAt,
      "startLat": startLat,
      "startLong": startLong,
      "salesmanName": salesmanName
    };
  }
}
