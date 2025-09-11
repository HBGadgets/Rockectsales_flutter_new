import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:location/location.dart' as loc;
import 'package:rocketsales/NativeChannel.dart';

import '../../TokenManager.dart';
import '../Login/AuthController.dart';

class salesmanDashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  loc.Location location = loc.Location();

  @override
  void onInit() {
    super.onInit();
    loadUsername();
    updateCheckIn();
  }

  Future<void> updateCheckIn() async {
    isConnected.value = await TokenManager.checkIfCheckedIn();
    if (isConnected.value) {
      NativeChannel.startService();
    }
  }

  Future<void> updateCheckoutTime(double latitude, double longitude) async {
    String formattedDate = DateFormat(
      'yyyy-MM-ddTHH:mm:ss.SSSZ',
    ).format(DateTime.now());
    String? token = await TokenManager.getToken();

    if (token == null) {
      print("Error: No token found in SharedPreferences!");
      return;
    }

    print("Using Token: $token");

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("Decoded Token: $decodedToken");

    String? objectId =
        decodedToken["id"] ?? decodedToken["_id"] ?? decodedToken["userId"];

    if (objectId == null) {
      print("Error: User ID not found in token!");
      return;
    }

    print("Extracted Object ID: $objectId");

    String url =
        "${dotenv.env['BASE_URL']}/api/api/updatecheckouttime/$objectId";

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    Map<String, dynamic> body = {
      "checkOutTime": formattedDate,
      "endLat": latitude,
      "endLong": longitude, // Replace with actual longitude
    };

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print("Success: ${response.body}");
      } else {
        print("Failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> loadUsername() async {
    String? name = await TokenManager.getUsername();
    if (name != null) {
      username.value = name;
    }
  }

  Future<bool> checkLocationPermission() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    // Check if location service (GPS) is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return false;
    }

    // Check permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return false;
      }
    }

    return _permissionGranted == loc.PermissionStatus.granted;
  }

  Future<loc.LocationData?> getCurrentLocation() async {
    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    // Create location instance
    loc.Location location = loc.Location();

    // Ensure service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return null;
    }

    // Ensure permission is granted
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) return null;
    }

    // Get location
    return await location.getLocation();
  }

  Future<void> logout() async {
    Get.find<AuthController>().logout();
  }
}
