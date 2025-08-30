import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'AttendanceModel.dart';
import 'NewAttendanceController.dart';

class TableCalendarWidget extends StatefulWidget {
  const TableCalendarWidget({super.key});

  @override
  State<TableCalendarWidget> createState() => _TableCalendarWidgetState();
}

class _TableCalendarWidgetState extends State<TableCalendarWidget> {
  final NewAttendanceController controller =
      Get.find<NewAttendanceController>();

  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final attendance = controller.attendanceForTheMonth.value;
      return TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.now(),
        focusedDay: controller.focusedDay.value ?? DateTime.now(),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            controller.focusedDay.value = focusedDay;
          });
        },

        onPageChanged: (focusedDay) {
          controller.focusedDay.value = focusedDay;
          controller
              .getAttendanceOfMonth(DateFormat("yyyy-MM").format(focusedDay));
        },

        // 🔹 Custom day rendering
        // calendarBuilders: CalendarBuilders(
        //   defaultBuilder: (context, day, focusedDay) {
        //     // If no attendance loaded, return normal day
        //
        //     if (day)
        //       // Find matching attendance record for this day
        //       final detail = attendance.attendanceDetails.firstWhere(
        //         (d) =>
        //             d.createdAt != null &&
        //             d.createdAt!.year == day.year &&
        //             d.createdAt!.month == day.month &&
        //             d.createdAt!.day == day.day,
        //         orElse: () => AttendanceDetail(
        //           status: "",
        //           createdAt: null,
        //           startLat: 0,
        //           startLong: 0,
        //           salesmanName: "",
        //         ),
        //       );
        //
        //     // If no record, return normal number
        //     if (detail.createdAt == null) {
        //       return Center(child: Text("${day.day}"));
        //     }
        //
        //     // ✅ Status-based color
        //     Color bgColor = Colors.grey;
        //     if (detail.status.toLowerCase() == "present") {
        //       bgColor = Colors.green;
        //     } else if (detail.status.toLowerCase() == "absent") {
        //       bgColor = Colors.red;
        //     }
        //
        //     return Container(
        //       margin: const EdgeInsets.all(6.0),
        //       decoration: BoxDecoration(
        //         color: bgColor,
        //         shape: BoxShape.circle,
        //       ),
        //       alignment: Alignment.center,
        //       child: Text(
        //         "${day.day}",
        //         style: const TextStyle(color: Colors.white),
        //       ),
        //     );
        //   },
        // ),
      );
    });
  }
}
