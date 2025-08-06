import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/EditUserManageController.dart';
import '../../../controllers/order_update_controller.dart';
import '../../../models/order_update_model.dart';

class EditUserManageScreen extends StatelessWidget {
  final EditUserManageController controller =
      Get.put(EditUserManageController());
  final controller1 = Get.put(OrderUpdateController());

  @override
  Widget build(BuildContext context) {
    controller
        .populateInitialData(); // Populate initial data when screen builds

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit User Manage"),
        leading: BackButton(),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Add Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => DropdownButtonFormField<String>(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  hint: Text("Select Product"),
                  value: null,
                  items: controller.availableProducts
                      .map((product) => DropdownMenuItem(
                            value: product,
                            child: Text(product),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.addProduct(value);
                  },
                )),
            const SizedBox(height: 16),
            Obx(() => Column(
                  children: controller.selectedProducts.map((product) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Product Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(product.name),
                                  SizedBox(height: 8),
                                  Text("Price (all tax inclusive)",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic)),
                                  Text(
                                      "Rs ${product.price.toStringAsFixed(2)}"),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          controller.decrementQuantity(product),
                                      icon: Icon(Icons.remove),
                                    ),
                                    Obx(() => Text('${product.quantity.value}',
                                        style: TextStyle(fontSize: 16))),
                                    IconButton(
                                      onPressed: () =>
                                          controller.incrementQuantity(product),
                                      icon: Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () =>
                                      controller.removeProduct(product),
                                  icon: Icon(Icons.delete, color: Colors.red),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: 16),
            _buildTextField(controller.storeNameController, "Store Name"),
            _buildTextField(controller.addressController, "Address"),
            _buildTextField(controller.dateController, "Date (DD-MM-YYYY)"),
            _buildTextField(controller.customerNameController, "Customer Name"),
            _buildTextField(controller.customerPhoneController, "Phone Number"),
            _buildTextField(
                controller.deliveryStoreController, "Delivery Store"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller1.updateOrderData(
                  orderId: '${controller.storeIDController.text}',
                  products: [
                    Products(
                        sId: "67ac6eed838fa64074bb6d71",
                        productName: "Cooler",
                        quantity: 4,
                        price: 40000),
                    Products(
                        sId: "67ac6eed838fa64074bb6d71",
                        productName: "AC",
                        quantity: 4,
                        price: 40000),
                  ],
                  shopName: "${controller.storeNameController.text}",
                  shopAddress: "${controller.addressController.text}",
                  shopOwnerName: "${controller.customerNameController.text}",
                  phoneNo: "${controller.customerPhoneController.text}",
                  deliveryDate: "${controller.dateController.text}",
                  companyId: "${controller.storecompanyIdController.text}",
                  branchId: "${controller.storebranchIdController.text}",
                  supervisorId:
                      "${controller.storesupervisorIdController.text}",
                  salesmanId: "${controller.storesalesmanIdController.text}",
                );
              },
              child: Text("Save / Generate Invoice "),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
