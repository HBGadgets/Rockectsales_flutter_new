import 'package:audioplayers/audioplayers.dart';
import 'package:face_camera/face_camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/auth/login_page.dart';
import 'package:rocketsale_rs/screens/admin/dashboard_admin.dart';
import 'package:rocketsale_rs/screens/auth/splash_screen.dart';
import 'package:rocketsale_rs/screens/saleman/dashboard_salesman.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/LiveController.dart';
import 'controllers/alertController.dart';
import 'controllers/attendance_tab_controller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/dashboard_salesman_controller.dart';
import 'controllers/notification_controller.dart';
import 'controllers/permission.dart';
import 'controllers/saleman_attendance_controller.dart';
import 'controllers/user_list_controller.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/*void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    playAlertSound();
    showLockScreenNotification();
    return Future.value(true);
  });
}*/

void playAlertSound() async {
  final player = AudioPlayer();
  await player.play(AssetSource('overSpeed.mp3'));
}

Future<void> showLockScreenNotification() async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'alert_channel', 'Overspeed Alerts',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true, // Ensures it wakes up the screen
    ongoing: true,
  );

  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    '⚠ Over Speed Alert!',
    'You are overspeeding! Reduce your speed immediately!',
    details,
  );
}

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  Get.put(AuthController());
  Get.put(DashboardSalesmanController());
  Get.put(LiveController());
  Get.put(AlertController());
  Get.put(UserListController());
  Get.put(AttendanceTabController());
  await Firebase.initializeApp();
  await GetStorage.init();
  Get.put(AttendanceController());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Get.put(NotificationController(), permanent: true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await requestAllPermissions();
  String? token = prefs.getString('token');
  int? role = prefs.getInt('role');
  String initialRoute = '/';
  if (token != null && token.isNotEmpty) {
    if (role == 4) {
      initialRoute = '/admin';
    } else if (role == 5) {
      initialRoute = '/salesman';
    }
  }
  await FaceCamera.initialize();
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rocket Sales',
      theme: ThemeData(
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'NataSans-Bold', // 👈 change font here
                    fontSize: 16,
                  ),
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'NataSans-Regular', // 👈 for TextButton
                    fontSize: 14,
                  ),
                ),
              ),
              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'NataSans-Regular', // 👈 for OutlinedButton
                    fontSize: 14,
                  ),
                ),
              ),
              textTheme: const TextTheme(
                titleMedium: TextStyle(fontFamily: 'NataSans-Bold'),
                titleLarge: TextStyle(fontFamily: 'NataSans-Bold'),
                bodyLarge: TextStyle(fontFamily: 'NataSans-Bold'),
                bodyMedium: TextStyle(fontFamily: 'NataSans-Regular'),
                bodySmall: TextStyle(fontFamily: 'NataSans-Regular'),
              ),
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              primarySwatch: Colors.blue)
          .copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      getPages: [
        GetPage(name: '/', page: () => splash_screen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/admin', page: () => DashboardAdmin()),
        GetPage(name: '/salesman', page: () => DashboardSalesman()),
      ],
    );
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final storage = GetStorage();
  List<dynamic> oldNotifications =
      storage.read<List<dynamic>>('notifications') ?? [];

  Map<String, dynamic> newNotification = {
    'title': message.notification?.title ?? '',
    'body': message.notification?.body ?? '',
    'data': message.data,
    'timestamp': DateTime.now().toIso8601String(),
  };

  oldNotifications.add(newNotification);
  storage.write('notifications', oldNotifications);
  print("📦 Notification saved in background: $newNotification");
}
