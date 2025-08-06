import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/controllers/attendance_tab_controller.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/admin/attendance/attendance%20screen/AttendanceTabChild.dart';
import 'package:rocketsale_rs/screens/admin/attendance/attendance%20screen/Lagacy_Attendance_Screen.dart';
import 'package:rocketsale_rs/screens/admin/attendance/leave%20application/LeaveApplicationTabChild.dart';
import 'package:rocketsale_rs/screens/admin/attendance/leave%20application/Lagacy_Leave_Application_Screen.dart';
import 'package:rocketsale_rs/screens/admin/attendance/manual%20attendance/ManualAttendanceTabChild.dart';
import 'package:rocketsale_rs/screens/admin/attendance/manual%20attendance/Lagacy_Manual_Attendance_Screen.dart';
import 'package:rocketsale_rs/screens/admin/attendance/visit%20shop/Visit_Shop_Screen.dart';

class AttendanceTabs extends StatefulWidget {
  const AttendanceTabs({super.key});

  @override
  State<AttendanceTabs> createState() => _AttendanceTabsState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _AttendanceTabsState extends State<AttendanceTabs>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: <Widget>[
            Tab(
              child: Text(
                'Attendance',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Manual\nAttendance',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Leave\nApplication',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Visit\nShop',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          const Attendancetabchild(),
          Manualattendancetabchild(),
          Leaveapplicationtabchild(),
          const Center(child: Text("Coming soon...")),
        ],
      ),
    );
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0; // iPhone 8 width
    return baseFontSize * (screenWidth / referenceWidth);
  }
}
