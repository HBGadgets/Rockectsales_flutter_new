import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutController extends GetxController {
  RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUsernameFromToken();
  }

  Future<void> getUsernameFromToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token != null) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = json.decode(
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
          );
          username.value = payload['username'] ?? '';
        }
      } catch (e) {
        print("Token decoding error: $e");
      }
    }
  }

  Future<void> logoutUser() async {
    String apiUrl = '${dotenv.env['BASE_URL']}/api/api/logout';
    final Map<String, dynamic> requestBody = {"username": username.value};

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("Logout successful");
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Error", "Logout failed. Try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
