import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:rocketsale_rs/screens/saleman/task%20sales%20man/TaskCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/task_controller/saleTask_controller.dart';
import '../../../resources/my_colors.dart';
import '../../admin/task/task details/Task_Details.dart';

class TaskManagementSalesMan extends StatelessWidget {
  TaskManagementSalesMan({super.key});

  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Task Manager',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (taskController.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(
            color: MyColor.dashbord,
          ));
        }

        if (taskController.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  taskController.error.value,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(MyColor.dashbord),
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () {
                    taskController.error.value = '';
                    taskController.fetchTasks();
                  },
                  child: const Text('Retry'),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: taskController.tasks.length,
          itemBuilder: (context, index) {
            final task = taskController.tasks[index];
            // final isCompleted = task.status.toLowerCase() == 'completed';
            return Taskcard(task: task);
          },
        );
      }),
    );
  }
}
