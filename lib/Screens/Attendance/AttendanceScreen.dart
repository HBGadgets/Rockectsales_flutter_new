import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../resources/my_colors.dart';
import 'AttendanceCard.dart';
import 'AttendanceReport.dart';
import 'NewAttendanceController.dart';
import 'TableCalendar.dart';

class AttendanceScreen extends StatelessWidget {
  final String name;

  AttendanceScreen({required this.name});

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
