import 'package:flutter/material.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/AttendanceSalesmanCard.dart';

import '../../../resources/my_colors.dart';

class Attendancescreen extends StatelessWidget {
  const Attendancescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [Attendancecard()],
      ),
    );
  }
}
