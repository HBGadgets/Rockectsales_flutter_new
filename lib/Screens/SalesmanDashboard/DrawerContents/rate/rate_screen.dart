import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: BackButton(color: Colors.black87, onPressed: () => Navigator.pop(context),),
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
                    Image.asset(
                      'assets/images/Rate.png', // Path to your asset image
                      height: 160,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Rate Us',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Help Us Improve-Share Your Experience ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/images/Rate_2.png', // Path to your asset image
                      height: 80,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Rating. 5.0',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    ElevatedButton(
                      onPressed: () {
                        // Define your button's onPressed action here
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.greenAccent, // Text color
                        backgroundColor: Colors.white, // Button background color
                        padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0), // Button padding
                        textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text style
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                        child: Text(
                          'Rate',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )

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
