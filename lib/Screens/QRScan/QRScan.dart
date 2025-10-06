import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rocketsales/Screens/QRScan/SubmitQRDataScreenController.dart';

import 'QRController.dart';
import 'SubmitQRDataScreen.dart';

class QrscanScreen extends StatefulWidget {
  const QrscanScreen({super.key});

  @override
  State<QrscanScreen> createState() => _QrscanScreenState();
}

class _QrscanScreenState extends State<QrscanScreen>
    with WidgetsBindingObserver {
  final QRCardsController controller = Get.put(QRCardsController());
  final MobileScannerController scannerController = MobileScannerController(
      // autoStart: false,
      detectionSpeed: DetectionSpeed.noDuplicates);

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      MobileScanner(
        controller: scannerController,
        onDetect: (result) {
          // controller.getAddress();
          controller.addressString.value = '';
          final List<Barcode> barcodes = result.barcodes;
          for (final barcode in barcodes) {
            final jsonData = json.decode(barcode.rawValue ?? '');
            final cardString = jsonData['boxNo'];
            final cardIdString = jsonData['id'];
            final questionSetId = jsonData['questionSetId'];
            controller.questionSetId.value = questionSetId;
            print("questionset id from scanner ========>>>>>> ${questionSetId}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Submitqrdatascreen(
                        cardNameString: cardString,
                        cardIdString: cardIdString,
                        questionSetId: questionSetId,
                        // addressString: controller.addressString.value,
                      )),
            );
          }
        },
      ),
    ]);
  }
}
