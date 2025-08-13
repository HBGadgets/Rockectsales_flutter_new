import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import '../../../../utils/token_manager.dart';
import 'dart:math' as math;

class LiveTrackingController extends GetxController {
  late IO.Socket socket;
  final String username;

  LiveTrackingController(this.username);

  GoogleMapController? mapController;

  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs;
  final List<LatLng> polylineCoordinates = [];
  var currentPosition = Rxn<LatLng>();

  final String socketUrl = '${dotenv.env['BASE_URL']}/api';
  final String googleApiKey =
      ''; 

  @override
  void onInit() {
    super.onInit();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    final token = await TokenManager.getToken();
    if (token != null) {
      _initSocket(token);
    } else {
      print('❌ Token is null. Cannot connect to socket.');
    }
  }

  void _initSocket(String token) {
    socket = IO.io(socketUrl, {
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.onConnect((_) {
      print('✅ Connected to tracking server');
      socket.emit('authenticate', token);
      socket.emit('requestSalesmanTracking', username);
      print('📡 Request sent for: $username');
    });
    socket.connect();

    socket.on('salesmanTrackingData', (data) async {
      if (data != null && data['username'] == username) {
        print('📡 Received Tracking Data: $data');
        print('✅ Processing Data for: ${data['username']}');
        print('Latitude: ${data['latitude']}, Longitude: ${data['longitude']}');
        double lat = data['latitude'].toDouble();
        double lng = data['longitude'].toDouble();
        LatLng newPos = LatLng(lat, lng);

        currentPosition.value = newPos;
        await fetchRoutePolyline(
            newPos); // Fetch route instead of direct polyline

        _updateMarker(newPos);
        _moveCamera(newPos);
      }
    });

    socket.onDisconnect((_) => print('❌ Disconnected from socket server'));
  }

  /// Fetches route from Google Directions API
  Future<void> fetchRoutePolyline(LatLng destination) async {
    if (currentPosition.value == null) return;

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${currentPosition.value!.latitude},${currentPosition.value!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApiKey&mode=driving';

    var response = await http.get(Uri.parse(url));
    var data = json.decode(response.body);

    if (data['status'] == 'OK') {
      polylineCoordinates.clear();
      var steps = data['routes'][0]['legs'][0]['steps'];

      for (var step in steps) {
        double lat = step['end_location']['lat'].toDouble();
        double lng = step['end_location']['lng'].toDouble();
        polylineCoordinates.add(LatLng(lat, lng));
      }

      _updatePolyline();
    } else {
      print('❌ Error fetching route: ${data['status']}');
    }
  }

  void _updateMarker(LatLng newPos) {
    // Clear previous markers
    markers.add(
      Marker(
        markerId: const MarkerId('salesman'),
        position: newPos,
        infoWindow: InfoWindow(title: "$username's Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
      ),
    );

    markers.refresh(); // <-- Manually trigger UI update
  }

  void _updatePolyline() {
    polylines.value = {
      Polyline(
        polylineId: PolylineId('tracking_path'),
        points: List.of(polylineCoordinates),
        color: Colors.blueAccent,
        width: 5,
      ),
    };
  }

  void _moveCamera(LatLng newPos) {
    if (mapController != null && currentPosition.value != null) {
      double bearing = _calculateBearing(currentPosition.value!, newPos);

      Future.delayed(const Duration(milliseconds: 100), () {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: newPos,
              zoom: 16.0,
              bearing: bearing, // 🔥 Set camera bearing
              tilt: 45.0, // Optional: Slight tilt for better tracking view
            ),
          ),
        );
      });
    }
  }

  /// 📍 **Calculate Bearing Between Two Points**
  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (math.pi / 180);
    double lon1 = start.longitude * (math.pi / 180);
    double lat2 = end.latitude * (math.pi / 180);
    double lon2 = end.longitude * (math.pi / 180);

    double dLon = lon2 - lon1;
    double y = math.sin(dLon) * math.cos(lat2);
    double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
    double bearing = math.atan2(y, x);

    return (bearing * (180 / math.pi) + 360) % 360; // Convert to degrees
  }

  void setMapController(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      _updateMarker(currentPosition.value!);
      _updatePolyline();
    }
  }

  @override
  void onClose() {
    _initializeTracking();
    socket.disconnect();
    socket.dispose();
    super.onClose();
  }
}
