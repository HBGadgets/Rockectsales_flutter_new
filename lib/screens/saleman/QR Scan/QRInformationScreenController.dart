import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../utils/token_manager.dart';
import 'QRCardsController.dart';

class Qrinformationscreencontroller extends GetxController {
  final QRCardsController controller = Get.find<QRCardsController>();

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
