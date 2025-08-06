class AttendanceModel {
  final String id;
  final String name;
  final String phone;
  final String date;

  AttendanceModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.date,
  });

  // Convert the API response JSON to the model
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      date: json['date'],
    );
  }
}