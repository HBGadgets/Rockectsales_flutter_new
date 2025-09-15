import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import 'AnalyticsModel.dart';

class AnalyticsController extends GetxController {
  final RxList<Performer> performers = <Performer>[].obs;
  final RxList<TaskPerformer> taskPerformers = <TaskPerformer>[].obs;
  final RxList<AttendancePerformer> attendancePerformers = <AttendancePerformer>[].obs;
  final RxList<OrderPerformer> orderPerformers = <OrderPerformer>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    isLoading.value = true;
    loadData().then((_) {
      isLoading.value = false;
    });
    super.onInit();
  }

  Future<void> loadData() async {
    await getTopPerformer();
    await getTaskPerformers();
    await getAttendancePerformers();
    await getOrderPerformers();
  }


  Future <void> getTopPerformer() async {
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/topsalesman/analytics?month=${DateTime.now().month}');

      print("url ======>>>>> $url");
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
        final List<dynamic> dataList = jsonData['topPerformers'];
        print("=======>>>>>>response is 200");
        print("topPerformers ========>>>>>> $dataList");
        final topPerformerList =
        dataList.map((item) => Performer.fromJson(item)).toList();
        performers.assignAll(topPerformerList);
      } else {
        performers.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
        print("error loading ======>>>>>>>>>>>>> ${response.body}");
      }
    } catch (e) {
      performers.clear();
      Get.snackbar("Exception", "Couldn't get TopPerformer");
    }
  }

  Future <void> getTaskPerformers() async {
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/salesman/task/analytics?month=${DateTime.now().month}&page=1&limit=3');

      print("url ======>>>>> $url");
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
        final List<dynamic> dataList = jsonData['performers'];
        print("taskperformers ========>>>>>> $dataList");
        final taskPerformerList =
        dataList.map((item) => TaskPerformer.fromJson(item)).toList();
        taskPerformers.assignAll(taskPerformerList);
      } else {
        taskPerformers.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
        print("error loading ======>>>>>>>>>>>>> ${response.body}");
      }
    } catch (e) {
      taskPerformers.clear();
      Get.snackbar("Exception", "Couldn't get Task Performers");
    }
  }

  Future <void> getAttendancePerformers() async {
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/salesman/attendance/analytics?month=${DateTime.now().month}&page=1&limit=3');

      print("url ======>>>>> $url");
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
        final List<dynamic> dataList = jsonData['performers'];
        print("=======>>>>>>response is 200");
        print("attendancePerformers ========>>>>>> $dataList");
        final attendancePerformerList =
        dataList.map((item) => AttendancePerformer.fromJson(item)).toList();
        attendancePerformers.assignAll(attendancePerformerList);
      } else {
        attendancePerformers.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
        print("error loading ======>>>>>>>>>>>>> ${response.body}");
      }
    } catch (e) {
      attendancePerformers.clear();
      Get.snackbar("Exception", "Couldn't get Task Performers");
    }
  }

  Future <void> getOrderPerformers() async {
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/salesman/order/analytics?month=${DateTime.now().month}&page=1&limit=3');

      print("url ======>>>>> $url");
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
        final List<dynamic> dataList = jsonData['performers'];
        print("=======>>>>>>response is 200");
        print("orderPerformers ========>>>>>> $dataList");
        final orderPerformerList =
        dataList.map((item) => OrderPerformer.fromJson(item)).toList();
        orderPerformers.assignAll(orderPerformerList);
      } else {
        orderPerformers.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
        print("error loading ======>>>>>>>>>>>>> ${response.body}");
      }
    } catch (e) {
      orderPerformers.clear();
      Get.snackbar("Exception", "Couldn't get Task Performers");
    }
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
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

}
