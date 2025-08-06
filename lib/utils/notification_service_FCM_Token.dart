import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    // Request permission (iOS-specific)
    NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notification permission granted");
    }

    // Get the token
    String? fcmToken = await _messaging.getToken();
    print("🔑 FCM Token: $fcmToken");

    // You can store this token using SharedPreferences or send it to your server
  }
}
