import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskDescriptionScreen extends StatefulWidget {
  final String task;
  final String deadline;
  final String taskId;

  TaskDescriptionScreen({
    required this.task,
    required this.deadline,
    required this.taskId,
  });
  // TaskDescriptionScreen({required this.taskId, required deadline});

  @override
  _TaskDescriptionScreenState createState() => _TaskDescriptionScreenState();
}

class _TaskDescriptionScreenState extends State<TaskDescriptionScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the passed values
    descriptionController.text = widget.task;  // Set task description
    deadlineController.text = widget.deadline;  // Set task deadline
    _fetchTaskDetails();  // Optionally fetch task details using taskId
  }

  Future<void> _fetchTaskDetails() async {
    String? token = await getToken();

    if (token == null) {
      print('Token is missing or invalid');
      return;
    }

    if (widget.taskId.isEmpty) {
      print('Task ID is empty');
      return;
    }

    // final url = 'https://rocketsales-server.onrender.com/api/task/${widget.taskId}';
    final url = 'http://104.251.218.102:8080/api/task/${widget.taskId}';
    print('Requesting URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final responseData = json.decode(response.body);
          if (responseData is List && responseData.isNotEmpty) {
            var taskData = responseData[0]; // Assuming the first item in the list
            final taskModel = TaskModel.fromJson(taskData);

            setState(() {
              descriptionController.text = taskModel.description ?? widget.task;
              deadlineController.text = taskModel.deadline ?? widget.deadline;
              locationController.text = taskModel.location ?? '';
              isLoading = false;
            });
          } else {
            print('No tasks found or unexpected response format.');
            setState(() {
              isLoading = false;
            });
          }
        } catch (e) {
          print('Error decoding response: $e');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('Failed to fetch task details');
        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error making request: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Fetches the token from SharedPreferences
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey.shade50,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Task'),
              background: Container(color: Colors.grey.shade50),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back(); // Go back to the previous screen
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Task Description',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter the task details',
                      ),
                      style: TextStyle(color: Colors.black),
                      maxLines: 4,
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: deadlineController,
                      decoration: InputDecoration(
                        labelText: 'Deadline',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter the deadline (e.g., YYYY-MM-DD)',
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location (Latitude, Longitude)',
                        labelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Enter the location coordinates',
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle task update logic here
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: Colors.black, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                        child: const Text('Edit Task'),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    deadlineController.dispose();
    locationController.dispose();
    super.dispose();
  }
}

class TaskModel {
  final String? description;
  final String? deadline;
  final String? location;

  TaskModel({this.description, this.deadline, this.location});

  // Factory constructor to parse the JSON response
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      description: json['description'] as String?,
      deadline: json['deadline'] as String?,
      location: json['location'] as String?,
    );
  }
}


// class TaskDescriptionScreen extends StatefulWidget {
//   const TaskDescriptionScreen({super.key});
//
//   @override
//   State<TaskDescriptionScreen> createState() => _TaskDescriptionScreenState();
// }
//
//
// class _TaskDescriptionScreenState extends State<TaskDescriptionScreenScreen> {
//   // Controllers for the input fields
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController deadlineController = TextEditingController();
//   final TextEditingController locationController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: Colors.grey.shade50,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: const Text('Task Description'),
//               background: Container(
//                 color: Colors.grey.shade50,
//               ),
//             ),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back),
//               onPressed: () {
//                 Get.back(); // Go back to the previous screen using GetX
//               },
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate(
//               [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Task Description Field
//                       TextField(
//                         controller: descriptionController,
//                         decoration: InputDecoration(
//                           labelText: 'Task Description',
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter the task details',
//                         ),
//                         maxLines: 4,
//                       ),
//                       SizedBox(height: 16.0),
//
//                       // Deadline Field
//                       TextField(
//                         controller: deadlineController,
//                         decoration: InputDecoration(
//                           labelText: 'Deadline',
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter the deadline (e.g., YYYY-MM-DD)',
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//
//                       // Location Field (Latitude and Longitude)
//                       TextField(
//                         controller: locationController,
//                         decoration: InputDecoration(
//                           labelText: 'Location (Latitude, Longitude)',
//                           border: OutlineInputBorder(),
//                           hintText: 'Enter the location coordinates',
//                         ),
//                       ),
//                       SizedBox(height: 16.0),
//
//                       // Optionally, add buttons for saving or updating
//                       ElevatedButton(
//                         onPressed: () {
//                           // Handle the task submission logic here
//                           String description = descriptionController.text;
//                           String deadline = deadlineController.text;
//                           String location = locationController.text;
//
//                           // Implement logic to save or send this data
//                           print("Description: $description");
//                           print("Deadline: $deadline");
//                           print("Location: $location");
//                         },
//                         child: const Text('Save Task'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }