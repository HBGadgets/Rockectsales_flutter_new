import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../TokenManager.dart';
import '../SalesmanDashboard/SalesmanDashboardController.dart';
import '../SalesmanDashboard/SalesmanDashboardScreen.dart';

class AuthController extends GetxController {

  // final salesmanDashboardController controller =
  // Get.find<salesmanDashboardController>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxString username = ''.obs;
  RxString salesmanId = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsername();
  }

  Future<void> loadUsername() async {
    String? name = await TokenManager.getUsername();
    String? token = await TokenManager.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final sId = decodedToken['id'];
    salesmanId.value = sId;
    if (name != null) {
      username.value = name;
    }
  }

  Future<void> login(BuildContext context) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse("${dotenv.env['BASE_URL']}/api/api/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      var data = jsonDecode(response.body);
      String responseMessage = data['message'];

      if (response.statusCode == 200 &&
          data.containsKey('username') &&
          data.containsKey('role') &&
          data.containsKey('token')) {
        String usernameFromAPI = data['username'];
        int role = data['role'];
        String token = data['token'];
        // String adminName = data['chatusername'];

        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('adminName', adminName);

        print("Mera Token =============>>>>>>> $token");
        print("response data ==========>>>>>>$data");

        await TokenManager.saveToken(token);
        await TokenManager.saveUserInfo(usernameFromAPI, role);

        username.value = usernameFromAPI; // Update observable

        // Get.snackbar('Login Successful', 'Welcome $usernameFromAPI');
        await fcmTockenSend();
        if (role == 4) {
          // Get.offAll(() => DashboardAdmin());
          isLoading.value = false;
          Get.snackbar('Login Failed', data['message'] ?? 'Invalid credentials');
        } else if (role == 5) {
          isLoading.value = false;
          Get.offAll(() => DashboardSalesman());
        } else {
          isLoading.value = false;
          Get.snackbar('Login Failed', 'Unknown user role');
        }
      } else {
        isLoading.value = false;
        print('user already');
        print("response data ==========>>>>>>$data");
        final snackBar = SnackBar(content: Text(responseMessage));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      isLoading.value = false;
      print("Login Error: $e");
      print('Error occured');
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await fcmTockenDelete();
      print("Logout successful");
      await TokenManager.clearAll();
      isLoading.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      // controller.isLoading.value = false;
      isLoading.value = false;
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // Future<void> logout() async {
  //   // controller.isLoading.value = true;
  //   isLoading.value = true;
  //   final String apiUrl = '${dotenv.env['BASE_URL']}/api/api/logout';
  //
  //   try {
  //     await fcmTockenDelete();
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"username": username.value}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // controller.isLoading.value = false;
  //       isLoading.value = false;
  //       print("Logout successful");
  //       await TokenManager.clearAll();
  //       Get.offAllNamed('/login');
  //     } else {
  //       // controller.isLoading.value = false;
  //       isLoading.value = false;
  //       Get.snackbar("Error", "Logout failed. Try again.");
  //     }
  //   } catch (e) {
  //     // controller.isLoading.value = false;
  //     isLoading.value = false;
  //     Get.snackbar("Error", "An error occurred: $e");
  //   }
  // }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  Future<void> fcmTockenSend() async {
    final url = '${dotenv.env['BASE_URL']}/api/api/fcmtokenupdate';
    final token = await TokenManager.getToken(); // your auth token
    final fcmToken =
    await FirebaseMessaging.instance.getToken(); // get FCM token directly

    if (token == null) {
      showSnackbar("Auth token not found");
      return;
    }

    if (fcmToken == null) {
      showSnackbar("FCM token not available");
      return;
    }

    try {
      final response = await GetConnect().put(
        url,
        {
          "token": fcmToken,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("FCM token sent successfully");
      } else {
        print("Failed to update FCM token: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating FCM token: $e");
      showSnackbar("Error updating FCM token: $e");
    }
  }

  Future<void> fcmTockenDelete() async {
    final url = '${dotenv.env['BASE_URL']}/api/api/fcmtokendelete';
    final token = await TokenManager.getToken();
    final fcmToken = await FirebaseMessaging.instance.getToken();

    if (token == null) {
      showSnackbar("Auth token not found");
      return;
    }

    if (fcmToken == null) {
      showSnackbar("FCM token not available");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "token": fcmToken,
        }),
      );

      if (response.statusCode == 200) {
        print("FCM token deleted successfully");
      } else {
        print(
            "❌ Failed to delete FCM token: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("🔥 Error deleting FCM token: $e");
    }
  }
}
