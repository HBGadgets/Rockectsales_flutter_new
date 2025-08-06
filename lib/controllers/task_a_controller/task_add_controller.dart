import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rocketsale_rs/screens/admin/dashboard_admin.dart';
import 'dart:convert';

import '../../models/get_task_model.dart';
import '../../models/task_model/addTask_model.dart';
import '../../screens/admin/task/task management/Task_Management_Screen.dart';
import '../../screens/admin/task/task management/task_screene.dart';
import '../../service_class/common_service.dart';
import '../../utils/token_manager.dart';
import '../task_management_controller.dart';

class TaskAddController extends GetxController {
  var taskMap = <int, String>{1: ''}.obs;
  var selectedDateTime = Rxn<DateTime>();
  var address = ''.obs;
  var selectedGeofence = Rxn<Geofence>();
  var geofences = <Geofence>[].obs;
  var selectedSalesmanId = ''.obs;
  final TextEditingController taskEdit = TextEditingController();
  final taskManagementController = Get.find<TaskManagementController>();
  var isEditing = false.obs;
  var editingTaskId = ''.obs;
  var taskStatus = 'Pending'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGeofences();
  }

  Future<void> fetchGeofences() async {
    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final endpoint = '/api/geofence';

      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: endpoint,
      );

      final List<dynamic> geofenceData = response['data'];
      geofences.value =
          geofenceData.map((json) => Geofence.fromJson(json)).toList();
      for (var geo in geofences) {
        print('Geofence: ${geo.shopName} (${geo.latitude}, ${geo.longitude})');
      }
    } catch (e) {
      print('Failed to fetch geofences: $e');
    }
  }

  void onSalesmanTap(String? salesmanId) async {
    if (salesmanId == null || salesmanId.isEmpty) {
      Get.snackbar("Error", "Please select a salesman ID");
      return;
    }

    print("Fetching tasks for Salesman ID: $salesmanId");

    final taskList =
        await taskManagementController.fetchTaskListForSalesman(salesmanId);

    Get.to(() =>
        TaskDetailsPage(taskList: taskList ?? [], salesmanId: salesmanId));
  }

  void addNewTaskField() {
    int newKey = taskMap.keys.length + 1;
    taskMap[newKey] = '';
  }

  void updateTask(int key, String value) {
    taskMap[key] = value;
  }

  void selectDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        selectedDateTime.value = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      }
    }
  }

  void submitTask() async {
    if (taskMap.values.every((task) => task.isEmpty)) {
      Get.snackbar("Validation", "Please enter at least one task description");
      return;
    }
    if (selectedDateTime.value == null) {
      Get.snackbar("Validation", "Please select a deadline");
      return;
    }
    if (selectedGeofence.value == null) {
      Get.snackbar("Validation", "Please select a geofence");
      return;
    }

    final payload = {
      "taskDescription":
          taskMap.values.where((t) => t.trim().isNotEmpty).toList(),
      "deadline": selectedDateTime.value!.toUtc().toIso8601String(),
      "assignedTo": [selectedSalesmanId.value],
      "companyId": {
        "_id": selectedGeofence.value!.companyId.id,
      },
      "branchId": {
        "_id": selectedGeofence.value!.branchId.id,
      },
      "supervisorId": {
        "_id": selectedGeofence.value!.supervisorId.id,
      },
      "address": address.value,
      "shopGeofenceId": selectedGeofence.value!.id,
    };

    print("Final Payload: $payload");

    try {
      final response = await ApiServiceCommon.request(
        method: 'POST',
        endpoint: '/api/task', // Base URL already included in ApiServiceCommon
        payload: payload,
      );
      Get.offAll(() => DashboardAdmin());
      Get.snackbar("Success", "Task created successfully");
      print("Task creation response: $response");
    } catch (e) {
      print("❌ Submit task error: $e");

      Get.snackbar("Error", "Failed to create task");
    }
  }

  void updateTaskApi() async {
    if (taskEdit.text.trim().isEmpty) {
      Get.snackbar("Validation", "Please enter task description");
      return;
    }
    if (selectedDateTime.value == null) {
      Get.snackbar("Validation", "Please select a deadline");
      return;
    }
    if (selectedGeofence.value == null) {
      Get.snackbar("Validation", "Please select a geofence");
      return;
    }

    final payload = {
      "taskDescription": taskEdit.text.trim(),
      "deadline": selectedDateTime.value!.toUtc().toIso8601String(),
      "status": taskStatus.value,
      "assignedTo": [selectedSalesmanId.value],
      "companyId": selectedGeofence.value!.companyId.id,
      "branchId": selectedGeofence.value!.branchId.id,
      "supervisorId": selectedGeofence.value!.supervisorId.id,
      "address": address.value,
      "shopGeofenceId": selectedGeofence.value!.id,
    };

    try {
      final response = await ApiServiceCommon.request(
        method: 'PUT',
        endpoint: '/api/task/${editingTaskId.value}',
        payload: payload,
      );
      Get.offAll(() => DashboardAdmin());
      Get.snackbar("Success", "Task updated successfully");
    } catch (e) {
      print("❌ Update task error: $e");
      Get.snackbar("Error", "Failed to update task");
    }
  }
}
