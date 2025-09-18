import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../resources/my_colors.dart';
import '../../TokenManager.dart';
import 'OrdersAndProductsClass.dart';

class OrdersController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;
  final RxBool isLoading = true.obs;

  // final RxBool areProductsLoading = false.obs;
  final RxString error = ''.obs;
  final dateTimeFilter = ''.obs;
  final searchString = ''.obs;
  final RxString selectedTag = "".obs;
  final RxBool isLoadingInDetails = false.obs;

  RxInt page = 2.obs;
  RxBool isMoreCardsAvailable = false.obs;

  @override
  void onInit() {
    getOrders();
    super.onInit();
  }

  void showInvoiceDialog(BuildContext context, Order order, String total) {
    final TextEditingController gstController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    final TextEditingController GSTNumber = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            "Enter Details",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: gstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "GST (₹)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Discount (₹)",
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: GSTNumber,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "GST Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(color: MyColor.dashbord),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: MyColor.dashbord,
                  foregroundColor: Colors.white),
              onPressed: () {
                String gst = gstController.text;
                String discount = discountController.text;
                String gstNumber = GSTNumber.text;
                int grandTotal = (int.tryParse(total) ?? 0) +
                    (order.gst ?? 0) -
                    (order.discount ?? 0);

                completeOrder(order.id, context, int.parse(gst),
                        int.parse(discount), gstNumber, grandTotal)
                    .then((_) => generateInvoicePdfPending(
                        order,
                        total,
                        context,
                        int.parse(gst),
                        int.parse(discount),
                        gstNumber,
                        grandTotal));

                // if (order.status == "Completed") {
                //   generateInvoicePdf(order, total)
                //       .then((_) => Navigator.pop(context));
                // } else {
                //   completeOrder(order.id, context).then((_) =>
                //       generateInvoicePdf(order, total).then((_) =>
                //           getOrders().then((_) => Navigator.pop(context))));
                // }
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<void> generateInvoicePdfPending(
      Order order,
      String total,
      BuildContext context,
      int gst,
      int discount,
      String gstNumber,
      int grandTotal) async {
    showLoading(context);
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Invoice #${order.id}',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text('Shop: ${order.shopName}'),
          pw.Text('Owner: ${order.shopOwnerName}'),
          pw.Text('Phone: ${order.phoneNo}'),
          pw.Text('Address: ${order.shopAddress}'),
          pw.Text('Order Date: ${order.createdAt.toLocal()}'),
          pw.Text('GST: ${gst}'),
          pw.Text('Discount: ${discount}'),
          pw.Text('GST Number: ${gstNumber}'),
          if (order.deliveryDate != null)
            pw.Text('Delivery Date: ${order.deliveryDate!.toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['#', 'Product', 'Qty', 'Price', 'Total'],
            data: List.generate(order.product.length, (index) {
              final p = order.product[index];
              return [
                (index + 1).toString(),
                p.productName,
                p.quantity.toString(),
                '${p.price}', // price per unit
                '${int.parse(p.quantity) * int.parse(p.price)}', // total
              ];
            }),
          ),

          pw.SizedBox(height: 20),

// ✅ Correct grand total calculation
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Grand Total: ${order.product.fold<int>(0, (sum, p) => sum + (int.parse(p.quantity) * int.parse(p.price)))}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

        ],
      ),
    );

    // Save file locally
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice_${order.id}.pdf");
    await file
        .writeAsBytes(await pdf.save())
        .then((_) => Navigator.pop(context));

    // Trigger download/preview (on mobile/desktop)
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "invoice_${order.id}.pdf",
    ).then((_) => Navigator.pop(context));
  }

  Future<void> generateInvoicePdfCompleted(
      Order order, BuildContext context) async {
    showLoading(context);
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Invoice #${order.id}',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text('Shop: ${order.shopName}'),
          pw.Text('Owner: ${order.shopOwnerName}'),
          pw.Text('Phone: ${order.phoneNo}'),
          pw.Text('Address: ${order.shopAddress}'),
          pw.Text('Order Date: ${order.createdAt.toLocal()}'),
          pw.Text('GST: ${order.gst}'),
          pw.Text('Discount: ${order.discount}'),
          pw.Text('GST Number: ${order.gstNumber}'),
          if (order.deliveryDate != null)
            pw.Text('Delivery Date: ${order.deliveryDate!.toLocal()}'),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['#', 'Product', 'Qty', 'Price', 'Total'],
            data: List.generate(order.product.length, (index) {
              final p = order.product[index];
              return [
                (index + 1).toString(),
                p.productName,
                p.quantity.toString(),
                '${p.price}', // price per unit
                '${int.parse(p.quantity) * int.parse(p.price)}', // total
              ];
            }),
          ),

          pw.SizedBox(height: 20),

