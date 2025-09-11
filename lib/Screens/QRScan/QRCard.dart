import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../resources/my_colors.dart';
import 'QRController.dart';
import 'QRInformationScreen.dart';

class Qrcard extends StatelessWidget {
  final String cardObjectId;
  final String cardIdString;
  final String cardNameString;
  final String date;
  final String time;
  final String addressString;

  Qrcard(
      {super.key,
      required this.cardObjectId,
      required this.cardIdString,
      required this.cardNameString,
      required this.date,
      required this.time,
      required this.addressString});

  // final QRCardsController controller = QRCardsController();
  final QRCardsController controller = Get.find<QRCardsController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8, top: 4),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            controller.selectedQRid.value = cardObjectId;
            Get.to(() => Qrinformationscreen());
          },
          leading: const Icon(
            Icons.qr_code_2,
            size: 60,
          ),
          title: Row(
            children: [
              Text(cardNameString),
              const Spacer(),
              Text(
                controller.formattedDate(date),
                style: const TextStyle(
                    fontFamily: 'NataSans-Regular', fontSize: 14),
              )
            ],
          ),
          subtitle: Text(addressString),
          trailing: const Icon(
            size: 15,
            Icons.arrow_forward_ios,
            color: MyColor.dashbord,
          ),
          titleAlignment: ListTileTitleAlignment.threeLine,
        ),
      ),
    );
  }
}
