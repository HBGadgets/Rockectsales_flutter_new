import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;

import '../../TokenManager.dart';
import 'QRController.dart';
import 'QRModel.dart';

class Submitqrdatascreencontroller extends GetxController {

  final isLoadingQuestions = false.obs;
  var qrQuestions = <QRQuestions>[].obs;

  final QRCardsController controller = Get.find<QRCardsController>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getQRQuestions();
  }

  void getQRQuestions() async {
    isLoadingQuestions.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/qrcode/questionbyid/${controller.questionSetId.value}');
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
        final List<dynamic> dataList = jsonData['questions'];
        print("qr questions ======>>>> $dataList");
        final qrQuestionsList =
        dataList.map((item) => QRQuestions.fromJson(item)).toList();
        qrQuestions.assignAll(qrQuestionsList);
      } else {
        qrQuestions.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrQuestions.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QR questions");
    } finally {
      isLoadingQuestions.value = false;
    }
  }
}