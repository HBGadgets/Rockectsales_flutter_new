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
                children: [
                  Spacer(),
                  controller.salesManSelfie.value != null
                      ? Column(
                          children: [
                            Image.file(
                              controller.salesManSelfie.value!,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
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
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Selfietakingscreen()));
                                },
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: MyColor.dashbord,
                                )),
                            const Text(
                              'Take selfie before submitting',
                              style: TextStyle(color: Colors.redAccent),
                            )
                          ],
                        ),
                  Qrcard(
                    cardIdString: widget.cardIdString,
                    cardNameString: widget.cardNameString,
                    date: DateTime.now().toString(),
                    time: DateTime.now().toString(),
                    addressString: controller.addressString.value,
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
