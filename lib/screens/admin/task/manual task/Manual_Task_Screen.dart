import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../task management/Task_Management_Screen.dart'; // For address to lat/lng conversion

class ManualTaskScreen extends StatefulWidget {
  const ManualTaskScreen({super.key});

  @override
  State<ManualTaskScreen> createState() => _ManualTaskScreenState();
}

class _ManualTaskScreenState extends State<ManualTaskScreen> {
  String? selectedGender;

  // Controllers for each TextField
  final TextEditingController taskDescription = TextEditingController();
  final TextEditingController salesmanController = TextEditingController();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();

  // GlobalKey for form validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    taskDescription.dispose();
    salesmanController.dispose();
    taskNameController.dispose();
    addressController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  Future<void> _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      // If form is not valid, exit early
      return;
    }

    // Get the values from the TextEditingControllers
    final id = taskDescription.text;
    final salesmanName = salesmanController.text;
    final taskName = taskNameController.text;
    final address = addressController.text;
    final deadline = deadlineController.text;

    // Prepare the request data
    final Map<String, String> taskData = {
      'id': id,
      'salesmanName': salesmanName,
      'taskName': taskName,
      'address': address,
      'deadline': deadline,
      'gender': selectedGender ?? '',
    };

    // Use a Bearer token for authentication
    final String? token =
        await getToken(); // Fetch the Bearer token asynchronously

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No token found, please log in again.'),
      ));
      return;
    }

    try {
      // Prepare the request body
      final response = await http.post(
        Uri.parse('${dotenv.env['BASE_URL']}/api/api/task'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          // Include Bearer token in the header
        },
        body: json.encode(taskData),
      );

      // Handle response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Task assigned successfully!'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to assign task. Please try again.'),
        ));
      }
    } catch (e) {
      // Handle error in case of an exception (e.g., no internet)
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // expandedHeight: 150.0, // Set your preferred height
            floating: false,
            pinned: true, // Keeps the AppBar visible when scrolling up
            flexibleSpace: FlexibleSpaceBar(
              // title: Text('Manual Task'),
              background: Container(
                color:
                    Colors.grey.shade50, // Set your preferred background color
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Get.back(); // Go back to the previous screen using GetX
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  // Wrap the Column inside SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Manual Task",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10), // Adjust spacing as needed
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(label: Text('Field')),
                                DataColumn(label: Text('Input')),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(Text('Task Description ')),
                                  DataCell(
                                    TextFormField(
                                      controller: taskDescription,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Task Description ',
                                        hintStyle: TextStyle(fontSize: 12),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade400,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(fontSize: 15),
                                      cursorColor: Colors.black,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter an ID';
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Salesman Name')),
                                  DataCell(
                                    TextFormField(
                                      controller: salesmanController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Salesman Name',
                                        hintStyle: TextStyle(fontSize: 12),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            width: 1.0,
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade400,
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(fontSize: 15),
                                      cursorColor: Colors.black,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Salesman Name';
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Task Name')),
                                  DataCell(
                                    TextFormField(
                                      controller: taskNameController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Task Name',
                                        hintStyle: TextStyle(fontSize: 12),
                                        // Smaller hint text size
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        // Padding for better layout
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            // Light grey color for the bottom border
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            // Slightly darker grey when focused
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            // Error color for the bottom border
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade400,
                                            // Darker error border color
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(fontSize: 15),
                                      // Set the text size to be small
                                      cursorColor: Colors.black,
                                      // Change the cursor color to black
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Task Name';
                                        }
                                        return null;
                                      },
                                    ),
                                  )
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Address')),
                                  DataCell(
                                    TextFormField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Address',
                                        hintStyle: TextStyle(fontSize: 12),
                                        // Smaller hint text size
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        // Padding for better layout
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            // Light grey color for the bottom border
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey.shade400,
                                            // Slightly darker grey when focused
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade300,
                                            // Error color for the bottom border
                                            width: 1.0,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red.shade400,
                                            // Darker error border color
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(fontSize: 15),
                                      // Set the text size to be small
                                      cursorColor: Colors.black,
                                      // Change the cursor color to black
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Address';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Deadline')),
                                  DataCell(
                                    TextFormField(
                                      controller: deadlineController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Deadline',
                                        hintStyle: TextStyle(fontSize: 13),
                                        // Smaller hint text size
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 12),
                                        // Padding for better layout
                                        border: InputBorder
                                            .none, // Removes all borders (including bottom)
                                      ),
                                      style: TextStyle(fontSize: 12),
                                      // Set the text size to be small
                                      cursorColor: Colors.black,
                                      // Change the cursor color to black
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Deadline';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ]),
                              ],
                            ),
                            const SizedBox(height: 15.0),
                            Center(
                              child: ElevatedButton(
                                onPressed: () {
                                  // Navigate to TaskManagementScreen using GetX
                                  Get.to(() => TaskManagementScreen());
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.green,
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 9.0, vertical: 2.0),
                                  textStyle: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                    side: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 12),
                                  child: Text(
                                    'Assign Task',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
// class _ManualTaskScreenState extends State<ManualTaskScreen> {
//   List<Task> tasks = [];
//   bool isLoading = true;
//
//   @override
//   // void initState() {
//   //   super.initState();
//   //   fetchTasks();
//   // }
//
//   // Fetch tasks from the API
//   // Future<void> fetchTasks() async {
//   //   try {
//   //     final response = await http.get(Uri.parse('https://yourapi.com/tasks')); // Replace with your API URL
//   //
//   //     if (response.statusCode == 200) {
//   //       // Check if the response is actually JSON
//   //       try {
//   //         final List<dynamic> data = json.decode(response.body);
//   //         setState(() {
//   //           tasks = data.map((json) => Task.fromJson(json)).toList();
//   //           isLoading = false;
//   //         });
//   //       } catch (e) {
//   //         // If JSON decoding fails, log the error
//   //         print("Failed to decode JSON: $e");
//   //         setState(() {
//   //           isLoading = false;
//   //         });
//   //       }
//   //     } else {
//   //       // Handle other HTTP errors (non-200 status code)
//   //       print("Failed to load tasks. Status code: ${response.statusCode}");
//   //       setState(() {
//   //         isLoading = false;
//   //       });
//   //     }
//   //   } catch (e) {
//   //     // Handle network or other errors
//   //     print("An error occurred: $e");
//   //     setState(() {
//   //       isLoading = false;
//   //     });
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.grey.shade50,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Get.back(); // Go back to the previous screen using GetX
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Manual Task",
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               if (isLoading)
//                 const Center(child: CircularProgressIndicator())
//               else
//                 DataTable(
//                   columns: const [
//                     DataColumn(label: Text('')),
//                     DataColumn(label: Text('')),
//                   ],
//                   rows: [
//                     DataRow(cells: [
//                       DataCell(Text('id')),
//                       DataCell(Text(tasks.isNotEmpty ? tasks[0].id : '')),
//                     ]),
//                     DataRow(cells: [
//                       DataCell(Text('Salesman Name')),
//                       DataCell(Text(tasks.isNotEmpty ? tasks[0].salesmanName : '')),
//                     ]),
//                     DataRow(cells: [
//                       DataCell(Text('Task Name')),
//                       DataCell(Text(tasks.isNotEmpty ? tasks[0].taskName : '')),
//                     ]),
//                     DataRow(cells: [
//                       DataCell(Text('Location')),
//                       DataCell(Text(tasks.isNotEmpty ? tasks[0].location : '')),
//                     ]),
//                     DataRow(cells: [
//                       DataCell(Text('Deadline')),
//                       DataCell(Text(tasks.isNotEmpty ? tasks[0].deadline : '')),
//                     ]),
//                   ],
//                 ),
//               const SizedBox(height: 10.0),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Define your button's onPressed action here
//                   },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.green,
//                     backgroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
//                     textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.0),
//                       side: BorderSide(
//                         color: Colors.grey.shade300,
//                         width: 1.0,
//                       ),
//                     ),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
//                     child: Text(
//                       'Assign Task',
//                       style: TextStyle(
//                         fontSize: 19,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildTextFormField({required String label, bool obscureText = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(label),
//           ),
//           Expanded(
//             child: TextFormField(
//               obscureText: obscureText,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Task {
//   final String id;
//   final String salesmanName;
//   final String taskName;
//   final String location;
//   final String deadline;
//
//   Task({
//     required this.id,
//     required this.salesmanName,
//     required this.taskName,
//     required this.location,
//     required this.deadline,
//   });
//
//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       id: json['id'],
//       salesmanName: json['salesmanName'],
//       taskName: json['taskName'],
//       location: json['location'],
//       deadline: json['deadline'],
//     );
//   }
// }

// old code according to provider
// // body: Padding(
// //     padding: const EdgeInsets.all(16.0),
// //     child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Text(
// //             "Manual Task",
// //             style: TextStyle(
// //               fontSize: 25,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //
// //
// //           const SizedBox(height: 10),
// //           DataTable(
// //             columns: const [
// //               DataColumn(label: Text('')),
// //               DataColumn(label: Text('')),
// //             ],
// //             rows: [
// //               const DataRow(cells: [
// //                 DataCell(Text('id')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //               const DataRow(cells: [
// //                 DataCell(Text('Salesman Name')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //               const DataRow(cells: [
// //                 DataCell(Text('Task Name')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //               DataRow(cells: [
// //                 const DataCell(Text('Gender')),
// //                 DataCell(
// //                   DropdownButton<String>(
// //                     hint: const Text('Select'),
// //                     value: selectedGender,
// //                     items: <String>['Male', 'Female', 'Other']
// //                         .map<DropdownMenuItem<String>>((String value) {
// //                       return DropdownMenuItem<String>(
// //                         value: value,
// //                         child: Text(value),
// //                       );
// //                     }).toList(),
// //                     onChanged: (String? newValue) {
// //                       setState(() {
// //                         selectedGender = newValue;
// //                       });
// //                     },
// //                   ),
// //                 ),
// //               ]),
// //               const DataRow(cells: [
// //                 DataCell(Text('Location')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //               const DataRow(cells: [
// //                 DataCell(Text('completion Date')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //               const DataRow(cells: [
// //                 DataCell(Text('Deadline')),
// //                 DataCell(TextField()), // Added TextField for input
// //               ]),
// //
// //             ],
// //           ),
// //           // DataTable(
// //           //   columns: const [
// //           //     DataColumn(label: Text('')),
// //           //     DataColumn(label: Text('')),
// //           //   ],
// //           //   rows: const [
// //           //     DataRow(cells: [DataCell(Text('Id')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Employee Name')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Task Name')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Role')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Gender')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Location')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Completion Date')), DataCell(Text(''))]),
// //           //     DataRow(cells: [DataCell(Text('Deadline')), DataCell(Text(''))]),
// //           //   ],
// //           // ),
// //           const SizedBox(height: 10.0),
// //           Center(
// //             child: ElevatedButton(
// //               onPressed: () {
// //                 // Define your button's onPressed action here
// //               },
// //               style: ElevatedButton.styleFrom(
// //                 foregroundColor: Colors.green, // Text color
// //                 backgroundColor: Colors.white, // Button background color
// //                 padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0), // Button padding
// //                 textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text style
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(16.0),
// //                   side: BorderSide(
// //                     color: Colors.grey.shade300, // Border color
// //                     width: 1.0, // Border width
// //                   ),// Adjust radius for rounded corners
// //                 ),
// //               ),
// //               child: const Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
// //                 child: Text(
// //                   'Assign Task',
// //                   style: TextStyle(
// //                     fontSize: 19,
// //                     fontWeight: FontWeight.w500,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           )
// //
// //         ]
// //     )
// // )
