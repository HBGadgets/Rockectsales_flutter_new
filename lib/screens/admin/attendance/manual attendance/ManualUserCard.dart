import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/controllers/manual_attendance_controller.dart';
import 'package:rocketsale_rs/models/admin_attendance_model.dart';
import 'package:rocketsale_rs/models/manual_attendance_model.dart';
import 'package:rocketsale_rs/service_class/common_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import '../../../../controllers/admin_attendance_controller.dart';

class Manualusercard extends StatefulWidget {
  final AbsentSalesmen item;

  Manualusercard({super.key, required this.item});

  @override
  State<Manualusercard> createState() => _ManualusercardState();
}

class _ManualusercardState extends State<Manualusercard> {
  // final AdminAttendanceController controller =

  late bool isLoading;

  // final AdminAttendanceController controller =
  //     Get.put(AdminAttendanceController());
  final ManualAttendanceController controller =
      Get.put(ManualAttendanceController());

  final AdminAttendanceController controllerAdminAttendance =
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

  void changeAttendanceStatus(String status, String salesmanId) async {
    try {
      controller.postAttendance(
          salesmanId: widget.item.sId ?? '',
          attendenceStatus: status,
          companyId: widget.item.companyId?.sId ?? '',
          branchId: widget.item.branchId?.sId ?? '',
          supervisorId: widget.item.supervisorId?.sId ?? '');
      print("Marked as $status");
      controller.fetchManualAttendanceData();
      controllerAdminAttendance.refreshAttendance();
      // controller.refreshAttendance();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('There was an error!'),
      ));
      print("Failed to update attendance: $e");
    }
  }

  Future<String?> showDialogueBox(String status) {
    return showDialog<String>(
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    String salesmanId = widget.item.sId ?? '';
    return Card.outlined(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      shadowColor: Colors.grey,
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            const CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 25,
              child: Icon(Icons.person, color: Colors.grey),
            ),
            const SizedBox(width: 12),

            // Name and Phone
            Expanded(
              child: GestureDetector(
                onTap: () =>
                    launchDialer(widget.item.salesmanPhone ?? '9521971737'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.salesmanName ?? 'Salesman',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          size: 17,
                        ),
                        Text(
                          widget.item.salesmanPhone ?? '9521971737',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Present & Absent Buttons
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    showDialogueBox('Present');
                  },
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(196, 255, 212, 0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Text('Present'),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showDialogueBox('Absent'),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 200, 178, 0.62),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Padding(
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 20, right: 20),
                      child: Text('Absent'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    // return Card.outlined(
    //     // color: const Color.fromRGBO(229, 229, 229, 0.8),
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10), // Optional rounded corners
    //     ),
    //     shadowColor: Colors.grey,
    //     elevation: 1,
    //     color: Colors.white,
    //     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    //     child: Container(
    //       // margin: const EdgeInsets.only(top: 7, bottom: 7),
    //       child: ListTile(
    //           leading: const CircleAvatar(
    //             backgroundColor: Colors.white70,
    //             radius: 25,
    //             child: Icon(
    //               Icons.person,
    //               color: Colors.grey,
    //             ),
    //             // foregroundImage:
    //             //     item.profileImgUrl != null && item.profileImgUrl!.isNotEmpty
    //             //         ? NetworkImage(item.profileImgUrl!)
    //             //         : null,
    //             // child: item.profileImgUrl == null || item.profileImgUrl!.isEmpty
    //             //     ? const Icon(Icons.person)
    //             //     : null,
    //           ),
    //           title: Align(
    //             alignment: Alignment.centerLeft,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Text(
    //                   widget.item.salesmanName ?? 'Salesman',
    //                   // No need for textAlign here
    //                 ),
    //                 Text(
    //                   widget.item.salesmanPhone ?? '9521971737',
    //                 ),
    //               ],
    //             ),
    //           ),
    //           trailing: SizedBox(
    //             width: 85,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 GestureDetector(
    //                   // onTap: () => changeAttendanceStatus(
    //                   //     "Present", widget.item.sId ?? ''),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: Color.fromRGBO(196, 255, 212, 0.8),
    //                       borderRadius:
    //                           BorderRadius.circular(5), // 👈 Increased radius
    //                     ),
    //                     child: Center(
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(5.0),
    //                         child: Text('Present'),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 GestureDetector(
    //                   // onTap: () => changeAttendanceStatus(
    //                   //     "Absent", widget.item.sId ?? ''),
    //                   child: Container(
    //                     decoration: BoxDecoration(
    //                       color: Color.fromRGBO(255, 200, 178, 0.62),
    //                       borderRadius:
    //                           BorderRadius.circular(5), // 👈 Increased radius
    //                     ),
    //                     child: Center(
    //                       child: Padding(
    //                         padding: const EdgeInsets.all(5.0),
    //                         child: Text('Absent'),
    //                       ),
    //                     ),
    //                   ),
    //                 )
    //
    //                 // ElevatedButton(
    //                 //     onPressed: () =>
    //                 //         {changeAttendanceStatus('Present', salesmanId)},
    //                 //     child: Text('Present')),
    //                 // ElevatedButton(
    //                 //     onPressed: () =>
    //                 //         {changeAttendanceStatus('Absent', salesmanId)},
    //                 //     child: Text('Absent'))
    //               ],
    //             ),
    //           )),
    //     ));
  }
}

// TextButton(
// onPressed: () {
// String status = widget.item.attendanceStatus == "Present"
// ? "Absent"
//     : "Present";
// showDialog<String>(
// context: context,
// builder: (BuildContext context) => AlertDialog(
// // Set the shape property to RoundedRectangleBorder
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(
// 10.0), // Adjust the radius as needed
// ),
// title: const Text('Change attendance status'),
// content: Text(
// 'Are you sure you want to mark this salesman as $status ?'),
// actions: <Widget>[
// TextButton(
// onPressed: () {
// Navigator.of(context).pop();
// },
// child: const Text('No'),
// ),
// isLoading
// ? CircularProgressIndicator()
//     : TextButton(
// onPressed: () async {
// changeAttendanceStatus(status);
// Navigator.of(context).pop();
// },
// child: Text('Yes'),
// ),
// ],
// ));
// },
// child: Text(
// widget.item.attendenceStatus?.capitalizeFirst ?? 'Status N/A',
// style: TextStyle(
// color: (widget.item.attendanceStatus == "Present")
// ? Colors.green
//     : Colors.red,
// ),
// ))
// // Text(item.attendenceStatus?.capitalizeFirst ?? 'Status N/A'),
// ),
