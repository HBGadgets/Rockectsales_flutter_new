import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../utils/token_manager.dart';
import 'OrdersAndProductsClass.dart';

class OrdersController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getOrders();
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

  void getTaggedOrders() async {
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
          '${dotenv.env['BASE_URL']}/api/api/getorder?&limit=20$dateTimeFilter&search=$searchString&status=$selectedTag');
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
        print("ordersList ========>>>>>> $dataList");
        final orderList = dataList.map((item) => Order.fromJson(item)).toList();
        orders.assignAll(orderList);
      } else {
        orders.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      orders.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Orders");
    } finally {
      isLoading.value = false;
    }
  }

  void getOrders() async {
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
          '${dotenv.env['BASE_URL']}/api/api/getorder?&limit=20$dateTimeFilter&search=$searchString');
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
        print("ordersList ========>>>>>> $dataList");
        final orderList = dataList.map((item) => Order.fromJson(item)).toList();
        orders.assignAll(orderList);
      } else {
        orders.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      orders.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Orders");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreOrderCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/getorder?page=$page&limit=10$dateTimeFilter&search=$searchString');
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
        final orderList = dataList.map((item) => Order.fromJson(item)).toList();
        // page.value++;
        if (orderList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        orders.addAll(orderList);
      } else {
        orders.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      orders.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Orders");
    }
  }
}
