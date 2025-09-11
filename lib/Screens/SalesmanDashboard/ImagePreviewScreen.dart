import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../resources/my_colors.dart';
import 'SalesmanDashboardController.dart';
import 'dart:typed_data';

class ImagePreviewScreen extends StatelessWidget {
  final Uint8List imageFile;

  ImagePreviewScreen({super.key, required this.imageFile});

  final salesmanDashboardController controller =
  Get.find<salesmanDashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: MyColor.dashbord,
          title: const Text(
            'Profile picture',
            style: TextStyle(color: Colors.white),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
        ),
        body: Stack(
          children: [
            Center(
              child: Image.memory( // ✅ use memory instead of file
                imageFile,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                const EdgeInsets.only(right: 12.0, left: 12, bottom: 60),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(28, 80, 140, 0.59),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          controller.updateImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 6),
                            Text("Another"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12), // spacing between buttons
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor:
                          const Color.fromRGBO(28, 80, 140, 0.59),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          controller.deleteImage(context).then((_) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            controller.getProfileImage();
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 6),
                            Text("Delete"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
