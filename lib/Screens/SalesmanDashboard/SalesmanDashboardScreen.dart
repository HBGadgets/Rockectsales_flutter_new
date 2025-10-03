import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rocketsales/Screens/SalesmanDashboard/ImagePreviewScreen.dart';
import '../../../resources/my_assets.dart';
import '../../../resources/my_colors.dart';
import '../../NativeChannel.dart';
import '../Analytics/AnalyticsScreen.dart';
import '../Attendance/AttendanceScreen.dart';
import '../Attendance/NewAttendanceController.dart';
import '../Expense/ExpensesHistoryScreen.dart';
import '../LeaveApplication/LeaveApplication.dart';
import '../Login/AuthController.dart';
import '../Orders/OrdersHistoryScreen.dart';
import '../QRScan/QRTabs.dart';
import '../chat/chat_screen_sales_man.dart';
import '../live trackings/Live_Tracking_Screen.dart';
import '../task sales man/Task_Management_Sales_Man.dart';
import 'SalesmanCustomDrawer.dart';
import 'SalesmanDashboardController.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardSalesman extends StatelessWidget {
  DashboardSalesman({super.key});


  final AuthController authController = Get.put(AuthController());
  final salesmanDashboardController controller = Get.put(salesmanDashboardController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Size size;


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (controller.isConnected.value) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Qrtabs()));
            } else {
              showDialogBox(context);
            }
          },
          backgroundColor: MyColor.dashbord,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.qr_code_scanner,
            size: 30,
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          title: const Text(
            "Rocketsales",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: MyColor.dashbord,
        ),
        drawer: SalesmanCustomDrawer(),
        body: Obx(() {
          return Stack(
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
                      // Color.fromRGBO(10, 42, 139, 1),
                      MyColor.dashbord,
                      Color.fromRGBO(0, 0, 0, 0.27)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(() {
                            Uint8List? profileImage = controller.bytes.value;
                            if (controller.loadingProfile.value) {
                              return const CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 40,
                                child: CircularProgressIndicator(color: MyColor.dashbord),
                              );
                            } else if (profileImage == null || controller.bytes.value == null) {
                              return GestureDetector(
                                onTap: controller.postImage,
                                child: Stack(
                                  children: [const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 40,
                                    child: Icon(Icons.person, size: 30, color: Colors.white), // default avatar
                                  ),Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue, // background for the plus icon
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),]
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ImagePreviewScreen(imageFile: profileImage));
                                },
                                child: Stack(
                                  children: [CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 40,
                                    backgroundImage: MemoryImage(profileImage),
                                  ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue, // background for the plus icon
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.add,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              );
                            }
                          }),
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
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: controller.isConnected.value
                                  ? null // Disable if already connected
                                  : () {
                                controller.isLoading.value = true;
                                controller
                                    .checkLocationPermission()
                                    .then((permission) {
                                  if (permission) {
                                    Permission.notification
                                        .request();
                                    NativeChannel.startService()
                                        .then((_) {
                                      controller.isConnected.value = true;
                                    });
                                  }
                                });
                                controller.isLoading.value = false;
                              },
                              child: const Text("Check in"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: controller.isConnected.value
                                  ? () async {
                                controller.isLoading.value = true;
                                final permission = await controller
                                    .checkLocationPermission();
                                if (permission) {
                                  final location = await controller
                                      .getCurrentLocation();
                                  if (location != null &&
                                      location.latitude != null &&
                                      location.longitude != null) {
                                    await controller.updateCheckoutTime(
                                      location.latitude!,
                                      location.longitude!,
                                    );
                                    await NativeChannel.stopService();
                                    controller.isConnected.value = false;
                                  } else {
                                    print("⚠️ Location data is null!");
                                    controller.isLoading.value = false;
                                  }
                                } else {
                                  print("⚠️ Location permission denied!");
                                  controller.isLoading.value = false;
                                }
                                controller.isLoading.value = false;
                              }
                                  : null,
                              child: const Text("Check Out"),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 5),

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
                                    salesmanName:
                                    authController.username.value),
                                context),
                            _buildMenuCard(
                                Icons.calendar_today,
                                "Attendance",
                                AttendanceScreen(),
                                context),
                            _buildMenuCard(Icons.shopping_cart_outlined,
                                "Order", OrdersHistoryScreen(), context),
                            _buildMenuCard(Icons.chat_bubble_outline,
                                "Chat Support", ChatScreen(), context),
                            _buildMenuCard(Icons.checklist, "Task",
                                TaskManagementSalesMan(), context),
                            _buildMenuCard(Icons.currency_rupee, "Expenses",
                                ExpensesHistoryScreen(), context),
                            _buildMenuCard(
                                Icons.exit_to_app,
                                "Leave Application",
                                LeaveApplicationScreen(),
                                context),
                            _buildMenuCard(Icons.analytics_outlined,
                                "Analytics", AnalyticsScreen(), context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.isLoading.value)
                Positioned.fill(
                  child: Container(
                    color: Color.fromRGBO(0, 0, 0, 0.35),
                    child: const Center(
                      child: CircularProgressIndicator(color: MyColor.dashbord),
                    ),
                  ),
                ),
            ],
          );
        }));
  }

  Widget _buildMenuCard(
      IconData icon, String title, Widget path, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (controller.isConnected.value) {
            Get.to(path);
          } else {
            showDialogBox(context);
          }
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

  void showDialogBox(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "You have to check in first!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Okay"),
                    style: FilledButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: MyColor.dashbord),
                  )
                ],
              )),
        );
      },
    );
  }
}
