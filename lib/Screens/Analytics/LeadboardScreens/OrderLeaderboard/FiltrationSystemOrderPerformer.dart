import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import '../../../../resources/my_colors.dart';
import 'OrderLeaderboardController.dart';

class FiltrationSystemOrderPerformers extends StatelessWidget {
  FiltrationSystemOrderPerformers({super.key});

  final Debouncer _debouncer = Debouncer();

  final TextEditingController searchController = TextEditingController();

  final OrderLeaderboardController controller = Get.put(OrderLeaderboardController());

  void _handleTextFieldChange(String value) {
    const duration = Duration(milliseconds: 500);
    _debouncer.debounce(
      duration: duration,
      onDebounce: () {
        controller.searchString.value = value;
        controller.getOrderPerformers();
      },
    );
  }

  void _prevMonth() {
    if (controller.month.value == 1) {
      controller.month.value = 12;
      controller.year.value = controller.year.value - 1;
    } else {
      controller.month.value = controller.month.value - 1;
    }
    controller.getOrderPerformers();
  }

  void _nextMonth() {
    if (controller.month.value == 12) {
      controller.month.value = 1;
      controller.year.value = controller.year.value + 1;
    } else {
      controller.month.value = controller.month.value + 1;
    }
    controller.getOrderPerformers();
  }


  Future<void> _selectMonth(BuildContext context) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: DateTime(controller.year.value, controller.month.value),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      controller.month.value = selected.month;
      controller.year.value = selected.year;
      controller.getOrderPerformers();
    }
  }


  String monthName(int monthNumber) {
    return DateFormat('MMMM').format(DateTime(0, monthNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: _prevMonth,
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                      foregroundColor: Colors.black87
                  ),
                  onPressed: () => _selectMonth(context),
                  icon: const Icon(
                    Icons.date_range,
                    color: Colors.black,
                  ),
                  label: Obx(() => Text(
                    monthName(controller.month.value),
                    style: const TextStyle(color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                  ))
                  ,
                ),
                Obx(() => IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: (controller.month.value == DateTime.now().month &&
                      controller.year.value == DateTime.now().year)
                      ? null
                      : _nextMonth,
                ))
                ,
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
                        hintText: 'Search Order Performers',
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
