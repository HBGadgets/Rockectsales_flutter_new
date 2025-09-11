import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../resources/my_colors.dart';
import '../../TokenManager.dart';
import 'ExpenseModel.dart';

class ExpensesController extends GetxController {
  final RxList<Expense> expenses = <Expense>[].obs;
  final RxBool isLoading = true.obs;

  // final RxBool areProductsLoading = false.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;
  final RxBool isLoadingInDetails = false.obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getExpenses();
    super.onInit();
  }

  void showInvoiceDialog(BuildContext context) {
    final TextEditingController sgstController = TextEditingController();
    final TextEditingController cgstController = TextEditingController();
    final TextEditingController discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: sgstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "SGST",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: cgstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "CGST",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Discount",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: MyColor.dashbord,
                  foregroundColor: Colors.white),
              onPressed: () {
                String sgst = sgstController.text;
                String cgst = cgstController.text;
                String discount = discountController.text;

                // 👉 Do something with values
                print("SGST: $sgst, CGST: $cgst, Discount: $discount");

                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getExpenses() async {
    isLoading.value = true;
    isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      print("user token ======>>>> $token");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/get/expence?&limit=10${dateTimeFilter.value == "" ? "today" : dateTimeFilter.value}&search=${searchString.value}');

      print("url ======>>>>> $url");
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        print("expenseList ========>>>>>> $dataList");
        final expenseList =
            dataList.map((item) => Expense.fromJson(item)).toList();
        expenses.assignAll(expenseList);
      } else {
        expenses.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      expenses.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Expenses");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreExpensesCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/get/expence?page=$page&limit=10$dateTimeFilter&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        // final List<dynamic> dataList = jsonData;
        final expenseList =
            dataList.map((item) => Expense.fromJson(item)).toList();
        // page.value++;
        if (expenseList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        expenses.addAll(expenseList);
      } else {
        expenses.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      expenses.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Expenses");
    }
  }
}
