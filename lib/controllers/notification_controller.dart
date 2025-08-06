import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GetStorage _storage = GetStorage();

  var notificationTitle = ''.obs;
  var notificationBody = ''.obs;
  var notificationData = {}.obs;
  var notificationList = <Map<String, dynamic>>[].obs;

  final String _storageKey = 'notifications';

  @override
  void onInit() {
    super.onInit();
    _initFirebaseMessaging();
    _initLocalNotifications();
    _loadStoredNotifications(); // Load previously saved notifications
  }

  void _initFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission();

    String? token = await _firebaseMessaging.getToken();
    print("🔐 FCM Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
      _navigateFromNotification(message.data);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
        _navigateFromNotification(message.data);
      }
    });
  }

  void _initLocalNotifications() {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const initSettings =
        InitializationSettings(android: androidInit, iOS: iosInit);

    _localNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: (payload) {
      // Handle payload if needed
    });
  }

  void _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotificationsPlugin.show(
      0,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      notificationDetails,
      payload: 'payload_data',
    );
  }

  void _handleMessage(RemoteMessage message) {
    String title = message.notification?.title ?? '';
    String body = message.notification?.body ?? '';
    Map<String, dynamic> data = message.data;

    notificationTitle.value = title;
    notificationBody.value = body;
    notificationData.value = data;

    // Save in local notification list
    Map<String, dynamic> newNotification = {
      'title': title,
      'body': body,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };

    notificationList.add(newNotification);
    _storage.write(_storageKey, notificationList);

    print('Notification saved: $newNotification');
  }

  void _navigateFromNotification(Map<String, dynamic> data) {
    if (data['screen'] == 'chat') {
      Get.toNamed('/chatScreen');
    } else if (data['screen'] == 'orders') {
      Get.toNamed('/orderScreen');
    }
  }

  void _loadStoredNotifications() {
    List<dynamic>? stored = _storage.read<List<dynamic>>(_storageKey);
    if (stored != null) {
      notificationList.assignAll(stored.cast<Map<String, dynamic>>());
    }
  }

  void clearNotifications() {
    notificationList.clear();
    _storage.remove(_storageKey);
  }
}
