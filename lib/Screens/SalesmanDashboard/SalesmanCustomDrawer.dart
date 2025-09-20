import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:rocketsales/Screens/SalesmanDashboard/SalesmanDashboardScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../NativeChannel.dart';
import '../../resources/my_colors.dart';
import '../Login/AuthController.dart';
import 'DrawerContents/about us/About_Us_Page.dart';
import 'DrawerContents/feedback/Feedback_Screen.dart';
import 'DrawerContents/help support/Help_Support_Screen.dart';
import 'DrawerContents/privacy policy/Privacy_Policy.dart';
import 'DrawerContents/update password/Update_Password_Screen.dart';
import 'SalesmanDashboardController.dart';
import 'dart:typed_data';

class SalesmanCustomDrawer extends StatelessWidget {
  SalesmanCustomDrawer({super.key});

  final salesmanDashboardController controller = Get.find();
  final AuthController authController = Get.put(AuthController());

  Future<void> openWebsite(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColor.dashbord, Color.fromRGBO(1, 29, 74, 1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                accountName: Obx(() => Text(
                  'Hello, ${authController.username.value}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                )),
                accountEmail: null,
                currentAccountPicture: Obx(() {
                  Uint8List? profileImage = controller.bytes.value;
                  if (controller.loadingProfile.value) {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(color: MyColor.dashbord),
                    );
                  } else if (profileImage == null) {
                    return const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 30, color: Colors.white),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: MemoryImage(profileImage),
                    );
                  }
                }),
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
                      // ListTile(
                      //   leading: const Icon(Icons.home),
                      //   title: const Text('Home'),
                      //   onTap: () {
                      //     Navigator.pushReplacement(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => DashboardSalesman()),
                      //     );
                      //   },
                      // ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text('About us'),
                        onTap: () {
                          openWebsite('${dotenv.env['ABOUT_US']}');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Privacy'),
                        onTap: () {
                          openWebsite('${dotenv.env['PRIVACY_POLICY']}');
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: const Text('Terms & Conditions'),
                        onTap: () {
                          openWebsite('${dotenv.env['TERMS_CONDITIONS']}');
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
                          Get.to(() => FeedbackScreen());
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
                          child: Obx(() => ElevatedButton.icon(
                            icon: const Icon(
                              Icons.logout,
                              size: 24.0,
                              color: Colors.white,
                            ),
                            label: (controller.isLoading.value ||
                                authController.isLoading.value)
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              minimumSize: const Size(100, 40),
                            ),
                            onPressed: (controller.isLoading.value ||
                                authController.isLoading.value)
                                ? null
                                : () async {
                              controller.isLoading.value = true;
                              final permission = await controller
                                  .checkLocationPermission();
                              if (permission) {
                                final location = await controller
                                    .getCurrentLocation();
                                if (location != null &&
                                    location.latitude != null &&
                                    location.longitude != null) {
                                  await controller
                                      .updateCheckoutTime(
                                    location.latitude!,
                                    location.longitude!,
                                  );
                                  await NativeChannel.stopService();
                                  await controller.logout();
                                  controller.isConnected.value = false;
                                } else {
                                  print("⚠️ Location data is null!");
                                }
                              } else {
                                print(
                                    "⚠️ Location permission denied!");
                              }
                              controller.isLoading.value = false;
                            },
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      onTap: () {
        // TODO: Add navigation logic
      },
    );
  }

  Widget _buildUserHeader() {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MyColor.dashbord, Color.fromRGBO(1, 29, 74, 1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    "Hello,",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Murlidhar",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          );
  }
}