import 'dart:io';

import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../resources/my_colors.dart';
import 'QRCardsController.dart';

class Selfietakingscreen extends StatefulWidget {
  const Selfietakingscreen({super.key});

  @override
  State<Selfietakingscreen> createState() => _SelfietakingscreenState();
}

class _SelfietakingscreenState extends State<Selfietakingscreen> {
  late FaceCameraController selfieController;
  final QRCardsController controller =
      Get.put(QRCardsController(), permanent: false);

  @override
  void initState() {
    selfieController = FaceCameraController(
      imageResolution: ImageResolution.low,
      autoCapture: true,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) {
        controller.salesManSelfie.value = image;
        Navigator.pop(context);
      },
    );
    super.initState();
  }

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
        body: SmartFaceCamera(
          showFlashControl: false,
          showCameraLensControl: false,
          showCaptureControl: false,
          controller: selfieController,
          message: 'Center your face in the square',
        ));
  }
}
