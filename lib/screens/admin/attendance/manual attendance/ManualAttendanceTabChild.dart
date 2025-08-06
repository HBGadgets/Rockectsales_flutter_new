import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/screens/admin/attendance/attendance%20screen/AttendanceUserCard.dart';

import '../../../../controllers/admin_attendance_controller.dart';
import '../../../../controllers/manual_attendance_controller.dart';
import '../../../saleman/Attendance/Attendance_Page.dart';
import 'ManualUserCard.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class Manualattendancetabchild extends StatelessWidget {
  Manualattendancetabchild({super.key});

  // final controller = Get.put(ManualAttendanceController());
  final ManualAttendanceController controller =
      Get.put(ManualAttendanceController());

  final Debouncer _debouncer = Debouncer();
  final AdminAttendanceController adminController =
      Get.put(AdminAttendanceController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        if (value.isEmpty) {
          adminController.attendanceListFromSearch.value =
              adminController.attendanceList;
        } else {
          adminController.attendanceListFromSearch.value =
              adminController.attendanceList.where((s) {
            final name = s.salesmanId?.salesmanName?.toLowerCase() ?? '';
            final phone = s.salesmanPhone?.toLowerCase() ?? '';
            return name.contains(value) || phone.contains(value);
          }).toList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // controller.fetchManualAttendanceData();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final list = controller.manualAttendanceModel.value?.absentSalesmen;

      if (list == null || list.isEmpty) {
        return Center(child: Text('No absent salesmen found.'));
      }
      return Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.only(top: 7, bottom: 7, left: 10, right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black54)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: _handleTextFieldChange,
                      decoration: const InputDecoration(
                        hintText: 'Search User',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.fetchManualAttendanceData(),
                child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    return Manualusercard(item: item);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
//
// Card(
// margin: EdgeInsets.all(12),
// shape:
// RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
// elevation: 4,
// color: Colors.white,
// child: Padding(
// padding: const EdgeInsets.all(12.0),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Profile Image
// CircleAvatar(
// radius: 30,
// backgroundImage: NetworkImage(
// ''), // replace with image URL or AssetImage
// ),
// SizedBox(width: 12),
//
// // Main Content Column
// Expanded(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// // Name & Edit Icon Row
// Row(
// children: [
// Expanded(
// child: Text(
// item.salesmanName ?? 'N/A',
// style: TextStyle(
// fontSize: 16, fontWeight: FontWeight.bold),
// ),
// ),
// Icon(Icons.edit, color: Colors.blue, size: 18),
// ],
// ),
// SizedBox(height: 4),
//
// // Phone Number
// Row(
// children: [
// Icon(Icons.phone, size: 16),
// SizedBox(width: 6),
// Text(item.salesmanPhone ?? ''),
// ],
// ),
// SizedBox(height: 4),
//
// // Date Row
// Row(
// children: [
// Icon(Icons.calendar_today, size: 16),
// SizedBox(width: 6),
// Text("12/07/2024"),
// // You can format the date dynamically
// ],
// ),
// ],
// ),
// ),
//
// // Present/Absent Buttons
// Column(
// crossAxisAlignment: CrossAxisAlignment.end,
// children: [
// ElevatedButton(
// onPressed: () {
// controller.postAttendance(
// salesmanId: item.sId ?? '',
// attendenceStatus: 'Present',
// companyId: item.companyId?.sId ?? '',
// branchId: item.branchId?.sId ?? '',
// supervisorId: item.supervisorId?.sId ?? '',
// );
// controller.manualAttendanceModel();
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.green.shade100,
// foregroundColor: Colors.black,
// padding:
// EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// ),
// child: Text("Present"),
// ),
// SizedBox(height: 8),
// ElevatedButton(
// onPressed: () {
// controller.postAttendance(
// salesmanId: item.sId ?? '',
// attendenceStatus: 'Absent',
// companyId: item.companyId?.sId ?? '',
// branchId: item.branchId?.sId ?? '',
// supervisorId: item.supervisorId?.sId ?? '',
// );
// controller.manualAttendanceModel();
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.red.shade100,
// foregroundColor: Colors.black,
// padding:
// EdgeInsets.symmetric(horizontal: 12, vertical: 4),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// ),
// child: Text("Absent"),
// ),
// ],
// ),
// ],
// ),
// ),
// );
