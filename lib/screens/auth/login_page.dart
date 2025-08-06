import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../resources/my_assets.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false, // Prevent back navigation
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Bottom wave image
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image(
                image: splashscreen,
                fit: BoxFit.cover,
                width: size.width,
              ),
            ),

            // Main content with scroll
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.085),
                  Image(image: rocket_sale, height: size.height * 0.15),
                  SizedBox(height: size.height * 0.033),

                  // Username Input
                  TextField(
                    controller: authController.usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.045),

                  // Password Input
                  TextField(
                    obscureText: true,
                    controller: authController.passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.05,
                    child: ElevatedButton(
                      onPressed: () {
                        authController.login();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Login",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  SizedBox(height: size.height * 0.25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
