import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalesmanExpense extends StatefulWidget {
  const SalesmanExpense({super.key});

  @override
  _SalesmanExpenseState createState() => _SalesmanExpenseState();
}

class _SalesmanExpenseState extends State<SalesmanExpense> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _salesmanNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();
  String _salesmanName = ''; // This will hold the dynamic salesman name
  String? _selectedExpenceType;
  String? _expenseDescription;
  List<String> _expenceTypes = [];
  bool isLoading = false;

  Future<void> _fetchSalesmanName() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _salesmanName = 'Dynamic Salesman Name';
      _salesmanNameController.text = _salesmanName;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchSalesmanName();
    _fetchExpenceTypes();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        print('Selected image path: ${image.path}');
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  // Fetch expense types from API
  Future<void> _fetchExpenceTypes() async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/expencetype');
    String? token = await getToken();

    if (token == null) {
      Get.snackbar('Error', 'No token found. Please login again.');
      return;
    }

    setState(() {
      isLoading = true; // Set isLoading to true while fetching data
    });

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            _expenceTypes = List<String>.from(
                data['data'].map((item) => item['expenceType']));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unexpected response structure')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load expense types')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred while fetching expense types')));
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false after fetching data
      });
    }
  }

// Get the JWT token from shared preferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

// Method for selecting a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.black,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(selectedDate);
      });
    }
  }

// POST API method
  // POST API method
  Future<void> _submitExpenseData() async {
    final String url = '${dotenv.env['BASE_URL']}/api/api/expence';

    // Get the token from SharedPreferences
    final String? token = await getToken();
    if (token == null) {
      // Show a message and return if no token is found
      Get.snackbar('Error', 'No token found. Please log in again.');
      return;
    }

    // Check if expenseType and amount are properly set
    if (_selectedExpenceType == null || _amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields')));
      return; // Exit early if validation fails
    }

    // Debugging: Print values to ensure they are correct
    print('Selected Expence Type: $_selectedExpenceType');
    print('Amount: ${_amountController.text}');

    final Map<String, dynamic> requestBody = {
      'salesmanName': _salesmanNameController.text.isEmpty
          ? _salesmanName
          : _salesmanNameController.text,
      'expenceType': _selectedExpenceType ?? '',
      // Ensure expenceType is selected or empty
      'expenseDescription': _expenseDescription ?? 'Sample Expense',
      // Provide default if empty
      'amount': _amountController.text.isEmpty ? '0' : _amountController.text,
      // Ensure amount is not empty
      'date': _dateController.text,
      'totalAmount': _totalAmountController.text,
    };

    print("Request Body: $requestBody");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Pass the token here
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Expense data submitted successfully');
        // Optionally, show success message or navigate
      } else {
        print('Failed to submit expense data');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit expense data')));
      }
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 12, right: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _salesmanNameController,
                decoration: const InputDecoration(
                  labelText: 'Salesman Name',
                  labelStyle: TextStyle(color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: Colors.black),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
                cursorColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: DropdownButtonFormField<String>(
                  value: _selectedExpenceType,
                  hint: const Text(
                    'Select Expence Type',
                    style: TextStyle(
                      color: Colors.black, // Text color black
                      fontSize: 18, // Font size, you can adjust it as needed
                    ),
                  ),
                  items: _expenceTypes.map((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedExpenceType = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    // Enables background color for the button
                    fillColor: Colors.white,
                    // Set the background color for the button to white
                    border: InputBorder.none,
                    // Remove borders if desired
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.black), // Black bottom border when focused
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors
                              .black), // Black bottom border when not focused
                    ),
                  ),
                  dropdownColor: Colors.grey
                      .shade200, // Set background color for the dropdown menu
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  onChanged: (text) {
                    _expenseDescription = text;
                  },
                  style: const TextStyle(
                    color: Colors.black, // Text color black
                    fontSize: 18, // Font size, you can adjust it as needed
                  ),
                  cursorColor: Colors.black, // Cursor color black
                  decoration: const InputDecoration(
                    labelText: 'Expense Description',
                    labelStyle: TextStyle(color: Colors.black),
                    // Label text color
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Bottom border color black
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.black), // Bottom border color when focused
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'amount',
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    labelStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.calendar_today, color: Colors.black),
                      onPressed: () => _selectDate(context),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.black),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 35),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Text('Total Amount', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 5),
                          Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: TextField(
                                controller: _totalAmountController,
                                decoration: InputDecoration(
                                  // You can add any text label here if needed.
                                  // labelText: 'Enter amount',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.black), // Bottom line color
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.black), // Bottom line color
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                // For numeric input
                                cursorColor: Colors.black, // Cursor color
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, color: Colors.black),
                    label: const Text('View Image'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(80, 40),
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  ElevatedButton.icon(
                    onPressed: _submitExpenseData,
                    icon: const Icon(Icons.edit, color: Colors.black),
                    label: const Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 40),
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.delete, color: Colors.black),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(60, 40),
                      backgroundColor: Colors.grey.shade200,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fetch data from the API
// Future<void> _fetchData() async {
//   // Fetch the salesmanId stored in SharedPreferences
//   String? salesmanId = await _getSalesmanId();
//   String? token = await getToken();
//
//   if (salesmanId == null) {
//     print("Salesman ID is missing");
//     return;
//   }
//
//   try {
//     // Make sure the token is valid
//     if (token == null) {
//       print("Token is missing");
//       return;
//     }
//
//     // Add the salesmanId to the request, either as a query parameter or part of the Authorization header
//     final response = await http.get(
//       Uri.parse('http://104.251.218.102:8080/api/expence')
//           .replace(queryParameters: {'salesmanId': salesmanId}),
//       headers: {
//         'Authorization': 'Bearer $token',  // Include the token for authorization
//       },
//     );
//
//     if (response.statusCode == 200) {
//       // Handle the response
//       final Map<String, dynamic> data = json.decode(response.body);
//       setState(() {
//         fetchedAmount = data['amount']; // Assuming the amount is in the 'amount' field
//         _amountController.text = fetchedAmount ?? '0.00'; // Set the amount in the TextField
//       });
//     } else {
//       print('Failed to load data. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching data: $e');
//   }
// }
