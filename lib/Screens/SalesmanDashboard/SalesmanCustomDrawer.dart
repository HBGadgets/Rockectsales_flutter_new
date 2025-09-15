import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../NativeChannel.dart';
import '../../resources/my_colors.dart';
import '../../resources/my_assets.dart';
import '../Login/AuthController.dart';
import '../drawer sales man/invite friend/Invite_Friend_Screen.dart';
import '../drawer sales man/update password/Update_Password_Screen.dart';
import 'DrawerContents/about us/About_Us_Page.dart';
import 'DrawerContents/feedback/Feedback_Screen.dart';
import 'DrawerContents/help support/Help_Support_Screen.dart';
import 'DrawerContents/privacy policy/Privacy_Policy.dart';
import 'DrawerContents/rate/rate_screen.dart';
import 'SalesmanDashboardController.dart';
import 'SalesmanDashboardScreen.dart';
import 'dart:typed_data';

class SalesmanCustomDrawer extends StatelessWidget {
  SalesmanCustomDrawer({super.key});

  final salesmanDashboardController controller = Get.find();
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Obx(() => Text(
                  'Hello, ${authController.username.value}',
                  style: const TextStyle(color: Colors.black),
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
                decoration: const BoxDecoration(color: Colors.white),
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
}