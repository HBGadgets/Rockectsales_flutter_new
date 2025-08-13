import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/leave_response_model.dart';
import '../models/updateLeaveRequestStatusModel.dart';
import '../utils/token_manager.dart'; // Adjust path accordingly

class LeaveAttendanceController extends GetxController {
  final storage = FlutterSecureStorage();

  var isLoading = false.obs;
  var leaveList = <Data>[].obs;

  Future<void> fetchLeaveRequests({
    required String startDate,
    required String endDate,
  }) async {
    try {
      isLoading.value = true;
      final token = await TokenManager.getToken();

      if (token == null) {
        Get.snackbar("Error", "User token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/leaverequest?startDate=$startDate&endDate=$endDate');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final leaveResponse = LeaveResponse.fromJson(jsonData);

        if (leaveResponse.success == true) {
          leaveList.value = leaveResponse.data ?? [];

          for (var leave in leaveList) {
            // print("=========== Leave Request ===========");
            // print("Leave ID: ${leave.sId}");
            // print("Salesman ID: ${leave.salesmanId?.sId}");
            // print("Salesman Name: ${leave.salesmanId?.salesmanName}");
            // print("Status: ${leave.leaveRequestStatus}");
            // print("Start Date: ${leave.leaveStartdate}");
            // print("End Date: ${leave.leaveEnddate}");
            // print("Reason: ${leave.reason}");
            // print("Company ID: ${leave.companyId}");
            // print("Branch ID: ${leave.branchId}");
            // print("Supervisor ID: ${leave.supervisorId}");
            // print("Created At: ${leave.createdAt}");
            // print("Updated At: ${leave.updatedAt}");
            // print("=====================================");
          }
        } else {
          Get.snackbar("Error", leaveResponse.message ?? "No data found");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch leave requests");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLeaveRequestStatus({
    required String leaveId,
    required String newStatus,
  }) async {
    try {
      final token = await TokenManager.getToken();
      print(token);

      if (token == null) {
        Get.snackbar("Error", "User token not found");
        return;
      }

      final url =
          Uri.parse("${dotenv.env['BASE_URL']}/api/api/leaverequest/$leaveId");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "leaveRequestStatus": newStatus,
        }),
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        final jsonData = jsonDecode(response.body);
        final updateResponse = UpdateLeaveRequestStatusModel.fromJson(jsonData);

        if (updateResponse.success == true) {
          Get.snackbar("Success", updateResponse.message ?? "Status updated");
        } else {
          Get.snackbar("Error", updateResponse.message ?? "Update failed");
        }
      } else {
        print(response.statusCode);
        Get.snackbar("Error", "Failed to update leave status");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    }
  }
}
