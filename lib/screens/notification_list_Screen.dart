import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller.dart';
import '../utils/widgets/admin_app_bar.dart';

class NotificationListScreen extends StatelessWidget {
  final NotificationController notificationController =
      Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        title: 'Notification',
        menuIcon: Icons.arrow_back,
        onMenuTap: () {
          Get.back(); // This opens the drawer
        },
      ),
      body: Obx(() {
        final notifications = notificationController.notificationList;
        if (notifications.isEmpty) {
          return Center(child: Text("No notifications available"));
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return ListTile(
              leading: Icon(Icons.notifications, color: Colors.blueAccent),
              title: Text(item['title'] ?? ''),
              subtitle: Text(item['body'] ?? ''),
              trailing: Text(
                item['timestamp']?.toString().split('T').first ?? '',
                style: TextStyle(fontSize: 12),
              ),
            );
          },
        );
      }),
    );
  }
}
