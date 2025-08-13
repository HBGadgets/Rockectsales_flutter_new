import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder package

class ManualExpenseScreen extends StatefulWidget {
  const ManualExpenseScreen({super.key});

  @override
  _ManualExpenseScreenState createState() => _ManualExpenseScreenState();
}

class _ManualExpenseScreenState extends State<ManualExpenseScreen> {
  bool isLoading = false;
  String? _salesmanId;
  final TextEditingController _salesmanNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedExpenseType;
  String? _expenseDescription;
  List<String> _expenceTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchExpenceTypes(); // Fetch expense types
    _fetchSalesmanId(); // Fetch Salesman ID from JWT
  }

  @override
  void dispose() {
    _salesmanNameController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Fetch expense types from API
  Future<void> _fetchExpenceTypes() async {
    final url =
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/expencetype'); //post api
    String? token = await getToken();

    if (token == null) {
      Get.snackbar('Error', 'No token found. Please login again.');
      return;
    }

    setState(() {
      isLoading = true;
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
        isLoading = false;
      });
    }
  }

  // Get the JWT token from shared preferences
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Fetch and decode salesmanId from JWT token
  Future<void> _fetchSalesmanId() async {
    String? token = await getToken(); // Fetch token from SharedPreferences

    if (token != null) {
      try {
        // Decode the JWT token
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print('Decoded token: $decodedToken'); // Debug: print the decoded token

        // Check for the 'id' key in the decoded token and set the salesmanId
        if (decodedToken.containsKey('id')) {
          setState(() {
            _salesmanId = decodedToken['id']; // Extract id as salesmanId
          });
          print(
              'Salesman ID fetched: $_salesmanId'); // Debug: print the fetched id
        } else {
          setState(() {
            _salesmanId = null;
          });
          print('No id in the token'); // Debug: print if id is missing
        }
      } catch (e) {
        print('Error decoding JWT: $e');
        setState(() {
          _salesmanId = null;
        });
      }
    } else {
      print('Token is null'); // Debug: print if token is null
      setState(() {
        _salesmanId = null;
      });
    }
  }

  // Submit expense data to API
  Future<void> _submitExpense() async {
    final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/expence');
    String? salesmanId = _salesmanId;

    if (salesmanId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Salesman ID not found. Please login again')));
      return;
    }

    // Fetch the token
    String? token = await getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No token found. Please login again.')));
      return;
    }

    // Validate the required fields
    if (_selectedExpenseType == null || _selectedExpenseType!.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Expense type is required')));
      return;
    }

    print('Selected Expense Type: $_selectedExpenseType'); // Debugging

    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Valid amount is required')));
      return;
    }

    print('Amount: ${_amountController.text}'); // Debugging

    final expenseData = {
      'salesmanName': _salesmanNameController.text,
      'salesmanId': salesmanId,
      'expenseType': _selectedExpenseType,
      'expenseDescription': _expenseDescription,
      'amount': _amountController.text, // Ensure this is in correct format
      'date': _dateController.text,
    };

    print(expenseData);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Use the token here
        },
        body: json.encode(expenseData),
      );

      // Log the response body for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Expense submitted successfully')));
      } else {
        // Handle specific failure cases and provide detailed error messages
        final responseBody = json.decode(response.body);
        String errorMessage = responseBody['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit expense: $errorMessage')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('An error occurred: $error')));
    }
  }

  // Select date using date picker
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Manual Expense",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextField(
                controller: _salesmanNameController,
                style: TextStyle(
                  color: Colors.black, // Text color black
                  fontSize: 18, // Font size, you can adjust it as needed
                ),
                cursorColor: Colors.black, // Cursor color black
                decoration: const InputDecoration(
                  labelText: 'Salesman Name',
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
              SizedBox(
                height: 5,
              ),
              // Show the salesmanId once it is fetched
              _salesmanId != null
                  ? Container(
                      padding: EdgeInsets.all(8),
                      // Optional padding for spacing around the text
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50, // Set the background color
                        border: Border(
                          bottom: BorderSide(
                              color: Colors.black), // Black bottom border
                        ),
                      ),
                      child: Text(
                        'Salesman ID: $_salesmanId',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    )
                  : isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator()) // Show loading if data is being fetched
                      : Text('No salesman ID found'),

              DropdownButtonFormField<String>(
                value: _selectedExpenseType,
                hint: const Text(
                  'Select Expense Type',
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
                    _selectedExpenseType = newValue;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  // Enables background color for the button
                  fillColor: Colors.grey.shade50,
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
              TextField(
                onChanged: (text) {
                  _expenseDescription = text;
                },
                style: TextStyle(
                  color: Colors.black, // Text color black
                  fontSize: 18, // Font size, you can adjust it as needed
                ),
                cursorColor: Colors.black, // Cursor color black
                decoration: InputDecoration(
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
              TextField(
                controller: _amountController,
                style: TextStyle(
                  color: Colors.black, // Text color black
                  fontSize: 18, // Font size, you can adjust it as needed
                ),
                cursorColor: Colors.black, // Cursor color black
                decoration: const InputDecoration(
                  labelText: 'Amount',
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
              TextField(
                controller: _dateController,
                style: TextStyle(
                  color: Colors.black, // Text color black
                  fontSize: 18, // Font size, you can adjust it as needed
                ),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
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
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _salesmanNameController.clear();
                        _selectedExpenseType = null;
                        _expenseDescription = null;
                        _amountController.clear();
                        _dateController.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      side: BorderSide(
                          color: Colors.grey
                              .shade100), // Optional: Adds a border around the button
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontSize: 18, // Set the text size here
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_salesmanNameController.text.isEmpty ||
                          _selectedExpenseType == null ||
                          _expenseDescription == null ||
                          _amountController.text.isEmpty ||
                          _dateController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Please fill out all fields')));
                        return;
                      }
                      _submitExpense();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Rounded corners
                      ),
                      side: BorderSide(
                          color: Colors.grey
                              .shade100), // Optional: Adds a border around the button
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18, // Set the text size here
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
