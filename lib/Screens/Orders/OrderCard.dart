import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import 'Create/CreateOrderController.dart';
import 'OrderDetailScreen.dart';
import 'OrdersAndProductsClass.dart';

class OrderCard extends StatelessWidget {
  final Order order;

  OrderCard({super.key, required this.order});

  late Color orderStatusTextColor;
  late Color orderStatusContainerColor;

  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (order.status == "Pending") {
      orderStatusContainerColor = Colors.yellow;
      orderStatusTextColor = Colors.black87;
    } else if (order.status == "Cancelled") {
      orderStatusContainerColor = Colors.red.shade100;
      orderStatusTextColor = Colors.red;
    } else {
      orderStatusContainerColor = Colors.green.shade50;
      orderStatusTextColor = Colors.green;
    }
    int totalAmount = order.product.fold(0, (sum, p) {
      int price = int.tryParse(p.price) ?? 0;
      int qty = int.tryParse(p.quantity) ?? 0;
      return sum + (price * qty);
    });
    return GestureDetector(
      onTap: () {
        Get.to(OrderDetailScreen(
          order: order,
        ));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Colors.black12, // border color
            width: 2, // border thickness
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status badge
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: orderStatusContainerColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.status,
                    style: TextStyle(
                      color: orderStatusTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Title & Subtitle
              Text(
                order.shopName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                order.shopOwnerName,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 12),

              // Amount Row
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${order.product.length.toString()} items',
                          style: const TextStyle(
                              color: Colors.green, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(
                      '₹ ${totalAmount.toString()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Details
              buildInfoRow("Date:", formatDate(order.createdAt)),
              buildInfoRow("Phone:", order.phoneNo),
              buildInfoRow("Delivery by:", formatDate(order.deliveryDate)),
              buildInfoRow("Address:", order.shopAddress),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
