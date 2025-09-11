import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../resources/my_colors.dart';
import '../OrdersAndProductsClass.dart';
import 'CreateOrderController.dart';

class CreateProductCard extends StatefulWidget {
  final int index;
  final Key? formKey;
  final Product? product;

  CreateProductCard(
      {super.key, required this.index, required this.formKey, this.product});

  @override
  State<CreateProductCard> createState() => _CreateProductCardState();
}

class _CreateProductCardState extends State<CreateProductCard> {
  // Product Form
  final TextEditingController price = TextEditingController();
  final TextEditingController quantity = TextEditingController();

  final CreateOrderController controller = Get.find<CreateOrderController>();

  late Product dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dropdownValue = controller.productsList.first;
    final product = widget.product;
    if (product != null) {
      price.text = product.price;
      quantity.text = product.quantity;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        // margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(240, 240, 240, 1),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Colors.blueGrey.shade100, // border color
            width: 2, // border thickness
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Product Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownMenu<Product>(
                        initialSelection: dropdownValue,
                        onSelected: (Product? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        dropdownMenuEntries: controller.productsList
                            .map((product) => DropdownMenuEntry<Product>(
                                  value: product,
                                  label: product.productName,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextEditField(price,
                          hint: "Price", inputType: TextInputType.number),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: buildTextEditField(quantity,
                          hint: "Quantity", inputType: TextInputType.number),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.productCardList.length > 1
                                        ? Colors.redAccent
                                        : Colors.grey,
                                foregroundColor: Colors.white),
                            onPressed: () {
                              if (controller.productCardList.length > 1 &&
                                  widget.index <
                                      controller.productCardList.length) {
                                controller.productCardList
                                    .removeAt(widget.index);
                              }
                            },
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete_outline_outlined),
                                Text(
                                  "Delete",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            )),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextEditField(TextEditingController textController,
      {String hint = "",
      TextInputType inputType = TextInputType.text,
      bool isDisabled = false}) {
    return TextFormField(
      keyboardType: inputType,
      onSaved: (String? string) {
        controller.productCardList[widget.index] = Product(
          productName: dropdownValue.productName,
          quantity: textController == quantity
              ? string ?? ""
              : controller.productCardList[widget.index].quantity,
          price: textController == price
              ? string ?? ""
              : controller.productCardList[widget.index].price,
          hsnCode: dropdownValue.hsnCode,
        );
      },
      readOnly: isDisabled,
      controller: textController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
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
