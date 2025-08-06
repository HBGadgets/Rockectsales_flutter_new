import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';

class Product {
  final String name;
  final double price;
  RxInt quantity;

  Product({
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class EditUserManageController extends GetxController {
  RxList<Product> selectedProducts = <Product>[].obs;

  RxList<String> availableProducts =
      ['RocketSales Product Name', 'Another Product', 'New Product'].obs;

  TextEditingController storeNameController = TextEditingController();
  TextEditingController storeproductsController = TextEditingController();
  TextEditingController storecompanyIdController = TextEditingController();
  TextEditingController storebranchIdController = TextEditingController();
  TextEditingController storesupervisorIdController = TextEditingController();
  TextEditingController storesalesmanIdController = TextEditingController();
  TextEditingController storeshopNameController = TextEditingController();
  TextEditingController storeIDController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerPhoneController = TextEditingController();
  TextEditingController deliveryStoreController = TextEditingController();

  dynamic orderData; // This will hold Get.arguments

  void addProduct(String productName) {
    final existing =
        selectedProducts.firstWhereOrNull((p) => p.name == productName);
    if (existing != null) {
      existing.quantity.value += 1;
    } else {
      selectedProducts.add(
        Product(name: productName, price: 40000.0, quantity: 1.obs),
      );
    }
  }

  void incrementQuantity(Product product) {
    product.quantity.value++;
  }

  void decrementQuantity(Product product) {
    if (product.quantity.value > 1) {
      product.quantity.value--;
    }
  }

  void removeProduct(Product product) {
    selectedProducts.remove(product);
  }

  void populateInitialData() {
    storeIDController.text = orderData.sId ?? '';

    deliveryStoreController.text = orderData.products
        .map((product) =>
            "${product.productName ?? ''} (Qty: ${product.quantity ?? 0}, Price: ${product.price ?? 0})")
        .join(', ');

    storecompanyIdController.text = orderData.companyId?.sId ?? '';
    storebranchIdController.text = orderData.branchId?.sId ?? '';
    storesupervisorIdController.text = orderData.supervisorId?.sId ?? '';
    storesalesmanIdController.text =
        orderData.salesmanId ?? '67907ff0b0213fa6e70a2b12';
    print(orderData.salesmanId);
    storeshopNameController.text = orderData.shopName ?? '';
    addressController.text = orderData.shopAddress ?? '';
    dateController.text = orderData.deliveryDate ?? '';
    customerNameController.text = orderData.shopOwnerName ?? '';
    customerPhoneController.text = orderData.phoneNo ?? '';
    storeNameController.text = orderData.shopName ?? '';

    if (orderData.products != null) {
      selectedProducts.clear();
      for (var product in orderData.products!) {
        selectedProducts.add(Product(
          name: product.productName ?? '',
          price: product.price?.toDouble() ?? 0.0,
          quantity: RxInt(product.quantity ?? 1),
        ));
      }
    }
  }

  @override
  void onInit() {
    orderData = Get.arguments as Data;
    populateInitialData();
    super.onInit();
  }
}
