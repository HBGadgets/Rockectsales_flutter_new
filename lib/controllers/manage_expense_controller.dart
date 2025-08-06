import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/screens/admin/dashboard_admin.dart';

import '../models/expense/expenseList.dart';
import '../service_class/common_service.dart';

class ManageExpenseController extends GetxController {
  RxString userName = 'Karan Sharma'.obs;
  RxString selectedExpenseType = ''.obs;
  RxString imageUrl = ''.obs;
  RxList<Expense> expenses = <Expense>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedSalesmanId = ''.obs;
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController EmpolyName = TextEditingController();
  RxList<ExpenseTypeModel> expenseTypeList = <ExpenseTypeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenseTypes();
  }

  Future<void> fetchExpenseTypes() async {
    try {
      isLoading.value = true;
      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: '/api/expencetype',
      );
      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'];
        expenseTypeList.value =
            data.map((e) => ExpenseTypeModel.fromJson(e)).toList();
      } else {
        Get.snackbar(
            'Error', response['message'] ?? 'Failed to load expense types');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchExpenses(String salesmanId) async {
    try {
      isLoading.value = true;

      // Build base endpoint
      String endpoint = '/api/expence/salesman/$salesmanId';

      // If both dates are selected, add them as query parameters
      if (fromDate.value != null && toDate.value != null) {
        final from =
            Uri.encodeQueryComponent(fromDate.value!.toIso8601String());
        final to = Uri.encodeQueryComponent(toDate.value!.toIso8601String());
        endpoint += '?startDate=$from&endDate=$to';
      }

      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: endpoint,
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data'];
        expenses.value = data.map((e) => Expense.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', response['message'] ?? 'Unknown error');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // pick date and time
  Future<void> pickFromDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: fromDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(fromDate.value ?? DateTime.now()),
      );

      fromDate.value = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? 0,
        pickedTime?.minute ?? 0,
      );
    }
  }

  Future<void> pickToDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: toDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(toDate.value ?? DateTime.now()),
      );

      toDate.value = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime?.hour ?? 0,
        pickedTime?.minute ?? 0,
      );
    }
  }

  void submitFilter() {
    if (fromDate.value != null &&
        toDate.value != null &&
        selectedSalesmanId.value.isNotEmpty) {
      fetchExpenses(selectedSalesmanId.value);
    } else {
      Get.snackbar('Missing Data', 'Please select both dates and a salesman');
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      isLoading.value = true;

      final response = await ApiServiceCommon.request(
        method: 'DELETE',
        endpoint: '/api/expence/$expenseId',
      );

      if (response != null && response['success'] == true) {
        Get.snackbar('Success', response['message'] ?? 'Expense deleted');
        print("${expenseId}");
        // Refetch updated expenses list
        fetchExpenses(selectedSalesmanId.value);
      } else {
        Get.snackbar(
            'Error', response['message'] ?? 'Failed to delete expense');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void resetFields() {
    descriptionController.clear();
    amountController.clear();
    EmpolyName.clear();
    fromDate.value = null;
    toDate.value = null;
    selectedExpenseType.value = '';
    selectedSalesmanId.value = '';
  }

  Future<void> updateExpense(String expenseId) async {
    if (isLoading.value) return; // Prevent multiple taps

    try {
      // 🧪 Validation
      if (selectedExpenseType.value.isEmpty) {
        Get.snackbar("Validation Error", "Please select an expense type");
        print("❌ Expense type is empty");
        return;
      }

      if (descriptionController.text.trim().isEmpty) {
        Get.snackbar("Validation Error", "Please enter description");
        print("❌ Description is empty");
        return;
      }

      if (fromDate.value == null) {
        Get.snackbar("Validation Error", "Please select a date");
        print("❌ Date is not selected");
        return;
      }

      if (amountController.text.trim().isEmpty) {
        Get.snackbar("Validation Error", "Please enter amount");
        print("❌ Amount is empty");
        return;
      }

      // 📅 Format date safely
      String formattedDate;
      try {
        formattedDate = DateFormat('dd/MM/yyyy').format(fromDate.value!);
      } catch (e) {
        Get.snackbar("Date Error", "Invalid date format");
        print("❌ FormatException on date: $e");
        return;
      }

      isLoading.value = true;

      final payload = {
        "expenceType": selectedExpenseType.value,
        "expenceDescription": descriptionController.text.trim(),
        "date": formattedDate,
        "billDoc": "nothing",
        "amount": int.tryParse(amountController.text.trim()) ?? 0,
      };

      print("📦 Final Payload: $payload");

      final response = await ApiServiceCommon.request(
        method: 'PUT',
        endpoint: '/api/expence/$expenseId',
        payload: payload,
      );

      if (response != null && response['success'] == true) {
        //  Get.off(DashboardAdmin());
        Get.snackbar("Success", "Expense updated successfully");

        // ✅ Fix: If salesmanId is missing locally but present in response, assign it
        if (selectedSalesmanId.value.isEmpty &&
            response['data']?['salesmanId'] != null) {
          selectedSalesmanId.value = response['data']['salesmanId'];
          print(
              "ℹ️ selectedSalesmanId set from response: ${selectedSalesmanId.value}");
        }

        // 🔄 Refresh expense list
        if (selectedSalesmanId.value.isNotEmpty) {
          await fetchExpenses(selectedSalesmanId.value);
        } else {
          print("⚠️ selectedSalesmanId still empty, skipping fetchExpenses()");
        }

        Get.back(); // Go back to previous screen
      } else {
        print("❌ API Error Response: $response");
        Get.snackbar("Error", response['message'] ?? "Update failed");
      }
    } catch (e, stackTrace) {
      print('❌ Exception occurred: $e');
      print('📌 StackTrace: $stackTrace');
      // ✅ Don't show this unless it's really unhandled (404 shouldn't show as "Exception")
      if (e.toString().contains("Exception")) {
        Get.snackbar("Error", "Something went wrong. Please try again.");
      }
    } finally {
      isLoading.value = false;
    }
  }
}

///model
class ExpenseTypeModel {
  final String id;
  final String name;

  ExpenseTypeModel({required this.id, required this.name});

  factory ExpenseTypeModel.fromJson(Map<String, dynamic> json) {
    return ExpenseTypeModel(
      id: json['_id'],
      name: json['expenceType'],
    );
  }
}
