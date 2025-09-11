import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../TokenManager.dart';
import 'QRController.dart';
import 'QRModel.dart';

class Qrinformationscreencontroller extends GetxController {
  final QRCardsController controller = Get.find<QRCardsController>();
  var answers = <AnsweredQuestion>[].obs;

  var singleQrCard = QRCardInfo(
          cardTitle: '',
          dateTime: '',
          qrId: '',
          addressString: '',
          companyName: '',
          branchName: '',
          supervisorName: '',
          salesmanName: '',
          salesmanSelfie: '')
      .obs;
  final isCardLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getSingleQRCard(controller.selectedQRid.value);
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

  void getSingleQRCard(String qrIdString) async {
    print('fetching qr info for ${qrIdString}');
    isCardLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/scanqr/getbyid/$qrIdString');
      print(url);
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('QR card Info==========>>>>>>>>>> $jsonData');
        singleQrCard.value = QRCardInfo.fromJson(jsonData);
        if (jsonData['questionAnswers'] != null) {
          answers.value = (jsonData['questionAnswers'] as List)
              .map((q) =>
              AnsweredQuestion(
                question: q['question'] ?? '',
                answer: q['answer'] ?? '',
              ))
              .toList();
        }
        isCardLoading.value = false;
      } else {
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Exception", "Couldn't get QR Info");
    }
  }
}
