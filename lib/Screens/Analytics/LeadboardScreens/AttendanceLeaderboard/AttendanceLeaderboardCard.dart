import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../AnalyticsModel.dart';

class AttendanceLeaderBoardCard extends StatelessWidget {
  final bool isCrown;
  final AttendancePerformer attendancePerformer;
  const AttendanceLeaderBoardCard({super.key, required this.attendancePerformer, this.isCrown = false,});

  @override
  Widget build(BuildContext context) {
    double attendancePercentage = (attendancePerformer.attendancePresent / DateTime.now().day) * 100;
    Uint8List profileImage = base64Decode(attendancePerformer.profileImage);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
        attendancePerformer.profileImage == "" ? CircleAvatar(
          backgroundColor: Colors.grey,
          radius: 20,
          child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
        ) : CircleAvatar(
            radius: 20,
            backgroundImage: MemoryImage(profileImage)
        ),
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
                      Text(attendancePerformer.salesmanName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E4DB7),
                          )),
                    ],
                  ),
                ),
                if (isCrown)
                  const Icon(Icons.emoji_events,
                      color: Colors.amber, size: 26),
              ],
            ),
            const SizedBox(height: 12),
            // Attendance Progress
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Attendance"),
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
          ],
        ),
      ),
    );
  }
}
