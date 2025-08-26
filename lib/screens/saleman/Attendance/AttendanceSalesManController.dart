import 'dart:io';

import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/token_manager.dart';
import '../SalesManLocationController.dart';

class AttendanceSalesmanController extends GetxController {
  final salesmanName = ''.obs;
  RxBool gettingLocation = false.obs;
  final addressString = ''.obs;

  var salesManSelfie = Rxn<File?>();
  SalesManLocationController controller = SalesManLocationController();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSalesmanName();
  }

  void getSalesmanName() async {
    String? name = await TokenManager.getUsername();
    salesmanName.value = name ?? '';
  }

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  void getAddress() async {
    gettingLocation.value = true;
    print("getting address.............");
    try {
      final salesManLocation = await controller.determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          salesManLocation.latitude, salesManLocation.longitude);
      Placemark place = placemarks[0];
      addressString.value =
          "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      print(addressString.value);
    } catch (e) {
      gettingLocation.value = false;
      Get.snackbar("Location Error", e.toString());
    } finally {
      gettingLocation.value = false;
    }
  }
}
