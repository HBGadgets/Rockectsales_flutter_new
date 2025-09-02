import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/screens/saleman/Analytics/AnalyticsScreen.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/AttendanceSalesmanScreen.dart';
import 'package:rocketsale_rs/screens/saleman/LeaveApplication/LeaveApplication.dart';
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
import 'Attendance/New Attendance/AttendanceScreen.dart';
import 'Expense/ExpensesHistoryScreen.dart';
import 'Orders/OrdersHistoryScreen.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Qrtabs()));
        },
        backgroundColor: MyColor.dashbord,
        foregroundColor: Colors.white,
        child: Icon(
          Icons.qr_code_scanner,
          size: 30,
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
      body: Stack(
        children: [
          /// Top Gradient Header
          Container(
            child: Image(image: dashBoardImage),
          ),
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(10, 42, 139, 1),
                  // MyColor.dashbord,
                  Color.fromRGBO(0, 0, 0, 0.27)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          /// Main Content
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),

                /// Profile + Welcome
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "https://via.placeholder.com/150", // replace with real image
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${authController.username.value}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none,
                            color: Colors.white, size: 30),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Check In / Out Buttons
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Check in"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.dashbord,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text("Check Out"),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// Grid Menu
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.count(
                      childAspectRatio: 1.1,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _buildMenuCard(
                            Icons.location_on_outlined,
                            "Live Tracking",
                            LiveTrackingscreen(
                                salesmanName: authController.username.value)),
                        _buildMenuCard(
                            Icons.calendar_today,
                            "Attendance",
                            AttendanceScreen(
                                name: authController.username.value)),
                        _buildMenuCard(Icons.shopping_cart_outlined, "Order",
                            OrdersHistoryScreen()),
                        _buildMenuCard(Icons.chat_bubble_outline,
                            "Chat Support", ChatScreen()),
                        _buildMenuCard(
                            Icons.checklist, "Task", TaskManagementSalesMan()),
                        _buildMenuCard(Icons.currency_rupee, "Expenses",
                            ExpensesHistoryScreen()),
                        _buildMenuCard(Icons.exit_to_app, "Leave Application",
                            LeaveApplicationHistory()),
                        _buildMenuCard(Icons.analytics_outlined, "Analytics",
                            AnalyticsScreen()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // body: Container(
      //   height: size.height,
      //   width: size.width,
      //   decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         MyColor.dashbordgrediant, // Start color
      //         MyColor.dashbordgrediant2,
      //         MyColor.dashbordgrediant2,
      //         MyColor.dashbordgrediant2,
      //         MyColor.dashbordgrediant, // End color
      //       ],
      //       // stops: [0.0, 0.5, 1.0],
      //     ),
      //   ),
      //   child: SingleChildScrollView(
      //     child: Padding(
      //       padding: const EdgeInsets.all(16.0),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(16.0),
      //             child: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      // CircleAvatar(radius: 40, backgroundImage: profile),
      //                 SizedBox(width: 16),
      //                 Expanded(
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Welcome!',
      //                         style: TextStyle(
      //                           fontSize: 18,
      //                           fontWeight: FontWeight.w500,
      //                         ),
      //                       ),
      //                       Text(
      //                         'Hello, ${authController.username.value}',
      //                         maxLines: 3,
      //                         style: TextStyle(
      //                           fontSize: 22,
      //                           fontWeight: FontWeight.bold,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           SizedBox(height: 16),
      //           GridView.count(
      //             shrinkWrap: true,
      //
      //             physics: NeverScrollableScrollPhysics(),
      //             // Prevents nested scrolling conflicts
      //             crossAxisCount: 2,
      //             crossAxisSpacing: 16,
      //             mainAxisSpacing: 16,
      //             padding: EdgeInsets.all(16.0),
      //             children: [
      //               _buildMenuItem(
      //                 Image(image: livetracking, width: 50, height: 50),
      //                 'Live Tracking',
      //                 onTap: () {
      //                   Get.to(
      //                     () => LiveTrackingscreen(
      //                       salesmanName: authController.username.value,
      //                     ),
      //                   );
      //                 },
      //               ),
      //               _buildMenuItem(
      //                 Image(image: attendance, width: 50, height: 50),
      //                 "Attendance",
      //                 onTap: () {
      //                   Get.to(() => AttendanceScreen(
      //                         name: authController.username.value,
      //                       ));
      //                 },
      //               ),
      //               _buildMenuItem(
      //                 Image(image: order, width: 50, height: 50),
      //                 "Order",
      //                 onTap: () {
      //                   Get.to(() => OrdersHistoryScreen());
      //                 },
      //               ),
      //               _buildMenuItem(
      //                 Image(image: chat, width: 50, height: 50),
      //                 "Chat",
      //                 onTap: () {
      //                   Get.to(() => ChatScreen());
      //                 },
      //               ),
      //               _buildMenuItem(
      //                 Image(image: task, width: 50, height: 50),
      //                 "Task",
      //                 onTap: () {
      //                   Get.to(() => TaskManagementSalesMan());
      //                 },
      //               ),
      //               _buildMenuItem(
      //                 Image(image: expenses, width: 50, height: 50),
      //                 "Expenses",
      //                 onTap: () {
      //                   Get.to(() => ExpensesHistoryScreen());
      //                 },
      //               ),
      //               // _buildMenuItem(
      //               //   Image(image: qrscan, width: 70, height: 70),
      //               //   "QR Scan",
      //               //   onTap: () {
      //               //     Get.to(() => QrscanScreen());
      //               //   },
      //               // ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
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
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(
            color: Colors.black12, // border color
            width: 2, // border thickness
          ),
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

  Widget _buildMenuCard(IconData icon, String title, Widget path) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(path);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: Colors.black12, // border color
              width: 2, // border thickness
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    icon,
                    // color: Colors.blue[800],
                    color: MyColor.dashbord,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
