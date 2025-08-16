import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/QRCardsController.dart';
import 'package:rocketsale_rs/screens/saleman/QR%20Scan/SubmitQRDataScreen.dart';

import '../../../resources/my_colors.dart';

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
          controller.getAddress();
          final List<Barcode> barcodes = result.barcodes;
          for (final barcode in barcodes) {
            final jsonData = json.decode(barcode.rawValue ?? '');
            final cardString = jsonData['boxNo'];
            final cardIdString = jsonData['id'];
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Submitqrdatascreen(
                        cardNameString: cardString,
                        cardIdString: cardIdString,
                        // addressString: controller.addressString.value,
                      )),
            );
          }
        },
      ),
    ]);
  }
}
