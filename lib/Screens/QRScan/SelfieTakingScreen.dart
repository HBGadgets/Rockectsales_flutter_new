import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import '../../../resources/my_colors.dart';
import 'QRController.dart';

class Selfietakingscreen extends StatefulWidget {
  const Selfietakingscreen({super.key});

  @override
  State<Selfietakingscreen> createState() => _SelfietakingscreenState();
}

class _SelfietakingscreenState extends State<Selfietakingscreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  final QRCardsController controller =
  Get.put(QRCardsController(), permanent: false);

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    final frontCamera = _cameras!
        .firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.low,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<File> _flipImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final flipped = img.flipHorizontal(image);

    final directory = await getTemporaryDirectory();
    final newPath = path.join(
        directory.path, "selfie_${DateTime.now().millisecondsSinceEpoch}.jpg");

    final newFile = File(newPath);
    await newFile.writeAsBytes(img.encodeJpg(flipped, quality: 70));
    return newFile;
  }

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized) return;

    final rawImage = await _cameraController!.takePicture();
    final flippedImage = await _flipImage(File(rawImage.path));

    // Save in your controller and go back
    controller.salesManSelfie.value = flippedImage;
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
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
        leading: const BackButton(color: Colors.white),
      ),
      body: _isInitialized
          ? Stack(
        children: [
          SizedBox.expand( // 👈 makes camera cover full screen
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _cameraController!.value.previewSize!.height,
                height: _cameraController!.value.previewSize!.width,
                child: CameraPreview(_cameraController!),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: MyColor.dashbord,
                onPressed: _captureImage,
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
