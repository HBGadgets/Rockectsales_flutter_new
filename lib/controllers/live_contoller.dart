import 'dart:async';
import 'dart:io';
import 'dart:io' as IO;
import 'dart:math' as math;

//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:ui' as ui;
import 'dart:typed_data' as typed_data; // Alias for dart:typed_data
// or for other libraries if needed
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shared_preferences/shared_preferences.dart';

class LiveContoller extends GetxController {
  late IO.Socket socket;
  Rx<LatLng?> currentPosition = Rx<LatLng?>(null);
  RxList<LatLng> polylineCoordinates = <LatLng>[].obs;
  RxBool isLoading = true.obs;
  GoogleMapController? mapController;
  RxBool isMapInitialized = false.obs;
  late String deviceId;
  String? authToken;
  Rx<BitmapDescriptor> customIcon = BitmapDescriptor.defaultMarker.obs;
  RxDouble markerRotation = 0.0.obs; //Add rotation state
  // New variable to animate camera rotation
  RxDouble cameraBearing = 0.0.obs;

//  Rx<LiveTrackingData?> liveData = Rx<LiveTrackingData?>(null);

  // LiveTrackingController(this.deviceId);

  @override
  void onInit() {
    super.onInit();

    //  startListeningLocation();
    customMarker();
  }

  // Function to resize marker
  Future<BitmapDescriptor> getResizedMarker(
    String assetPath,
    int targetWidth,
  ) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: targetWidth, // Set desired width
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? bytes =
        await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void customMarker() async {
    getResizedMarker("assets/images/car-top-green.png", 60) // Adjust size here
        .then((icon) {
      customIcon.value = icon; // Use .value to update Rx variable
    });
  }

  /// Update vehicle position and animate smoothly
  Position? currentLocation;
  StreamSubscription? subscription;
  LatLng newPosition = LatLng(0.0, 0.0);

  void updateVehiclePosition(double latitude, double longitude) {
    LatLng newPosition = LatLng(latitude ?? 0.0, longitude ?? 0.0);

    // print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$newPosition');
    if (currentPosition.value == null) {
      currentPosition.value = newPosition;
      polylineCoordinates.add(newPosition);
      double bearing = calculateBearing(currentPosition.value!, newPosition);
      markerRotation.value = 0.0;
      cameraBearing.value = 0.0;
      updateCameraPosition(newPosition, bearing);
    } else {
      double distance = calculateDistance(currentPosition.value!, newPosition);
      if (distance < 1.0) return; // Ignore small movements

      double newBearing = calculateBearing(currentPosition.value!, newPosition);
      smoothMarkerAnimation(
          currentPosition.value!, newPosition, cameraBearing.value, newBearing);
    }
  }

  /// Smoothly animate marker movement
  void smoothMarkerAnimation(LatLng oldPos, LatLng newPos,
      double oldCameraAngle, double newCameraAngle) {
    const int steps = 50;
    final latTween =
        Tween<double>(begin: oldPos.latitude, end: newPos.latitude);
    final lngTween =
        Tween<double>(begin: oldPos.longitude, end: newPos.longitude);

    int stepCount = 0;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      if (stepCount >= steps) {
        timer.cancel();
        currentPosition.value = newPos;
        markerRotation.value = 0.0; // Keep marker straight
        cameraBearing.value = newCameraAngle; // Final camera angle
        updateCameraPosition(newPos, newCameraAngle);
        polylineCoordinates.add(newPos);
      } else {
        double progress = (stepCount + 1) / steps;
        LatLng position =
            LatLng(latTween.lerp(progress), lngTween.lerp(progress));
        currentPosition.value = position;
        markerRotation.value =
            0.0; // Marker remains upright throughout animation

        // Interpolate the camera's rotation smoothly
        double cameraAngle =
            lerpBearing(oldCameraAngle, newCameraAngle, progress);
        cameraBearing.value = cameraAngle;

        polylineCoordinates.add(position);
        updateCameraPosition(position, cameraAngle);
        stepCount++;
      }
    });
  }

  /// Move camera to follow vehicle
  void updateCameraPosition(LatLng position, double bearing) {
    if (mapController == null || !isMapInitialized.value) return;
    final cameraPosition = CameraPosition(
      target: position,
      zoom: 16.5,
      bearing: bearing, // Camera rotates according to the computed bearing
      tilt: 60,
    );
    mapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  /// 📌 Calculate bearing (direction) between two points
  double calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371000;
    double lat1 = start.latitude * math.pi / 180;
    double lon1 = start.longitude * math.pi / 180;
    double lat2 = end.latitude * math.pi / 180;
    double lon2 = end.longitude * math.pi / 180;

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1) *
            math.cos(lat2) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (math.pi / 180.0);
    double lon1 = start.longitude * (math.pi / 180.0);
    double lat2 = end.latitude * (math.pi / 180.0);
    double lon2 = end.longitude * (math.pi / 180.0);

    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  /// Linearly interpolate between two bearings.
  double lerpBearing(double a, double b, double t) {
    double diff = ((b - a + 180) % 360) - 180;
    return (a + diff * t + 360) % 360;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
