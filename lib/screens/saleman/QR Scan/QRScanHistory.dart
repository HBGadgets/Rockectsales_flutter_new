import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/FiltrationSystem.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';

import '../../admin/attendance/attendance screen/FilterOnSpecificDate.dart';

class Qrscanhistory extends StatelessWidget {
  final QRCardsController controller = Get.put(QRCardsController());

  Qrscanhistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
      child: Column(
        children: [
          // SizedBox(height: size.width * 0.02),
          // const Filtrationsystem(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColor.dashbord,
                ));
              } else if (controller.qrCards.isEmpty) {
                return const Center(child: Text("No QR Scan history found."));
              } else {
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: MyColor.dashbord,
                  onRefresh: () async => controller.getQRCards(),
                  child: ListView.builder(
                    itemCount: controller.qrCards.length,
                    itemBuilder: (context, index) {
                      final reversedIndex =
                          controller.qrCards.length - 1 - index;
                      final item = controller.qrCards[reversedIndex];
                      return Qrcard(
                          cardIdString: item.qrId ?? '',
                          cardNameString: item.cardTitle ?? '',
                          date: item.dateTime ?? '',
                          time: item.dateTime ?? '');
                    },
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
