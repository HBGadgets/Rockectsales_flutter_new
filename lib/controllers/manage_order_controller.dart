import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/order_model.dart';
import '../utils/token_manager.dart';

class ManageOrderController extends GetxController {
  // Period Selection
  RxString selectedPeriod = 'Select Period'.obs;
  Rx<DateTime?> fromDate = Rx<DateTime?>(null);
  Rx<DateTime?> toDate = Rx<DateTime?>(null);
  RxBool isLoading = false.obs;

  RxList<Data> orderList = <Data>[].obs;
  RxDouble grossTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Load orders initially
  }

  /// Calculate gross total from all orders and their products
  void calculateGrossTotal() {
    double total = 0.0;

    for (var order in orderList) {
      for (var product in order.products ?? []) {
        final price = double.tryParse(product.price?.toString() ?? '0') ?? 0.0;
        final qty = double.tryParse(product.quantity?.toString() ?? '0') ?? 0.0;
        total += price * qty;
      }
    }

    grossTotal.value = total;
  }

  void selectPeriod(DateTimeRange? range) {
    if (range != null) {
      fromDate.value = range.start;
      toDate.value = range.end;
      selectedPeriod.value =
          "${DateFormat('dd MMM yyyy').format(range.start)} - ${DateFormat('dd MMM yyyy').format(range.end)}";
    }
  }

  void submitFilter() {
    // Optional: If the API supports date filter, use fromDate & toDate
    fetchOrders(); // Call fetch again if needed after filter
  }

  void generateInvoice() {
    // Placeholder - integrate PDF/invoice logic here
    Get.snackbar("Invoice", "Invoice generation started!");
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      String? token = await TokenManager.getToken();

      var response = await http.get(
        Uri.parse("http://104.251.218.102:8080/api/order"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        OrderModel orderModel = OrderModel.fromJson(jsonData);
        if (orderModel.success == true && orderModel.data != null) {
          orderList.value = orderModel.data!;
          calculateGrossTotal();

          /// 🔍 Print All Order Details
          for (var order in orderList) {
            // print("--------- ORDER START ---------");
            // print("Order ID: ${order.sId}");
            // print("Shop Name: ${order.shopName}");
            // print("Shop Address: ${order.shopAddress}");
            // print("Delivery Date: ${order.deliveryDate}");
            // print("Shop Owner: ${order.shopOwnerName}");
            // print("Phone No: ${order.phoneNo}");
            // print("Status: ${order.status}");
            // print("Created At: ${order.createdAt}");
            // print("Updated At: ${order.updatedAt}");
            //
            // print("Company: ${order.companyId?.companyName}");
            // print("Company: ${order.salesmanId}");
            // print(
            //     "Branch: ${order.branchId?.branchName} - ${order.branchId?.branchLocation}");
            // print("Supervisor: ${order.supervisorId?.supervisorName}");
            //
            // print("Products:");
            if (order.products != null) {
              for (var product in order.products!) {
                // print("  - Product Name: ${product.productName}");
                // print("    Quantity: ${product.quantity}");
                // print("    Price: ${product.price}");
                // print("    Product ID: ${product.sId}");
              }
            }

            print("--------- ORDER END ---------\n");
          }
        } else {
          print("API success false or no data");
        }
      } else {
        print("Failed to fetch orders: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
