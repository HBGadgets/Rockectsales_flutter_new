import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/SelfieTakingScreen.dart';
import 'package:rocketsale_rs/screens/saleman/dashboard_salesman.dart';

import 'QRCardsController.dart';

class Submitqrdatascreen extends StatefulWidget {
  final cardNameString;
  final cardIdString;

  Submitqrdatascreen(
      {super.key, required this.cardNameString, required this.cardIdString});

  @override
  State<Submitqrdatascreen> createState() => _SubmitqrdatascreenState();
}

class _SubmitqrdatascreenState extends State<Submitqrdatascreen> {
  // final addressString;
  final QRCardsController controller = Get.put(QRCardsController());

  @override
  void dispose() {
    controller.salesManSelfie.value = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        title: const Text(
          'Submit Info',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Obx(() {
            if (controller.addressString.value.isEmpty) {
              controller.getAddress();
            }
            if (controller.isLoading.value) {
              return const AlertDialog(
                backgroundColor: Colors.white,
                content: Center(
                  child: CircularProgressIndicator(
                    color: MyColor.dashbord,
                  ),
                ),
              );
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 8, right: 4, left: 4),
                        child: Container(
                          width: double.infinity, // 👈 full width container
                          height: 250,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            // 👈 centers the button
                            child: controller.salesManSelfie.value != null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Image.file(
                                      //   controller.salesManSelfie.value!,
                                      //   width: 200,
                                      //   height: 200,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      CircleAvatar(
                                        radius: 100, // half of width/height
                                        backgroundImage: FileImage(
                                            controller.salesManSelfie.value!),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Selfietakingscreen()));
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: MyColor.dashbord,
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Selfietakingscreen(),
                                            ),
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(100,
                                                100), // 👈 button's own size
                                            side: const BorderSide(
                                                color: Colors.white70),
                                            backgroundColor: Colors.black12),
                                        child: const Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.black45,
                                          size: 45,
                                        ),
                                      ),
                                      const Text(
                                        'Tap to take selfie',
                                        style: TextStyle(color: Colors.black54),
                                      )
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "QR ID:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.cardIdString,
                          style: TextStyle(color: Colors.black87),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Date:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   widget,
                        //   style: TextStyle(color: Colors.black87),
                        // )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(color: Colors.red))),
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.redAccent)),
                            onPressed: () {
                              // Navigator.pop(context);
                              controller.salesManSelfie.value = null;
                              Navigator.pushAndRemoveUntil<dynamic>(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        DashboardSalesman(),
                                  ),
                                  (Route<dynamic> route) =>
                                      false //if you want to disable back feature set to false
                                  );
                            },
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.white))),
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        final isGettingLocation =
                            controller.gettingLocation.value;
                        return Expanded(
                            child: ElevatedButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: BorderSide(color: Colors.green))),
                              backgroundColor: isGettingLocation ||
                                      controller.salesManSelfie.value == null
                                  ? WidgetStateProperty.all(Colors.grey)
                                  : WidgetStateProperty.all(Colors.green)),
                          onPressed: isGettingLocation ||
                                  controller.salesManSelfie.value == null
                              ? null
                              : () {
                                  controller.postQR(
                                    boxNumber: widget.cardNameString,
                                    qrID: widget.cardIdString,
                                    context: context,
                                  );
                                },
                          child: const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      })
                    ],
                  ),
                  Spacer(),
                ],
              );
            }
          })),
    );
  }
}
