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
  bool _isInitialLoading = true;
  bool _isSubmitting = false;
  bool _isProcessingAttendance = false;
  XFile? _image;
  String? _pickedDateTime;
  String? _pickedLatLng;
  String? _currentAddress;
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;
  LocationPermission? _permissionStatus;

  // final NewAttendanceController controller = Get.put(NewAttendanceController(attendanceService: null));
  final attendanceController =
      Get.put(NewAttendanceController(attendanceService: AttendanceService()));

  // Get today's key for SharedPreferences (YYYY-MM-DD)
  String _getTodayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _loadSavedAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();

    setState(() {
      _pickedDateTime = prefs.getString('$todayKey-date');
      _pickedLatLng = prefs.getString('$todayKey-location');
      _image = (_pickedDateTime != null) ? XFile('dummy') : null;
    });

    // Load address if location exists
    if (_pickedLatLng != null) {
      await _getAddressFromLatLng(_pickedLatLng!);
    }
  }

  Future<void> _getAddressFromLatLng(String latLng) async {
    try {
      final parts = latLng.split(',');
      if (parts.length != 2) return;

      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);
      if (lat == null || lng == null) return;

      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        setState(() {
          _currentAddress =
              "${place.street}, ${place.locality}, ${place.postalCode}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  // Save attendance data for today
  Future<void> _saveAttendance(String date, String location) async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = _getTodayKey();

    await prefs.setString('$todayKey-date', date);
    await prefs.setString('$todayKey-location', location);
  }

  // Post image to API
  Future<void> _postImageToAPI(
    XFile image,
    double lat,
    double lng,
    String dateTime,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    print("Latitude: $lat, Longitude: $lng");

    final url = '${dotenv.env['BASE_URL']}/api/api/attendence';

    try {
      // ✅ Troubleshooting image
      print("🛠️ Image path: ${image.path}");
      final file = File(image.path);
      final exists = await file.exists();
      final size = await file.length();

      print("📂 File exists: $exists");
      print("📏 File size: $size bytes");

      if (!exists || size == 0) {
        print("❌ Error: Image file does not exist or is empty!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid image. Please retake.")),
        );
        return;
      }
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['lat'] = lat.toString()
        ..fields['long'] = lng.toString()
        ..files.add(
          await http.MultipartFile.fromPath(
            'attendance',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );

      final response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _image = image;
          _pickedDateTime = dateTime;
          _pickedLatLng = '$lat,$lng';
        });
        await _saveAttendance(dateTime, '$lat,$lng');
        await _getAddressFromLatLng('$lat,$lng');
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance marked successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        print('✅ Attendance posted successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('❌ Upload failed: $responseBody');

        try {
          // Parse the JSON response
          final jsonResponse = json.decode(responseBody);
          final errorMessage = jsonResponse['message'] ?? 'Upload failed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        } catch (e) {
          // Fallback if JSON parsing fails
          print('Upload failed: ${response.reasonPhrase}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Upload failed: ${response.reasonPhrase}')),
          );
        }
      }
    } catch (e) {
      print('❌ Exception during upload: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Network error: $e')));
    } finally {
      setState(() => _isProcessingAttendance = false);
    }
  }

  Future<void> _resetTodayAttendance() async {
    final prefs = await SharedPreferences.getInstance();
    final todayKey = DateFormat('dd-MM-yyyy').format(DateTime.now());

    await prefs.remove('$todayKey-date');
    await prefs.remove('$todayKey-location');

    setState(() {
      _pickedDateTime = null;
      _pickedLatLng = null;
      _image = null;
      _currentAddress = null;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Attendance for today reset.")));
  }

  Future<void> _markAttendance() async {
    // Check location permission
    if (_permissionStatus != LocationPermission.whileInUse &&
        _permissionStatus != LocationPermission.always) {
      await _checkLocationPermission();
      return;
    }

    setState(() => _isProcessingAttendance = true);

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final clickedDateTime = DateTime.now();
      final formattedDateTime = DateFormat(
        'dd/MM/yyyy',
      ).format(clickedDateTime);

      try {
        final position = await _geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        );

        // Extract latitude and longitude
        final lat = position.latitude;
        final lng = position.longitude;
        final latLng = '$lat,$lng';

        // Save and post to API
        await _saveAttendance(formattedDateTime, latLng);
        await _postImageToAPI(pickedImage, lat, lng, formattedDateTime);
      } catch (e) {
        print("Error getting location: $e");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Location error: $e")));
        setState(() => _isProcessingAttendance = false);
      }
    } else {
      setState(() => _isProcessingAttendance = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _checkLocationPermission();
    _loadSavedAttendance(); // Load saved data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchAttendanceData(_focusedDay);
      setState(() => _isInitialLoading = false);
    });
  }

  Future<void> _checkLocationPermission() async {
    _permissionStatus = await _geolocator.checkPermission();
    if (_permissionStatus == LocationPermission.denied) {
      _permissionStatus = await _geolocator.requestPermission();
      if (_permissionStatus != LocationPermission.whileInUse &&
          _permissionStatus != LocationPermission.always) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission required')),
        );
      }
    }
  }

  Future<void> _fetchAttendanceData(DateTime month) async {
    // final prefs = await SharedPreferences.getInstance();
    // final id = prefs.getString('profileId') ?? '';
    final token = await TokenManager.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final id = decodedToken['id'];
    // await Provider.of<AttendanceProvider>(
    //   context,
    //   listen: false,
    // ).fetchAttendance(id: id, forMonth: month);
    attendanceController.fetchAttendance(id: id, forMonth: month);
    print(token);
  }

  Widget _buildShimmerDay() {
    return Container(
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
          stops: const [0.1, 0.5, 0.9],
        ),
      ),
    );
  }

  Widget _buildShimmerCircle() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 45,
        width: 45,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
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
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _resetTodayAttendance,
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

  @override
  Widget build(BuildContext context) {
    final monthAttendance =
        attendanceController.getMonthAttendance(_focusedDay);
    if (_isInitialLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            children: [
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime.utc(2020),
                lastDay: DateTime.utc(2030),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, _) => _buildShimmerDay(),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 7,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Attendance Report",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildShimmerCircle()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance Calendar",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: _buildAttendanceContainer(),
            ),
            const SizedBox(height: 5),
            // monthAttendance == null || monthAttendance.attendanceDetails.isEmpty
            //     ? const Text("No attendance data available")
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              calendarFormat: CalendarFormat.month,
              onDaySelected: (selectedDay, focusedDay) {
                attendanceController.updateSelectedDate(selectedDay);
              },
              onPageChanged: (focusedMonth) async {
                final token = await TokenManager.getToken();
                Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
                final id = decodedToken["id"];
                setState(() => _focusedDay = focusedMonth);
                await attendanceController.fetchAttendance(
                  id: id,
                  forMonth: focusedMonth,
                );
              },
              selectedDayPredicate: (day) =>
                  isSameDay(day, attendanceController.selectedDate.value),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) {
                  final status = attendanceController.getStatusForDate(day);

                  if (day.isAfter(DateTime.now())) {
                    return Center(
                      child: Text(
                        "${day.day}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  Color? bgColor;
                  if (status == "Present") {
                    bgColor = const Color(0xFF5DFF76);
                  } else if (status == "Absent") {
                    bgColor = Colors.red;
                  } else if (status == "On Leave") {
                    bgColor = Colors.orange;
                  }

                  return Container(
                    height: 35,
                    width: 35,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${day.day}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),
            const Divider(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Attendance Report",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.insights, color: Color(0xFF0A2D63)),
                    onPressed: () {
                      final data =
                          attendanceController.getMonthAttendance(_focusedDay);

                      if (data == null) return;

                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        builder: (_) => AttendanceInsightsPortal(
                          present: parsePercentage(data.presentPercentage),
                          absent: parsePercentage(data.totalAbsentPercentage),
                          plannedLeave: parsePercentage(
                            data.plannedLeavePercentage,
                          ),
                          unplannedLeave: parsePercentage(
                            data.unplannedLeavePercentage,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            //const SizedBox(height: 10),
            Obx(() {
              final data = attendanceController.getMonthAttendance(_focusedDay);

              return data != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle(
                          "Present\n Days",
                          data.presentCount,
                          Colors.green,
                        ),
                        _buildCircle(
                          "Absent\n Days",
                          data.absentCount,
                          Colors.red,
                        ),
                        _buildCircle(
                          "On\n Leave",
                          data.onLeaveCount,
                          Colors.orange,
                        ),
                        _buildCircle(
                          "Total\n Days",
                          data.totalDaysInMonth,
                          Colors.blue,
                        ),
                      ],
                    )
                  : attendanceController.isLoading.value
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            4,
                            (index) => _buildShimmerCircle(),
                          ),
                        )
                      : const Text("No attendance data available");
            })
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            "$count",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

double parsePercentage(String percentString) {
  return double.tryParse(percentString.replaceAll('%', '')) ?? 0.0;
}

class AttendanceInsightsPortal extends StatelessWidget {
  final double present;
  final double absent;
  final double plannedLeave;
  final double unplannedLeave;

  const AttendanceInsightsPortal({
    super.key,
    required this.present,
    required this.absent,
    required this.plannedLeave,
    required this.unplannedLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Insights',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A2D63)),
          ),
          const SizedBox(height: 20),
          _buildBar("Present Percentage", present, Colors.lightBlue),
          _buildBar("Absent Percentage", absent, Colors.green),
          _buildBar("Planned Leave %", plannedLeave, Colors.orange),
          _buildBar("Unplanned Leave %", unplannedLeave, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text("${value.toStringAsFixed(1)}%",
                  style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
