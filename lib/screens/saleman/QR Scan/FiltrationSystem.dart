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
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';

import '../../../../controllers/admin_attendance_controller.dart';
import '../../../../controllers/attendance_tab_controller.dart';
import '../../../../models/admin_attendance_model.dart' as adminModel;

class Filtrationsystem extends StatefulWidget {
  const Filtrationsystem({super.key});

  @override
  State<Filtrationsystem> createState() => _FiltrationsystemState();
}

class _FiltrationsystemState extends State<Filtrationsystem> {
  DateTime? fromDate;
  DateTime? tillDate;

  DateTime? toDate;

  DateTime Today = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  // late String dateTimeFilter = '';

  final Debouncer _debouncer = Debouncer();
  late String salesmanName;

  final TextEditingController searchController = TextEditingController();

  var filteredAttendanceList = <adminModel.Data>[];

  final QRCardsController controller = Get.put(QRCardsController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getQRCards();
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

  String filterString(DateTime fromDate, DateTime tillDate) {
    String filterString1 =
        "&fromDate=${formatDate(fromDate)}&toDate=${formatDate(tillDate)}";
    return filterString1;
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
        // String date = formatDate(fromDate!);

        // _pickTime(date);
      });
    }
  }

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: tillDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        tillDate = picked;
        // String date = formatDate(fromDate!);

        // _pickTime(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          children: [
            Row(
              children: [
                // Date box takes 2/3rd
                OutlinedButton.icon(
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
                    ],
                  ),
                ),

                // const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.arrow_forward_outlined,
                    size: 15,
                  ),
                ),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    side: const BorderSide(color: Colors.black54),
                  ),
                  onPressed: () => _selectTillDate(context),
                  icon: const Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  label: Row(
                    children: [
                      Text(
                        tillDate != null
                            ? DateFormat('dd/MM/yyyy').format(tillDate!)
                            : DateFormat('dd/MM/yyyy').format(Today),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // Apply button takes 1/3rd
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      // backgroundColor: MyColor.dashbord,
                      // side: const BorderSide(color: Colors.black54),
                      side: BorderSide(color: Colors.black)),
                  onPressed: () {
                    controller.dateTimeFilter.value = filterString(
                        fromDate ?? DateTime.now(), tillDate ?? DateTime.now());
                    controller.getQRCards();
                  },
                  label: const Icon(
                    Icons.check,
                    color: Colors.black,
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
                        hintText: 'Search QR',
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
