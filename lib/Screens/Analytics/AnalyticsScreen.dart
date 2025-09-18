import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales/Screens/Analytics/AnalyticsController.dart';
import 'package:rocketsales/Screens/Analytics/LeadboardScreens/AttendanceLeaderboard/AttendanceLeaderboardScreen.dart';
import 'package:rocketsales/Screens/Analytics/LeadboardScreens/OrderLeaderboard/OrderLeaderboardScreen.dart';
import 'package:rocketsales/Screens/Analytics/LeadboardScreens/TaskLeaderboard/TaskLeaderboardScreen.dart';
import 'package:rocketsales/Screens/Attendance/NewAttendanceController.dart';

import '../../resources/my_colors.dart';
import 'dart:typed_data';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final NewAttendanceController attendanceController =
    Get.put(NewAttendanceController());
    final controller = Get.put(AnalyticsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Analytics"),
        backgroundColor: const Color(0xFF1E4DB7), // blue header
        foregroundColor: Colors.white,
      ),
      body: Obx(() => controller.isLoading.value || attendanceController.isLoading.value ? const Center(child: CircularProgressIndicator(color: MyColor.dashbord,),) : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 Salesman of the Month Card
            _salesmanOfTheMonth(controller.attendancePerformers.first.attendancePresent, DateTime.now().day, controller),

            const SizedBox(height: 16),

            // 🔹 Task Card
            _sectionCard(
              title: "Task Leaderboard",
              children: [
                if (controller.taskPerformers.length > 0)
                _personRow(controller.taskPerformers.first.salesmanName.toString(), controller.taskPerformers.first.profileImage.toString(), crown: true),
                if (controller.taskPerformers.length > 1)
                _personRow(controller.taskPerformers[1].salesmanName.toString(), controller.taskPerformers[1].profileImage.toString()),
                if (controller.taskPerformers.length > 2)
                _personRow(controller.taskPerformers[2].salesmanName.toString(), controller.taskPerformers[2].profileImage.toString()),
                TextButton(
                  onPressed: () {
                    Get.to(TaskLeaderBoardScreen());
                  },
                  child: const Text("See full leaderboard"),
                  style: TextButton.styleFrom(foregroundColor: MyColor.dashbord),
                ),
              ], icon: Icons.task_alt,
            ),

            const SizedBox(height: 16),

            // 🔹 Attendance Leaderboard
            _sectionCard(
              title: "Attendance Leaderboard",
              children: [
                if (controller.attendancePerformers.length > 0)
                _personRow(controller.attendancePerformers.first.salesmanName.toString(), controller.attendancePerformers.first.profileImage.toString(), crown: true),
                if (controller.attendancePerformers.length > 1)
                _personRow(controller.attendancePerformers[1].salesmanName.toString(), controller.attendancePerformers[1].profileImage.toString()),
                if (controller.attendancePerformers.length > 2)
                _personRow(controller.attendancePerformers[2].salesmanName.toString(), controller.attendancePerformers[2].profileImage.toString()),
                TextButton(
                  onPressed: () {
                    Get.to(AttendanceLeaderBoardScreen());
                  },
                  child: const Text("See full leaderboard"),
                  style: TextButton.styleFrom(foregroundColor: MyColor.dashbord),
                ),
              ], icon: Icons.calendar_month,
            ),

            const SizedBox(height: 16),

            // 🔹 Order Leaderboard
            _sectionCard(
              title: "Order Leaderboard",
              children: [
                if (controller.orderPerformers.length > 0)
                _personRow(controller.orderPerformers.first.salesmanName.toString(), controller.orderPerformers.first.profileImage.toString(), crown: true),
                if (controller.orderPerformers.length > 1)
                _personRow(controller.orderPerformers[1].salesmanName.toString(), controller.orderPerformers[1].profileImage.toString()),
                if (controller.orderPerformers.length > 2)
                _personRow(controller.orderPerformers[2].salesmanName.toString(), controller.orderPerformers[2].profileImage.toString()),
                TextButton(
                  onPressed: () {
                    Get.to(OrderLeaderBoardScreen());
                  },
                  child: const Text("See full leaderboard"),
                  style: TextButton.styleFrom(foregroundColor: MyColor.dashbord),
                ),
              ], icon: Icons.shopping_cart_outlined,
            ),
          ],
        ),
      ))

    );
  }

  static Widget _salesmanOfTheMonth(
      int attendancePresent,
      int totalDays,
      AnalyticsController controller,
      ) {
    // ✅ If no performers, show a placeholder instead of crashing
    if (controller.performers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12, width: 2),
        ),
        child: const Center(
          child: Text(
            "No Salesman of the Month data",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
      );
    }

    final performer = controller.performers.first;
    final double attendancePercentage =
    totalDays > 0 ? (attendancePresent / totalDays) * 100 : 0;

    // ✅ Handle profileImage safely
    Uint8List? profileImage;
    if (performer.profileImgBase64 != null &&
        performer.profileImgBase64!.isNotEmpty) {
      try {
        profileImage = base64Decode(performer.profileImgBase64!);
      } catch (e) {
        profileImage = null; // if decode fails
      }
    }

    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                controller.isLoading.value
                    ? const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: CircularProgressIndicator(color: MyColor.dashbord),
                )
                    : (profileImage == null
                    ? const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: Icon(Icons.person,
                      size: 30, color: Colors.white),
                )
                    : CircleAvatar(
                  radius: 30,
                  backgroundImage: MemoryImage(profileImage),
                )),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Salesman of this month",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(performer.salesmanName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E4DB7),
                          )),
                    ],
                  ),
                ),
                const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              ],
            ),
            const SizedBox(height: 12),
            // Attendance Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Attendance"),
                Text("${attendancePercentage.toStringAsFixed(0)}%"),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: attendancePercentage / 100,
                minHeight: 6,
                backgroundColor: Colors.grey.shade300,
                color: const Color(0xFF1E4DB7),
              ),
            ),
            const SizedBox(height: 16),
            // Order / Task / Score
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoBox("Order", performer.orderCompleted?.toString() ?? "0"),
                _infoBox("Task", performer.taskCompleted?.toString() ?? "0"),
                _infoBox("Score", performer.score?.toString() ?? "0"),
              ],
            )
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widgets
  static Widget _infoBox(String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  static Widget _sectionCard({
    required String title,
    required List<Widget> children,
    required IconData icon
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 5, left: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            ListTile(
              leading: Icon(icon, color: Color(0xFF1E4DB7)),
              title: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              // trailing: const Icon(Icons.chevron_right),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  static Widget _leaderRow(
      IconData icon, String label, String name, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E4DB7)),
      title: Text.rich(
        TextSpan(
          text: "$label\n",
          style: const TextStyle(fontSize: 13, color: Colors.black54),
          children: [
            TextSpan(
              text: name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E4DB7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      trailing: Text(value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  static Widget _personRow(String name, String base64Image, {bool crown = false}) {
    Uint8List profileImage = base64Decode(base64Image);
    return ListTile(
      leading: base64Image == "" ? CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20,
        child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
      ) : CircleAvatar(
          radius: 20,
          backgroundImage: MemoryImage(profileImage)
      ),
      title: Text(
        name,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      trailing: crown
          ? Icon(Icons.emoji_events, color: Colors.amber)
          : null,
    );

  }
}
