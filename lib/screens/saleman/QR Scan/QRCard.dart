import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/Attendance_Page.dart';

import 'QRCardsController.dart';

class Qrcard extends StatelessWidget {
  final String cardIdString;
  final String cardNameString;
  final String date;
  final String time;
  final String addressString;

  Qrcard(
      {super.key,
      required this.cardIdString,
      required this.cardNameString,
      required this.date,
      required this.time,
      required this.addressString});

  // final QRCardsController controller = QRCardsController();
  final QRCardsController controller = Get.find<QRCardsController>();

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // const Icon(
            //   Icons.qr_code,
            //   size: 60,
            //   color: Colors.black54,
            // ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('QR id: '),
                        Expanded(
                          child: Text(
                            cardIdString,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Commodity no: '),
                        Expanded(
                          child: Text(
                            cardNameString,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Obx(() {
                            final isGettingLocation =
                                controller.gettingLocation.value;
                            if (isGettingLocation) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: MyColor.dashbord,
                                ),
                              );
                            } else {
                              return Text(
                                addressString,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          }),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(formattedDate(date)),
                        const Spacer(),
                        Text(formattedTime(time)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
