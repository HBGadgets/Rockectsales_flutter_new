import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/dashboard_salesman.dart';

import 'QRCardsController.dart';

class Submitqrdatascreen extends StatelessWidget {
  final adminName;
  final cardNameString;
  final cardIdString;

  final QRCardsController controller = Get.put(QRCardsController());

  // String formattedDate(String? dateTimeStr) {
  //   DateTime dateTime = DateTime.parse(dateTimeStr!);
  //   return DateFormat('dd/MM/yy').format(dateTime);
  // }
  //
  // String formattedTime(String? dateTimeStr) {
  //   DateTime dateTime = DateTime.parse(dateTimeStr!);
  //
  //   // Format to hh:mm a (12-hour format with AM/PM)
  //   return DateFormat('hh:mm a').format(dateTime);
  // }

  Submitqrdatascreen(
      {super.key,
      required this.adminName,
      required this.cardNameString,
      required this.cardIdString});

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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'To: $adminName',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Qrcard(
                      cardIdString: cardIdString,
                      cardNameString: cardNameString,
                      date: DateTime.now().toString(),
                      time: DateTime.now().toString()),
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
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(color: Colors.green))),
                                backgroundColor:
                                    WidgetStateProperty.all(Colors.green)),
                            onPressed: () {
                              controller.postQR(
                                  boxNumber: cardNameString,
                                  qrID: cardIdString,
                                  context: context);
                            },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            )),
                      )
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
