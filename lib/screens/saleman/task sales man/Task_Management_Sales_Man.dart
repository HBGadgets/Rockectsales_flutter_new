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

// return Card(
// margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(15)),
// elevation: 3,
// child: ListTile(
// contentPadding:
// const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// title: Text(
// task.taskDescription,
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// subtitle: Text(
// 'Status: ${task.status}',
// style: TextStyle(
// color: isCompleted ? Colors.green : Colors.grey,
// fontWeight: FontWeight.w500,
// ),
// ),
// trailing: ElevatedButton(
// onPressed: () async {
// final isCurrentlyCompleted = task.status == 'Completed';
// await taskController.toggleTaskStatus(
// task.id, isCurrentlyCompleted);
//
// // After the status update, refresh the task list to reflect the change
// setState(() {
// // Toggle the task's status locally
// task.status =
// isCurrentlyCompleted ? 'Pending' : 'Completed';
// });
// },
// style: ElevatedButton.styleFrom(
// backgroundColor: task.status == 'Completed'
// ? Colors.green.shade100
//     : Colors.grey.shade300,
// foregroundColor: task.status == 'Completed'
// ? Colors.green.shade800
//     : Colors.grey.shade700,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(20),
// ),
// elevation: 0,
// padding:
// const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// ),
// child: Text(
// task.status == 'Completed' ? 'Completed' : 'Pending',
// style: const TextStyle(fontWeight: FontWeight.bold),
// ),
// ),
// ),
// );

/*File? _imageFile;
  List<Map<String, dynamic>> tasks =
      []; // Change type to List<Map<String, dynamic>>

  // Function to fetch tasks from the API
  Future<void> _fetchTasks() async {
    try {
      // Retrieve token dynamically from local storage (SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs
          .getString('salesmanToken'); // Replace with your actual token key

      if (token == null) {
        _showSnackbar('Authorization token is missing or invalid');
        return;
      }

      final response = await http.get(
        Uri.parse('http://104.251.218.102:8080/api/task'),
        headers: {
          'Authorization': 'Bearer $token',
          // Use the token in the Authorization header
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty) {
          setState(() {
            tasks = data.map((task) {
              return {
                '_id': task['_id'], // Extract _id from the response body
                'taskDescription': task['taskDescription'],
                'status': task['status'], // Include status in the task map
              };
            }).toList();
          });
        } else {
          _showSnackbar('No tasks available.');
        }
      } else {
        _showSnackbar(
            'Failed to load tasks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackbar('Error fetching tasks: ${e.toString()}');
    }
  }

  Future<void> _pickImage() async {
    try {
      final status = await Permission.camera.request();
      if (status.isGranted) {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.camera);

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
          _showSnackbar('Image selected: ${pickedFile.path}');
        } else {
          _showSnackbar('No image selected.');
        }
      } else {
        _showSnackbar('Camera permission denied');
      }
    } catch (e) {
      _showSnackbar('Error picking image: ${e.toString()}');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Call the fetch function when the state is initialized
  }
*/
/*
class TaskItem extends StatelessWidget {
  final String task;
  final String status;
  final String taskId;
  final VoidCallback onImagePick; // Callback for image picking
  final Function(String) showSnackbar; // Callback for showing Snackbar
  final VoidCallback fetchTasks; // Callback for fetching tasks

  const TaskItem({
    super.key,
    required this.task,
    required this.status,
    required this.taskId,
    required this.onImagePick,
    required this.showSnackbar, // Accept showSnackbar as a parameter
    required this.fetchTasks, // Accept fetchTasks as a parameter
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.yellow;
      default:
        return Colors.red;
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('salesmanToken');

      if (token == null) {
        showSnackbar('Authorization token is missing or invalid');
        return;
      }

      final response = await http.put(
        // Uri.parse('https://rocketsales-server.onrender.com/api/task/$taskId'),
        Uri.parse('http://104.251.218.102:8080/api/task/$taskId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': newStatus,
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        showSnackbar('Task status updated successfully');
        fetchTasks(); // Fetch tasks again to update the UI
      } else {
        showSnackbar(
            'Failed to update task status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showSnackbar('Error updating task status: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 181.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Center(
              child: Text(
                task,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                // Pick image first, then update task status
                onImagePick(); // Pick the image (no need to await)
                updateTaskStatus(taskId,
                    'Completed'); // After image picked, update task status
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
              ),
              onPressed: () {
                // Pick image first, then update task status
                onImagePick(); // Pick the image (no need to await)
                updateTaskStatus(taskId,
                    'Pending'); // After image picked, update task status
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
