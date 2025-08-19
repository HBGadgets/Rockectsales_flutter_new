import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCard.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';
import 'dart:typed_data';
import 'dart:convert';

import 'QRInformationScreenController.dart';

class Qrinformationscreen extends StatelessWidget {
  Qrinformationscreen({super.key});

  final Qrinformationscreencontroller controller =
      Get.put(Qrinformationscreencontroller(), permanent: false);

  @override
  Widget build(BuildContext context) {
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
              child: CircularProgressIndicator(
                color: MyColor.dashbord,
              ),
            );
          } else {
            Uint8List bytes = base64Decode(
                controller.singleQrCard.value.salesmanSelfie ?? "");
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
                            Text(
                                '${controller.singleQrCard.value.salesmanName}'),
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
                            Text(
                                '${controller.singleQrCard.value.supervisorName}'),
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
                            Text(
                                '${controller.singleQrCard.value.companyName}'),
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
                            Text('${controller.singleQrCard.value.branchName}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Qrcard(
                        cardIdString: controller.singleQrCard.value.qrId ?? '',
                        cardNameString:
                            controller.singleQrCard.value.cardTitle ?? '',
                        date: controller.singleQrCard.value.dateTime ?? '',
                        time: controller.singleQrCard.value.dateTime ?? '',
                        addressString:
                            controller.singleQrCard.value.addressString ?? ''),
                  )
                ],
              ),
            );
          }
        }));
  }
}
