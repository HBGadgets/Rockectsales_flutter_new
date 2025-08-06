import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/screens/admin/attendance/attendance%20screen/FilterOnSpecificDate.dart';
import 'package:rocketsale_rs/screens/admin/attendance/attendance%20screen/AttendanceUserCard.dart';

import '../../../../controllers/admin_attendance_controller.dart';
import '../../../../controllers/attendance_tab_controller.dart';

class Attendancetabchild extends StatefulWidget {
  const Attendancetabchild({super.key});

  @override
  State<Attendancetabchild> createState() => _AttendancetabchildState();
}

class _AttendancetabchildState extends State<Attendancetabchild> {
  final AdminAttendanceController controller =
      Get.put(AdminAttendanceController());
  DateTime? fromDate;
  DateTime? toDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: Column(
        children: [
          // SizedBox(height: size.width * 0.02),
          const Filteronspecificdate(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.attendanceList.isEmpty) {
                return const Center(child: Text("No attendance data found."));
              } else {
                return RefreshIndicator(
                  onRefresh: () async => controller.refreshAttendance(),
                  child: ListView.builder(
                    itemCount: controller.attendanceListFromSearch.length,
                    itemBuilder: (context, index) {
                      final item = controller.attendanceListFromSearch[index];
                      return Attendanceusercard(item: item);
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
