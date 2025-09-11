import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as loc;
import 'package:share_plus/share_plus.dart';
import '../../SalesManLocationController.dart';
import '../../resources/my_colors.dart';
import '../task sales man/TaskCard.dart';
import '../task sales man/saleTask_controller.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';

class LiveTrackingscreen extends StatefulWidget {
  final String salesmanName;

  LiveTrackingscreen({Key? key, required this.salesmanName})
      : super(
          key: key,
        );

  @override
  _LiveTrackingscreenState createState() => _LiveTrackingscreenState();
}

class _LiveTrackingscreenState extends State<LiveTrackingscreen> {
  final Completer<GoogleMapController> _controller = Completer();
  loc.Location location = loc.Location();
  final LatLng _startingLocation = LatLng(21.1286167, 79.1037089);
  String _currentAddress = "Fetching address...";
  double totalDistance = 0.0;

  double latitude = 0.0;
  double longitude = 0.0;
  double lastLatitude = 0.0; // Store the last latitude
  double lastLongitude = 0.0;
  DateTime? lastTimestamp;
  String speedText = "0.0 km/h";

  bool _trafficEnabled = false;
  MapType _mapType = MapType.normal;

  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];
  BitmapDescriptor? userAvatar;
  Set<Marker> _markers = {};

  final TaskController controller = Get.put(TaskController());

  SalesManLocationController locationController = SalesManLocationController();

  GoogleMapController? _mapController;

  LatLng? _lastPosition;

  Future<BitmapDescriptor> _resizeAvatar(String path, int targetWidth) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth, // 👈 size in pixels
    );
    final ui.FrameInfo fi = await codec.getNextFrame();

    final ByteData? resized = await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(resized!.buffer.asUint8List());
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    controller.getTasksForLiveTrack();
    _loadUserAvatar();

    // ✅ Start listening for movement
    location.onLocationChanged.listen((loc.LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        final newPosition = LatLng(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        _updateUserMarker(newPosition);

        setState(() {
          _polylineCoordinates.add(newPosition);

          _polylines = {
            Polyline(
              polylineId: const PolylineId("user_path"),
              color: Colors.blue,
              width: 5,
              points: _polylineCoordinates,
            ),
          };
        });

        // ✅ Move camera smoothly
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(newPosition),
        );

        // if (_lastPosition == null) {
        //   // First time: just place marker
        //   _updateUserMarker(newPosition);
        // } else {
        //   // Animate smoothly
        //   _animateMarker(const MarkerId("user"), _lastPosition!, newPosition, const Duration(milliseconds: 1000));
        // }

        _updateUserMarker(newPosition);

        _lastPosition = newPosition;
      }
    });
  }

  Future<void> _loadUserAvatar() async {
    userAvatar = await _resizeAvatar("assets/images/salesmanStatic.png", 80);
    // 👆 try 60, 80, 100 pixels until it looks good
    setState(() {});
  }

  void _updateUserMarker(LatLng position) {
    setState(() {
      _markers.removeWhere((m) => m.markerId == const MarkerId("user"));
      _markers.add(
        Marker(
          markerId: const MarkerId("user"),
          position: position,
          icon: userAvatar ?? BitmapDescriptor.defaultMarker, // avatar image
          anchor: const Offset(0.5, 0.5), // center the icon
        ),
      );
    });
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

    getAddress();
  }

  void getAddress() async {
    print("getting address.............");
    try {
      final salesManLocation = await locationController.determinePosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          salesManLocation.latitude, salesManLocation.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      });

      // print(placemarks);
    } catch (e) {
      Get.snackbar("Location Error", e.toString());
    }
  }

  Future<void> _shareLocation() async {
    try {
      final pos = await locationController.determinePosition();
      final latitude = pos.latitude;
      final longitude = pos.longitude;

      final googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";

      SharePlus.instance.share(
          ShareParams(text: "Here’s my location: $googleMapsUrl")
      );
    } catch (e) {
      Get.snackbar("Error", "Could not fetch location: $e");
    }
  }

  // Future<void> _animateMarker(
  //     MarkerId markerId,
  //     LatLng from,
  //     LatLng to,
  //     Duration duration,
  //     ) async {
  //   final GoogleMapController mapController = await _controller.future;
  //   final int frames = 60; // smoother = more frames
  //   final double latStep = (to.latitude - from.latitude) / frames;
  //   final double lngStep = (to.longitude - from.longitude) / frames;
  //
  //   for (int i = 1; i <= frames; i++) {
  //     await Future.delayed(duration ~/ frames, () {
  //       final LatLng newPos = LatLng(
  //         from.latitude + latStep * i,
  //         from.longitude + lngStep * i,
  //       );
  //
  //       setState(() {
  //         _markers.removeWhere((m) => m.markerId == markerId);
  //         _markers.add(
  //           Marker(
  //             markerId: markerId,
  //             position: newPos,
  //             icon: userAvatar ?? BitmapDescriptor.defaultMarker,
  //             anchor: const Offset(0.5, 0.5),
  //           ),
  //         );
  //       });
  //     });
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Live Track",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body:
      Obx(() => Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _startingLocation,
              zoom: 15.5,
              tilt: 0,
              bearing: 0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _mapController = controller;
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            tiltGesturesEnabled: false,
            trafficEnabled: _trafficEnabled,
            mapType: _mapType,

            polylines: _polylines,
            markers: _markers,
          ),
          Positioned(
              top: 65,
              right: 10,
              child: Column(
                children: [
                  _mapButton(
                    icon: Icons.traffic,
                    active: _trafficEnabled,
                    onTap: () {
                      setState(() {
                        _trafficEnabled = !_trafficEnabled;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _mapButton(
                    icon: Icons.satellite_alt,
                    active: _mapType == MapType.satellite,
                    onTap: () {
                      setState(() {
                        _mapType = _mapType == MapType.normal
                            ? MapType.satellite
                            : MapType.normal;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _mapButton(
                    icon: Icons.share,
                    active: false,
                    onTap: _shareLocation,
                  ),
                ],
              ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.24,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: MyColor.dashbord,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              const Icon(Icons.my_location,
                                  color: Colors.white),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _currentAddress,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final item = controller.tasksForLiveTrack[index];
                            return Taskcard(task: item);
                          },
                          childCount: controller.tasksForLiveTrack.length,
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
          if (controller.isLoading.value)
            Positioned.fill(
              child: Container(
                color: Color.fromRGBO(0, 0, 0, 0.35),
                child: const Center(
                  child: CircularProgressIndicator(color: MyColor.dashbord),
                ),
              ),
            ),
        ],
      ),
      )

    );
  }

  Widget _mapButton({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: active ? MyColor.dashbord : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: active ? Colors.white : MyColor.dashbord,
          size: 24,
        ),
      ),
    );
  }
}
