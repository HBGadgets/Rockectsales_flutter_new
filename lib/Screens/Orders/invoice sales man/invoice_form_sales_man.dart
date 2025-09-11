import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'dart:io';


class InvoiceFormSalesMan extends StatefulWidget {
  const InvoiceFormSalesMan({super.key});

  @override
  State<InvoiceFormSalesMan> createState() => _InvoiceFormState();
}

class _InvoiceFormState extends State<InvoiceFormSalesMan> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController fromNameController = TextEditingController();
  final TextEditingController fromAddressController = TextEditingController();
  final TextEditingController toNameController = TextEditingController();
  final TextEditingController toAddressController = TextEditingController();
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController hsnCodeController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  double totalAmount = 0.0; // To store the calculated total amount

  // Method to calculate the total amount
  double calculateTotal() {
    double unitPrice = double.tryParse(unitPriceController.text) ?? 0;
    int quantity = int.tryParse(quantityController.text) ?? 0;
    double gst = double.tryParse(gstController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;

    double totalBeforeGST = unitPrice * quantity;
    double gstAmount = totalBeforeGST * gst / 100;
    double totalAfterDiscount = totalBeforeGST - discount;
    double totalAmount = totalAfterDiscount + gstAmount;

    return totalAmount;
  }

  // Method to select a date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != DateTime.now()) {
      setState(() {
        _controller.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  // Method to pick a PDF file
  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        print('Selected file: ${file.name}');
      } else {
        print('No file selected');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  // Method to submit the form
  Future<void> _submitForm() async {
    // Collect form data
    final String fromName = fromNameController.text;
    final String fromAddress = fromAddressController.text;
    final String toName = toNameController.text;
    final String toAddress = toAddressController.text;
    final String date = _controller.text;
    final String itemName = itemNameController.text;
    final String quantity = quantityController.text;
    final String gst = gstController.text;
    final String hsnCode = hsnCodeController.text;
    final String discount = discountController.text;
    final String unitPrice = unitPriceController.text;

    // Calculate the total amount
    totalAmount = calculateTotal();
    print("Total Amount: ₹ $totalAmount"); // Log the calculated total

    // Retrieve the token from secure storage
    final String? token = await getToken(); // Retrieve token

    // Declare the decodedToken variable
    Map<String, dynamic> decodedToken = {};

    try {
      // Decode the token
      decodedToken = JwtDecoder.decode(token!);
      print("Decoded Token: $decodedToken");  // Print the decoded token to check its structure
    } catch (e) {
      print("Error decoding the token: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid token format. Please log in again.')),
      );
      return;
    }

// Now you can safely use decodedToken
    String? companyId = decodedToken['companyId'];
    String? id = decodedToken['id'];  // Correct field name
    String? branchId = decodedToken['branchId'];
    String? supervisorId = decodedToken['supervisorId'];

// Handle null values gracefully
    if (companyId == null || id == null || branchId == null || supervisorId == null) {
      print("One or more required fields are missing in the decoded token.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token is missing required information.')),
      );
      return;
    }

    String finalCompanyId = companyId!;
    String finalId = id!; // Corrected variable name
    String finalBranchId = branchId!;
    String finalSupervisorId = supervisorId!;

// Now you can safely use these variables
    print("Company ID: $finalCompanyId");
    print("Salesman ID: $finalId");  // Corrected usage of variable
    print("Branch ID: $finalBranchId");
    print("Supervisor ID: $finalSupervisorId");


    // Create the PDF
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.Text('From: $fromName'),
            pw.Text('Address: $fromAddress'),
            pw.SizedBox(height: 10),
            pw.Text('To: $toName'),
            pw.Text('Address: $toAddress'),
            pw.SizedBox(height: 20),
            pw.Text('Date: $date'),
            pw.SizedBox(height: 10),
            pw.Text('Item Name: $itemName'),
            pw.Text('Quantity: $quantity'),
            pw.Text('GST: $gst'),
            pw.Text('HSN Code: $hsnCode'),
            pw.Text('Discount: $discount'),
            pw.Text('Unit Price: $unitPrice'),
            pw.SizedBox(height: 20),
            pw.Text('Total Amount: ₹ ${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ));

    // Save or print the PDF
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      print("PDF generated successfully.");
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // Retrieve the token
    String? token = preferences.getString('salesman_token');
    print('Retrieved Token: $token');
    return token;
  }


  @override
  Widget build(BuildContext context) {
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () {
                    print('PDF icon clicked');
                    _pickPDF(); // Call the PDF picker function
                  },
                ),
              ],
            )
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Invoice Form',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text('From :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                TextField(
                  controller: fromNameController,
                  decoration: InputDecoration(
                    hintText: 'Customer Name.........',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // Outer border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When focused
                    ),
                  ),
                  cursorColor: Colors.black, // Cursor color
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: fromAddressController,
                  decoration: InputDecoration(
                    hintText: 'Customer Address.........',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // Outer border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When not focused
                  ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When focused
                    ),
                ),
                  cursorColor: Colors.black, // Cursor color
                ),
                const SizedBox(height: 20),
                const Text('To :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                TextField(
                  controller: toNameController,
                  decoration: InputDecoration(
                    hintText: 'Company Name.........',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // Outer border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When focused
                    ),
                  ),
                  cursorColor: Colors.black, // Cursor color
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: toAddressController,
                  decoration: InputDecoration(
                    hintText: 'Company Address.........',
                    filled: true,
                    fillColor: Colors.grey[300],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // Outer border color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.black), // When focused
                    ),
                  ),
                  cursorColor: Colors.black, // Cursor color
                ),
                const SizedBox(height: 20),
                const Text('Items Details :', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  readOnly: true,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'Date',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  onTap: () => _selectDate(context),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: itemNameController,
                  decoration: const InputDecoration(
                    hintText: 'Product Name ',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = calculateTotal(); // Recalculate total on change
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: gstController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'GST',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = calculateTotal(); // Recalculate total on change
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: hsnCodeController,
                  decoration: const InputDecoration(
                    hintText: 'HSN Code',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Discount',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = calculateTotal(); // Recalculate total on change
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: unitPriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Unit Price',
                    hintStyle: TextStyle(color: Colors.black),
                    filled: false,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 2.0, color: Colors.black),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      totalAmount = calculateTotal(); // Recalculate total on change
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Amount: ₹ ${totalAmount.toStringAsFixed(2)}',  // Display total dynamically
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.grey.shade100, minimumSize: Size(50, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                  child: const Text('Submit Invoice'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}