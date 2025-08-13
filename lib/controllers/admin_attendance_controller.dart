import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../utils/token_manager.dart';
import '../../models/admin_attendance_model.dart' as adminModel;

class AdminAttendanceController extends GetxController {
  var isLoading = false.obs;
  var selectedFilter = 'Today'.obs;

  var attendanceList = <adminModel.Data>[].obs;
  var attendanceListFromSearch = <adminModel.Data>[].obs;
  var attendanceSearchText = ''.obs;

  final List<Map<String, String>> filterOptions = [
    {'label': 'Today', 'value': 'today'},
    {'label': 'Yesterday', 'value': 'yesterday'},
    {'label': 'This Week', 'value': 'thisWeek'},
    {'label': 'Previous Week', 'value': 'previousWeek'},
    {'label': 'This Month', 'value': 'thisMonth'},
    {'label': 'Previous Month', 'value': 'previousMonth'},
    {'label': 'Custom', 'value': 'custom'},
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAttendance(selectedFilter.value);
  }

  void refreshAttendance() {
    fetchAttendance(selectedFilter.value);
  }

  // search for users with debounced text
  // function coming soon

  /// Fetch Attendance based on predefined filters
  Future<void> fetchAttendance(String filter) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url =
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/attendence?$filter');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final attendanceData =
            adminModel.Admin_attendance_model.fromJson(jsonData);
        attendanceList.assignAll(attendanceData.data ?? []);
        attendanceListFromSearch.assignAll(attendanceData.data ?? []);
      } else {
        attendanceList.clear();
        attendanceListFromSearch.clear();
        Get.snackbar(
            "Error", "Failed to load data (Code: ${response.statusCode})");
      }
    } catch (e) {
      attendanceList.clear();
      attendanceListFromSearch.clear();
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Filter selector
  /// Filter selector
  void updateFilter(String filter) {
    selectedFilter.value = filter;
    if (filter != 'custom') {
      fetchAttendance(filter);
    }
  }
}
