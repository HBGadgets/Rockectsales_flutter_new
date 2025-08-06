import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/saleman_attendance_controller.dart';
import '../../../controllers/speed_controller.dart';
import '../../admin/dashboard_admin.dart';
import 'apply_leave.dart';

class AttendancePage extends StatefulWidget {
  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

final AttendanceController controller = Get.find();
final SpeedController controller1 = Get.put(SpeedController());

class _AttendancePageState extends State<AttendancePage> {
  final AttendanceController controller = Get.find();

  final SpeedController controller1 = Get.put(SpeedController());

  // final AuthController controller1 = Get.find();
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarDiameter = screenWidth * 0.5;
    String formattedDateTime =
        DateFormat('dd/MM/yy   hh:mm a').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Obx(() => CircleAvatar(
                          radius: avatarDiameter / 2,
                          backgroundImage: controller.imageFile.value == null
                              ? const AssetImage(
                                  'assets/images/Rectangle 24.png')
                              : FileImage(controller.imageFile.value!)
                                  as ImageProvider,
                          backgroundColor: Colors.grey.shade200,
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Text(
                      " ${authController.username.value}",
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 10),
                Container(
                  height: 60.0,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: TextEditingController(text: formattedDateTime),
                    decoration: InputDecoration(
                      prefixText: '  Date: ',
                      hintText: formattedDateTime,
                      hintStyle: const TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 50,
                          child: controller.isDisabled.value
                              ? Opacity(
                                  opacity: 0.5,
                                  child: _buildButton(
                                      'Check in', () {}, Colors.green.shade300),
                                )
                              : _buildButton(
                                  'Check in',
                                  controller.onCheckInPressed,
                                  Colors.green.shade300),
                        ),
                        SizedBox(
                          width: 140,
                          height: 50,
                          child: _buildButton(
                              'Check out',
                              controller.onCheckOutPressed,
                              Colors.red.shade300),
                        ),
                      ],
                    )),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Get.to(ApplyLeave()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side:
                            BorderSide(color: Colors.grey.shade300, width: 1.5),
                      ),
                    ),
                    child: const Text(
                      'Apply for leaves',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed, Color buttonColor) {
    return Container(
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
