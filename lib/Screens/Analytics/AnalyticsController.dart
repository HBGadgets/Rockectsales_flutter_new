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
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    isLoading.value = true;
    getTopPerformer().then((_) {
      isLoading.value = false;
    });
    super.onInit();
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
        final expenseList =
        dataList.map((item) => Performer.fromJson(item)).toList();
        performers.assignAll(expenseList);
      } else {
        performers.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
        print("error loading ======>>>>>>>>>>>>> ${response.body}");
      }
    } catch (e) {
      performers.clear();
      Get.snackbar("Exception", "Couldn't get Expenses");
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
