import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/admin/task/task%20management/taskAdd.dart';
import '../../../../controllers/task_controller/saleTask_controller.dart';
import '../../../../controllers/task_management_controller.dart';
import '../../../../models/get_task_model.dart';
import '../../../../resources/my_assets.dart';
import 'Edit_task.dart';

class TaskDetailsPage extends StatefulWidget {
  final List<Get_Task_Model> taskList;
  final String? salesmanId;

  TaskDetailsPage({super.key, required this.taskList, this.salesmanId});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  final TaskController taskController = Get.put(TaskController());
  final TaskManagementController taskController1 =
      Get.put(TaskManagementController());

  String formatDeadline(String? deadline) {
    if (deadline == null) return 'N/A';

    try {
      DateTime dt = DateTime.parse(deadline);
      return DateFormat('hh:mm a, MMM dd, yyyy').format(dt);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('All Tasks', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.taskList.length,
        itemBuilder: (context, index) {
          final task = widget.taskList[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description: ${task.taskDescription ?? 'N/A'}"),
                  const SizedBox(height: 6),
                  Text("Status: ${task.status ?? 'N/A'}"),
                  const SizedBox(height: 6),
                  Text("Deadline: ${formatDeadline(task.deadline)}"),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Get.to(() => EditingTask(
                                salesmanId: widget.salesmanId!,
                                existingTask: task,
                              ));
                        },
                        child: const Text("Update"),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final isCurrentlyCompleted =
                              task.status == 'Completed';

                          // await taskController.toggleTaskStatus(
                          //   task.sId ?? '',
                          //   isCurrentlyCompleted,
                          // );

                          setState(() {
                            task.status =
                                isCurrentlyCompleted ? 'Pending' : 'Completed';
                          });

                          Get.back(); // Close screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: task.status == 'Completed'
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          foregroundColor: task.status == 'Completed'
                              ? Colors.green.shade800
                              : Colors.grey.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                        ),
                        child: Text(
                          task.status == 'Completed' ? 'Completed' : 'Pending',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final shouldDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Task'),
                              content: const Text(
                                  'Are you sure you want to delete this task?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (shouldDelete == true) {
                            final isDeleted = await taskController1
                                .deleteTask(task.sId ?? '');

                            if (isDeleted) {
                              setState(() {
                                widget.taskList.removeAt(index);
                              });
                            }
                            // else do nothing
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 150,
        height: 56,
        child: FloatingActionButton.extended(
          onPressed: () {
            // Add debug print

            Get.to(
              () => AddTaskPage(salesmanId: widget.salesmanId!),
            );
          },
          backgroundColor: Colors.black,
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          label: const Text(
            "Add Task",
            style: TextStyle(
              color: Colors.white,
            ),
          ), // Optional, remove if only icon needed
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
