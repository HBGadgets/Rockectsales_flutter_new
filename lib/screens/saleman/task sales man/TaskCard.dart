import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../../controllers/task_controller/saleTask_controller.dart';
import '../../../models/task_model/salesTask_model.dart';
import '../../../resources/my_colors.dart';

class Taskcard extends StatefulWidget {
  final Task task;

  Taskcard({super.key, required this.task});

  @override
  State<Taskcard> createState() => _TaskcardState();
}

class _TaskcardState extends State<Taskcard> {
  final TaskController taskController = Get.put(TaskController());

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  late String taskStatus;

  void changeTaskStatus(String status, String taskId, BuildContext context) {
    try {
      taskController.toggleTaskStatus(taskId, status);
      setState(() {
        taskStatus = status;
        print('Marked as ==============>>>>>>>>> $status');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      print("Failed to update task: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskStatus = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    Future<String?> changeStatusDialogue(String status) {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: const Text('Change task status'),
                content: Text(
                    'Are you sure you want to mark this task as $status ?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      changeTaskStatus(status, widget.task.id, context);
                      // setState(() {
                      //   taskStatus = widget.task.status == 'Completed'
                      //       ? 'Pending'
                      //       : 'Completed';
                      // });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Yes',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ));
    }

    return Container(
      // padding: EdgeInsets.all(15),
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(
              Icons.pending_actions,
              size: 35,
              color: Colors.black,
            ),
            title: Text(
              widget.task.taskTitle,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
            ),
          ),
          ExpansionTile(
            leading: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 35,
            ),
            title: Text(
              widget.task.address,
            ),
            shape: const Border(),
            collapsedShape: const Border(),
            children: [
              Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.description_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    title: Text(widget.task.taskDescription),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10, left: 10),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            taskStatus == 'Pending'
                                ? Colors.green
                                : Colors.redAccent),
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        String status =
                            taskStatus == 'Completed' ? 'Pending' : 'Completed';
                        changeStatusDialogue(status);
                        // changeTaskStatus(status, widget.task.id, context);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Icon(taskStatus == 'Pending'
                                ? Icons.check_circle_outline
                                : Icons.block),
                          ),
                          Text(taskStatus == 'Pending'
                              ? 'Mark as Completed'
                              : 'Mark as Pending'),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            // height: 20,
            decoration: BoxDecoration(
              color:
                  taskStatus == "Completed" ? Colors.green : Colors.redAccent,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Center(
              child: Text(
                taskStatus,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
