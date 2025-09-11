import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../TokenManager.dart';
import 'TaskModel.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;

  final RxList<Task> tasksForLiveTrack = <Task>[].obs;

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

  void getTasksForLiveTrack() async {
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
          '${dotenv.env['BASE_URL']}/api/api/get-task?&limit=1000$dateTimeFilter&search=$searchString&status=$selectedTag');
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
        tasksForLiveTrack.assignAll(taskList);
      } else {
        tasksForLiveTrack.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      tasksForLiveTrack.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Tasks");
    } finally {
      isLoading.value = false;
    }
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
          '${dotenv.env['BASE_URL']}/api/api/get-task?&limit=20$dateTimeFilter&search=$searchString&status=$selectedTag');
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
          '${dotenv.env['BASE_URL']}/api/api/get-task?page=$page&limit=10$dateTimeFilter&search=$searchString&status=$selectedTag');
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
}
