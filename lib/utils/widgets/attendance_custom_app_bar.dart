// import 'package:flutter/material.dart';
// import '../../../../resources/my_colors.dart';
// import 'attendance_widget.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool centerTitle;
//   final Color backgroundColor;
//
//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.centerTitle = true,
//     this.backgroundColor = MyColor.dashbord,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       titleTextStyle: TextStyle(color: Colors.white),
//       title: const Text(
//         'Attendance',
//         style: TextStyle(
//           // fontWeight: FontWeight.w600,
//           fontSize: 20
//         ),
//       ),
//       leading: const BackButton(
//           color: Colors.white, // Change your color here
//         ),
//       centerTitle: centerTitle,
//       backgroundColor: backgroundColor,
//       bottom: PreferredSize(
//         preferredSize: const Size.fromHeight(0),
//         // child: Padding(
//         //   padding: const EdgeInsets.only(bottom: 8.0),
//         //   child: AttendanceTopButtons(),
//         // ),
//         child: AttendanceTopButtons(),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(130); // Adjust total height
// }
