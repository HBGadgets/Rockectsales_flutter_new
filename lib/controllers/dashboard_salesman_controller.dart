import 'package:get/get.dart';
import '../utils/token_manager.dart';
import 'auth_controller.dart';

class DashboardSalesmanController extends GetxController {
  RxString username = ''.obs;

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

  void handleMenuTap(String routeName) {
    Get.toNamed(routeName);
  }

  void logout() async {
    Get.find<AuthController>().logout();
  }
}
