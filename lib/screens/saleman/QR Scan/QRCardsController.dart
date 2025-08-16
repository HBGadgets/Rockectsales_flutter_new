import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
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
  final addressString = ''.obs;

  // final salesManId = ''.obs;
  // final companyId = ''.obs;
  // final branchId = ''.obs;
  // final supervisorId = ''.obs;
  RxInt page = 1.obs;
  RxBool isMoreCardsAvailable = true.obs;
  RxBool gettingLocation = false.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;

  SalesManLocationController controller = SalesManLocationController();

  @override
  void onInit() {
    // TODO: implement onInit
    getSalesmanAdminName();
    getQRCards();
    super.onInit();
  }

  void getAddress() async {
    gettingLocation.value = true;
    print("getting address.............");
    try {
      final salesManLocation = await controller.determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          salesManLocation.latitude, salesManLocation.longitude);
      Placemark place = placemarks[0];
      addressString.value =
          "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      // print(placemarks);
    } catch (e) {
      gettingLocation.value = false;
      Get.snackbar("Location Error", e.toString());
    } finally {
      // ✅ Always reset to false, even if error
      gettingLocation.value = false;
    }
  }

  void getQRCards() async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/scanqr/get?page=$page&limit=10$dateTimeFilter&search=$searchString');
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
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QR history");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreQrCards() async {
    if (isMoreCardsAvailable.value) {
      page.value++;
    }
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/scanqr/get?page=$page&limit=10$dateTimeFilter&search=$searchString');
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
        final List<dynamic> dataList = jsonData['data'];
        // final List<dynamic> dataList = jsonData;
        final qrcardsList =
            dataList.map((item) => QRCard.fromJson(item)).toList();
        // page.value++;
        if (qrcardsList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        }
        qrCards.addAll(qrcardsList);
      } else {
        qrCards.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      qrCards.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get QR history");
    }
  }

  void getSalesmanAdminName() async {
    String? token = await TokenManager.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    // print(decodedToken);
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

        // print("QR code ID is this =====>>>> $qrID");

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
            'long': salesManLocation.longitude.toString(),
            'address': addressString.value
          }),
        );

        if (response.statusCode == 201) {
          isLoading.value = false;
          addressString.value = '';
          print("✅ qr card Submitted");
          // print("address field =========>>>>>${addressString.value}");
          // Navigator.pop(context);
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => DashboardSalesman(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
          getQRCards();
          Get.snackbar("Success", "QR info submitted");
        } else {
          isLoading.value = false;
          print("❌ qr card submission Failed: ${response.body}");
          Get.snackbar("Error", response.body);
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
  String? qrId;
  String? addressString;

  QRCard(
      {this.cardTitle,
      required this.dateTime,
      required this.qrId,
      required this.addressString});

  QRCard.fromJson(Map<String, dynamic> json) {
    // cardTitle = json['qrcodeId']?['boxNo'];
    cardTitle = json['boxNo']?.toString();
    dateTime = json['createdAt'];
    // dateTime = json['qrcodeId']?['createdAt'];
    qrId = json['qrcodeId']?['_id']; // Nested access
    addressString = json['address'];
  }
}
