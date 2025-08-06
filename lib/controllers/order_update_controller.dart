import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/order_update_model.dart';
import '../utils/token_manager.dart';

class OrderUpdateController extends GetxController {
  final storage = const FlutterSecureStorage();

  var isLoading = false.obs;
  var responseMessage = ''.obs;
  OrderUpdateModel? updatedOrder;

  Future<void> updateOrderData({
    required String orderId, // pass this from UI
    required List<Products> products,
    required String shopName,
    required String shopAddress,
    required String shopOwnerName,
    required String phoneNo,
    required String deliveryDate,
    required String companyId,
    required String branchId,
    required String supervisorId,
    required String salesmanId,
  }) async {
    isLoading.value = true;

    final url = Uri.parse(
        'http://104.251.218.102:8080/api/order/$orderId'); // Replace with your actual PUT endpoint

    String? token = await TokenManager.getToken();

    final body = jsonEncode({
      "products": products.map((e) => e.toJson()).toList(),
      "shopName": shopName,
      "shopAddress": shopAddress,
      "shopOwnerName": shopOwnerName,
      "phoneNo": phoneNo,
      "deliveryDate": deliveryDate,
      "companyId": companyId,
      "branchId": branchId,
      "supervisorId": supervisorId,
      "salesmanId": salesmanId,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        final jsonResponse = json.decode(response.body);
        updatedOrder = OrderUpdateModel.fromJson(jsonResponse);
        responseMessage.value =
            updatedOrder?.message ?? "Order Updated Successfully";
      } else {
        responseMessage.value =
            "Failed to update order. Status Code: ${response.statusCode}";
        debugPrint("Error: ${response.body}");
      }
    } catch (e) {
      responseMessage.value = "Exception: $e";
      debugPrint("Exception in updateOrderData: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
