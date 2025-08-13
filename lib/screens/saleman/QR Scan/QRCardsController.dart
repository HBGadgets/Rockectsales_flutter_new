import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsale_rs/screens/saleman/SalesManLocationController.dart';
import 'package:rocketsale_rs/screens/saleman/dashboard_salesman.dart';

import '../../../utils/token_manager.dart';

class QRCardsController extends GetxController {
  var qrCards = <QRCard>[].obs;
  final isLoading = false.obs;
  final adminName = ''.obs;

  // final salesManId = ''.obs;
  // final companyId = ''.obs;
  // final branchId = ''.obs;
  // final supervisorId = ''.obs;

  SalesManLocationController controller = SalesManLocationController();

  @override
  void onInit() {
    // TODO: implement onInit
    getSalesmanAdminName();
    super.onInit();
  }

  void getQRCards() async {
    isLoading.value = true;
    final token = await TokenManager.getToken();

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final salesManId = decodedToken['id'];
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url =
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/scanqr/$salesManId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> dataList = jsonData['data'];
        final qrcardsList =
            dataList.map((item) => QRCard.fromJson(item)).toList();
        qrCards.assignAll(qrcardsList);
      } else {
        qrCards.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrCards.clear();
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void getSalesmanAdminName() async {
    String? token = await TokenManager.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    print(decodedToken);
    adminName.value = decodedToken['chatusername'];
  }

  Future<void> postQR(
      {required String boxNumber,
      required String qrID,
      required BuildContext context}) async {
    isLoading.value = true;
    try {
      final salesManLocation = await controller.determinePosition();
      try {
        final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/scanqr');

        final token = await TokenManager.getToken();

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
        final salesManId = decodedToken['id'];
        final companyId = decodedToken['companyId'];
        final branchId = decodedToken['branchId'];
        final supervisorId = decodedToken['supervisorId'];

        print("QR code ID is this =====>>>> $qrID");

        // var request = http.MultipartRequest('POST', uri);
        // request.headers['Authorization'] = 'Bearer $token';
        // request.fields['boxNo'] = boxNumber;
        // request.fields['companyId'] = companyId;
        // request.fields['branchId'] = branchId;
        // request.fields['supervisorId'] = supervisorId;
        // // request.fields['qrcodeId'] = qrID;
        // request.fields['qrcodeId'] = '689b3a692727d74089f689f8';
        // request.fields['salesmanId'] = salesManId;
        // request.fields['lat'] = salesManLocation.latitude.toString();
        // request.fields['long'] = salesManLocation.longitude.toString();

        // final streamedResponse = await request.send();
        // final response = await http.Response.fromStream(streamedResponse);

        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, String>{
            'boxNo': boxNumber,
            'companyId': companyId,
            'branchId': branchId,
            'supervisorId': supervisorId,
            'qrcodeId': qrID,
            'salesmanId': salesManId,
            'lat': salesManLocation.latitude.toString(),
            'long': salesManLocation.longitude.toString()
          }),
        );

        // print("request fields =========>>>>>${request.fields}");

        if (response.statusCode == 201) {
          isLoading.value = false;
          print("✅ qr card Submitted");
          // Navigator.pop(context);
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DashboardSalesman(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          Get.snackbar("Success", "QR info submitted");
        } else {
          isLoading.value = false;
          print("❌ qr card submission Failed: ${response.body}");
          Get.snackbar("Error", "Failed to submit qr");
        }
      } catch (e) {
        isLoading.value = false;
        print("⚠️ Exception in posting qr: $e");
        Get.snackbar("Exception", e.toString());
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Location Error", e.toString());
    }
  }
}

class QRCard {
  String? cardTitle;
  String? dateTime;

  QRCard({this.cardTitle, required this.dateTime});

  QRCard.fromJson(Map<String, dynamic> json) {
    cardTitle = json['boxName'];
    dateTime = json['dateTime'];
  }
}
