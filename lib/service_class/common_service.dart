import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/token_manager.dart';

class ApiServiceCommon {
  static final String baseUrl = "${dotenv.env['BASE_URL']}/api";

  static Future<dynamic> request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? payload,
  }) async {
    final id = await TokenManager.getSupervisorId();
    if (id == null) {
      Get.snackbar("Error", "User ID not found from token");
      print("❌ User ID not found from token");
      return;
    }

    final token = await TokenManager.getToken();
    final url = Uri.parse('$baseUrl$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    http.Response response;

    try {
      print("📤 [$method] → $url");
      if (payload != null) print("📦 Payload: $payload");

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(url, headers: headers);
          break;
        case 'POST':
          response =
              await http.post(url, headers: headers, body: jsonEncode(payload));
          break;
        case 'PUT':
          response =
              await http.put(url, headers: headers, body: jsonEncode(payload));
          break;
        case 'PATCH':
          response = await http.patch(url,
              headers: headers, body: jsonEncode(payload));
          break;
        case 'DELETE':
          response = await http.delete(url, headers: headers);
          break;
        default:
          throw Exception('❌ Unsupported HTTP method: $method');
      }

      print("✅ Response [${response.statusCode}]: ${response.body}");

      dynamic resData;
      try {
        resData = jsonDecode(response.body);
      } catch (_) {
        throw Exception("❌ Failed to decode JSON: ${response.body}");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return resData;
      } else {
        final errorMessage = resData['message'] ??
            'Request failed with status ${response.statusCode}';
        throw Exception("❌ $errorMessage");
      }
    } catch (e, stackTrace) {
      print('❌ API Exception: $e');
      print('📌 StackTrace: $stackTrace');
      rethrow; // so calling controller catches it too
    }
  }
}
