import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../TokenManager.dart';
import '../../resources/my_colors.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  late bool isLoading = false;
  DateTime? fromDate;
  DateTime? toDate;
  String? leaveType;
  final TextEditingController descriptionController = TextEditingController();

  Future<void> _pickDate(BuildContext context, bool isFromDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Apply for Leave",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fill the Leave Application:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // To Date
                  _buildFormRow(
                    label: "From Date",
                    child: _datePickerField(
                      date: fromDate,
                      onTap: () => _pickDate(context, true),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Till Date
                  _buildFormRow(
                    label: "Till Date",
                    child: _datePickerField(
                      date: toDate,
                      onTap: () => _pickDate(context, false),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Leave Description
                  const Text(
                    "Leave Description:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: "Write your reason for leave...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Submit button
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.dashbord,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        if (fromDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a From Date")),
                          );
                          return;
                        }
                        if (toDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please select a Till Date")),
                          );
                          return;
                        }
                        if (descriptionController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please enter a leave description")),
                          );
                          return;
                        }

                        // ✅ All fields filled → proceed
                        postLeave();
                      },

                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColor.dashbord),
                  ),
                ),
              ),
          ]
        ),
      ),
    );
  }

  Widget _buildFormRow({required String label, required Widget child}) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            "$label :",
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _datePickerField({DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Text(
              date != null
                  ? "${date.day} ${_monthName(date.month)} ${date.year}"
                  : "Select Date",
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  Future<void> postLeave() async {
    setState(() {
      isLoading = true;
    });
    final token = await TokenManager.getToken();

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    final salesmanId = decodedToken['id'];
    final supervisorId = decodedToken['supervisorId'];
    final branchId = decodedToken['branchId'];
    final companyId = decodedToken['companyId'];
    String formattedFromDate = DateFormat(
      'dd-MM-yyyy',
    ).format(fromDate!);
    String formattedToDate = DateFormat(
      'dd-MM-yyyy',
    ).format(toDate!);

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/leaverequest'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "salesmanId": salesmanId,
          "leaveStartdate":formattedFromDate,
          "leaveEnddate": formattedToDate,
          "reason": descriptionController.text,
          "supervisorId": supervisorId,
          "branchId": branchId,
          "companyId": companyId
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        print("✅ Upload successful: ${response.body}");
      } else {
        setState(() {
          isLoading = false;
        });
        print("❌ Upload failed: ${response.body}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("⚠️ Error uploading: $e");
    }
  }
}
