import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/my_assets.dart';
import '../../resources/my_colors.dart';
import 'AuthController.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Obx(() => WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            /// Splashscreen pinned at bottom
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

            /// Scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: size.height, // ensures it fills screen
                ),
                child: IntrinsicHeight(
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
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: MyColor.dashbord, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.045),

                      // Password Input
                      TextField(
                        obscureText: _obscureText,
                        controller: authController.passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: MyColor.dashbord, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
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
                            authController.login(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade800,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style:
                            TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const Spacer(), // pushes button up if space remains
                    ],
                  ),
                ),
              ),
            ),
            if (authController.isLoading.value)
              Positioned.fill(
                child: Container(
                  color: Color.fromRGBO(0, 0, 0, 0.35),
                  child: const Center(
                    child: CircularProgressIndicator(color: MyColor.dashbord),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));

  }
}

