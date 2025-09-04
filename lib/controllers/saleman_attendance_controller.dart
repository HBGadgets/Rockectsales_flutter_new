import 'dart:convert';
import 'dart:developer' as console;
import 'dart:io' as IO;
import 'dart:async';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as secureStorage;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rocketsale_rs/controllers/speed_controller.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'live_contoller.dart';

import '../../../controllers/alertController.dart';
import '../../../data/api constants/api_constants.dart';
import '../utils/token_manager.dart';

class AttendanceController extends GetxController {
  var attendanceStatus = ''.obs;
  var salesmanId = ''.obs;
  var isDisabled = false.obs;
  double totalDistance = 0.0;
  String speedText = "0.0 km/h";
  DateTime? lastTimestamp;

  double lastLatitude = 0.0;
  double lastLongitude = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;
  double speedThreshold = 60.0;
  bool _isDisabled = false;
  var batteryPercentage = 0.obs;

  XFile? _imageFile;
  File? _convertedImageFile;
  bool isLoading = false;
  bool alert = true;
  Timer? _timer;
  final AudioPlayer player = AudioPlayer();
  late LiveContoller controller;
  final Battery _battery = Battery();
  int? _batteryPercentage;

  // final alertController = Get.find<AlertController>();
  final AlertController controllerGCW = Get.put(AlertController());
  int speed = 0;
  late Color checkInColor = Colors.transparent; // Default color
  late Color checkOutColor = Colors.transparent; // Default color
  String? globalToken;
  late io.Socket socket;
  Position? currentLocation;
  StreamSubscription? subscription;

  var limit = "".obs; // Define an observable string

  void updateLimit() {
    limit.value = "${controller1.speedData.value?.data?.speedLimit ?? '65'}";
  }

  TextEditingController attendanceStatusController = TextEditingController();
  TextEditingController salesmanIdController = TextEditingController();

  final Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();
  final GetStorage storage = GetStorage();
  final SpeedController controller1 = Get.put(SpeedController());
  final String _imageFileName = 'daily_image.jpg';
  final String _dateKey = 'image_saved_date';

