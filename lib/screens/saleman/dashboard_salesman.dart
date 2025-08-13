import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRScan.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRTabs.dart';
import 'package:rocketsale_rs/screens/saleman/task%20sales%20man/Task_Management_Sales_Man.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/dashboard_salesman_controller.dart';
import '../../resources/my_assets.dart';
import '../../resources/my_colors.dart';
import '../../utils/notification_service_FCM_Token.dart';
import '../../utils/token_manager.dart';
import '../../utils/widgets/admin_app_bar.dart';

import '../../utils/widgets/salesman_custom_drawer.dart';
import '../notification_list_Screen.dart';
import 'Attendance/Attendance_Page.dart';
import 'Expense/ExpensesScreen.dart';
import 'Orders/order/all_orders.dart';
import 'chat/chat_screen_sales_man.dart';
import 'live trackings/Live_Tracking_Screen.dart';

class DashboardSalesman extends StatefulWidget {
  const DashboardSalesman({super.key});

  @override
  State<DashboardSalesman> createState() => _DashboardSalesmanState();
}

final AuthController authController = Get.put(AuthController());
final DashboardSalesmanController dashboardController =
    Get.put(DashboardSalesmanController());
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

late Size size;
RxString username = ''.obs;

Future<void> loadUsername() async {
  String? name = await TokenManager.getUsername();
  if (name != null) {
    username.value = name;
  }
}

class _DashboardSalesmanState extends State<DashboardSalesman> {
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.large(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Qrtabs()));
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.qr_code,
          size: 45,
        ),
      ),
      appBar: AdminAppBar(
        title: 'Dashboard',
        onMenuTap: () {
          _scaffoldKey.currentState?.openDrawer(); // This opens the drawer
        },
        onNotificationTap: () {
          Get.to(NotificationListScreen());
        },
      ),
      drawer: SalesmanCustomDrawer(),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              MyColor.dashbordgrediant, // Start color
              MyColor.dashbordgrediant2,
              MyColor.dashbordgrediant2,
              MyColor.dashbordgrediant2,
              MyColor.dashbordgrediant, // End color
            ],
            // stops: [0.0, 0.5, 1.0],
          ),
        ),
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
                            'Hello, ${authController.username.value}',
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
                      onTap: () {
                        Get.to(
                          () => LiveTrackingscreen(),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Image(image: attendance, width: 50, height: 50),
                      "Attendance",
                      onTap: () {
                        Get.to(() => AttendancePage());
                      },
                    ),
                    _buildMenuItem(
                      Image(image: order, width: 50, height: 50),
                      "Order",
                      onTap: () {
                        Get.to(() => AllOrders());
                      },
                    ),
                    _buildMenuItem(
                      Image(image: chat, width: 50, height: 50),
                      "Chat",
                      onTap: () {
                        Get.to(() => ChatPage());
                      },
                    ),
                    _buildMenuItem(
                      Image(image: task, width: 50, height: 50),
                      "Task",
                      onTap: () {
                        Get.to(() => TaskManagementSalesMan());
                      },
                    ),
                    _buildMenuItem(
                      Image(image: expenses, width: 50, height: 50),
                      "Expenses",
                      onTap: () {
                        Get.to(() => Expensesscreen());
                      },
                    ),
                    // _buildMenuItem(
                    //   Image(image: qrscan, width: 70, height: 70),
                    //   "QR Scan",
                    //   onTap: () {
                    //     Get.to(() => QrscanScreen());
                    //   },
                    // ),
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
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 4,
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
                  fontSize: 14,
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
