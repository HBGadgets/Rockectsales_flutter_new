import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/screens/admin/attendance/Attendance_Tabs.dart';
import 'package:rocketsale_rs/screens/admin/report%20manager/Report_Manager.dart';
import 'package:rocketsale_rs/screens/admin/task/task%20management/Task_Management_Screen.dart';
import 'package:rocketsale_rs/screens/admin/user/user%20management/User_Management_Screen.dart';
import '../../../resources/my_colors.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/user_management_controller.dart';
import '../../resources/my_assets.dart';
import '../../utils/widgets/admin_app_bar.dart';
import '../../utils/widgets/admin_custom_drawer.dart';
import '../notification_list_Screen.dart';
import 'attendance/attendance screen/Lagacy_Attendance_Screen.dart';
import 'chat bot/chat 1/ChatBot_Screen.dart';
import 'expence/manage expense/Manage_Expense_Screen.dart';
import 'live user/User_List_Screen.dart';
import 'manage order/manage order screen/Manage_Order_Screen.dart';

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

final UserManagementController userController =
    Get.put(UserManagementController());
final AuthController authController = Get.put(AuthController());
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final notificationController =
    Get.put(NotificationController(), permanent: true);

late Size size;

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AdminAppBar(
        title: 'Dashboard',
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // This opens the drawer
        },
        onNotificationTap: () {
          Get.to(NotificationListScreen());
        },
      ),
      drawer: Admin_Drawer(
        profile: profile,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 40, backgroundImage: profile),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${authController.username.value}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,

                  physics: NeverScrollableScrollPhysics(),
                  // Prevents nested scrolling conflicts
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  padding: EdgeInsets.all(16.0),
                  children: [
                    _buildMenuItem(
                      Image(image: livetracking, width: 50, height: 50),
                      'Live Tracking',
                      onTap: () => Get.to(() => UserListScreen()),
                    ),
                    _buildMenuItem(
                      Image(image: attendance, width: 50, height: 50),
                      'Attendance',
                      onTap: () => Get.to(() => AttendanceTabs()),
                    ),
                    _buildMenuItem(
                      Image(image: usermanagement, width: 50, height: 50),
                      'User Management',
                      onTap: () => Get.to(() => UserManagementScreen()),
                    ),
                    _buildMenuItem(
                      Image(image: task, width: 50, height: 50),
                      'Task Management',
                      onTap: () => Get.to(() => TaskManagementScreen()),
                    ),
                    _buildMenuItem(
                      Image(image: order, width: 50, height: 50),
                      'Manage Order',
                      onTap: () => Get.to(() => ManageOrderScreen()),
                    ),
                    // _buildMenuItem(
                    //   Image(image: chat, width: 50, height: 50),
                    //   'Chat Bot',
                    //   onTap: () => Get.to(() => ChatBotScreen()),
                    // ),
                    _buildMenuItem(
                      Image(image: expenses, width: 50, height: 50),
                      'Expenses',
                      onTap: () async {
                        if (userController.salesmenList.isEmpty) {
                          await userController
                              .fetchSalesmen(); // Make sure this is defined
                        }

                        final selectedId =
                            userController.salesmenList.isNotEmpty
                                ? userController.salesmenList.first.sId ?? ''
                                : '';

                        if (selectedId.isNotEmpty) {
                          Get.to(() =>
                              ManageExpenseScreen(salesmanId: selectedId));
                        } else {
                          Get.snackbar('Error', 'No salesman available');
                        }
                      },
                    ),
                    _buildMenuItem(
                      Image(image: reportmanager, width: 50, height: 50),
                      'Report Manager',
                      onTap: () => Get.to(() => ReportManager()),
                      // onTap: () => Get.to(() => NotificationListScreen()),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    Widget leadingWidget,
    String title, {
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: MyColor.dashbord),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 7,
            ),
          ],
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leadingWidget,
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: size.height * 0.015,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : Colors.black, // Change text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
