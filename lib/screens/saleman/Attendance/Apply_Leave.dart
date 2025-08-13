import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding the request body to JSON
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Add this import for decoding JWT

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  _ApplyLeaveState createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  DateTime? selectedFromDate;
  DateTime? selectedTillDate;
  TextEditingController reasonController = TextEditingController();

  // Method to show Snackbar
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // Method to select date for 'From Date' or 'Till Date'
  Future<void> _selectDate(BuildContext context, String dateType) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(2020); // Start date (e.g., 2020)
    final DateTime lastDate = DateTime(2101); // End date (e.g., 2101)

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        if (dateType == 'from') {
          selectedFromDate = picked;
        } else {
          selectedTillDate = picked;
        }
      });
    }
  }

  Future<void> _applyLeaveRequest() async {
    // Check if dates and reason are valid
    if (selectedFromDate == null ||
        selectedTillDate == null ||
        reasonController.text.isEmpty) {
      _showSnackbar('Please fill in all the fields');
      return;
    }

    // Decode the JWT token to get the salesmanId (or user ID) and additional fields
    String token =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3YTlhYzRhMmJhM2RmMWYzNzkyZjZmZSIsInVzZXJuYW1lIjoicGF2YW5zYWwiLCJyb2xlIjo1LCJjb21wYW55SWQiOiI2NzkwN2ViZGIwMjEzZmE2ZTcwYTJhYWQiLCJicmFuY2hJZCI6IjY3OTA3ZjA0YjAyMTNmYTZlNzBhMmFiZCIsInN1cGVydmlzb3JJZCI6IjY3OTA3ZjczYjAyMTNmYTZlNzBhMmFkMyIsImNoYXR1c2VybmFtZSI6ImFuaXN1cCIsImlhdCI6MTczOTMzOTc2MywiZXhwIjoyMDU0OTE1NzYzfQ.tgYo7jT_WtcclJ45DI8XwhmelgRi61kSyfAoW_GQabA'; // Use your token here

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String salesmanId = decodedToken['id']; // Extracting the salesmanId
    String companyId = decodedToken['companyId']; // Extracting companyId
    String supervisorId =
        decodedToken['superviserId']; // Extracting superviserId
    String branchId = decodedToken['branchId']; // Extracting branchId

    // Prepare the request body with the required fields, including the newly extracted fields
    final Map<String, dynamic> leaveRequestData = {
      'salesmanId': salesmanId,
      // Add the salesmanId extracted from the token
      'leaveStartdate': selectedFromDate?.toIso8601String(),
      // Assuming leaveStartdate is the same as 'fromDate'
      'leaveEnddate': selectedTillDate?.toIso8601String(),
      // Assuming leaveEnddate is the same as 'tillDate'
      'reason': reasonController.text,
      // The reason for leave
      'companyId': companyId,
      // Add companyId from token
      'supervisorId': supervisorId,
      // Add supervisorId from token
      'branchId': branchId,
      // Add branchId from token
    };

    try {
      print('Using Token: $token'); // Debug the token

      // Send the POST request with the Authorization header
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leaverequest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Add the token here
        },
        body: json.encode(leaveRequestData),
      );

      // Log response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle response
      if (response.statusCode == 201) {
        _showSnackbar('Leave application submitted successfully!');
      } else {
        _showSnackbar('Failed to submit leave application: ${response.body}');
      }
    } catch (e) {
      // Catch and log errors (e.g., network errors)
      _showSnackbar('Error: ${e.toString()}');
      print('Error: ${e.toString()}');
    }
  }

  // Future<void> _applyLeaveRequest() async {
  //   // Check if dates and reason are valid
  //   if (selectedFromDate == null || selectedTillDate == null || reasonController.text.isEmpty) {
  //     _showSnackbar('Please fill in all the fields');
  //     return;
  //   }
  //
  //   // Decode the JWT token to get the salesmanId (or user ID)
  //   String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY3YTlhYzRhMmJhM2RmMWYzNzkyZjZmZSIsInVzZXJuYW1lIjoicGF2YW5zYWwiLCJyb2xlIjo1LCJjb21wYW55SWQiOiI2NzkwN2ViZGIwMjEzZmE2ZTcwYTJhYWQiLCJicmFuY2hJZCI6IjY3OTA3ZjA0YjAyMTNmYTZlNzBhMmFiZCIsInN1cGVydmlzb3JJZCI6IjY3OTA3ZjczYjAyMTNmYTZlNzBhMmFkMyIsImNoYXR1c2VybmFtZSI6ImFuaXN1cCIsImlhdCI6MTczOTMzOTc2MywiZXhwIjoyMDU0OTE1NzYzfQ.tgYo7jT_WtcclJ45DI8XwhmelgRi61kSyfAoW_GQabA';  // Use your token here
  //
  //   Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
  //   String salesmanId = decodedToken['id'];  // Assuming the 'id' field is the salesman ID in the decoded token
  //
  //   // Prepare the request body with the required fields
  //   final Map<String, dynamic> leaveRequestData = {
  //     'salesmanId': salesmanId, // Add the salesmanId extracted from the token
  //     'leaveStartdate': selectedFromDate?.toIso8601String(),  // Assuming leaveStartdate is the same as 'fromDate'
  //     'leaveEnddate': selectedTillDate?.toIso8601String(),    // Assuming leaveEnddate is the same as 'tillDate'
  //     'reason': reasonController.text,  // The reason for leave
  //   };
  //
  //   try {
  //     print('Using Token: $token');  // Debug the token
  //
  //     // Send the POST request with the Authorization header
  //     final response = await http.post(
  //       Uri.parse('http://104.251.218.102:8080/api/leaverequest'),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token', // Add the token here
  //       },
  //       body: json.encode(leaveRequestData),
  //     );
  //
  //     // Log response for debugging
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //
  //     // Handle response
  //     if (response.statusCode == 201) {
  //       _showSnackbar('Leave application submitted successfully!');
  //     } else {
  //       _showSnackbar('Failed to submit leave application: ${response.body}');
  //     }
  //   } catch (e) {
  //     // Catch and log errors (e.g., network errors)
  //     _showSnackbar('Error: ${e.toString()}');
  //     print('Error: ${e.toString()}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back(); // This will pop the current screen
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
                const SizedBox(height: 10),
                Text(
                  'Planned Leave',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // "From Date" container with calendar functionality
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('From Date -',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    GestureDetector(
                      onTap: () => _selectDate(context, 'from'),
                      child: Container(
                        height: 40.0,
                        width: 135.0,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedFromDate == null
                                    ? 'Select date'
                                    : '${selectedFromDate!.toLocal()}'
                                        .split(' ')[0],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // "Till Date" container with calendar functionality
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Till Date -',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    GestureDetector(
                      onTap: () => _selectDate(context, 'till'),
                      child: Container(
                        height: 40.0,
                        width: 135.0,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedTillDate == null
                                    ? 'Select date'
                                    : '${selectedTillDate!.toLocal()}'
                                        .split(' ')[0],
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Icon(Icons.calendar_today, color: Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Reason for leave container
                Container(
                  height: 120.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                    controller: reasonController,
                    decoration: InputDecoration(
                      hintText: 'Reason for leave.......',
                      border: InputBorder.none, // Removes the inner line
                    ),
                    cursorColor: Colors.black, // Sets the cursor color to black
                  ),
                ),
                const SizedBox(height: 20),

                // Half Day Leave text
                Text(
                  'Half Day Leave',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),

                // Row with two halves for "Half Day Leave"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First half container
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      height: 50.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Centering horizontally
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Centering vertically
                        children: [
                          Text('First Half',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6))),
                        ],
                      ),
                    ),

                    // Second half container
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      height: 50.0,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // Centering horizontally
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Centering vertically
                        children: [
                          Text(
                            'Second Half',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: _buildButton('Apply for leaves', _applyLeaveRequest),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildButton(String text, VoidCallback onPressed) {
    return Container(
      width: 150,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
