import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';
import 'dart:typed_data';
import 'dart:convert';

class Qrinformationscreen extends StatelessWidget {
  final String qrCardId;

  Qrinformationscreen({super.key, required this.qrCardId});

  final QRCardsController controller = Get.find<QRCardsController>();

  @override
  Widget build(BuildContext context) {
    controller.getSingleQRCard(qrCardId);
    final qrCard = controller.singleQrCard.value;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColor.dashbord,
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'QR Information',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Obx(() {
          if (controller.isCardLoading.value) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            Uint8List bytes = base64Decode(qrCard.salesmanSelfie!);
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: MemoryImage(bytes),
                      ),
                      const Spacer()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Salesman Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text('${qrCard.salesmanName}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Supervisor: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text('${qrCard.supervisorName}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Company Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text('${qrCard.companyName}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Branch Name: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text('${qrCard.branchName}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Qrcard(
                        cardIdString: qrCard.qrId!,
                        cardNameString: qrCard.cardTitle!,
                        date: qrCard.dateTime!,
                        time: qrCard.dateTime!,
                        addressString: qrCard.addressString!),
                  )
                ],
              ),
            );
          }
        }));
  }
}
