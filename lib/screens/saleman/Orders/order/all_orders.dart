import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import '../../dashboard_salesman.dart';
import 'Order_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  _AllOrdersState createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final String? token = await getToken();

      if (token == null) {
        throw Exception('Authorization token is missing');
      }

      print('Token retrieved: $token');

      final response = await http.get(
        Uri.parse('http://104.251.218.102:8080/api/order'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        // Decode the response as a map
        Map<String, dynamic> data = json.decode(response.body);

        // Check if the "orders" key is not null and contains a list
        if (data['orders'] != null && data['orders'] is List) {
          List<dynamic> ordersData = data['orders'];

          setState(() {
            orders = ordersData.map((item) => Order.fromJson(item)).toList();
            isLoading = false;
          });
        } else {
          throw Exception('Orders data is missing or malformed');
        }
      } else {
        throw Exception(
          'Failed to load orders, Status Code: ${response.statusCode}, Response Body: ${response.body}',
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load orders');
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(
      'salesman_token',
    ); // Retrieve the token from SharedPreferences
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.grey.shade50,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Get.to(() => const DashboardSalesman());
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Container
              Container(
                height: screenHeight * 0.6,
                width: screenWidth,
                color: Colors.grey.shade50,
                child: Container(
                  height: screenHeight * 0.5,
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(55.0),
                      bottomRight: Radius.circular(55.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'All Orders',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Card with Dropdown
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.grey.shade50,
                          child: InkWell(
                            onTap: () {
                              // Show Bottom Sheet when the card is tapped
                              showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                builder: (context) {
                                  return Container(
                                    height: 250,
                                    // Set height as needed
                                    width: 360,
                                    color: Colors.white,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Products Name:-",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Quantity:-",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Shope Owner Name:-",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Phone Number:-",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text(
                                          "Price:-",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        // You can add other widgets as needed
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Shope Name:-',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const Text(
                                        'Salesman Name:-',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Delivery Date:-',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      const Text(
                                        'Shope Address-',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Display Orders List (when data is fetched)
              if (isLoading)
                const CircularProgressIndicator()
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      title: Text(order.shopName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Salesman: ${order.salesmanName}'),
                          Text('Delivery Date: ${order.deliveryDate}'),
                          Text('Shop Address: ${order.shopAddress}'),
                        ],
                      ),
                    );
                  },
                ),

              Container(
                padding: const EdgeInsets.all(80.0),
                width: screenWidth,
                color: Colors.grey.shade50,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => const OrderScreen(),
                            ); // Add action for Forward Order button
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(90, 40),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey.shade200,
                          ),
                          child: const Text("Create Order"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Order {
  final String shopName;
  final String salesmanName;
  final String deliveryDate;
  final String shopAddress;

  Order({
    required this.shopName,
    required this.salesmanName,
    required this.deliveryDate,
    required this.shopAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      shopName: json['shopName'] ?? '',
      salesmanName: json['salesmanName'] ?? '',
      deliveryDate: json['deliveryDate'] ?? '',
      shopAddress: json['shopAddress'] ?? '',
    );
  }
}
