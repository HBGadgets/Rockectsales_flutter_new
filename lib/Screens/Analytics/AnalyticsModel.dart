class Performer {
  String salesmanId;
  String salesmanName;
  String profileImgBase64;
  int month;
  String monthName;
  int totalDays;
  int attendancePresent;
  int taskTotal;
  int taskCompleted;
  int orderTotal;
  int orderCompleted;
  double score;

  Performer({
    required this.salesmanId,
    required this.salesmanName,
    required this.profileImgBase64,
    required this.month,
    required this.monthName,
    required this.totalDays,
    required this.attendancePresent,
    required this.taskTotal,
    required this.taskCompleted,
    required this.orderTotal,
    required this.orderCompleted,
    required this.score,
  });

  Performer.fromJson(Map<String, dynamic> json)
      : salesmanId = json['salesmanId'] ?? "",
        salesmanName = json['salesmanName'] ?? "",
        profileImgBase64 = json['profileImgBase64'] ?? "",
        month = json['month'] ?? 1,
        monthName = json['monthName'] ?? "",
        totalDays = json['totalDays'] ?? 30,
        attendancePresent = json['attendancePresent'] ?? 30,
        taskTotal = json['taskTotal'] ?? 30,
        taskCompleted = json['taskCompleted'] ?? 30,
        orderTotal = json['orderTotal'] ?? 30,
        orderCompleted = json['orderCompleted'] ?? 30,
        score = (json['score'] ?? 0).toDouble();
}

class AttendancePerformer {
  String salesmanId;
  String salesmanName;
  String profileImage;
  int month;
  String monthName;
  int totalDays;
  int attendancePresent;

  AttendancePerformer({
    required this.salesmanId,
    required this.salesmanName,
    required this.profileImage,
    required this.month,
    required this.monthName,
    required this.totalDays,
    required this.attendancePresent,
  });

  AttendancePerformer.fromJson(Map<String, dynamic> json)
      : salesmanId = json['salesmanId'] ?? "",
        salesmanName = json['salesmanName'] ?? "",
        profileImage = json['profileImage'] ?? "",
        month = json['month'] ?? 1,
        monthName = json['monthName'] ?? "",
        totalDays = json['totalDays'] ?? 30,
        attendancePresent = json['attendancePresent'] ?? 30;
}

class OrderPerformer {
  String salesmanId;
  String salesmanName;
  String profileImage;
  int month;
  String monthName;
  int orderTotal;
  int orderCompleted;

  OrderPerformer({
    required this.salesmanId,
    required this.salesmanName,
    required this.profileImage,
    required this.month,
    required this.monthName,
    required this.orderTotal,
    required this.orderCompleted,
  });

  OrderPerformer.fromJson(Map<String, dynamic> json)
      : salesmanId = json['salesmanId'] ?? "",
        salesmanName = json['salesmanName'] ?? "",
        profileImage = json['profileImage'] ?? "",
        month = json['month'] ?? 1,
        monthName = json['monthName'] ?? "",
        orderTotal = json['orderTotal'] ?? 30,
        orderCompleted = json['orderCompleted'] ?? 30;
}

class TaskPerformer {
  String salesmanId;
  String salesmanName;
  String profileImage;
  int month;
  String monthName;
  int taskTotal;
  int taskCompleted;

  TaskPerformer({
    required this.salesmanId,
    required this.salesmanName,
    required this.profileImage,
    required this.month,
    required this.monthName,
    required this.taskTotal,
    required this.taskCompleted,
  });

  TaskPerformer.fromJson(Map<String, dynamic> json)
      : salesmanId = json['salesmanId'] ?? "",
        salesmanName = json['salesmanName'] ?? "",
        profileImage = json['profileImage'] ?? "",
        month = json['month'] ?? 1,
        monthName = json['monthName'] ?? "",
        taskTotal = json['taskTotal'] ?? 30,
        taskCompleted = json['taskCompleted'] ?? 30;
}
