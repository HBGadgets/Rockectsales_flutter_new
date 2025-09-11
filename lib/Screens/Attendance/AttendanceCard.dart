import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../resources/my_colors.dart';
import 'NewAttendanceController.dart';
import 'SelfieTakingScreenAttendance.dart';

class AttendanceCard extends StatelessWidget {
  final String name;
  final DateTime? date;
  final String location;

  AttendanceCard({
    super.key,
    required this.name,
    required this.date,
    required this.location,
  });

  final NewAttendanceController controller =
      Get.find<NewAttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey.shade300,
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          // "jshdbfkgjsbdfgldjsfglsjdfgsdfgsdhsgfh",
                          maxLines: 3,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MyColor.dashbord),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.black54),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat("dd/MM/yyyy").format(date!),
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24),

              // Location Row
              Row(
                children: [
                  const Icon(Icons.location_on, color: MyColor.dashbord),
                  const SizedBox(width: 6),
                  Expanded(child: Obx(() {
                    return Text(
                      controller.addressString.value,
                      style: const TextStyle(color: Colors.black87),
                    );
                  })),
                ],
              ),

              const SizedBox(height: 16),

              // Button
              Obx(() {
                if (controller.isAttendanceMarkedToday.value == null) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: MyColor.dashbord,
                    ),
                  );
                } else {
                  return Center(
                      child: controller.isAttendanceMarkedToday.value!
                          ? const Text("Attendance marked for today")
                          : ElevatedButton(
                              onPressed: () {
                                controller.salesManSelfie.value = null;
                                Get.to(SelfietakingscreenAttendance());
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.indigo.shade900,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 12),
                              ),
                              child: const Text(
                                "Mark Attendance",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ));
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
