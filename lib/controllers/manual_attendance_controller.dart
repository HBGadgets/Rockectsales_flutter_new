import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/manual_attendance_model.dart'; // adjust the path accordingly
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/postattendancemodel.dart';
import '../models/present_model.dart';
import '../utils/token_manager.dart';

class ManualAttendanceController extends GetxController {
  var isLoading = false.obs;
  var manualAttendanceModel = Rxn<ManualAttendanceModel>();
  var manualAttendanceListFromSearch = <AbsentSalesmen>[].obs;

  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  @override
  void onInit() {
    super.onInit();
    fetchManualAttendanceData();
  }

  Future<void> fetchManualAttendanceData() async {
    try {
      final token = await TokenManager.getToken();
      isLoading.value = true;

      final response = await http.get(
        Uri.parse(
            'https://salestrack.rocketsalestracker.com/api/api/manualattendence'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("=== Raw Response ===");
        print(response.body);

        final jsonData = json.decode(response.body);
        manualAttendanceModel.value = ManualAttendanceModel.fromJson(jsonData);

        if (manualAttendanceModel.value != null &&
            manualAttendanceModel.value!.absentSalesmen != null) {
          // print("=== Absent Salesmen List ===");
          // for (var salesman in manualAttendanceModel.value!.absentSalesmen!) {
          //   print("------------------------------");
          //   print("Salesman ID     : ${salesman.sId}");
          //   print("Name            : ${salesman.salesmanName}");
          //   print("Email           : ${salesman.salesmanEmail}");
          //   print("Phone           : ${salesman.salesmanPhone}");
          //   print("Username        : ${salesman.username}");
          //   print("Role            : ${salesman.role}");
          //   print("Company Name    : ${salesman.companyId?.companyName}");
          //   print("Branch Name     : ${salesman.branchId?.branchName}");
          //   print("Supervisor Name : ${salesman.supervisorId?.supervisorName}");
          //   print("Created At      : ${salesman.createdAt}");
          //   print("Updated At      : ${salesman.updatedAt}");
          // }
        } else {
          print("No absent salesmen data found.");
        }
      } else {
        Get.snackbar('Error', 'Failed to load data: ${response.statusCode}');
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
      print("Exception: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> postAttendance({
    required String salesmanId,
    required String attendenceStatus,
    required String companyId,
    required String branchId,
    required String supervisorId,
  }) async {
    try {
      final token = await TokenManager.getToken();
      print(token);

      final uri = Uri.parse('http://104.251.218.102:8080/api/attendence');

      var request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['salesmanId'] = salesmanId;
      request.fields['attendenceStatus'] = attendenceStatus;
      request.fields['companyId'] = companyId;
      request.fields['branchId'] = branchId;
      request.fields['supervisorId'] = supervisorId;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final attendanceResponse = postAttendanceModel.fromJson(jsonData);
        print("✅ Attendance Submitted: ${attendanceResponse.message}");
      } else {
        print("❌ Attendance Failed: ${response.body}");
        Get.snackbar("Error", "Failed to submit attendance");
      }
    } catch (e) {
      print("⚠️ Exception in posting attendance: $e");
      Get.snackbar("Exception", e.toString());
    }
  }
}
