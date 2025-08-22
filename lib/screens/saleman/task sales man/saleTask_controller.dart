import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../models/task_model/salesTask_model.dart';
import '../../../utils/token_manager.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getTasks();
    super.onInit();
  }

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getTasks() async {
    isLoading.value = true;
    isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/get-task?&limit=20$dateTimeFilter&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['tasks'];
        print("dataList ========>>>>>> $dataList");
        final taskList = dataList.map((item) => Task.fromJson(item)).toList();
        tasks.assignAll(taskList);
      } else {
        tasks.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      tasks.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Tasks");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreTaskCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/get-task?page=$page&limit=10$dateTimeFilter&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        final List<dynamic> dataList = jsonData['tasks'];
        // final List<dynamic> dataList = jsonData;
        final taskList = dataList.map((item) => Task.fromJson(item)).toList();
        // page.value++;
        if (taskList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        tasks.addAll(taskList);
      } else {
        tasks.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      tasks.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Tasks");
    }
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  Future<void> toggleTaskStatus(String taskId, String newStatus) async {
    final url = '${dotenv.env['BASE_URL']}/api/api/task/status/$taskId';

    final id = await TokenManager.getSupervisorId(); // Get user ID from token
    if (id == null) {
      showSnackbar("User ID not found from token");
      return;
    }
    final token = await TokenManager.getToken(); // Get the full token

    if (token == null) {
      showSnackbar("Auth token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'status': newStatus,
          'userId': id,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Update the task list locally after a successful update
        final index = tasks.indexWhere((t) => t.id == taskId);
        if (index != -1) {
          tasks[index].status =
              newStatus; // Directly update status without using copyWith
        }

        showSnackbar("Task marked as $newStatus");
      } else {
        showSnackbar("Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      print("Error updating status: $e");
      showSnackbar("Error updating status: $e");
    }
  }
}
