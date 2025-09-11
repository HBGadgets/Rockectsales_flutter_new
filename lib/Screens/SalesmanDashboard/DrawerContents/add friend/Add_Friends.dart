import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/my_assets.dart';

class AddFriends extends StatelessWidget {
  const AddFriends({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        // backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image(image: rocket_sale, height: 160),
                    const SizedBox(height: 16),
                    const Text(
                      'Add Friends',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "I appreciate the effort put into this app. It has some great features and potential. However, there are a few areas where I believe it could be even better with some enhancements. Overall it's a promising app.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 25),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Define your onPressed action here
                        },
                        icon: const Icon(Icons.person_add,
                            color: Colors.greenAccent),
                        // Icon for the button
                        label: const Text(
                          'Add Friends',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.greenAccent,
                          // Text color
                          backgroundColor: Colors.white,
                          // Button background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 14),
                          // Button padding
                          textStyle: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold), // Text size
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
