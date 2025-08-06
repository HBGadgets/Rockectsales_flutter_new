import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../dashboard_salesman.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ManageExpenseSalesMan extends StatefulWidget {
  const ManageExpenseSalesMan({super.key});

  @override
  _ManageExpenseSalesManState createState() => _ManageExpenseSalesManState();
}

class _ManageExpenseSalesManState extends State<ManageExpenseSalesMan> {
  String? selectedExpenseType;
  DateTime? selectedDate;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<dynamic> expenses = []; // This will hold the fetched expense data
  List<String> expenseTypes = []; // This will hold the fetched expense types

  // Fetching expense types from the GET API
  Future<void> getExpenseTypes() async {
    try {
      // final url = 'https://rocketsales-server.onrender.com/api/expencetype';
      final url = 'http://104.251.218.102:8080/api/expencetype';
      final String? token = await getToken();

      if (token == null || token.isEmpty) {
        print("Token is missing or invalid.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is missing or invalid. Please log in again.'),
          ),
        );
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print('Response Data (Expense Types): $data'); // Log the full response

        if (data != null && data['data'] != null) {
          // Correct the parsing logic for the list of expense types
          setState(() {
            expenseTypes = List<String>.from(
              data['data'].map((item) => item['expenceType'].toString()),
            );
          });
          print("Expense Types fetched successfully");
        } else {
          print("No expense types found in the response");
        }
      } else {
        print("Failed to fetch expense types: ${response.body}");
      }
    } catch (e) {
      print('Error fetching expense types: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // getExpenses();  // Fetch the expense data when the screen is loaded
    getExpenseTypes(); // Fetch the expense types when the screen is loaded
  }

  // Function to retrieve the token from SharedPreferences
  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = preferences.getString('salesman_token');
    print('Retrieved Token: $token');
    return token;
  }

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file path: ${file.path}');
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // API call method to submit a new expense (POST)
  Future<void> submitExpense() async {
    // Validate the required fields
    if (selectedExpenseType == null ||
        selectedExpenseType!.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null ||
        amountController.text.isEmpty) {
      print("Please fill all fields");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    // Log the form data to see what is being sent
    print('selectedExpenseType: $selectedExpenseType');
    print('Amount: ${amountController.text}');

    try {
      // final url = 'https://rocketsales-server.onrender.com/api/expence';
      final url = 'http://104.251.218.102:8080/api/expence';
      final String? token = await getToken();

      if (token == null || token.isEmpty) {
        print("Token is missing or invalid.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is missing or invalid. Please log in again.'),
          ),
        );
        return;
      }

      // Decode the JWT token to extract the required data
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      String? userId = decodedToken['id'];
      String? supervisorId = decodedToken['supervisorId'];
      String? companyId = decodedToken['companyId'];
      String? branchId = decodedToken['branchId'];

      print('UserId: $userId');
      print('SupervisorId: $supervisorId');
      print('CompanyId: $companyId');
      print('BranchId: $branchId');

      // Ensure 'expenseType' and 'amount' are not null or empty
      if (selectedExpenseType == null || selectedExpenseType!.isEmpty) {
        print("Expense Type is required");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense Type is required.')),
        );
        return;
      }

      if (amountController.text.isEmpty) {
        print("Amount is required");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Amount is required.')));
        return;
      }

      // Prepare the form data to send in the request body
      Map<String, dynamic> formData = {
        'expenceType': selectedExpenseType,
        'description': descriptionController.text,
        'date': selectedDate!.toIso8601String(),
        'amount':
            amountController.text.isEmpty
                ? '0'
                : double.tryParse(amountController.text)?.toString() ?? '0',
        'userId': userId,
        'supervisorId': supervisorId,
        'companyId': companyId,
        'branchId': branchId,
      };

      print("Form data: $formData"); // Log form data before sending

      String jsonData = json.encode(formData);

      // Send the HTTP request to submit the expense
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 201) {
        print("Expense submitted successfully");
      } else {
        print("Failed to submit expense: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit expense: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error submitting expense: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting expense.')),
      );
    }
  }

  // API call method to update an existing expense (PUT)
  Future<void> submitUpdatedExpense(String expenseId) async {
    // Validate the required fields
    if (selectedExpenseType == null ||
        selectedExpenseType!.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedDate == null ||
        amountController.text.isEmpty) {
      print("Please fill all fields");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    // Log the form data to see what is being sent
    print('selectedExpenseType: $selectedExpenseType');
    print('Amount: ${amountController.text}');

    try {
      // final url = 'https://rocketsales-server.onrender.com/api/expence/$expenseId'; // Endpoint to update expense by ID
      final url = 'http://104.251.218.102:8080/api/expence/$expenseId';
      final String? token = await getToken();

      if (token == null || token.isEmpty) {
        print("Token is missing or invalid.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token is missing or invalid. Please log in again.'),
          ),
        );
        return;
      }

      // Decode the JWT token to extract the required data
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      String? userId = decodedToken['id'];
      String? supervisorId = decodedToken['supervisorId'];
      String? companyId = decodedToken['companyId'];
      String? branchId = decodedToken['branchId'];

      // Ensure 'expenseType' and 'amount' are not null or empty
      if (selectedExpenseType == null || selectedExpenseType!.isEmpty) {
        print("Expense Type is required");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense Type is required.')),
        );
        return;
      }

      if (amountController.text.isEmpty) {
        print("Amount is required");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Amount is required.')));
        return;
      }

      // Prepare the form data to send in the request body
      Map<String, dynamic> formData = {
        'expenceType': selectedExpenseType,
        'description': descriptionController.text,
        'date': selectedDate!.toIso8601String(),
        'amount':
            amountController.text.isEmpty
                ? '0'
                : double.tryParse(amountController.text)?.toString() ?? '0',
        'userId': userId,
        'supervisorId': supervisorId,
        'companyId': companyId,
        'branchId': branchId,
      };

      String jsonData = json.encode(formData);

      // Send the HTTP request to update the expense (PUT request)
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print("Expense updated successfully");
        // Handle success (e.g., clear form, show confirmation)
      } else {
        print("Failed to update expense: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update expense: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error updating expense: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error updating expense.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(DashboardSalesman());
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    'Manage Expenses',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedExpenseType,
                    hint: const Text(
                      'Expense Types',
                      style: TextStyle(color: Colors.black),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedExpenseType = newValue;
                      });
                    },
                    items:
                        expenseTypes.isNotEmpty
                            ? expenseTypes.map<DropdownMenuItem<String>>((
                              String value,
                            ) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()
                            : [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Loading...'),
                              ),
                            ],
                    decoration: const InputDecoration(border: InputBorder.none),
                    dropdownColor:
                        Colors
                            .white, // Set background color of dropdown options to white
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 190.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Expenses description..........',
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 0.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey.shade200,
                  ),
                  child: TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Amount',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                  label: Text(
                    selectedDate == null
                        ? 'Select date'
                        : 'Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(color: Colors.black),
                  ),
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != selectedDate) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.file_upload_outlined,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Upload Document',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    print('PDF icon clicked');
                    _pickPDF(); // Call the PDF picker function
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    submitExpense(); // Call the function to submit the expense
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Display the fetched expense data
                expenses.isNotEmpty
                    ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Expense Type: ${expenses[index]['expenseType']}',
                          ),
                          subtitle: Text(
                            'Description: ${expenses[index]['description']}',
                          ),
                          trailing: Text(
                            'Amount: ${expenses[index]['amount']}',
                          ),
                        );
                      },
                    )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
