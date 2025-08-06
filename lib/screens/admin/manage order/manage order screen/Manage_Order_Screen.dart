import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import '../../../../controllers/manage_order_controller.dart';
import '../../../../utils/widgets/admin_app_bar.dart';
import '../EditUserManageScreen.dart';

class ManageOrderScreen extends StatelessWidget {
  ManageOrderScreen({super.key});

  final ManageOrderController controller = Get.put(ManageOrderController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('Manage Order', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      body: Column(
        children: [
          /// Date Filter UI
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      controller.selectPeriod(picked);
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.blue),
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      backgroundColor: Colors.white,
                    ),
                    child: Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedPeriod.value,
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 16),
                            ),
                            Icon(Icons.calendar_month_outlined,
                                color: Colors.black87),
                          ],
                        )),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    controller.submitFilter();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),

          /// Order Cards List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (controller.orderList.isEmpty) {
                return Center(child: Text("No orders found."));
              }

              return ListView.builder(
                itemCount: controller.orderList.length,
                itemBuilder: (context, index) {
                  final order = controller.orderList[index];
                  final shop = order.shopName;
                  final salesman = order.sId;
                  final products = order.products;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Shop Info
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.store, size: 36),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${order.shopName ?? '_'}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.person, size: 16),
                                        SizedBox(width: 4),
                                        Text("${order.shopOwnerName ?? '-'}"),
                                        SizedBox(width: 12),
                                        Icon(Icons.call, size: 16),
                                        SizedBox(width: 4),
                                        Text('${order.phoneNo ?? '_'}'),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on,
                                            size: 16, color: Colors.red),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            "${order.sId ?? 'N/A'}",
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          // child: Text(
                                          //   "${order.shopAddress ?? '_'}",
                                          //   style: TextStyle(fontSize: 13),
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: Icon(Icons.more_vert),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    Get.to(() => EditUserManageScreen(),
                                        arguments: order);
                                  } else if (value == 'share') {
                                    // Trigger share logic here
                                    Get.snackbar(
                                        "Share", "Share option clicked");
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 16),
                                        SizedBox(width: 6),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'share',
                                    child: Row(
                                      children: [
                                        Icon(Icons.share, size: 16),
                                        SizedBox(width: 6),
                                        Text("Share"),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        Divider(),

                        /// Products Table
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Table(
                            border: TableBorder.all(color: Colors.black54),
                            columnWidths: {
                              0: FlexColumnWidth(2),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(2),
                            },
                            children: [
                              TableRow(
                                decoration:
                                    BoxDecoration(color: Color(0xFFEDEDED)),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Product Name",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Qty",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Price",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Total",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              ...?products?.map((item) => TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(item.productName ?? ''),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            item.quantity?.toString() ?? ''),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                            item.price?.toStringAsFixed(2) ??
                                                ''),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          ((item.quantity ?? 0) *
                                                  (item.price ?? 0))
                                              .toStringAsFixed(2),
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),

                        /// Footer
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width * 0.4,
                                height: size.height * 0.05,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: Text(
                                    "Generate Invoice",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.015),
                                  ),
                                ),
                              ),
                              Text(
                                "Gross Total: ₹ ${products?.fold<double>(0, (sum, item) => sum + ((item.quantity ?? 0) * (item.price ?? 0))).toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height * 0.014,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
