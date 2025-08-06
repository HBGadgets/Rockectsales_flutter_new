// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../resources/my_colors.dart';
//
// import '../../controllers/attendance_tab_controller.dart';
// import '../../screens/admin/attendance/attendance screen/Lagacy_Attendance_Screen.dart';
// import '../../screens/admin/attendance/leave application/Lagacy_Leave_Application_Screen.dart';
// import '../../screens/admin/attendance/manual attendance/Lagacy_Manual_Attendance_Screen.dart';
// import '../../screens/admin/attendance/visit shop/Visit_Shop_Screen.dart';
//
// class AttendanceTopButtons extends StatelessWidget {
//   AttendanceTopButtons({super.key});
//
//   final AttendanceTabController tabController = Get.find();
//
//   void handleButtonPress(int index) {
//     tabController.changeTab(index);
//
//     switch (index) {
//       case 0:
//         tabController.changeTab(0); // 🟢 Ensure index 0 selected
//         Get.off(() => AttendanceScreen());
//         break;
//       case 1:
//         Get.off(() => ManualAttendanceScreen());
//         break;
//       case 2:
//         Get.off(() => LeaveAttendanceScreen());
//         break;
//       case 3:
//         Get.off(() => VisitShopScreen());
//         break;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Container(
//       color: MyColor.dashbord,
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Obx(() => Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               buildButton(
//                 "Attendance",
//                 0,
//                 size,
//               ),
//               buildButton("Manual\nAttendance", 1, size),
//               buildButton("Leave\nAttendance", 2, size),
//               buildButton("Visit\nShop", 3, size),
//             ],
//           )),
//     );
//   }
//
//   Widget buildButton(String title, int index, Size size) {
//     return TextButton(
//       style: TextButton.styleFrom(
//         backgroundColor: tabController.selectedIndex.value == index
//             ? Colors.white
//             : MyColor.dashbord,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
//       ),
//       onPressed: () => handleButtonPress(index),
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: TextStyle(
//           color: tabController.selectedIndex.value == index
//               ? Colors.black
//               : Colors.white,
//           fontSize: size.height * 0.015,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
// }
