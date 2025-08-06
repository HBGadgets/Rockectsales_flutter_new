import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/admin/dashboard_admin.dart';
import '../screens/saleman/dashboard_salesman.dart';
import '../utils/token_manager.dart';

class AuthController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsername();
  }

  Future<void> loadUsername() async {
    String? name = await TokenManager.getUsername();
    if (name != null) {
      username.value = name;
    }
  }

  Future<void> login() async {
    try {
      final response = await http.post(
        // Uri.parse("http://104.251.218.102:8080/api/login"),
        Uri.parse("https://salestrack.rocketsalestracker.com/api/api/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': usernameController.text.trim(),
          'password': passwordController.text.trim(),
        }),
      );

      var data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data.containsKey('username') &&
          data.containsKey('role') &&
          data.containsKey('token')) {
        String usernameFromAPI = data['username'];
        int role = data['role'];
        String token = data['token'];
        String adminName = data['chatusername'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('adminName', adminName);

        print("Mera Token =============>>>>>>> $token");

        await TokenManager.saveToken(token);
        await TokenManager.saveUserInfo(usernameFromAPI, role);

        username.value = usernameFromAPI; // Update observable

        Get.snackbar('Login Successful', 'Welcome $usernameFromAPI');
        await fcmTockenSend();
        if (role == 4) {
          Get.offAll(() => DashboardAdmin());
        } else if (role == 5) {
          Get.offAll(() => DashboardSalesman());
        } else {
          Get.snackbar('Login Failed', 'Unknown user role');
        }
      } else {
        Get.snackbar('Login Failed', data['message'] ?? 'Invalid credentials');
      }
    } catch (e) {
      // print("Login Error: $e");
      Get.snackbar('Error', 'Something went wrong. Please try again.');
    }
  }

  Future<void> logout() async {
    const String apiUrl = 'http://104.251.218.102:8080/api/logout';

    try {
      await fcmTockenDelete();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username.value}),
      );

      if (response.statusCode == 200) {
        print("Logout successful");
        await TokenManager.clearAll();
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", "Logout failed. Try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  Future<void> fcmTockenSend() async {
    const url = 'http://104.251.218.102:8080/api/fcmtokenupdate';
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
        showSnackbar("✅ FCM token updated successfully");
        print("FCM token sent successfully");
      } else {
        print("Failed to update FCM token: ${response.statusCode}");
        showSnackbar("❌ Failed to update FCM token");
      }
    } catch (e) {
      print("Error updating FCM token: $e");
      showSnackbar("Error updating FCM token: $e");
    }
  }

  Future<void> fcmTockenDelete() async {
    const url = 'http://104.251.218.102:8080/api/fcmtokendelete';
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
        showSnackbar("✅ FCM token deleted successfully");
        print("FCM token deleted successfully");
      } else {
        print(
            "❌ Failed to delete FCM token: ${response.statusCode} - ${response.body}");
        showSnackbar("❌ Failed to delete FCM token");
      }
    } catch (e) {
      print("🔥 Error deleting FCM token: $e");
      showSnackbar("Error deleting FCM token");
    }
  }
}
