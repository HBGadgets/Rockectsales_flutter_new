import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales/Screens/Analytics/AnalyticsController.dart';
import 'package:rocketsales/Screens/Attendance/NewAttendanceController.dart';

import '../../resources/my_colors.dart';
import 'dart:typed_data';

class AnalyticsScreen extends StatelessWidget {
  AnalyticsScreen({super.key});

  final NewAttendanceController attendanceController =
  Get.find<NewAttendanceController>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalyticsController(), permanent: false);

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
            Container(
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() {

                          Uint8List profileImage = base64Decode(controller.performers.first.profileImgBase64);
                          if (controller.isLoading.value) {
                            return const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              child: CircularProgressIndicator(color: MyColor.dashbord),
                            );
                          } else if (controller.performers.first.profileImgBase64 == null) {
                            return const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
                            );
                          } else {
                            return CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 30,
                              backgroundImage: MemoryImage(profileImage),
                            );
                          }
                        }),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Salesman of this month",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 4),
                              Text(controller.performers.first.salesmanName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E4DB7),
                                  )),
                            ],
                          ),
                        ),
                        const Icon(Icons.emoji_events,
                            color: Colors.amber, size: 28),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Attendance Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Attendance"),
                        Text(attendanceController.attendanceForTheMonth.value!.presentPercentage),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFF1E4DB7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Order / Task / Sales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoBox("Order", controller.performers.first.orderCompleted.toString()),
                        _infoBox("Task", controller.performers.first.taskCompleted.toString()),
                        _infoBox("Score", controller.performers.first.score.toString()),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Task Card
            _sectionCard(
              title: "Task Leaderboard",
              children: [
                // _leaderRow(Icons.shopping_cart_outlined, "Top in Orders",
                //     "Priya Sharma", "135"),
                // _leaderRow(Icons.task_alt_outlined, "Top in Task",
                //     "Pavan Raghuvanshi", "45"),
                // _leaderRow(Icons.calendar_today_outlined, "Top in Attendance",
                //     "Piyush", "30"),
                _personRow("Pawan Raghuvanshi", crown: true),
                _personRow("Priya Mehra"),
                _personRow("Piyush"),
                TextButton(
                  onPressed: () {},
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
                _personRow("Pawan Raghuvanshi", crown: true),
                _personRow("Priya Mehra"),
                _personRow("Piyush"),
                TextButton(
                  onPressed: () {},
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
                _personRow("Darlene Robertson", crown: true),
                _personRow("Priya Sharma"),
                TextButton(
                  onPressed: () {},
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

  static Widget _personRow(String name, {bool crown = false}) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/2.jpg"),
      ),
      title: Text(
        name,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      trailing: crown
          ? Row(
        mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, color: Colors.amber),
              const Icon(Icons.chevron_right)
            ],
          )
          : const Icon(Icons.chevron_right),
    );
  }
}
