import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rocketsales/Screens/Analytics/AnalyticsModel.dart';
import 'dart:typed_data';

class TaskPerformerCard extends StatelessWidget {
  final TaskPerformer taskPerformer;
  final bool crown;

  const TaskPerformerCard({
    super.key,
    required this.taskPerformer,
    this.crown = false,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List profileImage = base64Decode(taskPerformer.profileImage);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header Row
          Row(
            children: [
              taskPerformer.profileImage == "" ? CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 20,
                child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
              ) : CircleAvatar(
                  radius: 20,
                  backgroundImage: MemoryImage(profileImage)
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  taskPerformer.salesmanName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E4DB7), // Blue text
                  ),
                ),
              ),
              if (crown)
                const Icon(Icons.emoji_events,
                    color: Colors.amber, size: 26), // Crown icon
            ],
          ),

          const SizedBox(height: 10),

          // 🔹 Task Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _infoDot(Colors.blue, "Total Task", taskPerformer.taskTotal),
              _infoDot(Colors.green, "Completed", taskPerformer.taskCompleted),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable Dot + Label Widget
  Widget _infoDot(Color color, String label, int value) {
    return Row(
      children: [
        CircleAvatar(radius: 6, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          "$label: $value",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
