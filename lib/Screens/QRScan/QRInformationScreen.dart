import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:convert';

import '../../resources/my_colors.dart';
import 'QRInformationScreenController.dart';

class Qrinformationscreen extends StatelessWidget {
  Qrinformationscreen({super.key});

  final Qrinformationscreencontroller controller =
      Get.put(Qrinformationscreencontroller(), permanent: false);

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
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    Container(
                      width: 160,
                      // same as diameter of CircleAvatar (radius * 2)
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.green,
                          // border color
                          width: 2, // border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 80, // half of container size
                        backgroundImage: MemoryImage(bytes),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        textAlign: TextAlign.start,
                        '${controller.singleQrCard.value.salesmanName}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Supervisor : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.supervisorName}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Company : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.companyName}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Branch : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.branchName}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "QR id : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.qrId}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Commodity no: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.cardTitle}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            padding: const EdgeInsets.all(12), // inner spacing
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // background color
                              borderRadius: BorderRadius.circular(12),
                              // rounded corners
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              // border
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Address : ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // 👈 ensures long text wraps
                                  child: Text(
                                    '${controller.singleQrCard.value.addressString}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                // inner spacing
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // background color
                                  borderRadius: BorderRadius.circular(12),
                                  // rounded corners
                                  border: Border.all(
                                      color: Colors.black12, width: 1.5),
                                  // border
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Date:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.formattedDate(controller
                                          .singleQrCard.value.dateTime),
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                // inner spacing
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  // background color
                                  borderRadius: BorderRadius.circular(12),
                                  // rounded corners
                                  border: Border.all(
                                      color: Colors.black12, width: 1.5),
                                  // border
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Time:",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      controller.formattedTime(controller
                                          .singleQrCard.value.dateTime),
                                      style: const TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: controller.answers.map((ans) {
                            return ListTile(
                              title: Text(ans.question),
                              subtitle: Text(ans.answer),
                            );
                          }).toList(),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }));
  }
}
