import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportManager extends StatefulWidget {
  const ReportManager({super.key});

  @override
  State<ReportManager> createState() => _ReportManagerState();
}

class _ReportManagerState extends State<ReportManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding to avoid edge touch
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity, // Use double.infinity to fill available width
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Coming Soon...",
                    style: TextStyle(
                      fontSize: 27, // Adjust font size as needed
                      fontWeight: FontWeight.bold, // Adjust text weight as needed
                      color: Colors.black, // Adjust text color as needed
                    ),
                    textAlign: TextAlign.center, // Center the text inside the container
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
