import 'package:flutter/services.dart';

class NativeChannel {
  static const platform = MethodChannel("com.example.rocketsale_rs/native");

  static Future<void> startService(String username, String userId) async {
    try {
      await platform.invokeMethod("startService", {
        "username": username,
        "userId": userId,
      });
    } on PlatformException catch (e) {
      print("⚠️ Failed to start service: ${e.message}");
    }
  }
}
