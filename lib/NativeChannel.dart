import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'TokenManager.dart';

class NativeChannel {
  static const platform = MethodChannel("com.example.rocketsale_rs/native");

  static Future<void> startService() async {
    String? token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      print('🚨 No token found!');
      Get.snackbar('Error', 'No token found. Please login again.');
      return;
    }
    Map<String, dynamic> tokenData = JwtDecoder.decode(token);

    String salesmanId = tokenData['id'] ?? '';
    String salesmanName = tokenData['username'] ?? '';
    try {
      await platform.invokeMethod("startService", {
        "username": salesmanName,
        "userId": salesmanId,
      });
      TokenManager.saveIfCheckedIn();
    } on PlatformException catch (e) {
      print("⚠️ Failed to start service: ${e.message}");
    }
  }

  static Future<void> stopService() async {
    try {
      await platform.invokeMethod("stopService");
      await TokenManager.deleteCheckOut();
    } on PlatformException catch (e) {
      print("⚠️ Failed to stop service: ${e.message}");
    }
  }
}
