import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/screens/saleman/SalesmanDashboard/salesmanDashboardController.dart';
import '../../controllers/alertController.dart';
import '../../controllers/saleman_attendance_controller.dart';
import '../../controllers/dashboard_salesman_controller.dart';
import '../../resources/my_colors.dart';
import '../../resources/my_assets.dart';
import '../../screens/admin/drawer admin/about us/About_Us_Page.dart';
import '../../screens/admin/drawer admin/feedback/Feedback_Screen.dart';
import '../../screens/admin/drawer admin/help support/Help_Support_Screen.dart';
import '../../screens/admin/drawer admin/privacy policy/Privacy_Policy.dart';
import '../../screens/admin/drawer admin/rate/rate_screen.dart';
import '../../screens/saleman/SalesmanDashboard/dashboard_salesman.dart';
import '../../screens/saleman/drawer sales man/invite friend/Invite_Friend_Screen.dart';
import '../../screens/saleman/drawer sales man/update password/Update_Password_Screen.dart';

class SalesmanCustomDrawer extends StatelessWidget {
  SalesmanCustomDrawer({super.key});

  final salesmanDashboardController dashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Obx(() => Text(
                  'Hello, ${authController.username.value}',
                  style: const TextStyle(color: Colors.black),
                )),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: profile,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(55.0),
                  bottomRight: Radius.circular(55.0),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      // Navigate to Home screen
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About us'),
                    onTap: () {
                      Get.back(); // Equivalent to Navigator.pop(context)
                      Get.to(() => AboutUsPage());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline),
                    title: const Text('Privacy'),
                    onTap: () {
                      Get.back(); // Equivalent to Navigator.pop(context)
                      Get.to(() => const PrivacyPolicy());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.password_outlined),
                    title: const Text('Change Password'),
                    onTap: () {
                      Get.to(() => const UpdatePasswordScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.feedback_outlined),
                    title: const Text('Feedback'),
                    onTap: () {
                      Get.back(); // Equivalent to Navigator.pop(context)
                      Get.to(() => const FeedbackScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.star_border),
                    title: const Text('Rate us'),
                    onTap: () {
                      Get.back(); // Equivalent to Navigator.pop(context)
                      Get.to(() => const RateScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add_outlined),
                    title: const Text('Add Friends'),
                    onTap: () {
                      Get.to(() => const InviteFriendScreen());
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help'),
                    onTap: () {
                      Get.back();
                      Get.to(() => const HelpSupportScreen());
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.logout,
                          size: 24.0, // Adjust the icon size as needed
                          color:
                              Colors.white, // Adjust the icon color as needed
                        ),
                        label: const Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            // Adjust the text color as needed
                            fontSize: 16.0, // Adjust the text size as needed
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16.0,
                            ), // Rounded corners (you can adjust this value to make it more or less rounded)
                          ),
                          minimumSize: const Size(
                            100,
                            40,
                          ), // Adjust width (100) and height (40) as needed
                        ),
                        onPressed: () async {
                          dashboardController.logout();
                          Get.find<AttendanceController>().updateCheckoutTime();
                          Get.find<AttendanceController>()
                              .stopListeningLocation();
                          Get.find<AlertController>().stopAlertManually();
                          Get.find<AlertController>().stopBeepSound();
                          // Get.find<AttendanceController>()
                          //     .alertController
                          //     .stopBeepSound();
                          Get.find<AttendanceController>()
                              .subscription
                              ?.cancel();
                          Get.find<AttendanceController>().subscription = null;
                          Get.find<AttendanceController>().isDisabled.value =
                              false;
                        },

                        // onPressed: () async {
                        //   printFormattedDate();
                        //   String? decodedUsername = await decodeToken();
                        //
                        //   if (decodedUsername != null) {
                        //     await logoutUser(decodedUsername);
                        //     Get.offNamed('/login');
                        //     await tokenController.delete(key: 'token');
                        //     await roleController.delete(key: 'role');
                        //     // locationController.stopListeningLocation();
                        //     // locationSocketController.disposeSocket();
                        //     // attendanceController.dispose();
                        //   } else {
                        //     Get.snackbar(
                        //       "Error",
                        //       "Username not found. Cannot logout.",
                        //     );
                        //   }
                        //
                        //   setState(() {});
                        // },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: MyColor.dashbord),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
