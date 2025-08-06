import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../manual task/Manual_Task_Screen.dart';
import '../task description/Task_Description.dart';

class TaskDetails extends StatefulWidget {
  final String id;

  const TaskDetails({required this.id});

  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  List<Map<String, dynamic>> tasks = [];
  bool isLoading = true;
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    String? token = await getToken();
    if (token == null || token.isEmpty) {
      print("No token found. Please log in.");
      return;
    }

    setState(() {
      this.token = token;
      isLoading = true;
    });

    try {
      final String taskId =
          widget.id; // Get the taskId passed from SalesmanCard
      print("Fetching task for taskId: $taskId");

      if (taskId.isEmpty || taskId == "No task") {
        print("Invalid taskId");
        return;
      }

      // final String apiUrl = "https://rocketsales-server.onrender.com/api/task/$taskId"; // Ensure this is the correct URL with the task ID
      final String apiUrl = "http://104.251.218.102:8080/api/task/$taskId";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        print("Fetched tasks: $jsonResponse");

        setState(() {
          tasks = jsonResponse.map((taskData) {
            return {
              "task": taskData["taskDescription"] ?? "No task available",
              "deadline": taskData["deadline"] ?? "No deadline available",
            };
          }).toList();
        });
      } else {
        print(
            "Failed to load tasks: ${response.statusCode}. Response body: ${response.body}");
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    } finally {
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
    // return Padding(
    //   padding: const EdgeInsets.all(16.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       isLoading
    //           ? Center(child: CircularProgressIndicator())
    //           : tasks.isEmpty
    //           ? Center(child: Text("No tasks available."))
    //           : Expanded(
    //         child: SingleChildScrollView(
    //           child: Column(
    //             children: List.generate(tasks.length, (index) {
    //               return GestureDetector(
    //                   onTap: () {
    //                 // Navigate to TaskDescriptionScreen when tapped
    //                     Get.to(() => TaskDescriptionScreen(
    //                       taskId: tasks[index]["task"]!, // Assuming "task" is a non-null string
    //                       deadline: tasks[index]["deadline"]!, // Assuming "deadline" is a non-null string
    //                       task: tasks[index]["task"]!,
    //                     ));
    //               },
    //               child:
    //               TaskItem(
    //                 task: tasks[index]["task"]!,
    //                 deadline: tasks[index]["deadline"]!,
    //               ));
    //             }),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 8.0), // Adjust padding to avoid overflow
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             TextButton(
    //               onPressed: () {
    //                 Get.to(() =>  ManualTaskScreen(
    //                   taskId: '',));
    //               },
    //               style: TextButton.styleFrom(
    //                 foregroundColor: Colors.black,
    //                 minimumSize: Size(0, 30), // Adjust height here
    //                 side: BorderSide(
    //                   color: Colors.black, // Set your desired border color
    //                   width: 2.0, // Set the border width
    //                 ),
    //               ),
    //               child: const Text(
    //                 'Add Task',
    //                 style: TextStyle(fontSize: 16),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Wrap the entire Column in SingleChildScrollView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? Center(child: Text("No tasks available."))
                    : Column(
                        // Removed Expanded to prevent layout overflow inside scroll view
                        children: List.generate(tasks.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to TaskDescriptionScreen when tapped
                              Get.to(() => TaskDescriptionScreen(
                                    taskId: tasks[index][
                                        "task"]!, // Assuming "task" is a non-null string
                                    deadline: tasks[index][
                                        "deadline"]!, // Assuming "deadline" is a non-null string
                                    task: tasks[index]["task"]!,
                                  ));
                            },
                            child: TaskItem(
                              task: tasks[index]["task"]!,
                              deadline: tasks[index]["deadline"]!,
                            ),
                          );
                        }),
                      ),
            // ListView.builder(
            //   itemCount: tasks.length, // The number of tasks
            //   itemBuilder: (context, index) {
            //     return TextButton(
            //       onPressed: () {
            //         Get.to(() => ManualTaskScreen(
            //           taskId: tasks[index]["task"]!, // Accessing the task using index
            //         ));
            //       },
            //       style: TextButton.styleFrom(
            //         foregroundColor: Colors.black,
            //         minimumSize: Size(0, 30), // Adjust height here
            //         side: BorderSide(
            //           color: Colors.black, // Set your desired border color
            //           width: 2.0, // Set the border width
            //         ),
            //       ),
            //       child: const Text(
            //         'Add Task',
            //         style: TextStyle(fontSize: 16),
            //       ),
            //     );
            //   },
            // )
            Padding(
              padding: const EdgeInsets.only(
                  top: 16.0), // Adjust padding to avoid overflow
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.to(() => ManualTaskScreen());
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      minimumSize: Size(0, 30), // Adjust height here
                      side: BorderSide(
                        color: Colors.black, // Set your desired border color
                        width: 2.0, // Set the border width
                      ),
                    ),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String task;
  final String deadline; // Added deadline field

  const TaskItem({super.key, required this.task, required this.deadline});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 195.0,
            height: 68.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  task.isNotEmpty
                      ? task
                      : "No task available", // Check if task is non-null
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 4.0),
                Text(
                  'Deadline: ${deadline.isNotEmpty ? deadline : "No deadline available"}', // Check if deadline is non-null
                  style: const TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Container(
          //   width: 45.0,
          //   height: 45.0,
          //   decoration: BoxDecoration(
          //     color: Colors.green,
          //     borderRadius: BorderRadius.circular(0.0),
          //     border: Border.all(
          //       color: Colors.black,
          //       width: 2.0,
          //     ),
          //   ),
          // ),
          const SizedBox(width: 8.0),
          Container(
            width: 80.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(0.0),
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Center(
              child: TextButton(
                onPressed: () {
                  // Show the alert dialog when pressed
                  _showDeleteDialog(context);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Adjust font size as needed
                  ),
                ),
              ),
            ),
          ),
//           // Container(
//           //   width: 60.0,
//           //   height: 55.0,
//           //   decoration: BoxDecoration(
//           //     color: Colors.red,
//           //     borderRadius: BorderRadius.circular(0.0),
//           //     border: Border.all(
//           //       color: Colors.black,
//           //       width: 2.0,
//           //     ),
//           //   ),
//           //   child: Center(
//           //     child: Text(
//           //       "Delete", // You can replace this with whatever text you want
//           //       style: TextStyle(
//           //         color: Colors.white,
//           //         fontWeight: FontWeight.bold,
//           //         fontSize: 18.0, // Adjust font size as needed
//           //       ),
//           //     ),
//           //   ),
//           // ),
        ],
      ),
    );
  }
}

// The function to show the confirmation dialog
void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Set background color to white
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // Handle "No" action
              Navigator.of(context).pop();
            },
            child: Text('No'),
            style: TextButton.styleFrom(
                foregroundColor: Colors.black), // Black text color
          ),
          TextButton(
            onPressed: () {
              // Handle "Yes" action
              // You can add the logic to delete the task here
              Navigator.of(context).pop();
              // For example, you might remove the task from the list:
              // tasks.removeAt(index);
              // setState(() {});
            },
            child: Text('Yes'),
            style: TextButton.styleFrom(
                foregroundColor: Colors.black), // Black text color
          ),
        ],
      );
    },
  );
}
