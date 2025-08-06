import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:intl/intl.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:rocketsale_rs/resources/my_assets.dart';

import '../../../../controllers/admin_attendance_controller.dart';
import '../../../../controllers/attendance_tab_controller.dart';
import '../../../../models/admin_attendance_model.dart' as adminModel;

class Filteronspecificdate extends StatefulWidget {
  const Filteronspecificdate({super.key});

  @override
  State<Filteronspecificdate> createState() => _FilteronspecificdateState();
}

class _FilteronspecificdateState extends State<Filteronspecificdate> {
  DateTime? fromDate;

  DateTime? toDate;

  DateTime Today = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  late String dateTimeFilter = '';

  final Debouncer _debouncer = Debouncer();
  late String salesmanName;

  final TextEditingController searchController = TextEditingController();

  var filteredAttendanceList = <adminModel.Data>[];

  final AdminAttendanceController controller =
      Get.put(AdminAttendanceController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        if (value.isEmpty) {
          controller.attendanceListFromSearch.value = controller.attendanceList;
        } else {
          controller.attendanceListFromSearch.value =
              controller.attendanceList.where((s) {
            final name = s.salesmanId?.salesmanName?.toLowerCase() ?? '';
            final phone = s.salesmanPhone?.toLowerCase() ?? '';
            return name.contains(value) || phone.contains(value);
          }).toList();
        }
      },
    );
  }

  String formatTimeOfDayFull(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute:00.000";
  }

  String formatTimeOfDay(BuildContext context, TimeOfDay time) {
    return time.format(context); // returns something like "1:45 PM"
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _pickTime(String fromDateString) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
        String date = formatDate(fromDate!);

        String fromTimeString = formatTimeOfDayFull(twelveAM);

        String endTimeString = formatTimeOfDayFull(selectedTime);

        dateTimeFilter = "startDate=$date" +
            "T" +
            fromTimeString +
            "Z&endDate=$date" +
            "T" +
            endTimeString +
            "Z";
      });
    }
  }

  void applyFilter() {
    controller.fetchAttendance(dateTimeFilter);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        String date = formatDate(fromDate!);

        _pickTime(date);
      });
    }
  }

  // void _filterList(String query) {
  //   if (query.isEmpty) {
  //     filteredAttendanceList = List.from(controller.attendanceList);
  //   } else {
  //     filteredAttendanceList = controller.attendanceList.where((item) {
  //       salesmanName = item.salesmanId?.salesmanName ?? '';
  //       salesmanName.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   setState(() {}); // If you're in a StatefulWidget
  // }

  @override
  Widget build(BuildContext context) {
    // searchController.addListener(() {
    //   if (_debounce?.isActive ?? false) _debounce!.cancel();
    //   _debounce = Timer(const Duration(milliseconds: 500), () {
    //     final text = searchController.text;
    //     _filterList(text);
    //   });
    // });
    return Container(
        margin: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                // Date box takes 2/3rd
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectFromDate(context),
                    icon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    label: Row(
                      children: [
                        Text(
                          fromDate != null
                              ? DateFormat('dd/MM/yyyy').format(fromDate!)
                              : DateFormat('dd/MM/yyyy').format(Today),
                          style: const TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Text(
                          formatTimeOfDay(context, selectedTime),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Apply button takes 1/3rd
                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        backgroundColor: dateTimeFilter.isEmpty
                            ? Colors.white
                            : Colors.green,
                        // side: const BorderSide(color: Colors.black54),
                        side: dateTimeFilter.isEmpty
                            ? BorderSide(color: Colors.black54)
                            : BorderSide(color: Colors.green)),
                    onPressed: () {
                      if (dateTimeFilter.isNotEmpty) {
                        applyFilter();
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      color:
                          dateTimeFilter.isEmpty ? Colors.black : Colors.white,
                    ),
                    label: Text(
                      'Apply',
                      style: TextStyle(
                        color: dateTimeFilter.isEmpty
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 7, bottom: 7),
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
            )
          ],
        ));
  }
}
