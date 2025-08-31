import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/New%20Attendance/AttendanceCard.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/New%20Attendance/AttendanceReport.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/New%20Attendance/TableCalendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../resources/my_colors.dart';
import 'NewAttendanceController.dart';

class AttendanceScreen extends StatelessWidget {
  final String name;

  AttendanceScreen({required this.name});

  // final NewAttendanceController controller = Get.put(NewAttendanceController(attendanceService: null));
  final controller = Get.put(NewAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AttendanceCard(
              name: name,
              date: controller.focusedDay.value,
              location: controller.addressString.value,
            ),
            Obx(() {
              return Stack(
                children: [
                  TableCalendarWidget(),
                  if (controller.isLoading.value)
                    Positioned.fill(
                      child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.35),
                        child: const Center(
                          child: CircularProgressIndicator(
                              color: MyColor.dashbord),
                        ),
                      ),
                    ),
                ],
              );
            }),
            AttendanceReport()
          ],
        ),
      ),
    );
  }
}
