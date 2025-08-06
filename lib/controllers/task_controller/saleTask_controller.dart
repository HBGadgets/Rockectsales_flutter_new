import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../models/task_model/salesTask_model.dart';
import '../../utils/token_manager.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);

      final id = await TokenManager.getSupervisorId(); // get ID from token

      if (id == null) {
        error('ID not found in token');
        return;
      }
      final token = await TokenManager.getToken();
      final response = await GetConnect().get(
        'https://salestrack.rocketsalestracker.com/api/api/task/$id',
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        tasks.assignAll((response.body as List)
            .map((item) => Task.fromJson(item))
            .toList());
      } else {
        error('Failed to load tasks: Check your Internet connection');
      }
    } catch (e) {
      error('Failed to load tasks: Check your Internet connection');
    } finally {
      isLoading(false);
    }
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  Future<void> toggleTaskStatus(String taskId, String newStatus) async {
    final url =
        'https://salestrack.rocketsalestracker.com/api/api/task/status/$taskId';

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
