import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../utils/token_manager.dart';
import '../../SalesManLocationController.dart';
import 'AttendanceModel.dart';

class NewAttendanceController extends GetxController {
  SalesManLocationController controller = SalesManLocationController();

  final addressString = 'Loading...'.obs;
  RxBool isGettingLocation = false.obs;
  RxBool isLoading = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  var attendanceForTheMonth = Rxn<Attendance>();
  RxnBool isPresentToday = RxnBool();

  var focusedDay = Rxn<DateTime>();

  // final RxList<Attendance> orders = <A>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
        .then((_) {
      isPresentToday.value = hasAttendance(
          attendanceForTheMonth.value!.attendanceDetails, DateTime.now());
    });
    getAddress();

    focusedDay.value = DateTime.now();
  }

  Future<void> getAttendanceOfMonth(String month) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/attendence-by-id?month=$month');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("json data of attendance ========>>> $jsonData");
        attendanceForTheMonth.value = Attendance.fromJson(jsonData);
        print("is present today =====>>>> ${isPresentToday.value}");
        print(
            "attendance data from model after modeling =======>>>> ${attendanceForTheMonth.value!.presentCount}");
        // final List<dynamic> dataList = jsonData['data'];
        // print("attendanceData ========>>>>>> $dataList");
        // final orderList =
        //     dataList.map((item) => Attendance.fromJson(item)).toList();
        // orders.assignAll(orderList);
        isLoading.value = false;
      } else {
        isLoading.value = false;
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      isLoading.value = false;
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get attendance");
    } finally {
      isLoading.value = false;
    }
  }

  bool hasAttendance(List<AttendanceDetail> attendanceDetails, DateTime day) {
    return attendanceDetails.any((detail) {
      if (detail.createdAt == null) return false;

      return detail.createdAt!.year == day.year &&
          detail.createdAt!.month == day.month &&
          detail.createdAt!.day == day.day;
    });
  }

  void getAddress() async {
    isGettingLocation.value = true;
    print("getting address.............");
    try {
      final salesManLocation = await controller.determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          salesManLocation.latitude, salesManLocation.longitude);
      Placemark place = placemarks[0];
      latitude.value = salesManLocation.latitude;
      longitude.value = salesManLocation.longitude;
      addressString.value =
          "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      // print(placemarks);
    } catch (e) {
      isGettingLocation.value = false;
      Get.snackbar("Location Error", e.toString());
    } finally {
      // ✅ Always reset to false, even if error
      isGettingLocation.value = false;
    }
  }

  Future<void> startAttendanceProcess() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    sendAttendanceData(pickedImage);
  }

  Future<void> sendAttendanceData(
    XFile? image,
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
      request.fields['startLat'] = latitude.value.toString();
      request.fields['startLong'] = longitude.value.toString();

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
        // setState(() => _isProcessingAttendance = false);
        print("Attendance Submitted Successfully: $responseData");
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        // setState(() => _isProcessingAttendance = false);
        print("Attendance Already Marked:");
        // print("Attendance Already Marked: $responseData");
        Get.snackbar('Today', 'Attendance Already Marked:');
      }
    } catch (e) {
      // setState(() => _isProcessingAttendance = false);
      print('🔥 Error submitting attendance: $e');
      Get.snackbar(
        '❌ Error',
        'Something went wrong while submitting attendance.',
      );
    }
  }
}
