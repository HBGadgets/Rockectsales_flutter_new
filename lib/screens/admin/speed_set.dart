import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/speed_controller.dart';

class SetOverSpeedScreen extends StatelessWidget {
  final SpeedController controller = Get.put(SpeedController());

  final TextEditingController speedController = TextEditingController();
  final TextEditingController speedlimitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Set Over Speed Limit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Set Speed Limit", style: _headingStyle),
              SizedBox(height: 10),
              _buildTextField(speedController, "Enter speed limit (km/h)"),
              SizedBox(height: 10),
              Obx(() => _buildButton(
                    onTap: () {
                      int? speedLimit = int.tryParse(speedController.text);
                      if (speedLimit != null) {
                        controller.setOverSpeed(speedLimit);
                      } else {
                        Get.snackbar(
                            "Error", "Please enter a valid speed limit",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    text: "Set Speed Limit",
                    isLoading: controller.isLoading.value,
                  )),
              SizedBox(height: 20),

              Text("Update Speed Limit", style: _headingStyle),
              SizedBox(height: 10),
              _buildTextField(
                  speedlimitController, "Enter new speed limit (km/h)"),
              SizedBox(height: 10),
              Obx(() => _buildButton(
                    onTap: () {
                      int? speedLimit = int.tryParse(speedlimitController.text);
                      if (speedLimit != null
                          // && speedLimit > 0
                          ) {
                        controller.updateSpeedLimit(speedLimit);
                      } else {
                        Get.snackbar("Error", "Enter a valid speed limit",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    text: "Update Speed Limit",
                    isLoading: controller.isLoading.value,
                  )),
              SizedBox(height: 20),

              Text("Delete Speed Limit", style: _headingStyle),
              SizedBox(height: 10),
              Obx(() => _buildButton(
                    onTap: () {
                      String id = controller.supervisorId.value;
                      controller.deleteSpeedLimit(id);
                    },
                    text: "Delete Speed Limit",
                    isLoading: controller.isLoading.value,
                    color: Colors.red,
                  )),
              SizedBox(height: 20),

              /// **Message Display**
              Obx(() => Text(
                    controller.message.value,
                    style: TextStyle(fontSize: 16, color: Colors.green),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  /// **Helper Widget for TextField**
  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  /// **Helper Widget for Buttons**
  Widget _buildButton(
      {required VoidCallback onTap,
      required String text,
      bool isLoading = false,
      Color color = Colors.blue}) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? CircularProgressIndicator(color: Colors.white)
          : Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  /// **Heading TextStyle**
  TextStyle get _headingStyle =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
}
