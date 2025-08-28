import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/token_manager.dart';
import '../OrdersAndProductsClass.dart';
import 'CreateOrderScreen.dart';

class CreateOrderController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Product> productsList = <Product>[].obs;
  final RxList<Product> productCardList = <Product>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProductsFromDropDown();
  }

  void getProductsFromDropDown() async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/product');
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
        print("productsList ========>>>>>> $dataList");
        final downloadedProducts =
            dataList.map((item) => Product.fromJson(item)).toList();
        productsList.assignAll(downloadedProducts);
      } else {
        productsList.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      productsList.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Products");
    } finally {
      isLoading.value = false;
    }
  }
}
