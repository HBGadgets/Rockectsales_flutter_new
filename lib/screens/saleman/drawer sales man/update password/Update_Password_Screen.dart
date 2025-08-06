import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  _UpdatePasswordScreenState createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _updatePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform the password update action here
      // This could involve making an API call or updating a local database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back to the previous screen
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.7,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(55.0),
                    bottomRight: Radius.circular(55.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 4.0,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Make children stretch horizontally
                    children: [
                      const Center(
                        child: Text(
                          'Update Password',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'Current Password',
                                labelStyle: const TextStyle(color: Colors.black), // Set text color for the label
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when enabled
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when error
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused and error
                                ),
                              ),
                              style: const TextStyle(color: Colors.black), // Set text color inside the field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your current password';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _currentPassword = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                labelStyle: const TextStyle(color: Colors.black), // Set text color for the label
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when enabled
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when error
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused and error
                                ),
                              ),
                              style: const TextStyle(color: Colors.black), // Set text color inside the field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _newPassword = value;
                                });
                              },
                            ),
                            const SizedBox(height: 20.0),
                            TextFormField(
                              obscureText: _obscureText, // Set the obscureText property
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                labelStyle: const TextStyle(color: Colors.black), // Set text color for the label
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.black,
                                  ),
                                  onPressed: _togglePasswordVisibility,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when enabled
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when error
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16), // Square corners
                                  borderSide: const BorderSide(color: Colors.black), // Outer border color when focused and error
                                ),
                              ),
                              style: const TextStyle(color: Colors.black), // Set text color inside the field
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your new password';
                                }
                                if (value != _newPassword) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  _confirmPassword = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16.0),


                            // ElevatedButton(
                            //   onPressed: _updatePassword,
                            //   style: ElevatedButton.styleFrom(
                            //     foregroundColor: Colors.black,
                            //     backgroundColor: Colors.white, // Text color
                            //     minimumSize: const Size(40, 30), // Adjusted width and height
                            //   ),
                            //   child: const Text('Update Password'),
                            // )
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Implement your button action here
                                    // For example, you might want to navigate to another screen or submit data
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black, // Text color
                                    backgroundColor: Colors.blue.shade50, // Button background color
                                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14), // Button padding
                                    textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text size
                                  ),
                                  child: const Text(
                                    'Update Password',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
