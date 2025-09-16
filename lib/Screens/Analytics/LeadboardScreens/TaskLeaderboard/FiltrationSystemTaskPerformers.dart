import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:month_year_picker/month_year_picker.dart';

import '../../../../resources/my_colors.dart';
import 'TaskLeaderboardController.dart';

class FiltrationSystemtaskPerformers extends StatelessWidget {
  FiltrationSystemtaskPerformers({super.key});

  DateTime? fromDate;

  DateTime? tillDate;

  DateTime? toDate;

  DateTime Today = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay.now();

  TimeOfDay twelveAM = const TimeOfDay(hour: 00, minute: 00);

  // late String dateTimeFilter = '';
  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final TaskLeaderboardController controller = Get.put(TaskLeaderboardController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getTaskPerformers();
      },
    );
  }

  void _prevMonth() {
    controller.month.value = controller.month.value - 1;
  }

  void _nextMonth() {
    controller.month.value = controller.month.value + 1;
  }

  Future<void> _selectMonth(BuildContext context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime(2025),
    );
    if (selected != null) {
      // setState(() {
      //   fromDate = picked;
      // });
      controller.month.value = selected.month;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
          Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: _prevMonth,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  side: const BorderSide(color: Colors.black54),
                ),
                onPressed: () => _selectMonth(context),
                icon: const Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
                label: Text(
                  controller.month.value.toString().padLeft(2, '0'),
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // child: Row(
              //   children: [
              //     const Icon(Icons.calendar_month, size: 20, color: Colors.black87),
              //     const SizedBox(width: 8),
              //     Text(
              //       controller.month.value.toString().padLeft(2, '0'),
              //       style: const TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 16,
              //       ),
              //     ),
              //   ],
              // ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: _nextMonth,
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
                        hintText: 'Search Tasks',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.search),
                ],
              ),
            ),
          ],
        ));
  }
}
