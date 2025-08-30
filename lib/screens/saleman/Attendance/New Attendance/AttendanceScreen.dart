import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsale_rs/controllers/saleman_attendance_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../resources/my_assets.dart';
import '../../../../resources/my_colors.dart';
import '../../../../utils/token_manager.dart';
import 'NewAttendanceController.dart';

class AttendanceScreen extends StatefulWidget {
  final String name;

  const AttendanceScreen({required this.name});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late DateTime _focusedDay;
  XFile? _image;

  // final NewAttendanceController controller = Get.put(NewAttendanceController(attendanceService: null));
  final attendanceController = Get.put(NewAttendanceController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance Calendar",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }

  Widget _buildAttendanceContainer() {
    if (_isProcessingAttendance) {
      return Container(
        height: 225,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFF294BB4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _isProcessingAttendance
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 26, top: 10),
                        child: Container(
                          height: 62,
                          width: 62,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFF1F1F1),
                            border: Border.all(),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (_image == null) {
                                _markAttendance();
                              } else {
                                print("Image already picked");
                              }
                            },
                            child: Center(
                              child: _isSubmitting
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : _image == null
                                      ? const Icon(Icons.camera_alt,
                                          color: Colors.black54)
                                      : const Icon(Icons.check,
                                          color: Colors.green, size: 30),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 9),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Color(0xFF0A2D63),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 20,
                                  color: Color(0xFF0A2D63),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _pickedDateTime ?? 'Date not picked',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 10,
                    ),
                    child: Column(
                      children: [
                        const Divider(height: 0.5, color: Color(0xFF0A2D63)),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                              color: Color(0xFF0A2D63),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                _currentAddress ??
                                    _pickedLatLng ??
                                    'Location not available',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _markAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A2D63),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Mark Attendance',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFF294BB4),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 26, top: 10),
                child: Container(
                  height: 62,
                  width: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFF1F1F1),
                    border: Border.all(),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      if (_image == null) {
                        _markAttendance();
                      } else {
                        print("Image already picked");
                      }
                    },
                    child: Center(
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _image == null
                              ? const Icon(Icons.camera_alt,
                                  color: Colors.black54)
                              : const Icon(Icons.check,
                                  color: Colors.green, size: 30),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Color(0xFF0A2D63),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 20,
                          color: Color(0xFF0A2D63),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _pickedDateTime ?? 'Date not picked',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 25.0,
              vertical: 10,
            ),
            child: Column(
              children: [
                const Divider(height: 0.5, color: Color(0xFF0A2D63)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.location_on_sharp,
                      color: Color(0xFF0A2D63),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _currentAddress ??
                            _pickedLatLng ??
                            'Location not available',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: _markAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A2D63),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    //minimumSize: const Size(, 40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      'Mark Attendance',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
