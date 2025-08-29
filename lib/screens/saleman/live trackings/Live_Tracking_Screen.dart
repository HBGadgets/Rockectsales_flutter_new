import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:rocketsale_rs/resources/my_assets.dart';
import '../../../controllers/alertController.dart';

class LiveTrackingscreen extends StatefulWidget {
  LiveTrackingscreen({Key? key}) : super(key: key);

  @override
  _LiveTrackingscreenState createState() => _LiveTrackingscreenState();
}

class _LiveTrackingscreenState extends State<LiveTrackingscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  StreamSubscription<LocationData>? _locationSubscription;
  loc.Location location = loc.Location();
  LatLng? _lastKnownLocation;
  final LatLng _startingLocation = LatLng(21.1286167, 79.1037089);
  double _movementThreshold = 2.0; // Minimum movement for tracking
  double _speedThreshold = 40.0; // Max speed in m/s
  double _currentSpeed = 0.0; // Speed in m/s
  double _bearing = 0.0; // गाड़ी की दिशा
  Timer? _speedUpdateTimer;
  final AudioPlayer player = AudioPlayer();
  bool _isBeeping = true;
  bool _isTemporarilyStopped = false;
  final alertController = Get.find<AlertController>();

  double _currentSpeed1 = 0.0;

  double _totalDistance = 0.0;
  String _currentAddress = "Fetching address...";
  double totalDistance = 0.0;

  double latitude = 0.0;
  double longitude = 0.0;
  double lastLatitude = 0.0; // Store the last latitude
  double lastLongitude = 0.0;
  DateTime? lastTimestamp;
  String speedText = "0.0 km/h";

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _startSpeedUpdateTimer();
  }

  Future<void> _checkLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    _startTracking();
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _currentAddress =
            "${place.subLocality}, ${place.locality}, ${place.administrativeArea}, -${place.postalCode}";
        return "${place.street}, ${place.locality}, ${place.country}, -${place.postalCode}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error fetching address: $e";
    }
  }

  void _startTracking() {
    _locationSubscription = location.onLocationChanged.listen((
      LocationData currentLocation,
    ) {
      latitude = currentLocation!.latitude!;
      longitude = currentLocation!.longitude!;

      if (lastTimestamp != null) {
        calculateDistanceAndSpeed();
      }
      lastLatitude = latitude;
      lastLongitude = longitude;
      lastTimestamp = DateTime.now();

      LatLng newLocation = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      getAddressFromLatLng(newLocation);
      if (_lastKnownLocation != null) {
        double distance = _calculateDistance(_lastKnownLocation!, newLocation);
        double timeDiff = 1.0;
        double calculatedSpeed = distance / timeDiff;

        if (calculatedSpeed < _speedThreshold) {
          _currentSpeed = calculatedSpeed;
          setState(() {
            _totalDistance += distance;
          });
          print('kkk$_currentSpeed');
        }

        if (distance < _movementThreshold) return;

        _bearing = _calculateBearing(_lastKnownLocation!, newLocation);
      }

      setState(() {
        _lastKnownLocation = newLocation;
        _polylineCoordinates.addAll(
          _interpolate(_lastKnownLocation!, newLocation),
        );
        _updatePolyline();
        _updateMarker(newLocation);
        _animateCamera(newLocation, _bearing);
      });
    });
  }

  void _startSpeedUpdateTimer() {
    _speedUpdateTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void calculateDistanceAndSpeed() {
    // Calculate the distance (in meters) between the previous and current coordinates.
    double distance = haversineDistance(
      lastLatitude,
      lastLongitude,
      latitude,
      longitude,
    );
    totalDistance += distance;

    // Determine the elapsed time between the last update and now.
    DateTime now = DateTime.now();
    double secondsElapsed = now.difference(lastTimestamp!).inSeconds.toDouble();

    if (secondsElapsed > 0) {
      // Calculate speed in km/h:
      double speedInKmph = (distance / 1000) / (secondsElapsed / 3600);

      setState(() {
        // If the calculated speed exceeds the threshold, show a popup.

        speedText = speedInKmph.toStringAsFixed(2) + " km/h";
      });

      print('Interval Distance: ${distance.toStringAsFixed(2)} m');
      print('Calculated Speed: $speedText');
    } else {
      print('Time difference is zero, cannot calculate speed.');
    }
  }

  double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const double R = 6371e3; // Earth radius in meters
    double phi1 = lat1 * math.pi / 180; // Convert degrees to radians
    double phi2 = lat2 * math.pi / 180;
    double deltaPhi = (lat2 - lat1) * math.pi / 180;
    double deltaLambda = (lon2 - lon1) * math.pi / 180;

    double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = R * c; // Distance in meters
    return distance;
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double R = 6371000; // Earth radius in meters
    double lat1 = _toRadians(start.latitude);
    double lon1 = _toRadians(start.longitude);
    double lat2 = _toRadians(end.latitude);
    double lon2 = _toRadians(end.longitude);

    double dLat = lat2 - lat1;
    double dLon = lon2 - lon1;

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = R * c;

    // ✅ Add distance to total distance
    _totalDistance += distance;

    return distance;
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double startLat = _toRadians(start.latitude);
    double startLng = _toRadians(start.longitude);
    double endLat = _toRadians(end.latitude);
    double endLng = _toRadians(end.longitude);

    double dLon = endLng - startLng;

    double y = sin(dLon) * cos(endLat);
    double x =
        cos(startLat) * sin(endLat) - sin(startLat) * cos(endLat) * cos(dLon);
    double bearing = atan2(y, x);

    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  double _toDegrees(double radian) {
    return radian * 180 / pi;
  }

  List<LatLng> _interpolate(LatLng start, LatLng end) {
    List<LatLng> interpolatedPoints = [];
    int numPoints = 5;
    for (int i = 1; i <= numPoints; i++) {
      double lat =
          start.latitude + (end.latitude - start.latitude) * (i / numPoints);
      double lng =
          start.longitude + (end.longitude - start.longitude) * (i / numPoints);
      interpolatedPoints.add(LatLng(lat, lng));
    }
    return interpolatedPoints;
  }

  void _updatePolyline() {
    _polylines.clear();
    _polylines.add(
      Polyline(
        polylineId: PolylineId("route"),
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  void _updateMarker(LatLng position) {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId("userLocation"),
        position: position,
        infoWindow: InfoWindow(title: "User Location"),
      ),
    );
  }

  Future<void> _animateCamera(LatLng position, double bearing) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 18,

          tilt: 60, // Slightly tilted for better tracking
        ),
      ),
    );
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _speedUpdateTimer?.cancel();
    totalDistance = 0.0;
    super.dispose();
  }

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _startingLocation,
                zoom: 14.5,
              ),
              markers: _markers,
              polylines: _polylines,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.24,
              maxChildSize: 0.35,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    // border: Border.all(
                    //   color: Colors.grey,
                    // ),
                    boxShadow: [],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Center(
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.grey,
                              size: 40,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle Image
                              SizedBox(
                                height: size.height * 0.15,
                                width: 90,
                                child: Image(
                                  image: salesman,
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Device Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'R04-MH12RN5047',
                                      style: const TextStyle(fontSize: 18.0),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Last updated: 21/02/2025 03:55 PM',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                    const SizedBox(height: 5),

                                    // Address Section
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 15,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Expanded(
                                          child: Text(
                                            _currentAddress,
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 0,
                            ),
                            child: Wrap(
                              spacing: 10,
                              runSpacing: 1,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    right: 15.0,
                                    left: 15.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.speed),
                                      Text(
                                        "Speed: $speedText",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(Icons.speed),
                                      Text(
                                        ("Distance: ${(totalDistance / 1000)}"),
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
