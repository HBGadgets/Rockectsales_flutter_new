import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales/Screens/Attendance/AttendanceReport.dart';
import 'package:rocketsales/Screens/LeaveApplication/ApplyLeaveScreen.dart';
import 'package:rocketsales/Screens/LeaveApplication/LeaveHistoryScreen.dart';

import '../../resources/my_colors.dart';
import '../SalesmanDashboard/SalesmanDashboardController.dart';
import 'dart:typed_data';

class LeaveApplicationScreen extends StatelessWidget {
  LeaveApplicationScreen({super.key});

  final salesmanDashboardController controller =
  Get.find<salesmanDashboardController>();

  String formatDate(DateTime? date) {
    if (date == null) {
      return "N/A";
    } else {
      return DateFormat('dd MMMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? profileImage = controller.bytes.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Leave Application",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar with plus icon
            Center(
              child: Obx(() {
                if (controller.loadingProfile.value) {
                  return const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: CircularProgressIndicator(color: MyColor.dashbord),
                  );
                } else if (profileImage == null || controller.bytes.value == null) {
                  return const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
                  );
                } else {
                  return CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 50,
                    backgroundImage: MemoryImage(profileImage),
                  );
                }
              }),
            ),

            const SizedBox(height: 12),

            // Name
            Obx(() {
              return Text(
                controller.salesmanProfileInfo.value.name ?? "Loading...",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),


            const SizedBox(height: 16),

            // Date and Time row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.black87),
                SizedBox(width: 6),
                Text(formatDate(DateTime.now()), style: TextStyle(color: Colors.black87)),
              ],
            ),

            const SizedBox(height: 20),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColor.dashbord,
                    foregroundColor: Colors.white
                  ),
                  onPressed: () {
                    Get.to(ApplyLeaveScreen());
                  },
                  child: const Text("Apply for Leave"),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: MyColor.dashbord),
                    foregroundColor: MyColor.dashbord
                  ),
                  onPressed: () {
                    Get.to(LeaveHistoryScreen());
                  },
                  child: const Text("Leave History"),
                ),
              ],
            ),

            const SizedBox(height: 24),

            AttendanceReport(),

            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }
}
