import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';

import '../../models/get_task_model.dart';
import '../../models/salesman_model.dart';
import '../../resources/my_assets.dart';
import '../../screens/admin/task/task management/task_screene.dart';
import '../../service_class/common_service.dart';
import '../../utils/token_manager.dart';

class TaskManagementController extends GetxController {
  var isLoading = true.obs;
  var salesmanList = <Salesmandata>[].obs;
  var userName = "".obs;
  var userEmail = "".obs;
  var userPhone = "".obs;
  var errorMessage = ''.obs;

  final taskIdController = TextEditingController();
  final taskDescriptionController = TextEditingController();
  final taskStatusController = TextEditingController();
  final taskDeadlineController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSalesmen();
  }

  void updateUser(String name, String email, String phone) {
    userName.value = name;
    userEmail.value = email;
    userPhone.value = phone;
  }

  Future<bool> deleteTask(String taskId) async {
    try {
      final response = await ApiServiceCommon.request(
        method: 'DELETE',
        endpoint: '/api/task/$taskId',
      );

      print('Task deleted successfully');
      return true;
    } catch (e) {
      print('Error deleting task: $e');
      return false;
    }
  }

  Future<List<Get_Task_Model>> fetchTaskListForSalesman(
      String salesmanId) async {
    try {
      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: '/api/task/$salesmanId',
      );

      final data = response as List;
      return data.map((e) => Get_Task_Model.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  void onSalesmanTap(String? salesmanId) async {
    if (salesmanId == null || salesmanId.isEmpty) {
      Get.snackbar("Error", "Invalid salesman ID");
      return;
    }

    final List<Get_Task_Model> taskList =
        await fetchTaskListForSalesman(salesmanId);

    if (taskList.isEmpty) {
      Get.snackbar("Notice", "No tasks found for this salesman");
    }

    Get.to(() => TaskDetailsPage(
          taskList: taskList,
          salesmanId: salesmanId,
        ));
  }

  Future<void> fetchSalesmen() async {
    try {
      isLoading(true);

      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: '/api/salesman',
      );

      final salesmanModel = Salesman_model.fromJson(response);

      if (salesmanModel.salesmandata != null &&
          salesmanModel.salesmandata!.isNotEmpty) {
        salesmanList.assignAll(salesmanModel.salesmandata!);
        var firstSalesman = salesmanModel.salesmandata!.first;
        updateUser(
          firstSalesman.salesmanName ?? "N/A",
          firstSalesman.salesmanEmail ?? "N/A",
          firstSalesman.salesmanPhone ?? "N/A",
        );
      } else {
        Get.snackbar("No Data", "No salesmen found.");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch salesmen: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<Get_Task_Model?> fetchTask(String taskId) async {
    try {
      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: '/api/task/$taskId',
      );

      if (response is List && response.isNotEmpty) {
        return Get_Task_Model.fromJson(response[0]);
      } else if (response is Map<String, dynamic>) {
        return Get_Task_Model.fromJson(response);
      } else {
        print("Unexpected response format");
        return null;
      }
    } catch (e) {
      print("Error fetching task: $e");
      return null;
    }
  }

  @override
  void onClose() {
    taskIdController.dispose();
    taskDescriptionController.dispose();
    taskStatusController.dispose();
    taskDeadlineController.dispose();
    super.onClose();
  }
}
