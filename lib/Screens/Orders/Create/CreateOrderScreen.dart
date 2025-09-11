import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../resources/my_colors.dart';
import '../OrdersAndProductsClass.dart';
import 'CreateOrderController.dart';
import 'CreateProductCard.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final CreateOrderController controller = Get.put(CreateOrderController());

  final productFormKey = GlobalKey<FormState>();

  final orderInfoFormKey = GlobalKey<FormState>();

  late Map args;

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: controller.tillDate.value ?? DateTime.now(),
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
      // setState(() {
      //   tillDate = picked;
      // });
      controller.tillDate.value = picked;
    }
  }

  void addProductCard() {
    controller.productCardList
        .add(Product(productName: "", quantity: "", price: "", hsnCode: ""));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    args = Get.arguments;
    if (args['screenType'] == "edit" && args['order'] != null) {
      controller.orderToEdit.value = args['order'];
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.renderScreen();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.appBarTitle.value,
            style: const TextStyle(color: Colors.white),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            "Product Items:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ),
                        ...controller.productCardList
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          if (controller.orderToEdit.value != null) {
                            return CreateProductCard(
                              key: ValueKey(product),
                              index: index,
                              formKey: productFormKey,
                              product: product,
                            );
                          } else {
                            return CreateProductCard(
                              key: ValueKey(product),
                              index: index,
                              formKey: productFormKey,
                            );
                          }
                        }),
                        Center(
                          child: Padding(
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
                                backgroundColor: Colors.green, // button color
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Form(
                      key: orderInfoFormKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Order Info:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                          buildLabel("Shop Name:"),
                          buildTextEditField(controller.shopName),
                          buildLabel("Shop Owner Name:"),
                          buildTextEditField(controller.shopOwnerName),
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
                              controller.tillDate.value != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(controller.tillDate.value!)
                                  : "N/A",
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          buildLabel("Address:"),
                          buildTextEditField(controller.address),
                          buildLabel("Phone No. :"),
                          buildTextEditField(controller.phoneNo),
                        ],
                      )),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity, // 👈 full width
                      child: ElevatedButton(
                        onPressed: () {
                          // handle submit
                          if (orderInfoFormKey.currentState!.validate() &&
                              productFormKey.currentState!.validate()) {
                            productFormKey.currentState!.save();
                            if (controller.orderToEdit.value != null) {
                              controller.updateOrder(context);
                            } else {
                              controller.uploadOrder(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          // taller button
                          backgroundColor: MyColor.dashbord,
                        ),
                        child: const Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
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
