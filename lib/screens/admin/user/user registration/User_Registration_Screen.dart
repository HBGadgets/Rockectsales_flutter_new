import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../controllers/user_management_controller.dart';
import '../../../../utils/widgets/admin_app_bar.dart';
import '../user management/User_Management_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool isLoading = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _createSalesman() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Extract token data
      Map<String, dynamic> tokenData = await extractTokenData();
      String? companyId = tokenData['companyId'];
      String? branchId = tokenData['branchId'];
      String? supervisorId = tokenData['id'];

      if (companyId == null || branchId == null || supervisorId == null) {
        Get.snackbar(
            'Error', 'Token is missing required fields. Please login again.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      String? token = await getToken();
      if (token == null) {
        Get.snackbar('Error', 'No token found. Please login again.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Prepare request data
      final Map<String, String> requestData = {
        "salesmanName": nameController.text,
        "salesmanEmail": emailController.text,
        "username": usernameController.text,
        "password": passwordController.text,
        "salesmanPhone": phoneController.text,
        "companyId": companyId,
        "branchId": branchId,
        "supervisorId": supervisorId, // Include supervisor ID
      };

      var uri = Uri.parse('http://104.251.218.102:8080/api/salesman');
      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = "Bearer $token";

      request.fields.addAll(requestData);

      if (_imageFile != null) {
        var imageFile =
            await http.MultipartFile.fromPath('profileImage', _imageFile!.path);
        request.files.add(imageFile);
      } else {
        Get.snackbar('Error', 'Please select an image before submitting.');
        setState(() {
          isLoading = false;
        });
        return;
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Salesman created successfully');

        Get.back(result: true);
        final controller = Get.find<UserManagementController>();
        controller.fetchSalesmen();
      } else {
        print('Failed to create salesman. Status Code: ${response.statusCode}');
        print('Response: $responseBody');
        Get.snackbar('Error', 'Failed to create salesman. Please try again.');
      }
    } catch (e) {
      print('Error creating salesman: $e');
      Get.snackbar('Error', 'An error occurred while creating the salesman.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> extractTokenData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        return {};
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String companyId = decodedToken['companyId'] ?? '';
      String branchId = decodedToken['branchId'] ?? '';
      String supervisorId = decodedToken['id'] ?? '';

      if (supervisorId.isEmpty) {
        print('Warning: supervisorId is missing or empty');
      }

      return {
        'companyId': companyId,
        'branchId': branchId,
        'id': supervisorId,
      };
    } catch (e) {
      print('Error decoding token: $e');
      return {};
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Registration',
        menuIcon: Icons.arrow_back,
        onMenuTap: () => Get.back(),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text('Register below:')),
                          DataColumn(label: Text('')),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text('Salesman Name')),
                            DataCell(TextField(controller: nameController)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Salesman Email Address')),
                            DataCell(TextField(controller: emailController)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Salesman username')),
                            DataCell(TextField(controller: usernameController)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Salesman password')),
                            DataCell(TextField(controller: passwordController)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Salesman Mob.No')),
                            DataCell(TextField(controller: phoneController)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text('Choose Profile Picture')),
                            DataCell(Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: _pickImage,
                                    icon:
                                        Icon(Icons.image, color: Colors.black),
                                    label: Text('Image'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(80, 40),
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (_imageFile != null)
                                  Image.file(File(_imageFile!.path)),
                              ],
                            )),
                          ]),
                        ],
                      ),
                    ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: _createSalesman,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.green,
                    backgroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
                    textStyle:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
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
