import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../resources/my_colors.dart';
import '../../SalesManLocationController.dart';
import '../../TokenManager.dart';
import 'AttendanceModel.dart';

class NewAttendanceController extends GetxController {
  SalesManLocationController controller = SalesManLocationController();

  final addressString = 'Loading...'.obs;
  RxBool isGettingLocation = false.obs;
  RxBool isLoading = false.obs;
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  var attendanceForTheMonth = Rxn<Attendance>();
  RxnBool isAttendanceMarkedToday = RxnBool();
  var salesManSelfie = Rxn<File?>();

  var focusedDay = Rxn<DateTime>();

  // final RxList<Attendance> orders = <A>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
        .then((_) {
      final attendance = attendanceForTheMonth.value;

      if (attendance == null) {
        isAttendanceMarkedToday.value = false;
      } else {
        if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
            "noData") {
          isAttendanceMarkedToday.value = false;
        } else if (hasAttendance(
                    attendance.attendanceDetails, DateTime.now()) ==
                "Present" ||
            hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "Absent") {
          isAttendanceMarkedToday.value = true;
        }
      }
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
        print("is present today =====>>>> ${isAttendanceMarkedToday.value}");
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

  String hasAttendance(List<AttendanceDetail> attendanceDetails, DateTime day) {
    if (attendanceDetails.isEmpty) {
      return "noData";
    }

    // Look for the first matching record
    final match = attendanceDetails.firstWhere(
      (detail) =>
          detail.checkInTime != null &&
          detail.checkInTime!.year == day.year &&
          detail.checkInTime!.month == day.month &&
          detail.checkInTime!.day == day.day,
      orElse: () => AttendanceDetail(
        status: "noData",
        checkInTime: null,
        startLat: 0,
        startLong: 0,
        salesmanName: "",
        checkOutTime: null,
        endLat: 0,
        endLong: 0,
      ),
    );

    return match.status;
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
                Text("Uploading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendAttendanceData(XFile? image, BuildContext context) async {
    showLoading(context);
    String? token = await TokenManager.getToken();
    if (token == null || token.isEmpty) {
      print('No token found!');
      Get.snackbar('Error', 'No token found. Please login again.');
      return;
    }

    try {
      Map<String, dynamic> tokenData = JwtDecoder.decode(token);

      String salesmanId = tokenData['id'] ?? '';
      String companyId = tokenData['companyId'] ?? '';
      String branchId = tokenData['branchId'] ?? '';
      String supervisorId = tokenData['supervisorId'] ?? '';
      String salesmanName = tokenData['username'] ?? '';
      isAttendanceMarkedToday.value = null;
      print("Processing Attendance Submission...");

      final compressedBytes = await FlutterImageCompress.compressWithFile(
        image!.path,
        quality: 20,
      );

      // final bytes = await image!.readAsBytes();
      final base64Image = base64Encode(compressedBytes!);

      if (salesmanId.isEmpty ||
          companyId.isEmpty ||
          branchId.isEmpty ||
          supervisorId.isEmpty) {
        Get.snackbar(
          'Error',
          'Token is missing required fields. Please login again.',
        );
        return;
      }

      String attendanceStatus = "Present";

      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/attendence');

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'attendenceStatus': attendanceStatus,
          'startLat': latitude.value.toString(),
          'startLong': longitude.value.toString(),
          'profileImgUrl': base64Image,
        }),
      );

      if (response.statusCode == 201) {
        print("Attendance Submitted Successfully: ${response.body}");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                        attendance.attendanceDetails, DateTime.now()) ==
                    "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });
        getAddress();

        focusedDay.value = DateTime.now();
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Get.snackbar('Success', 'Attendance submitted successfully.');
      } else {
        // setState(() => _isProcessingAttendance = false);
        print("Error: ${response.body}");
        // print("Attendance Already Marked: $responseData");
        getAttendanceOfMonth(DateFormat("yyyy-MM").format(DateTime.now()))
            .then((_) {
          final attendance = attendanceForTheMonth.value;

          if (attendance == null) {
            isAttendanceMarkedToday.value = false;
          } else {
            if (hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                "noData") {
              isAttendanceMarkedToday.value = false;
            } else if (hasAttendance(
                        attendance.attendanceDetails, DateTime.now()) ==
                    "Present" ||
                hasAttendance(attendance.attendanceDetails, DateTime.now()) ==
                    "Absent") {
              isAttendanceMarkedToday.value = true;
            }
          }
        });
        getAddress();
        Get.snackbar('Error', '${response.body}');
      }
    } catch (e) {
      // setState(() => _isProcessingAttendance = false);
      print(' Error submitting attendance: $e');
      Get.snackbar(
        ' Error',
        'Something went wrong while submitting attendance.',
      );
    }
  }
}
