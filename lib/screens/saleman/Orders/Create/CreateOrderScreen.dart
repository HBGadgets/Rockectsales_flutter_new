import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/Attendance_Page.dart';
import 'package:rocketsale_rs/screens/saleman/Orders/Create/CreateProductCard.dart';
import 'package:rocketsale_rs/screens/saleman/Orders/Edit/EditOrderController.dart';
import 'package:rocketsale_rs/screens/saleman/Orders/OrdersAndProductsClass.dart';

import '../../../../resources/my_colors.dart';
import 'CreateOrderController.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  DateTime? tillDate;

  // Detail Form
  final TextEditingController shopName = TextEditingController();

  final TextEditingController shopOwnerName = TextEditingController();

  final TextEditingController address = TextEditingController();

  final TextEditingController phoneNo = TextEditingController();

  final CreateOrderController controller = Get.put(CreateOrderController());

  final productFormKey = GlobalKey<FormState>();

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: tillDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        tillDate = picked;
      });
    }
  }

  void addProductCard() {
    if (controller.productsList.last.price != "" ||
        controller.productsList.last.quantity != "") {
      controller.productCardList
          .add(Product(productName: "", quantity: "", price: "", hsnCode: ""));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Create Order",
            style: TextStyle(color: Colors.white),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: MyColor.dashbord,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(
              color: MyColor.dashbord,
            ));
          } else if (controller.productsList.isEmpty) {
            return const Center(child: Text("No Products found."));
          } else {
            if (controller.productCardList.isEmpty) {
              addProductCard();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: productFormKey,
                    child: Column(
                      children: [
                        ...controller.productCardList
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          return CreateProductCard(
                            key: ValueKey(product),
                            index: index,
                            formKey: productFormKey,
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (productFormKey.currentState!.validate()) {
                                // All fields valid -> add product card
                                addProductCard();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(20),
                              // controls button size
                              backgroundColor: MyColor.dashbord, // button color
                            ),
                            child: const Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  buildLabel("Shop Name:"),
                  buildTextEditField(shopName),
                  buildLabel("Shop Owner Name:"),
                  buildTextEditField(shopOwnerName),
                  buildLabel("Delivery by:"),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7),
                      ),
                      side: const BorderSide(color: Colors.black54),
                    ),
                    onPressed: () => _selectTillDate(context),
                    icon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                    label: Text(
                      tillDate != null
                          ? DateFormat('dd/MM/yyyy').format(tillDate!)
                          : "N/A",
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  buildLabel("Address:"),
                  buildTextEditField(address),
                  buildLabel("Phone No. :"),
                  buildTextEditField(phoneNo),
                  const SizedBox(height: 8),
                  const Text(
                    "Product Items:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
            );
          }
        }));
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTextEditField(TextEditingController controller,
      {String hint = "",
      TextInputType inputType = TextInputType.text,
      bool isDisabled = false}) {
    return TextFormField(
      readOnly: isDisabled,
      controller: controller,
      decoration: InputDecoration(
        hint: Text(hint),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: MyColor.dashbord, width: 2), // On focus
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          // Default border color
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
