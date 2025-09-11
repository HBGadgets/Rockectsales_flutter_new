import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../resources/my_colors.dart';
import 'Create/CreateOrderController.dart';
import 'Create/CreateOrderScreen.dart';
import 'OrdersAndProductsClass.dart';
import 'OrdersController.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;

  OrderDetailScreen({super.key, required this.order});

  final OrdersController controller = Get.find<OrdersController>();

  String formattedDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final totals = order.product
        .map((item) => int.parse(item.quantity) * int.parse(item.price))
        .toList();
    final grandTotal = totals.reduce((a, b) => a + b);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: MyColor.dashbord,
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Shop Name:"),
                  buildReadOnlyField(order.shopName),
                  buildLabel("Shop Owner Name:"),
                  buildReadOnlyField(order.shopOwnerName),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("Date:"),
                            buildReadOnlyField(formattedDate(order.createdAt)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildLabel("Time:"),
                            buildReadOnlyField(
                                formattedTime(order.createdAt.toString())),
                          ],
                        ),
                      ),
                    ],
                  ),
                  buildLabel("Delivery by:"),
                  buildReadOnlyField(formattedDate(order.createdAt)),
                  buildLabel("Address:"),
                  buildReadOnlyField(order.shopAddress),
                  buildLabel("Phone No. :"),
                  buildReadOnlyField("7548754558"),
                  const SizedBox(height: 8),
                  const Text(
                    "Product Items:",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ...order.product.map(
                    (item) => buildProductItem(
                      item.productName,
                      item.price,
                      item.quantity,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed bottom section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Colors.grey)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount:",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Text(
                      "₹ ${grandTotal.toString()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                order.status != "Cancelled"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    controller.cancelOrder(order.id, context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 2),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(
                                              10), // optional: rounded corners
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            "Cancel Order",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(CreateOrderScreen(), arguments: {
                                      "screenType": "edit",
                                      "order": order,
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 2),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: MyColor.dashbord,
                                          borderRadius: BorderRadius.circular(
                                              10), // optional: rounded corners
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          child: Text(
                                            "Edit Details",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              if (order.status == "Pending") {
                                controller.showInvoiceDialog(
                                    context, order, grandTotal.toString());
                              } else {
                                controller
                                    .generateInvoicePdfCompleted(order, context)
                                    .then((_) => controller
                                        .getOrders()
                                        .then((_) => Navigator.pop(context)));
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 8),
                              child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(
                                        10), // optional: rounded corners
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        left: 20,
                                        right: 20),
                                    child: Text(
                                      "Generate Invoice",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
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

  Widget buildReadOnlyField(String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              maxLines: 20,
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductItem(String name, String subtitle, String qty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 20,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  "${subtitle}₹ each",
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
            // Quantity & total
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Quantity:$qty",
                    style:
                        const TextStyle(fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(
                  "Total: ₹ ${int.parse(subtitle) * int.parse(qty)}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
