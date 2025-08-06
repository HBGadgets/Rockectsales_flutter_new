import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../utils/token_manager.dart';


class CheckInOutController extends GetxController {
  final Battery _battery = Battery();
  final ImagePicker _picker = ImagePicker();

  // Observables
  RxInt batteryPercentage = 0.obs;
  RxString networkType = 'No Network'.obs;
  RxString speedText = '0 km/h'.obs;
  RxDouble totalDistance = 0.0.obs;
  Rx<XFile?> imageFile = Rx<XFile?>(null);

  double latitude = 0.0;
  double longitude = 0.0;
  double lastLatitude = 0.0;
  double lastLongitude = 0.0;
  DateTime? lastTimestamp;

  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  StreamSubscription<Position>? locationSubscription;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _listenConnectivity();
    _getBatteryPercentage();
  }

  void _listenConnectivity() {
    connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
          _getNetworkType(result as ConnectivityResult);
        }) as StreamSubscription<ConnectivityResult>?;
  }

  Future<void> _getBatteryPercentage() async {
    final level = await _battery.batteryLevel;
    batteryPercentage.value = level;
  }

  Future<void> _getNetworkType(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile) {
      networkType.value = "Mobile Data";
    } else if (result == ConnectivityResult.wifi) {
      networkType.value = "WiFi";
    } else {
      networkType.value = "No Network";
    }
  }

  Future<void> checkIn() async {
    await _pickImage();
    await sendAttendanceData(imageFile.value, "Present");
    startListeningLocation();
  }

  Future<void> checkOut() async {
    stopListeningLocation();
    await updateCheckoutTime();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) imageFile.value = picked;
  }

  String calculateDistanceAndSpeed() {
    double haversine(double lat1, lon1, lat2, lon2) {
      const R = 6371e3;
      final dLat = (lat2 - lat1) * math.pi / 180;
      final dLon = (lon2 - lon1) * math.pi / 180;
      final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
          math.cos(lat1 * math.pi / 180) *
              math.cos(lat2 * math.pi / 180) *
              math.sin(dLon / 2) *
              math.sin(dLon / 2);
      final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      return R * c;
    }

    double distance = haversine(lastLatitude, lastLongitude, latitude, longitude);
    totalDistance.value += distance;

    DateTime now = DateTime.now();
    double timeDiff = now.difference(lastTimestamp!).inSeconds.toDouble();
    if (timeDiff > 0) {
      double speed = (distance / 1000) / (timeDiff / 3600);
      if (speed < 0.5) speed = 0;
      speedText.value = "${speed.toStringAsFixed(2)} km/h";
    }

    lastTimestamp = now;
    lastLatitude = latitude;
    lastLongitude = longitude;
    return speedText.value;
  }

  Future<void> sendAttendanceData(XFile? image, String status) async {
    String? token = await TokenManager.getToken();
    if (token == null) {
      Get.snackbar('Error', 'No token found.');
      return;
    }

    var tokenData = JwtDecoder.decode(token);
    final salesmanId = tokenData['id'] ?? '';
    final companyId = tokenData['companyId'] ?? '';
    final branchId = tokenData['branchId'] ?? '';
    final supervisorId = tokenData['supervisorId'] ?? '';

    Position pos = await _determinePosition();
    latitude = pos.latitude;
    longitude = pos.longitude;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://104.251.218.102:8080/api/attendence'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll({
      'salesmanId': salesmanId,
      'companyId': companyId,
      'branchId': branchId,
      'supervisorId': supervisorId,
      'attendenceStatus': status,
      'startLat': latitude.toString(),
      'startLong': longitude.toString(),
    });

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profileImgUrl',
        image.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      Get.snackbar('Success', 'Attendance submitted successfully');
    } else {
      Get.snackbar('Info', 'Attendance already marked.');
    }
  }

  Future<void> updateCheckoutTime() async {
    String? token = await TokenManager.getToken();
    if (token == null) return;

    var tokenData = JwtDecoder.decode(token);
    final objectId = tokenData['id'] ?? tokenData['_id'] ?? tokenData['userId'];

    final url =
        "http://104.251.218.102:8080/api/updatecheckouttime/$objectId";

    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "checkOutTime": DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').format(DateTime.now()),
        "endLat": latitude,
        "endLong": longitude,
      }),
    );

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Checkout time updated successfully');
    } else {
      Get.snackbar('Failed', 'Failed to update checkout');
    }
  }

  void startListeningLocation() {
    locationPermission(inSuccess: () {
      locationSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position pos) {
        latitude = pos.latitude;
        longitude = pos.longitude;

        if (lastTimestamp != null) calculateDistanceAndSpeed();
        lastTimestamp = DateTime.now();
      });
    });
  }

  void stopListeningLocation() {
    locationSubscription?.cancel();
    locationSubscription = null;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Enable Location Services');
      return Future.error('Location disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permission denied');
        return Future.error('Permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Permission denied forever');
      return Future.error('Permission denied forever');
    }

    return await Geolocator.getCurrentPosition();
  }

  void locationPermission({VoidCallback? inSuccess}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.deniedForever) {
      inSuccess?.call();
    }
  }

  @override
  void onClose() {
    connectivitySubscription?.cancel();
    locationSubscription?.cancel();
    timer?.cancel();
    super.onClose();
  }
}
