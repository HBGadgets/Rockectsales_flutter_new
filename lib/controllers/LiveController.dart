import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveController extends GetxController {
  var currentPosition = LatLng(0.0, 0.0).obs; // Default position
  GoogleMapController? mapController;
  var isMapInitialized = false.obs;

  void updatePosition(LatLng newPosition) {
    currentPosition.value = newPosition;
    if (isMapInitialized.value) {
      mapController?.animateCamera(CameraUpdate.newLatLng(newPosition));
    }
  }
}
