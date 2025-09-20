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
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double startLat;
  final double startLong;
  final double endLat;
  final double endLong;
  final String salesmanName;

  AttendanceDetail({
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
    required this.startLat,
    required this.startLong,
    required this.endLat,
    required this.endLong,
    required this.salesmanName,
  });

  factory AttendanceDetail.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic value) {
      if (value == null || value.toString().isEmpty) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (_) {
        return null;
      }
    }

    return AttendanceDetail(
      status: json['status']?.toString() ?? '',
      checkInTime: parseDate(json['createdAt']),
      checkOutTime: parseDate(json['checkOutTime']),
      startLat: (json['startLat'] as num?)?.toDouble() ?? 0.0,
      startLong: (json['startLong'] as num?)?.toDouble() ?? 0.0,
      endLat: (json['endLat'] as num?)?.toDouble() ?? 0.0,
      endLong: (json['endLong'] as num?)?.toDouble() ?? 0.0,
      salesmanName: json['salesmanName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "createdAt": checkInTime?.toIso8601String(),
      "checkOutTime": checkOutTime?.toIso8601String(),
      "startLat": startLat,
      "startLong": startLong,
      "endLat": endLat,
      "endLong": endLong,
      "salesmanName": salesmanName,
    };
  }
}
