import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

class AlertController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  RxBool isAlertOpen = false.obs; // Alert visibility
  RxBool isBeepPlaying = false.obs; // Beep sound status
  RxBool enableDisableController = false.obs; // Beep sound status

  void playBeepSound() async {
    await _player.play(AssetSource('overSpeed.mp3'));
    isBeepPlaying.value = true;
    await _player.setReleaseMode(ReleaseMode.loop);
  }

  void stopBeepSound() async {
    //  Workmanager().cancelAll();
    await _player.stop();
    await _player.release();
    isBeepPlaying.value = false;
  }

  void showAlert() {
    if (isAlertOpen.value) {
      stopAlertManually(); // 🛑 Close existing alert before opening a new one
    }
    isAlertOpen.value = true;
    playBeepSound(); // 🔊 Start beep

    /*  Workmanager().registerOneOffTask(
      'lock_screen_alert',
      'lock_screen_alert',
    );*/
    Get.dialog(
      WillPopScope(
        onWillPop: () async {
          stopAlertManually(); // ⬅ Close on back button press
          return false;
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "⚠ Over Speed Alert!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, size: 50, color: Colors.red),
              const SizedBox(height: 15),
              const Text(
                "You are overspeeding! Reduce your speed immediately!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false, // ❌ Prevent accidental dismiss
    );
  }

  void stopAlertManually() {
    if (isBeepPlaying.value) {
      stopBeepSound();
    }
    if (isAlertOpen.value) {
      isAlertOpen.value = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }

  void enableFunction() {
    enableDisableController.value = true;
  }

  void disableFunction() {
    enableDisableController.value = false;
  }
}