// ✅ Correct grand total calculation
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Grand Total: ${order.product.fold<int>(0, (sum, p) => sum + (int.parse(p.quantity) * int.parse(p.price)))}',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),

        ],
      ),
    );

    // Save file locally
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/invoice_${order.id}.pdf");
    await file.writeAsBytes(await pdf.save());

    // Trigger download/preview (on mobile/desktop)
    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: "invoice_${order.id}.pdf",
    );
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

  Future<void> cancelOrder(String orderId, BuildContext buildContext) async {
    isLoadingInDetails.value = true;
    showLoading(buildContext);
    final url = '${dotenv.env['BASE_URL']}/api/api/order/status/$orderId';

    final id = await TokenManager.getSupervisorId(); // Get user ID from token
    if (id == null) {
      // showSnackbar("User ID not found from token");
      Get.snackbar("Error", "User Id not found");
      return;
    }
    final token = await TokenManager.getToken(); // Get the full token

    if (token == null) {
      Get.snackbar("Error", "User token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'status': "Cancelled",
          '_id': id,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        getOrders().then((_) {
          Navigator.of(buildContext).pop();
          Navigator.of(buildContext).pop();
        });
      } else {
        Navigator.of(buildContext).pop();
        Get.snackbar(
            "Error", "Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      Navigator.of(buildContext).pop();
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }

  Future<void> completeOrder(String orderId, BuildContext buildContext, int gst,
      int discount, String gstNumber, int grandTotal) async {
    isLoadingInDetails.value = true;
    showLoading(buildContext);
    final url = '${dotenv.env['BASE_URL']}/api/api/order/status/$orderId';

    final id = await TokenManager.getSupervisorId(); // Get user ID from token
    if (id == null) {
      // showSnackbar("User ID not found from token");
      Get.snackbar("Error", "User Id not found");
      return;
    }
    final token = await TokenManager.getToken(); // Get the full token

    if (token == null) {
      Get.snackbar("Error", "User token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'status': "Completed",
          '_id': id,
          'gst': gst,
          'discount': discount,
          'gstNumber': gstNumber,
          'grandTotal': grandTotal,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        getOrders();
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).pop();
      } else {
        Navigator.of(buildContext).pop();
        Get.snackbar(
            "Error", "Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      Navigator.of(buildContext).pop();
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  Future<void> getOrders() async {
    isLoading.value = true;
    isMoreCardsAvailable.value = false;
    page.value = 2;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/getorder?&limit=10$dateTimeFilter&search=$searchString&status=$selectedTag');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        print("ordersList ========>>>>>> $dataList");
        final orderList = dataList.map((item) => Order.fromJson(item)).toList();
        orders.assignAll(orderList);
      } else {
        orders.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      orders.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Orders");
    } finally {
      isLoading.value = false;
    }
  }

  void getMoreOrderCards() async {
    print('fetching more');
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/getorder?page=$page&limit=10$dateTimeFilter&search=$searchString');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        // final List<dynamic> dataList = jsonData;
        final orderList = dataList.map((item) => Order.fromJson(item)).toList();
        // page.value++;
        if (orderList.length < 1) {
          isMoreCardsAvailable.value = false;
          // page.value = 1;
        } else {
          page.value++;
        }
        orders.addAll(orderList);
      } else {
        orders.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      orders.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get Orders");
    }
  }
}
