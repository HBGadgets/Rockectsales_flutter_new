import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';

import '../../admin/attendance/attendance screen/FilterOnSpecificDate.dart';

class Qrscanhistory extends StatelessWidget {
  final QRCardsController controller = Get.put(QRCardsController());

  Qrscanhistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Coming soon'),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
    //   child: Column(
    //     children: [
    //       // SizedBox(height: size.width * 0.02),
    //       const Filteronspecificdate(),
    //       Expanded(
    //         child: Obx(() {
    //           if (controller.isLoading.value) {
    //             return const Center(child: CircularProgressIndicator());
    //           } else if (controller.qrCards.isEmpty) {
    //             return const Center(child: Text("No QR Scan history found."));
    //           } else {
    //             return RefreshIndicator(
    //               onRefresh: () async => controller.getQRCards(),
    //               child: ListView.builder(
    //                 itemCount: controller.qrCards.length,
    //                 itemBuilder: (context, index) {
    //                   final item = controller.qrCards[index];
    //                   return Qrcard(cardIdString: item., cardNameString: cardNameString, date: date, time: time)
    //                 },
    //               ),
    //             );
    //           }
    //         }),
    //       ),
    //     ],
    //   ),
    // );
  }
}
