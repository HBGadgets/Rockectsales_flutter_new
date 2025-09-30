import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../TokenManager.dart';
import 'TaskModel.dart';
import 'saleTask_controller.dart';
import '../../../resources/my_colors.dart';

class Taskcard extends StatefulWidget {
  final Task task;

  Taskcard({super.key, required this.task});

  @override
  State<Taskcard> createState() => _TaskcardState();
}

class _TaskcardState extends State<Taskcard> {
  final TaskController controller = Get.find<TaskController>();

  final ExpansibleController expansionController = ExpansibleController();
  bool _isExpanded = false;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  late String taskStatus;

  bool _isLoading = false;

  Future<void> openMap(double lat, double lng) async {
    Uri uri;

    if (Platform.isAndroid) {
      // Android → use geo: scheme
      uri = Uri.parse("geo:$lat,$lng?q=$lat,$lng");
    } else if (Platform.isIOS) {
      // iOS → use Apple Maps if available
      uri = Uri.parse("http://maps.apple.com/?ll=$lat,$lng");
    } else {
      // Fallback → open Google Maps web
      uri = Uri.parse(
          "https://www.google.com/maps/search/?api=1&query=$lat,$lng");
    }

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Could not open map.";
    }
  }

  void changeTaskStatus(
      String status, String taskId, BuildContext buildContext) {
    try {
      toggleTaskStatus(taskId, status, buildContext);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      print("Failed to update task: $e");
    }
  }

  void showSnackbar(String message) {
    Get.snackbar('Message', message);
  }

  Future<void> toggleTaskStatus(
      String taskId, String newStatus, BuildContext buildContext) async {
    setState(() {
      _isLoading = true;
    });
    final url = '${dotenv.env['BASE_URL']}/api/api/task/status/$taskId';

    final id = await TokenManager.getSupervisorId(); // Get user ID from token
    if (id == null) {
      showSnackbar("User ID not found from token");
      return;
    }
    final token = await TokenManager.getToken(); // Get the full token

    if (token == null) {
      showSnackbar("Auth token not found");
      return;
    }
    try {
      final response = await GetConnect().put(
        url,
        {
          'status': newStatus,
          'userId': id,
        },
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      // Debug: Print response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          taskStatus = newStatus;
        });
        Navigator.of(buildContext).pop();
        Navigator.of(buildContext).pop();

        showSnackbar("Task marked as $newStatus");
      } else {
        showSnackbar("Failed to update status: ${response.statusText}");
      }
    } catch (e) {
      print("Error updating status: $e");
      showSnackbar("Error updating status: $e");
    }
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> changeStatusDialogue(String status) {
    return showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: const Text('Change task status'),
              content:
                  Text('Are you sure you want to mark this task as $status ?'),
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
                _isLoading
                    ? const CircularProgressIndicator(
                        color: MyColor.dashbord,
                      )
                    : TextButton(
                        onPressed: () async {
                          showLoading();
                          changeTaskStatus(status, widget.task.id, context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
              ],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskStatus = widget.task.status;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expansionController.isExpanded) {
            expansionController.collapse();
          } else {
            expansionController.expand();
          }
        },
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Text(widget.task.taskDescription,
              maxLines: _isExpanded ? 20 : 1,
              softWrap: _isExpanded ? true : false,
              overflow: TextOverflow.fade),
          subtitle: _isExpanded
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 👈 add this
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: MyColor.dashbord,
                              size: 20,
                            ),
                            Text(
                              "Address:",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.task.address,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              : Row(
                  children: [
                    const Icon(
                      Icons.watch_later_outlined,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                        controller
                            .formattedDate(widget.task.deadline.toString())),
                  ],
                ),
          trailing: taskStatus == "Completed"
              ? Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        224, 247, 210, 1), // background color
                    border: Border.all(
                      color: Colors.green, // border color
                      width: 1, // border thickness
                    ),
                    borderRadius:
                        BorderRadius.circular(6), // optional: rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 1, left: 8, right: 8, bottom: 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: Color.fromRGBO(37, 87, 9, 1),
                          size: 12,
                        ),
                        Text(
                          taskStatus,
                          style: const TextStyle(
                              color: Color.fromRGBO(37, 87, 9, 1)),
                        ),
                      ],
                    ),
                  ))
              : Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(
                        247, 210, 210, 1), // background color
                    border: Border.all(
                      color: Colors.red, // border color
                      width: 1, // border thickness
                    ),
                    borderRadius:
                        BorderRadius.circular(6), // optional: rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 1, left: 8, right: 8, bottom: 1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.pending_actions,
                          color: Colors.red,
                          size: 12,
                        ),
                        Text(
                          taskStatus,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  )),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 👈 add this
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warehouse_outlined,
                              color: MyColor.dashbord,
                              size: 20,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Shop Name:",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.task.shopGeofence?.shopName ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 👈 add this
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(bottom: 2.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.watch_later_outlined,
                              color: MyColor.dashbord,
                              size: 20,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "Deadline:",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        formatDate(widget.task.deadline),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15),
                  child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColor.dashbord,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                      ),
                      onPressed: () {
                        openMap(widget.task.shopGeofence!.latitude,
                            widget.task.shopGeofence!.longitude);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map,
                            color: Colors.white,
                          ),
                          SizedBox(width: 2),
                          Text(
                            "Set destination",
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 8),
                  child: OutlinedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: taskStatus == "Completed"
                              ? Colors.red
                              : Colors.green,
                          width: 1.5, // thickness of border
                        ),
                        backgroundColor: taskStatus == "Completed"
                            ? const Color.fromRGBO(247, 210, 210, 1)
                            : const Color.fromRGBO(224, 247, 210, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Adjust radius as needed
                        ),
                      ),
                      onPressed: () {
                        changeStatusDialogue(taskStatus == "Completed"
                            ? "Pending"
                            : "Completed");
                      },
                      child: taskStatus == "Completed"
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.pending_actions,
                                  color: Colors.red,
                                ),
                                Text(
                                  "Mark as Pending",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 15,
                                  color: Color.fromRGBO(37, 87, 9, 1),
                                ),
                                Text(
                                  "Mark as complete",
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Color.fromRGBO(37, 87, 9, 1),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
