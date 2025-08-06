import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../controllers/live_tracking_controller.dart';
import '../../../../resources/my_assets.dart';

class LiveTrackingScreen extends StatelessWidget {
  final String username;

  const LiveTrackingScreen({Key? key, required this.username})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LiveTrackingController controller =
        Get.put(LiveTrackingController(username));

    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(title: Text('Tracking: $username')),
      body: Obx(() {
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentPosition.value!,
                zoom: 14.0,
              ),
              markers: controller.markers,
              polylines: controller.polylines,
              onMapCreated: (mapCtrl) {
                controller.setMapController(mapCtrl);
              },
            ),

            // Draggable Scrollable Bottom Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.24,
              maxChildSize: 0.35,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Center(
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: Colors.grey,
                              size: 35,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle or Salesman Image
                              SizedBox(
                                height: size.height * 0.15,
                                width: 90,
                                child: Image(
                                  image: salesman,
                                ),
                              ),
                              const SizedBox(width: 20),

                              // Device / Tracking Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' $username',
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Last updated:',
                                      style: const TextStyle(fontSize: 12.0),
                                    ),
                                    const SizedBox(height: 10),

                                    // Address
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Expanded(
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                              fontSize: screenWidth * 0.03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(),

                          // Speed & Distance Info
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.speed, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Speed: ",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.route, size: 16),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Distance:  km",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
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
        );
      }),
    );
  }
}
