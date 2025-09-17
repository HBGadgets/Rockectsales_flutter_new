import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'NewAttendanceController.dart';

class AttendanceReport extends StatelessWidget {
  AttendanceReport({Key? key}) : super(key: key);

  final NewAttendanceController controller =
  Get.put(NewAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Monthly Report",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Four circles in a row
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttendanceItem(
                    controller.attendanceForTheMonth.value?.presentPercentage ??
                        "0",
                    "Present\nDays",
                    Colors.green),
                _buildAttendanceItem(
                    controller.attendanceForTheMonth.value?.absentCount
                            .toString() ??
                        "0",
                    "Absent\nDays",
                    Colors.red),
                _buildAttendanceItem(
                    controller.attendanceForTheMonth.value?.onLeaveCount
                            .toString() ??
                        "0",
                    "On\nLeave",
                    Colors.grey),
                _buildTotalDaysItem(
                    controller.attendanceForTheMonth.value?.totalDaysInMonth
                            .toString() ??
                        "0",
                    "Total\nDays",
                    Colors.grey),
              ],
            );
          })
        ],
      ),
    );
  }

  // Reusable widget
  Widget _buildAttendanceItem(String count, String label, Color borderColor) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${count.split('.')[0]}%",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTotalDaysItem(String count, String label, Color borderColor) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${count.split('.')[0]}",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
