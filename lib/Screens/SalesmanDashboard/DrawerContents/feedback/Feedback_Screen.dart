import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../TokenManager.dart';
import '../../../../resources/my_assets.dart';
import '../../../../resources/my_colors.dart';

class FeedbackScreen extends StatelessWidget {
  FeedbackScreen({super.key});

  final TextEditingController feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<void> submitFeedback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      showLoading(context);
      try {
        final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/feedback');

        final token = await TokenManager.getToken();

        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          },
          body: jsonEncode(<String, dynamic>{
            'feedbackText': feedbackController.text
          }),
        );

        if (response.statusCode == 201) {
          Navigator.of(context).pop();
          feedbackController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Feedback submitted!'),
            ),
          );
        } else {
          Navigator.of(context).pop();
          print("❌ Feedback submission Failed: ${response.body}");
          Get.snackbar("Error", response.body);
        }
      } catch (e) {
        // isLoading.value = false;
        Navigator.of(context).pop();
        print("⚠️ Exception in posting feedback: $e");
        Get.snackbar("Exception", e.toString());
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        title: Text("Feedback"),
        leading: BackButton( onPressed: () => Navigator.pop(context),),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Image(image: rocket_sale, height: 160),
                  const SizedBox(height: 10.0),
                  Container(
                    height: 230.0,
                    width: 300,
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.grey.shade300, // Border color
                        width: 2.0, // Border width
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: feedbackController,
                              decoration: InputDecoration(
                                hintText: 'Write your feedback here..........',
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(8.0),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter something";
                                }
                                return null;
                              },
                              maxLines: null, // Allow multiple lines
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Help Us Get Better –  Share your feedback',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: MyColor.dashbord,
                      // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 12.0),
                      // Button padding
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                      // Text style
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle feedback submission
                      submitFeedback(context);

                    },
                    child: const Text(
                      'Submit Feedback',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
