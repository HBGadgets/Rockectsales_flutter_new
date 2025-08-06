import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/models/admin_attendance_model.dart';
import 'package:rocketsale_rs/service_class/common_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/admin_attendance_controller.dart';

class Attendanceusercard extends StatefulWidget {
  final Data item;

  Attendanceusercard({super.key, required this.item});

  @override
  State<Attendanceusercard> createState() => _AttendanceusercardState();
}

class _AttendanceusercardState extends State<Attendanceusercard> {
  // final AdminAttendanceController controller =

  late bool isLoading;

  final AdminAttendanceController controller =
      Get.put(AdminAttendanceController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  void launchDialer(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.grey,
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        margin: const EdgeInsets.only(top: 7, bottom: 7),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.white70,
            radius: 25,
            child: Icon(
              Icons.person,
              color: Colors.grey,
            ),
          ),
          // foregroundImage:
          //           //     item.profileImgUrl != null && item.profileImgUrl!.isNotEmpty
          //           //         ? NetworkImage(item.profileImgUrl!)
          //           //         : null,
          //           // child: item.profileImgUrl == null || item.profileImgUrl!.isEmpty
          //           //     ? const Icon(Icons.person)
          //           //     : null,
          title: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () =>
                  launchDialer(widget.item.salesmanPhone ?? '9521971737'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.salesmanId?.salesmanName ?? 'Salesman',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 17,
                      ),
                      Text(
                        widget.item.salesmanId?.salesmanPhone ?? '9521971737',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              String status = widget.item.attendanceStatus == "Present"
                  ? "Absent"
                  : "Present";
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  title: const Text('Change attendance status'),
                  content: Text(
                      'Are you sure you want to mark this salesman as $status ?'),
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
                    isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              changeAttendanceStatus(
                                  status, widget.item.sId ?? "Salesman");
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                  ],
                ),
              );
            },
            child: Text(
              widget.item.attendenceStatus?.capitalizeFirst ?? 'Status N/A',
              style: TextStyle(
                color: (widget.item.attendanceStatus == "Present")
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeAttendanceStatus(String status, String salesmanId) async {
    try {
      await ApiServiceCommon.request(
        method: 'PUT',
        endpoint: '/api/attendence/$salesmanId',
        payload: {"attendenceStatus": status},
      );
      print("Marked as $status");
      controller.refreshAttendance();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      print("Failed to update attendance: $e");
    }
  }
}
