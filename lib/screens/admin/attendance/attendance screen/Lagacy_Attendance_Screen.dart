// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../../../../controllers/admin_attendance_controller.dart';
// import '../../../../controllers/attendance_tab_controller.dart';
// import '../../../../resources/my_colors.dart';
// import '../../../../utils/widgets/attendance_custom_app_bar.dart';
// import '../../../../utils/widgets/attendance_widget.dart';
// import '../Attendance_Tabs.dart';
//
// class AttendanceScreen extends StatefulWidget {
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }
//
// class _AttendanceScreenState extends State<AttendanceScreen> {
//   final AdminAttendanceController controller =
//       Get.put(AdminAttendanceController());
//   DateTime? fromDate;
//   DateTime? toDate;
//
//   Future<void> _selectFromDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: fromDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         fromDate = picked;
//       });
//     }
//   }
//
//   Future<void> _selectToDate(BuildContext context) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: toDate ?? DateTime.now(),
//       firstDate: fromDate ?? DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         toDate = picked;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     final tabController = Get.find<AttendanceTabController>();
//     tabController
//         .changeTab(0); // Force tab highlight to Attendance on screen open
//   }
//
//   bool isPressed = false;
//   bool isPressed1 = false;
//   bool isPressed2 = false;
//   bool isPressed3 = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Column(
//       children: [
//         // SizedBox(height: size.width * 0.02),
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//           child: Obx(() => DropdownButtonFormField<String>(
//                 value: controller.filterOptions.any((opt) =>
//                         opt['value'] == controller.selectedFilter.value)
//                     ? controller.selectedFilter.value
//                     : 'thisMonth',
//                 items: controller.filterOptions.map((option) {
//                   return DropdownMenuItem<String>(
//                     value: option['value'] ?? '',
//                     child: Text(option['label'] ?? ''),
//                   );
//                 }).toList(),
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'Filter Attendance',
//                 ),
//                 onChanged: (value) {
//                   if (value != null) {
//                     controller.updateFilter(value);
//                     if (value != 'custom') {
//                       setState(() {
//                         fromDate = null;
//                         toDate = null;
//                       });
//                     }
//                   }
//                 },
//               )),
//         ),
//         Obx(() {
//           if (controller.selectedFilter.value == 'custom') {
//             return Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () => _selectFromDate(context),
//                           icon: const Icon(Icons.date_range),
//                           label: Text(fromDate != null
//                               ? DateFormat('yyyy-MM-dd').format(fromDate!)
//                               : 'From Date'),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           onPressed: () => _selectToDate(context),
//                           icon: const Icon(Icons.date_range),
//                           label: Text(toDate != null
//                               ? DateFormat('yyyy-MM-dd').format(toDate!)
//                               : 'To Date'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: () {
//                         if (fromDate != null && toDate != null) {
//                           // controller.getAttendanceByCustomDate(
//                           //   DateFormat('yyyy-MM-dd').format(fromDate!),
//                           //   DateFormat('yyyy-MM-dd').format(toDate!),
//                           // );
//                         } else {
//                           Get.snackbar(
//                               'Error', 'Please select both From and To dates');
//                         }
//                       },
//                       icon: const Icon(Icons.search),
//                       label: const Text("Apply Date Filter"),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const SizedBox.shrink();
//           }
//         }),
//         Expanded(
//           child: Obx(() {
//             if (controller.isLoading.value) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (controller.attendanceList.isEmpty) {
//               return const Center(child: Text("No attendance data found."));
//             } else {
//               return ListView.builder(
//                 itemCount: controller.attendanceList.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.attendanceList[index];
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         radius: 25,
//                         foregroundImage: item.profileImgUrl != null &&
//                                 item.profileImgUrl!.isNotEmpty
//                             ? NetworkImage(item.profileImgUrl!)
//                             : null,
//                         child: item.profileImgUrl == null ||
//                                 item.profileImgUrl!.isEmpty
//                             ? const Icon(Icons.person)
//                             : null,
//                       ),
//                       title: Row(
//                         children: [
//                           Column(
//                             children: [
//                               Text(item.salesmanId?.salesmanName ?? 'Salesman'),
//                             ],
//                           ),
//                         ],
//                       ),
//                       trailing: Text(item.attendenceStatus?.capitalizeFirst ??
//                           'Status N/A'),
//                     ),
//                   );
//                 },
//               );
//             }
//           }),
//         ),
//       ],
//     );
//
//     // return Scaffold(
//     //   // appBar: CustomAppBar(
//     //   //   title: 'Attendance',
//     //   // ),
//     //   appBar: AppBar(
//     //     leading: const BackButton(
//     //       color: Colors.white, // Change your color here
//     //     ),
//     //     title: const Text('Attendance', style: TextStyle(color: Colors.white)),
//     //     backgroundColor: MyColor.dashbord,
//     //   ),
//     //   body: Column(
//     //     children: [
//     //       AttendanceTabs(),
//     //       SizedBox(height: size.width * 0.02),
//     //       Padding(
//     //         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
//     //         child: Obx(() => DropdownButtonFormField<String>(
//     //               value: controller.filterOptions.any((opt) =>
//     //                       opt['value'] == controller.selectedFilter.value)
//     //                   ? controller.selectedFilter.value
//     //                   : 'thisMonth',
//     //               items: controller.filterOptions.map((option) {
//     //                 return DropdownMenuItem<String>(
//     //                   value: option['value'] ?? '',
//     //                   child: Text(option['label'] ?? ''),
//     //                 );
//     //               }).toList(),
//     //               decoration: const InputDecoration(
//     //                 border: OutlineInputBorder(),
//     //                 labelText: 'Filter Attendance',
//     //               ),
//     //               onChanged: (value) {
//     //                 if (value != null) {
//     //                   controller.updateFilter(value);
//     //                   if (value != 'custom') {
//     //                     setState(() {
//     //                       fromDate = null;
//     //                       toDate = null;
//     //                     });
//     //                   }
//     //                 }
//     //               },
//     //             )),
//     //       ),
//     //       Obx(() {
//     //         if (controller.selectedFilter.value == 'custom') {
//     //           return Column(
//     //             children: [
//     //               Padding(
//     //                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     //                 child: Row(
//     //                   children: [
//     //                     Expanded(
//     //                       child: OutlinedButton.icon(
//     //                         onPressed: () => _selectFromDate(context),
//     //                         icon: const Icon(Icons.date_range),
//     //                         label: Text(fromDate != null
//     //                             ? DateFormat('yyyy-MM-dd').format(fromDate!)
//     //                             : 'From Date'),
//     //                       ),
//     //                     ),
//     //                     const SizedBox(width: 10),
//     //                     Expanded(
//     //                       child: OutlinedButton.icon(
//     //                         onPressed: () => _selectToDate(context),
//     //                         icon: const Icon(Icons.date_range),
//     //                         label: Text(toDate != null
//     //                             ? DateFormat('yyyy-MM-dd').format(toDate!)
//     //                             : 'To Date'),
//     //                       ),
//     //                     ),
//     //                   ],
//     //                 ),
//     //               ),
//     //               Padding(
//     //                 padding:
//     //                     const EdgeInsets.only(top: 8.0, left: 16, right: 16),
//     //                 child: SizedBox(
//     //                   width: double.infinity,
//     //                   child: ElevatedButton.icon(
//     //                     onPressed: () {
//     //                       if (fromDate != null && toDate != null) {
//     //                         controller.getAttendanceByCustomDate(
//     //                           DateFormat('yyyy-MM-dd').format(fromDate!),
//     //                           DateFormat('yyyy-MM-dd').format(toDate!),
//     //                         );
//     //                       } else {
//     //                         Get.snackbar('Error',
//     //                             'Please select both From and To dates');
//     //                       }
//     //                     },
//     //                     icon: const Icon(Icons.search),
//     //                     label: const Text("Apply Date Filter"),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ],
//     //           );
//     //         } else {
//     //           return const SizedBox.shrink();
//     //         }
//     //       }),
//     //       Expanded(
//     //         child: Obx(() {
//     //           if (controller.isLoading.value) {
//     //             return const Center(child: CircularProgressIndicator());
//     //           } else if (controller.attendanceList.isEmpty) {
//     //             return const Center(child: Text("No attendance data found."));
//     //           } else {
//     //             return ListView.builder(
//     //               itemCount: controller.attendanceList.length,
//     //               itemBuilder: (context, index) {
//     //                 final item = controller.attendanceList[index];
//     //                 return Card(
//     //                   margin: const EdgeInsets.symmetric(
//     //                       horizontal: 12, vertical: 6),
//     //                   child: ListTile(
//     //                     leading: CircleAvatar(
//     //                       radius: 25,
//     //                       foregroundImage: item.profileImgUrl != null &&
//     //                               item.profileImgUrl!.isNotEmpty
//     //                           ? NetworkImage(item.profileImgUrl!)
//     //                           : null,
//     //                       child: item.profileImgUrl == null ||
//     //                               item.profileImgUrl!.isEmpty
//     //                           ? const Icon(Icons.person)
//     //                           : null,
//     //                     ),
//     //                     title: Row(
//     //                       children: [
//     //                         Column(
//     //                           children: [
//     //                             Text(item.salesmanId?.salesmanName ??
//     //                                 'Salesman'),
//     //                           ],
//     //                         ),
//     //                       ],
//     //                     ),
//     //                     trailing: Text(item.attendenceStatus?.capitalizeFirst ??
//     //                         'Status N/A'),
//     //                   ),
//     //                 );
//     //               },
//     //             );
//     //           }
//     //         }),
//     //       ),
//     //     ],
//     //   ),
//     // );
//   }
// }
