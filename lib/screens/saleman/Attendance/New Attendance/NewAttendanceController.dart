import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/token_manager.dart';
import 'AttendanceModel.dart';

class NewAttendanceController extends GetxController {
  final AttendanceService attendanceService;

  NewAttendanceController({required this.attendanceService});

  final RxMap<String, Attendance> _monthlyData = <String, Attendance>{}.obs;
  final RxBool isLoading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  Attendance? getMonthAttendance(DateTime month) {
    final key = _formatMonthKey(month);
    return _monthlyData[key];
  }

  Future<void> fetchAttendance({
    required String id,
    required DateTime forMonth,
  }) async {
    final key = _formatMonthKey(forMonth);
    if (_monthlyData.containsKey(key)) return; // Already fetched

    isLoading.value = true;

    try {
      final attendance = await attendanceService.fetchAttendance(
        id: id,
        forMonth: forMonth,
      );

      _monthlyData[key] = attendance ??
          Attendance(
            presentCount: 0,
            absentCount: 0,
            onLeaveCount: 0,
            totalDaysInMonth:
                DateTime(forMonth.year, forMonth.month + 1, 0).day,
            presentPercentage: "0.00%",
            totalAbsentPercentage: "0.00%",
            unplannedLeavePercentage: "0.00%",
            plannedLeavePercentage: "0.00%",
            attendanceDetails: [],
          );
    } catch (e) {
      print('Error fetching attendance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  String? getStatusForDate(DateTime date) {
    final attendance = _monthlyData[_formatMonthKey(date)];
    final formattedDate =
        "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";

    final match = attendance?.attendanceDetails.firstWhere(
      (d) => d.createdAt == formattedDate,
      orElse: () => AttendanceDetail(status: '', createdAt: ''),
    );

    return match?.status.isNotEmpty == true ? match!.status : null;
  }

  String _formatMonthKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }
}

class AttendanceService extends ApiService {
  Future<Attendance?> fetchAttendance({
    required String id,
    required DateTime forMonth,
  }) async {
    final monthKey =
        "${forMonth.year}-${forMonth.month.toString().padLeft(2, '0')}";
    final endpoint = "/api/api/attendence-by-id?month=$monthKey";
    print(endpoint);
    try {
      final response = await getRequest(endpoint: endpoint);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Attendance.fromJson(jsonData);
      } else {
        print('Failed to fetch attendance: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Attendance fetch error: $e');
      return null;
    }
  }
}

class ApiService {
  static final String _baseUrl = '${dotenv.env['BASE_URL']}';

  Future<http.Response> getRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final token = await TokenManager.getToken();
    final url = Uri.parse('$_baseUrl/$endpoint');

    return await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        ...?headers,
      },
    );
  }

  Future<http.Response> postRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final token = await TokenManager.getToken();
    final uri = Uri.parse("$_baseUrl/$endpoint");

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> putRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final token = await TokenManager.getToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');

    final response = await http.put(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> patchRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    final token = await TokenManager.getToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');

    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> deleteRequest({
    required String endpoint,
    Map<String, String>? headers,
  }) async {
    final token = await TokenManager.getToken();
    final uri = Uri.parse('$_baseUrl/$endpoint');

    final response = await http.delete(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
    );
    return response;
  }

  Future<http.Response> multipartRequest({
    required String endpoint,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final url = Uri.parse('$_baseUrl/$endpoint');

    var request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = 'Bearer $token';

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    // Add files
    files.forEach((key, value) async {
      request.files.add(
        await http.MultipartFile.fromPath(
          key,
          value.path,
          filename: value.path.split('/').last,
        ),
      );
    });

    var response = await request.send();
    return http.Response.fromStream(response);
  }

  Future<http.Response> multipartPatchRequest({
    required String endpoint,
    required Map<String, String> fields,
    required Map<String, File> files,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = await TokenManager.getToken();
    final url = Uri.parse('$_baseUrl/$endpoint');

    var request = http.MultipartRequest('PATCH', url);
    request.headers['Authorization'] = 'Bearer $token';

    fields.forEach((key, value) {
      request.fields[key] = value;
    });

    for (var entry in files.entries) {
      request.files
          .add(await http.MultipartFile.fromPath(entry.key, entry.value.path));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
