import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../resources/my_colors.dart';
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
          setState(() {
            controller.focusedDay.value = focusedDay;
            controller
                .getAttendanceOfMonth(DateFormat("yyyy-MM").format(focusedDay));
          });
        },
        calendarBuilders:
            CalendarBuilders(defaultBuilder: (context, day, focusedDay) {
              if (day.weekday == DateTime.sunday) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: const BoxDecoration(
                    color: MyColor.dashbord,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "${day.day}",
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
          if (controller.attendanceForTheMonth.value != null) {
            if (controller.hasAttendance(
                    controller.attendanceForTheMonth.value!.attendanceDetails,
                    day) ==
                "Present") {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${day.day}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (controller.hasAttendance(
                    controller.attendanceForTheMonth.value!.attendanceDetails,
                    day) ==
                "Absent") {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${day.day}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
          }
        }, todayBuilder: (context, day, focusedDay) {
          if (controller.attendanceForTheMonth.value != null) {
            if (controller.hasAttendance(
                    controller.attendanceForTheMonth.value!.attendanceDetails,
                    day) ==
                "Present") {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${day.day}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            } else if (controller.hasAttendance(
                    controller.attendanceForTheMonth.value!.attendanceDetails,
                    day) ==
                "Absent") {
              return Container(
                margin: const EdgeInsets.all(6.0),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  "${day.day}",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
          }
        }),
      );
    });
  }
}
