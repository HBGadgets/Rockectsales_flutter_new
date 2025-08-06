import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/task_management_controller.dart';
import '../../screens/admin/dashboard_admin.dart';
import '../../screens/admin/drawer admin/about us/About_Us_Page.dart';
import '../../screens/admin/drawer admin/add friend/Add_Friends.dart';
import '../../screens/admin/drawer admin/feedback/Feedback_Screen.dart';
import '../../screens/admin/drawer admin/help support/Help_Support_Screen.dart';
import '../../screens/admin/drawer admin/privacy policy/Privacy_Policy.dart';
import '../../screens/admin/drawer admin/rate/rate_screen.dart';

import '../../screens/admin/speed_set.dart';
import '../token_manager.dart';

class Admin_Drawer extends StatelessWidget {
  final ImageProvider profile;
  final TaskManagementController controller =
      Get.put(TaskManagementController());

  Admin_Drawer({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              ' ${authController.username.value}',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: profile,
            ),
            decoration: BoxDecoration(color: Colors.white),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () => Get.back(),
                ),
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About Us'),
                  onTap: () {
                    Get.back();
                    Get.to(() => AboutUsPage());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_add_outlined),
                  title: Text('Add friend'),
                  onTap: () {
                    Get.back();
                    Get.to(() => AddFriends());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback_outlined),
                  title: Text('Feedback'),
                  onTap: () {
                    Get.back();
                    Get.to(() => FeedbackScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.star_border),
                  title: Text('Rate the app'),
                  onTap: () {
                    Get.back();
                    Get.to(() => RateScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Privacy Policy'),
                  onTap: () {
                    Get.back();
                    Get.to(() => PrivacyPolicy());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Help & support'),
                  onTap: () {
                    Get.back();
                    Get.to(() => HelpSupportScreen());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help_outline),
                  title: Text('Speed'),
                  onTap: () {
                    Get.back();
                    Get.to(() => SetOverSpeedScreen());
                  },
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, size: 24.0, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  minimumSize: const Size(100, 40),
                ),
                onPressed: () async {
                  await TokenManager.clearAll();
                  Get.offNamed("/login");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
