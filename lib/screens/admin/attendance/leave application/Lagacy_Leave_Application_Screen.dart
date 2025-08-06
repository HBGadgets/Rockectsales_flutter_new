// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../../controllers/leave_attendance_controller.dart';
// import '../../../../utils/widgets/attendance_custom_app_bar.dart';
//
// class LeaveAttendanceScreen extends StatelessWidget {
//   final controller = Get.put(LeaveAttendanceController());
//
//   final TextEditingController fromDateController = TextEditingController();
//   final TextEditingController toDateController = TextEditingController();
//
//   final Rx<DateTime?> startDate = Rx<DateTime?>(null);
//   final Rx<DateTime?> endDate = Rx<DateTime?>(null);
//
//   final dateFormat = DateFormat('yyyy-MM-dd');
//
//   Future<void> _pickStartDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: startDate.value ?? DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       startDate.value = picked;
//     }
//   }
//
//   Future<void> _pickEndDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: endDate.value ?? DateTime.now(),
//       firstDate: DateTime(2023),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null) {
//       endDate.value = picked;
//     }
//   }
//
//   void _applyFilter() {
//     if (startDate.value != null && endDate.value != null) {
//       // Convert to ISO format
//       final start = startDate.value!.toUtc().toIso8601String();
//       final end = endDate.value!.toUtc().toIso8601String();
//       controller.fetchLeaveRequests(startDate: start, endDate: end);
//     } else {
//       Get.snackbar("Select Dates", "Please select both Start and End dates");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Leave Attendance'),
//       body: Column(
//         children: [
//           // Date filter section
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Obx(() => Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Start Date
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _pickStartDate(context),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             startDate.value != null
//                                 ? "From: ${dateFormat.format(startDate.value!)}"
//                                 : "Select From Date",
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     // End Date
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _pickEndDate(context),
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 10),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             endDate.value != null
//                                 ? "To: ${dateFormat.format(endDate.value!)}"
//                                 : "Select To Date",
//                             style: TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 5),
//                     ElevatedButton(
//                       onPressed: _applyFilter,
//                       child: Text("Apply"),
//                     ),
//                   ],
//                 )),
//           ),
//
//           // Leave List Section
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (controller.leaveList.isEmpty) {
//                 return Center(child: Text("No leave data found"));
//               } else {
//                 return ListView.builder(
//                   itemCount: controller.leaveList.length,
//                   itemBuilder: (context, index) {
//                     final leave = controller.leaveList[index];
//                     return Card(
//                       margin: EdgeInsets.all(8),
//                       elevation: 3,
//                       child: Padding(
//                         padding: const EdgeInsets.all(10.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               leave.salesmanId?.salesmanName ?? 'N/A',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(height: 6),
//                             Text("Reason: ${leave.reason}"),
//                             Text("Status: ${leave.leaveRequestStatus}"),
//                             Text("From: ${leave.createdAt}"),
//                             Text("To: ${leave.updatedAt}"),
//                             SizedBox(height: 10),
//
//                             // Buttons Row
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     controller.updateLeaveRequestStatus(
//                                       leaveId: leave.sId ?? 'N/A',
//                                       newStatus: "Approved",
//                                     );
//                                     print(leave.sId);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.green,
//                                   ),
//                                   child: Text("Approve"),
//                                 ),
//                                 SizedBox(width: 10),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     controller.updateLeaveRequestStatus(
//                                       leaveId: leave.sId ?? "",
//                                       newStatus: "Pending",
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.orange,
//                                   ),
//                                   child: Text("Pending"),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               }
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }
