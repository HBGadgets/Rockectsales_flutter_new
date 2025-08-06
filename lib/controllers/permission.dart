import 'package:permission_handler/permission_handler.dart';

Future<void> requestAllPermissions() async {
  await [
    Permission.location,
    Permission.camera,
    Permission.storage,
    // Permission.microphone,
    Permission.notification,
  ].request();

  // Optional: Check status after request
  if (await Permission.location.isDenied) {
    print("❌ Location permission denied");
  }
  if (await Permission.camera.isDenied) {
    print("❌ Camera permission denied");
  }
}
