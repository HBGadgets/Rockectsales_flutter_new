// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../controllers/manual_attendance_controller.dart';
// import '../../../../utils/widgets/attendance_custom_app_bar.dart';
//
// class ManualAttendanceScreen extends StatelessWidget {
//   final controller = Get.put(ManualAttendanceController());
//
//   @override
//   Widget build(BuildContext context) {
//     controller.fetchManualAttendanceData();
//
//     return Scaffold(
//       appBar: CustomAppBar(title: 'Manual Attendance'),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return Center(child: CircularProgressIndicator());
//         }
//
//         final list = controller.manualAttendanceModel.value?.absentSalesmen;
//
//         if (list == null || list.isEmpty) {
//           return Center(child: Text('No absent salesmen found.'));
//         }
//
//         return ListView.builder(
//           itemCount: list.length,
//           itemBuilder: (context, index) {
//             final item = list[index];
//             return Card(
//               margin: EdgeInsets.all(12),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16)),
//               elevation: 4,
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Profile Image
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(
//                           ''), // replace with image URL or AssetImage
//                     ),
//                     SizedBox(width: 12),
//
//                     // Main Content Column
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Name & Edit Icon Row
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   item.salesmanName ?? 'N/A',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                               Icon(Icons.edit, color: Colors.blue, size: 18),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//
//                           // Phone Number
//                           Row(
//                             children: [
//                               Icon(Icons.phone, size: 16),
//                               SizedBox(width: 6),
//                               Text(item.salesmanPhone ?? ''),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//
//                           // Date Row
//                           Row(
//                             children: [
//                               Icon(Icons.calendar_today, size: 16),
//                               SizedBox(width: 6),
//                               Text("12/07/2024"),
//                               // You can format the date dynamically
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Present/Absent Buttons
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.postAttendance(
//                               salesmanId: item.sId ?? '',
//                               attendenceStatus: 'Present',
//                               companyId: item.companyId?.sId ?? '',
//                               branchId: item.branchId?.sId ?? '',
//                               supervisorId: item.supervisorId?.sId ?? '',
//                             );
//                             controller.manualAttendanceModel();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.green.shade100,
//                             foregroundColor: Colors.black,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 4),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text("Present"),
//                         ),
//                         SizedBox(height: 8),
//                         ElevatedButton(
//                           onPressed: () {
//                             controller.postAttendance(
//                               salesmanId: item.sId ?? '',
//                               attendenceStatus: 'Absent',
//                               companyId: item.companyId?.sId ?? '',
//                               branchId: item.branchId?.sId ?? '',
//                               supervisorId: item.supervisorId?.sId ?? '',
//                             );
//                             controller.manualAttendanceModel();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.red.shade100,
//                             foregroundColor: Colors.black,
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 4),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           child: Text("Absent"),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
