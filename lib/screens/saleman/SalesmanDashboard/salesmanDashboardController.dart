import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../NativeKTMethodChannel.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/token_manager.dart';

class salesmanDashboardController extends GetxController {
  RxString username = ''.obs;
  RxBool isConnected = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsername();
  }

  Future<void> loadUsername() async {
    String? name = await TokenManager.getUsername();
    if (name != null) {
      username.value = name;
    }
  }

  Future<void> checkSocketConnection() async {
    isLoading.value = true;
    try {
      final result =
          await NativeChannel.platform.invokeMethod("isSocketConnected");
      if (result != null) {
        isConnected.value = true;
        print("location socket connected -- message from flutter");
      } else {
        isConnected.value = false;
      }
      isLoading.value = false;
    } on PlatformException catch (e) {
      print("⚠️ Error checking connection: ${e.message}");
      isConnected.value = false;
      isLoading.value = false;
    }
  }

  void logout() async {
    Get.find<AuthController>().logout();
  }
}
