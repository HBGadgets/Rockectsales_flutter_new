import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/screens/saleman/Expense/ExpensesController.dart';

class FilterExpensesBar extends StatelessWidget {
  FilterExpensesBar({super.key});

  final ExpensesController controller = Get.put(ExpensesController());

  void _handleTextFieldChange(String value) {
    if (value.isEmpty) {
      controller.expensesListFromSearch.value = controller.expensesList;
    } else {
      controller.expensesListFromSearch.value =
          controller.expensesList.where((expense) {
        final name = expense.expenceDescription.toLowerCase();
        return name.contains(value);
      }).toList();
    }
  }

  void applyFilter(BuildContext context) {
    controller.fetchExpenses(controller.dateTimeFilter.value);
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: controller.fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.fromDate.value = picked;
      String date = controller.formatDate(controller.fromDate.value!);

      _pickTime(date, context);
    }
  }

  Future<void> _pickTime(String fromDateString, BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      controller.selectedTime.value = picked;
      print('changed date and time');
      print(picked);
      String date = controller.formatDate(controller.fromDate.value!);

      String fromTimeString =
          controller.formatTimeOfDayFull(controller.twelveAM.value);

      String endTimeString =
          controller.formatTimeOfDayFull(controller.selectedTime.value);

      controller.dateTimeFilter.value = "startDate=$date" +
          "T" +
          fromTimeString +
          "Z&endDate=$date" +
          "T" +
          endTimeString +
          "Z";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          controller.fromDate.value != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(controller.fromDate.value!)
                              : DateFormat('dd/MM/yyyy')
                                  .format(controller.Today.value),
                          style: const TextStyle(color: Colors.black),
                        ),
                        Spacer(),
                        Text(
                          controller.formatTimeOfDay(
                              context, controller.selectedTime.value),
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  flex: 1,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        backgroundColor: controller.dateTimeFilter.value.isEmpty
                            ? Colors.white
                            : Colors.green,
                        // side: const BorderSide(color: Colors.black54),
                        side: controller.dateTimeFilter.value.isEmpty
                            ? BorderSide(color: Colors.black54)
                            : BorderSide(color: Colors.green)),
                    onPressed: () {
                      if (controller.dateTimeFilter.value.isNotEmpty) {
                        controller.applyFilter(context);
                      }
                    },
                    icon: Icon(
                      Icons.check,
                      color: controller.dateTimeFilter.value.isEmpty
                          ? Colors.black
                          : Colors.white,
                    ),
                    label: Text(
                      'Apply',
                      style: TextStyle(
                        color: controller.dateTimeFilter.value.isEmpty
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