  @override
  void onInit() {
    super.onInit();
    _checkDateAndLoadImage();
    getNetworkType();

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      if (result.isNotEmpty) {
        getNetworkType(
          result[0],
        );
      }
    });
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final File image = File(pickedFile.path);
      imageFile.value = File(pickedFile.path);
      await _saveImage(image);
      _imageFile = pickedFile;
    }
  }

  Future<void> _saveImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final imagePath = '${dir.path}/$_imageFileName';

    // Delete old image if exists
    final File oldImage = File(imagePath);
    if (oldImage.existsSync()) {
      oldImage.deleteSync();
    }

    // Save new image
    final File savedImage = await image.copy(imagePath);
    imageFile.value = savedImage;

    // Save current date
    final today = DateTime.now().toIso8601String().split('T')[0]; // yyyy-MM-dd
    storage.write(_dateKey, today);
  }

  Future<void> _checkDateAndLoadImage() async {
    final dir = await getApplicationDocumentsDirectory();
    final imagePath = '${dir.path}/$_imageFileName';
    final File storedImage = File(imagePath);

    final savedDate = storage.read(_dateKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (savedDate == today && storedImage.existsSync()) {
      imageFile.value = storedImage;
    } else {
      if (storedImage.existsSync()) {
        storedImage.deleteSync();
      }
      imageFile.value = null;
      storage.remove(_dateKey);
    }
  }

  Future<void> updateCheckoutTime() async {
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
        _timer?.cancel();
        _timer = null;
        print("Success: ${response.body}");
      } else {
        print("Failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> sendAttendanceData(
    XFile? image,
    TextEditingController attendanceStatusController,
    double lastLatitude,
    double lastLongitude,
  ) async {
    try {
      print("🔹 Processing Attendance Submission...");

      // 🔹 Get Token
      String? token = await TokenManager.getToken();
      if (token == null || token.isEmpty) {
        print('🚨 No token found!');
        Get.snackbar('Error', 'No token found. Please login again.');
        return;
      }
      // print("✅ Token Retrieved: $token");

      // 🔹 Decode Token
      Map<String, dynamic> tokenData = JwtDecoder.decode(token);
      // print("✅ Token Data Extracted: $tokenData");

      // 🔹 Extract Token Fields
      String salesmanId = tokenData['id'] ?? '';
      String companyId = tokenData['companyId'] ?? '';
      String branchId = tokenData['branchId'] ?? '';
      String supervisorId = tokenData['supervisorId'] ?? '';

      if (salesmanId.isEmpty ||
          companyId.isEmpty ||
          branchId.isEmpty ||
          supervisorId.isEmpty) {
        // print("Missing required fields in token");
        Get.snackbar(
          'Error',
          'Token is missing required fields. Please login again.',
        );
        return;
      }

      Position position = await _determinePosition();
      double latitude = position.latitude;
      double longitude = position.longitude;

      // print("✅ Current Location: Lat: $latitude, Long: $longitude");

      // 🔹 Set Attendance Status
      String attendanceStatus = "Present";

      // 🔹 Prepare Multipart Request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/attendence'),
      );

      // 🔹 Add Headers
      request.headers['Authorization'] = 'Bearer $token';
      request.fields['salesmanId'] = salesmanId;
      request.fields['companyId'] = companyId;
      request.fields['branchId'] = branchId;
      request.fields['supervisorId'] = supervisorId;
      request.fields['attendenceStatus'] = attendanceStatus;
      request.fields['startLat'] = latitude.toString();
      request.fields['startLong'] = longitude.toString();

      // 🔹 Attach Image (if provided)
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profileImgUrl',
            image.path,
            contentType: MediaType(
              'image',
              'jpeg',
            ), // or 'png' based on your image type
          ),
        );
      }

      // print("📤 Sending Attendance Data: ${request.fields}");

      // 🔹 Send Request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      // 🔹 Check Response
      if (response.statusCode == 201) {
        print("Attendance Submitted Successfully: $responseData");
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        print("Attendance Already Marked:");
        // print("Attendance Already Marked: $responseData");
        Get.snackbar('Today', 'Attendance Already Marked:');
      }
    } catch (e) {
      print('🔥 Error submitting attendance: $e');
      Get.snackbar(
        '❌ Error',
        'Something went wrong while submitting attendance.',
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    // Handle initial permission request
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    // Handle Android 10+ background location requirement
    if (permission == LocationPermission.whileInUse) {
      // Request background location if we only have whileInUse
      if (await _requestBackgroundLocationPermission()) {
        permission = await Geolocator.checkPermission();
      } else {
        return Future.error('Background location permission required');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<bool> _requestBackgroundLocationPermission() async {
    if (Platform.isAndroid) {
      // For Android 10+, we need to explicitly request background location
      if (await Geolocator.isLocationServiceEnabled()) {
        final status = await Permission.locationWhenInUse.request();
        if (status.isGranted) {
          final backgroundStatus = await Permission.locationAlways.request();
          return backgroundStatus.isGranted;
        }
      }
    }
    return false;
  }

  locationPermission({VoidCallback? inSuccess}) async {
    late bool serviceEnable;
    late LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openAppSettings();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
        'Location permission are permanently denied, We cannot request permission ',
      );
    }
    {
      inSuccess?.call();
    }
  }

  void startListeningLocation() async {
    try {
      // Check if we have proper permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        print('Location permission not granted');
        return;
      }

      // Configure foreground service for Android
      final locationSettings = Platform.isAndroid
          ? AndroidSettings(
              accuracy: LocationAccuracy.high,
              intervalDuration: Duration(seconds: 3),
              foregroundNotificationConfig: ForegroundNotificationConfig(
                notificationTitle: 'Attendance Tracking Active',
                notificationText:
                    'Your location is being tracked for attendance purposes',
                notificationIcon: AndroidResource(
                  name: 'ic_notification',
                  defType: 'drawable',
                ),
                enableWakeLock: true,
              ),
            )
          : AppleSettings(
              accuracy: LocationAccuracy.high,
              activityType: ActivityType.fitness,
            );

      subscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen((Position position) {
        currentLocation = position;
        latitude = position.latitude;
        longitude = position.longitude;

        if (lastTimestamp != null) {
          calculateDistanceAndSpeed();
        }

        lastLatitude = latitude;
        lastLongitude = longitude;
        lastTimestamp = DateTime.now();

        // Rest of your existing listener code...
      });
    } catch (e) {
      print('Error starting location listener: $e');
      Get.snackbar('Error', 'Failed to start location tracking: $e');
    }
  }

  String calculateDistanceAndSpeed() {
    if (lastLatitude == null ||
        lastLongitude == null ||
        lastTimestamp == null) {
      lastLatitude = latitude;
      lastLongitude = longitude;
      lastTimestamp = DateTime.now();
      return "0 km/h";
    }

    double haversineDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
    ) {
      const double R = 6371e3;
      double phi1 = lat1 * math.pi / 180;
      double phi2 = lat2 * math.pi / 180;
      double deltaPhi = (lat2 - lat1) * math.pi / 180;
      double deltaLambda = (lon2 - lon1) * math.pi / 180;

      double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
          math.cos(phi1) *
              math.cos(phi2) *
              math.sin(deltaLambda / 2) *
              math.sin(deltaLambda / 2);

      double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
      return R * c;
    }

    double distance = haversineDistance(
      lastLatitude,
      lastLongitude,
      latitude,
      longitude,
    );

    if (distance <= 5) {
      return speedText;
    }

    totalDistance += distance;

    DateTime now = DateTime.now();
    double millisecondsElapsed =
        now.difference(lastTimestamp!).inMilliseconds.toDouble();

    if (millisecondsElapsed <= 0) {
      lastTimestamp = now;
      return "0 km/h";
    }

    double hoursElapsed = millisecondsElapsed / (1000 * 60 * 60);

    double speedInKmph = (distance / 1000) / hoursElapsed;

    speedInKmph = math.max(0, speedInKmph);

    speedText = "${speedInKmph.toStringAsFixed(2)} km/h";
    // print('Interval Distance: ${distance.toStringAsFixed(2)} m');
    // print('Calculated Speed: $speedText');
    lastLatitude = latitude;
    lastLongitude = longitude;
    lastTimestamp = now;

    return speedText;
  }

  void PostLatLong() async {
    String? username = await TokenManager.getUsername();

    print('User: $username');

    final url = ApiConstants.serverUrl;

    socket = io.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.emit('registerUser', {'username': username});

    socket.on('registerUserResponse', (response) {
      print(response);

      if (response['status'] == 'success') {
        // Cancel previous timer if already running
        _timer?.cancel();

        _timer = Timer.periodic(Duration(seconds: 10), (timer) {
          // getNetworkType();
          print(networkType.value);
          getBatteryPercentage();
          socket.emit('sendLocation', {
            'latitude': latitude,
            'longitude': longitude,
            'mobileNetwork': networkType.value,
            'batteryLevel': batteryPercentage.value,
            'distance': (totalDistance / 1000),
            'speed': speedText,
          });
        });
      }
    });
  }

  void stopListeningLocation() {
    if (subscription != null) {
      subscription!.cancel();
      subscription = null;
      print("Location listening stopped.");
    }
  }

  Future<void> getBatteryPercentage() async {
    final batteryLevel = await _battery.batteryLevel;
    batteryPercentage.value = batteryLevel;
    _batteryPercentage = batteryLevel; // <-- This line is missing
    print('Battery Percentage: $batteryLevel');
  }

  var networkType = "Unknown".obs;

  Future<void> getNetworkType([ConnectivityResult? result]) async {
    try {
      if (result == null) {
        var connectivityResult = await Connectivity().checkConnectivity();
        // Take the first result if multiple are available
        result = connectivityResult.isNotEmpty
            ? connectivityResult.first
            : ConnectivityResult.none;
      }

      switch (result) {
        case ConnectivityResult.mobile:
          networkType.value = "Mobile Data";
          break;
        case ConnectivityResult.wifi:
          networkType.value = "WiFi";
          break;
        case ConnectivityResult.ethernet:
          networkType.value = "Ethernet";
          break;
        case ConnectivityResult.bluetooth:
          networkType.value = "Bluetooth";
          break;
        case ConnectivityResult.vpn:
          networkType.value = "VPN";
          break;
        case ConnectivityResult.other:
          networkType.value = "Other";
          break;
        case ConnectivityResult.none:
        default:
          networkType.value = "No Network";
          break;
      }
      print("Network Type: ${networkType.value}");
    } catch (e) {
      print("Error getting network type: $e");
      networkType.value = "Unknown";
    }
  }

  void printFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    print("Formatted Date and Time: $formattedDate");
  }

  Future<void> onCheckInPressed() async {
    try {
      // First: ensure image is selected
      if (_imageFile == null) {
        Get.snackbar("Image Required", "Please select an image first.");
        return;
      }

      // Check and request permissions
      final hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        Get.snackbar('Permission Required',
            'Background location permission is required for attendance tracking');
        return;
      }

      // Get initial position
      Position initialPosition = await _determinePosition();
      latitude = initialPosition.latitude;
      longitude = initialPosition.longitude;

      // Proceed with check-in
      await controller1.fetchOverSpeedsaleData();
      attendanceStatus.value = "Checked In";
      attendanceStatusController.text = "Checked In";
      isDisabled.value = true;
      getBatteryPercentage();
      getNetworkType();
      printFormattedDate();
      startListeningLocation();
      PostLatLong();

      await sendAttendanceData(
        _imageFile,
        attendanceStatusController,
        latitude,
        longitude,
      );
    } catch (e) {
      print('Error during check-in: $e');
      Get.snackbar('Error', 'Failed to check in: ${e.toString()}');
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    // Check location services
    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.openLocationSettings();
      return false;
    }

    // Check permissions
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // For Android 10+, request background location if needed
    if (permission == LocationPermission.whileInUse) {
      if (Platform.isAndroid) {
        final status = await Permission.locationAlways.request();
        if (!status.isGranted) {
          // Show rationale and open app settings
          Get.dialog(
            AlertDialog(
              title: Text('Background Location Required'),
              content: Text(
                  'This app needs background location permission to track your attendance continuously.'),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Get.back();
                    await openAppSettings();
                  },
                  child: Text('Open Settings'),
                ),
              ],
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  Future<void> onCheckOutPressed() async {
    attendanceStatus.value = "Checked Out";
    attendanceStatusController.text = "Checked Out";
    isDisabled.value = false;
    _timer?.cancel();
    _timer = null;
    updateCheckoutTime();
    stopListeningLocation();
    // Get.find<AlertController>().stopAlertManually();
    // Get.find<AlertController>().stopBeepSound();
    // alertController.stopBeepSound();
    subscription?.cancel();
    subscription = null;
    Get.snackbar("", "checkOut Successfully.");
    try {
      Position position = await _determinePosition();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Error getting location: $e');
    }
  }
}
