import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../dashboard_salesman.dart';
import '../invoice sales man/invoice_form_sales_man.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Product> selectedProducts =
      []; // List to store selected products with quantity and price
  List<Product> availableProducts =
      []; // List to store fetched products from the API

  final TextEditingController quantityController = TextEditingController();

  final String apiUrl = "http://104.251.218.102:8080/api/order";
  final String productApiUrl =
      "http://104.251.218.102:8080/api/product"; // API to fetch products
  String? token;

  @override
  void initState() {
    super.initState();
    _fetchProducts(); // Fetch products when the screen loads
  }

  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = preferences.getString('salesman_token');
    print(
      'Retrieved Token: $token',
    ); // This will show whether the token is fetched successfully
    return token;
  }

  Future<void> _fetchProducts() async {
    // Ensure token is retrieved before making the API request
    token = await getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authorization token is missing. Please login again."),
        ),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(productApiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add Authorization header
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseMap = json.decode(response.body);
        print(
          "Decoded Response: $responseMap",
        ); // To see the full decoded response

        if (responseMap.containsKey('data')) {
          List<dynamic> productList = responseMap['data'];
          print("Product List: $productList"); // See the actual product list

          setState(() {
            availableProducts =
                productList.map((productJson) {
                  return Product.fromJson(
                    productJson,
                  ); // Convert each product into Product instance
                }).toList();
          });
        } else {
          print("No 'data' key in response or it's empty.");
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("No products found")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch products")),
        );
      }
    } catch (e) {
      print('Error occurred while fetching products: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to connect to the server")),
      );
    }
  }

  Future<void> submitOrder() async {
    if (selectedProducts.isEmpty) {
      // Show an error message if the form is incomplete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select products and enter quantity"),
        ),
      );
      return;
    }

    // Ensure the token is available before making the request
    token = await getToken();

    if (token == null) {
      // Handle the case when the token is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authorization token is missing. Please login again."),
        ),
      );
      return;
    }

    // Create a map of the data you want to send
    final List<Map<String, dynamic>> orderData =
        selectedProducts.map((product) {
          return {
            'product': product.name,
            'quantity': product.quantity,
            'price': product.price,
          };
        }).toList();

    try {
      // Sending the POST request
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Add Authorization header
        },
        body: json.encode({
          'products': orderData,
        }), // Send the product details in the body
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Order saved successfully!")),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Authorization failed. Please login again."),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to save order")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Unable to connect to the server")),
      );
    }
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
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
                  // Navigate to Dashboard_Salesman
                  Get.to(() => const DashboardSalesman());
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.7,
                width: screenWidth,
                color: Colors.grey.shade50,
                child: Container(
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
                            'Order',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Products:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        availableProducts.isEmpty
                            ? const Center(
                              child: CircularProgressIndicator(),
                            ) // Show loading indicator if products are not loaded
                            : MultiSelectDialogField<String>(
                              title: Text("Select Products"),
                              items:
                                  availableProducts.map((product) {
                                    return MultiSelectItem(
                                      product.name,
                                      product.name,
                                    );
                                  }).toList(),
                              initialValue:
                                  selectedProducts.map((e) => e.name).toList(),
                              onConfirm: (values) {
                                setState(() {
                                  selectedProducts =
                                      values.map((productName) {
                                        return Product(
                                          name: productName,
                                          quantity: 0, // Default quantity
                                          price: 10.0, // Default price
                                        );
                                      }).toList();
                                });
                              },
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              buttonText: Text(
                                "Select Products",
                                style: TextStyle(fontSize: 16),
                              ),
                              cancelText: Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              itemsTextStyle: TextStyle(fontSize: 16),
                              selectedColor: Colors.blue,
                              confirmText: Text(
                                'Ok',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children:
                                  selectedProducts.map((product) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(product.name),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 55,
                                                child: TextField(
                                                  controller:
                                                      TextEditingController(
                                                        text:
                                                            product.quantity
                                                                .toString(),
                                                      ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      product.quantity =
                                                          int.tryParse(value) ??
                                                          0;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText: 'Qty',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                    border:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                  ),
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 80,
                                                child: TextField(
                                                  controller:
                                                      TextEditingController(
                                                        text:
                                                            product.price
                                                                .toString(),
                                                      ),
                                                  keyboardType:
                                                      TextInputType.numberWithOptions(
                                                        decimal: true,
                                                      ),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      product.price =
                                                          double.tryParse(
                                                            value,
                                                          ) ??
                                                          10.0;
                                                    });
                                                  },
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'Per piece price',
                                                    labelStyle: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                    border:
                                                        UnderlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                  ),
                                                  cursorColor: Colors.black,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    submitOrder();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(80, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                  child: const Text("Save Order"),
                                ),
                                const SizedBox(width: 25),
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const InvoiceFormSalesMan());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(80, 40),
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey.shade200,
                                  ),
                                  child: const Text("Generate Invoice"),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Product {
  final String name;
  int quantity;
  double price;

  // Constructor to initialize the product
  Product({required this.name, required this.quantity, required this.price});

  // Factory method to create a Product from a JSON map
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      // Adjust these fields according to your actual API response
      quantity: json['quantity'] ?? 0,
      // Provide a default value if not present
      price: json['price']?.toDouble() ?? 0.0, // Ensure that price is a double
    );
  }

  // Method to convert a Product to a JSON map (optional, in case you need it for POST requests)
  Map<String, dynamic> toJson() {
    return {'name': name, 'quantity': quantity, 'price': price};
  }
}
