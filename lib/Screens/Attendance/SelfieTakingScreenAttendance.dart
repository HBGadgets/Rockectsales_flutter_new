import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../resources/my_colors.dart';
import 'SelfiePreviewScreen.dart';

class SelfietakingscreenAttendance extends StatefulWidget {
  const SelfietakingscreenAttendance({super.key});

  @override
  State<SelfietakingscreenAttendance> createState() =>
      _SelfietakingscreenAttendanceState();
}

class _SelfietakingscreenAttendanceState
    extends State<SelfietakingscreenAttendance> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isFrontCamera = true;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera({bool useFrontCamera = true}) async {
    _cameras = await availableCameras();
    final selectedCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection ==
          (useFrontCamera ? CameraLensDirection.front : CameraLensDirection.back),
    );

    _cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) {
      setState(() => _isInitialized = true);
    }
  }

  Future<File> flipImage(File file) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final flipped = img.flipHorizontal(image);

    final directory = await getTemporaryDirectory();
    final newPath = path.join(directory.path, "flipped_${DateTime.now().millisecondsSinceEpoch}.jpg");

    final newFile = File(newPath);
    await newFile.writeAsBytes(img.encodeJpg(flipped));
    return newFile;
  }

  Future<void> _captureImage() async {
    if (!_cameraController!.value.isInitialized) return;

    final rawImage = await _cameraController!.takePicture();
    final flippedImage = await flipImage(File(rawImage.path));

    await _cameraController?.dispose();
    _cameraController = null;
    _isInitialized = false;

    // Get.to(() => SelfiePreviewScreen(imageFile: flippedImage))!.then((_) {
    //   // re-init camera when coming back
    //   _initCamera(useFrontCamera: _isFrontCamera);
    // });
    final result = await Get.to(() => SelfiePreviewScreen(imageFile: flippedImage));

    if (result == 'retake') {
      _initCamera(); // only reinit if user pressed retake
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _cameraController = null;
    _isInitialized = false;
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
