import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../resources/my_colors.dart';
import '../../../TokenManager.dart';
import '../OrdersAndProductsClass.dart';
import '../OrdersController.dart';
import 'CreateOrderScreen.dart';

class CreateOrderController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<Product> productsList = <Product>[].obs;
  late RxList<Product> productCardList = <Product>[].obs;

  // Detail Form
  final TextEditingController shopName = TextEditingController();

  final TextEditingController shopOwnerName = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController phoneNo = TextEditingController();

  var tillDate = Rxn<DateTime>();

  final OrdersController controller = Get.find<OrdersController>();

  //Conditional rendering of the screen
  var orderToEdit = Rxn<Order>();
  final RxString appBarTitle = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getProductsFromDropDown();
  }

  void renderScreen() {
    if (orderToEdit.value != null) {
      appBarTitle.value = "Edit Order Detail";
      shopOwnerName.text = orderToEdit.value!.shopOwnerName;
      shopName.text = orderToEdit.value!.shopName;
      address.text = orderToEdit.value!.shopAddress;
      phoneNo.text = orderToEdit.value!.phoneNo;
      tillDate.value = orderToEdit.value!.deliveryDate;
      productCardList.clear();
      productCardList.addAll(orderToEdit.value!.product);
      final products = productCardList.map((p) => p.toJson()).toList();
      print(products);
    } else {
      appBarTitle.value = "Create Order";
    }
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

  Future<void> updateOrder(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/order/${orderToEdit.value!.id}');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['supervisorId'];
      final salesmanId = decodedToken['id'];

      final products = productCardList.map((p) => p.toJson()).toList();

      print(products);

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'deliveryDate': tillDate.value?.toIso8601String(),
          'phoneNo': phoneNo.text,
          'products': products,
          'shopAddress': address.text,
          'shopName': shopName.text,
          'shopOwnerName': shopOwnerName.text
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getOrders();
        Get.snackbar("Success", "Order info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Order submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting qr: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> uploadOrder(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/order');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['supervisorId'];
      final salesmanId = decodedToken['id'];

      final products = productCardList.map((p) => p.toJson()).toList();

      print(products);

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'deliveryDate': tillDate.value?.toIso8601String(),
          'phoneNo': phoneNo.text,
          'products': products,
          'shopAddress': address.text,
          'shopName': shopName.text,
          'shopOwnerName': shopOwnerName.text
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getOrders();
        Get.snackbar("Success", "Order info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Order submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting qr: $e");
      Get.snackbar("Exception", e.toString());
    }
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
