import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/New%20Attendance/SelfiePreviewScreen.dart';
import 'package:image/image.dart' as img;
import '../../../../resources/my_colors.dart';
import 'NewAttendanceController.dart';

class SelfietakingscreenAttendance extends StatefulWidget {
  const SelfietakingscreenAttendance({super.key});

  @override
  State<SelfietakingscreenAttendance> createState() =>
      _SelfietakingscreenAttendanceState();
}

class _SelfietakingscreenAttendanceState
    extends State<SelfietakingscreenAttendance> {
  late FaceCameraController selfieController;

  Future<File> flipImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final flipped = img.flipHorizontal(image);
    final newFile = await file.writeAsBytes(img.encodeJpg(flipped));
    return newFile;
  }

  @override
  void initState() {
    selfieController = FaceCameraController(
      imageResolution: ImageResolution.high,
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      onCapture: (File? image) async {
        if (image != null) {
          final flippedImage = await flipImage(image);
          Get.to(SelfiePreviewScreen(
            imageFile: flippedImage,
          ));
          // controller.salesManSelfie.value = image;
          // controller.sendAttendanceData(XFile(image.path));
        }

        // Stop camera safely before leaving
        // await selfieController.dispose();

        // if (mounted) {
        //   Navigator.pop(context);
        // }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    selfieController.dispose();
    // TODO: implement dispose
    super.dispose();
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
          showCaptureControl: true,
          controller: selfieController,
          showControls: true,
        ));
  }
}
