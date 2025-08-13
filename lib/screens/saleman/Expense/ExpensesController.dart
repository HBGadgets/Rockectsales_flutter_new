import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
// import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:intl/intl.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:rocketsale_rs/resources/my_assets.dart';

import '../../../models/expense/expenseList.dart';
import '../../../utils/token_manager.dart';

class ExpensesController extends GetxController {
  var fromDate = Rxn<DateTime>();

  var toDate = Rxn<DateTime>();

  var Today = DateTime.now().obs;

  var selectedTime = TimeOfDay.now().obs;

  var twelveAM = const TimeOfDay(hour: 00, minute: 00).obs;

  var dateTimeFilter = ''.obs;
  var salesmanName = Rxn<String>;

  var searchController = TextEditingController().obs;

  var isLoading = false.obs;

  var expensesList = <Expense>[].obs;
  var expensesListFromSearch = <Expense>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchExpenses(dateTimeFilter.value);
  }

  void refreshExpenses() {
    fetchExpenses(dateTimeFilter.value);
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

  // Future<void> _pickTime(String fromDateString, BuildContext context) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (picked != null) {
  //     selectedTime.value = picked;
  //     String date = formatDate(fromDate.value!);
  //
  //     String fromTimeString = formatTimeOfDayFull(twelveAM.value);
  //
  //     String endTimeString = formatTimeOfDayFull(selectedTime.value);
  //
  //     dateTimeFilter.value = "startDate=$date" +
  //         "T" +
  //         fromTimeString +
  //         "Z&endDate=$date" +
  //         "T" +
  //         endTimeString +
  //         "Z";
  //   }
  // }

  void applyFilter(BuildContext context) {
    fetchExpenses(dateTimeFilter.value);
  }

  // Future<void> _selectFromDate(BuildContext context) async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     // initialDate: fromDate ?? DateTime.now(),
  //     initialDate: fromDate.value ?? DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null) {
  //     fromDate.value = picked;
  //     String date = formatDate(fromDate.value!);
  //
  //     _pickTime(date, context);
  //   }
  // }

  Future<void> fetchExpenses(String filter) async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url =
          Uri.parse('${dotenv.env['BASE_URL']}/api/api/expence?$filter');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];
        final List<Expense> expenseData =
            data.map((e) => Expense.fromJson(e)).toList();
        // final expenseData = Expense.fromJson(jsonData);
        expensesList.assignAll(expenseData);
        expensesListFromSearch.assignAll(expenseData);
      } else {
        expensesList.clear();
        expensesListFromSearch.clear();
        Get.snackbar(
            "Error", "Failed to load data (Code: ${response.statusCode})");
      }
    } catch (e) {
      expensesList.clear();
      expensesListFromSearch.clear();
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
