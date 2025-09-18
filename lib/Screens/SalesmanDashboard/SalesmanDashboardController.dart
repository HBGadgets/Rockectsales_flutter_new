import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:location/location.dart' as loc;
import 'package:rocketsales/NativeChannel.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';
import '../Login/AuthController.dart';
import 'dart:typed_data';

class salesmanDashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;
  loc.Location location = loc.Location();
  var salesmanProfileInfo = SalesmanProfileInfo(
      name: '', userId: '', profileImage: '', objectId: '',
  )
      .obs;
  RxBool loadingProfile = false.obs;
  var bytes = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();
    loadUsername();
    updateCheckIn();
    getProfileImage();
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getProfileImage() async {
    loadingProfile.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final salesmanId = decodedToken['id'];

      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$salesmanId');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        salesmanProfileInfo.value = SalesmanProfileInfo.fromJson(jsonData);
        if (salesmanProfileInfo.value.profileImage?.isNotEmpty ?? false) {
          bytes.value = base64Decode(salesmanProfileInfo.value.profileImage!);
        } else {
          bytes.value = null;
        }
      } else {
        bytes.value = null;
      }
    } catch (e) {
      Get.snackbar("Exception", "Couldn't get Profile");
    } finally {
      loadingProfile.value = false; // ✅ always reset
    }
  }


  Future<void> deleteImage(BuildContext context) async {
    showLoading(context);
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final objectId = salesmanProfileInfo.value.objectId;
      final response = await http.delete(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$objectId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 201) {
        isLoading.value = false;
        print("✅ Delete successful: ${response.body}");
        getProfileImage();
      } else {
        isLoading.value = false;
        print("❌ Delete failed: ${response.body}");
      }
    } catch (e) {
      isLoading.value = false;
      print("⚠️ Error uploading: $e");
    }
  }

  Future<void> postImage() async {
    isLoading.value = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'img'],
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);

      String base64File;

      // ✅ Compress the image before encoding
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: 20, // adjust quality as needed
        format: CompressFormat.jpeg,
      );

      if (compressedBytes == null) {
        print("⚠️ Compression failed, using original image");
        final fileBytes = await file.readAsBytes();
        base64File = base64Encode(fileBytes);
      } else {
        base64File = base64Encode(compressedBytes);
      }

      final token = await TokenManager.getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final salesmanId = decodedToken['id'];
      final salesmanName = await TokenManager.getUsername();

      try {
        final response = await http.post(
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "profileImage": base64File,
            "name": salesmanName,
            "userId": salesmanId,
          }),
        );

        if (response.statusCode == 201) {
          isLoading.value = false;
          print("✅ Upload successful: ${response.body}");
          getProfileImage();
        } else {
          isLoading.value = false;
          print("❌ Upload failed: ${response.body}");
        }
      } catch (e) {
        isLoading.value = false;
        print("⚠️ Error uploading: $e");
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> updateImage(BuildContext context) async {
    isLoading.value = true;
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'img'],
    );

    if (result != null && result.files.single.path != null) {
      showLoading(context);
      File file = File(result.files.single.path!);

      try {
        // ✅ Compress before upload
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          file.absolute.path,
          minWidth: 800,   // adjust to your needs
          minHeight: 800,
          quality: 20,     // 0–100 (lower = smaller size)
        );

        if (compressedBytes == null) {
          throw Exception("Image compression failed");
        }

        // ✅ Convert compressed image to Base64
        String base64File = base64Encode(compressedBytes);

        final objectId = salesmanProfileInfo.value.objectId;
        final salesmanName = await TokenManager.getUsername();
        final token = await TokenManager.getToken();

        final response = await http.put(
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/profile/$objectId'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode({
            "profileImage": base64File,
            "name": salesmanName,
          }),
        );

        if (response.statusCode == 200) {
          isLoading.value = false;
          print("✅ Upload successful: ${response.body}");
          getProfileImage(); // refresh profile after update
        } else {
          isLoading.value = false;
          print("❌ Upload failed: ${response.body}");
        }
      } catch (e) {
        isLoading.value = false;
        print("⚠️ Error uploading: $e");
      }
    } else {
      isLoading.value = false;
    }
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
    String? token = await TokenManager.getToken();

    if (token == null) {
      print("Error: No token found in SharedPreferences!");
      return;
    }

    print("Using Token: $token");
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
    isLoading.value = true;
    Get.find<AuthController>().logout();
    isLoading.value = false;
  }
}

class SalesmanProfileInfo {
  String? objectId;
  String? name;
  String? userId;
  String? profileImage;

  SalesmanProfileInfo(
      { required this.objectId,
        required this.name,
        required this.userId,
        required this.profileImage});

  SalesmanProfileInfo.fromJson(Map<String, dynamic> json) {
    objectId = json['_id'];
    name = json['name'];
    userId = json['userId'];
    profileImage = json['profileImage'];
  }
}