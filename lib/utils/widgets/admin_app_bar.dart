import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../resources/my_colors.dart';
import '../../controllers/notification_controller.dart';
import '../../screens/notification_list_Screen.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;
  final IconData menuIcon;
  final notificationController = Get.find<NotificationController>();

  AdminAppBar({
    Key? key,
    required this.title,
    this.onNotificationTap,
    this.onMenuTap,
    this.menuIcon =
        Icons.menu, // 👈 You can change this icon when using AdminAppBar
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) { 
    return AppBar(
      backgroundColor: MyColor.dashbord,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      ),
      leading: IconButton(
        icon: Icon(
          menuIcon,
          color: Colors.white,
        ),
        onPressed: onMenuTap ??
            () {
              Scaffold.of(context).openDrawer(); // fallback
            },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          onPressed:
              onNotificationTap ?? () => Get.to(() => NotificationListScreen()),
        ),
      ],
    );
  }
}
