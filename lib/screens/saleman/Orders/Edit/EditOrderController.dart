import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/token_manager.dart';
import '../OrdersAndProductsClass.dart';

class EditOrderController extends GetxController {
  // final RxList<ProductFromDropdown> productsFromDropDown =
  //     <ProductFromDropdown>[].obs;
  // final RxBool isLoading = true.obs;
  // final Rxn<ProductFromDropdown> selectedProduct = Rxn<ProductFromDropdown>();
  //
  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   getProductsFromDropDown();
  // }
  //
  // void getProductsFromDropDown() async {
  //   isLoading.value = true;
  //   try {
  //     final token = await TokenManager.getToken();
  //
  //     if (token == null || token.isEmpty) {
  //       Get.snackbar("Auth Error", "Token not found");
  //       return;
  //     }
  //
  //     final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/product');
  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       print(jsonData);
  //       final List<dynamic> dataList = jsonData['data'];
  //       print("productsList ========>>>>>> $dataList");
  //       final productsList =
  //           dataList.map((item) => ProductFromDropdown.fromJson(item)).toList();
  //       productsFromDropDown.assignAll(productsList);
  //       selectedProduct.value = productsFromDropDown.first;
  //     } else {
  //       productsFromDropDown.clear();
  //       Get.snackbar("Error connect",
  //           "Failed to Connect to DB (Code: ${response.statusCode})");
  //     }
  //   } catch (e) {
  //     productsFromDropDown.clear();
  //     // Get.snackbar("Exception", e.toString());
  //     Get.snackbar("Exception", "Couldn't get Products");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
}
