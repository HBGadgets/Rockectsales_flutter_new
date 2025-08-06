import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';
import '../../utils/token_manager.dart';
import '../models/get_speed_model.dart';
import '../models/put_speed.dart';

class SpeedController extends GetxController {
  var isLoading = false.obs;
  var message = ''.obs;
  var supervisorId = ''.obs;
  var speedData = Rxn<GetSpeedModel>(); // Observable to store API data

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> deleteSpeedLimit(String id) async {
    try {
      isLoading.value = true;
      String? token = await TokenManager.getToken();
      String? pd = await TokenManager.getSupervisorId();
      print("Supervisor ID: $pd");
      var url = Uri.parse("http://104.251.218.102:8080/api/setoverspeed/$pd");

      var response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // print(response.statusCode);
        var data = jsonDecode(response.body);
        message.value = data['message'] ?? "Speed limit deleted successfully!";
      } else {
        // print(response.statusCode);
        message.value = "Failed to delete speed limit!";
      }
    } catch (e) {
      message.value = "Error: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setOverSpeed(int speedLimit) async {
    try {
      isLoading.value = true;
      String? token = await TokenManager.getToken();
      String? pd = await TokenManager.getSupervisorId();
      print(token);

      var url = Uri.parse('http://104.251.218.102:8080/api/setoverspeed');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Use token correctly
        },
        body: jsonEncode({
          'supervisorId': "$pd",
          'speedLimit': speedLimit,
        }),
      );

      if (response.statusCode == 201) {
        // print(response.statusCode);
        var data = jsonDecode(response.body);
        message.value = data['message'] ?? 'Speed limit set successfully';
      } else {
        // print(response.statusCode);
        message.value = 'Failed to set speed limit';
      }
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOverSpeedsaleData() async {
    try {
      isLoading.value = true;
      String? token = await TokenManager.getToken();
      String? cd = await TokenManager.getSupervisorinsalemanId();
      var url = Uri.parse('http://104.251.218.102:8080/api/setoverspeed/$cd');
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = jsonDecode(response.body);

        speedData.value = GetSpeedModel.fromJson(data);
        message.value = speedData.value?.message ?? 'Data fetched successfully';
      } else {
        message.value = 'Failed to fetch data';
      }
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSpeedLimit(int speedLimit) async {
    // if (supervisorId.value.isEmpty) {
    //   message.value = 'Supervisor ID not found';
    //   return;
    // }

    try {
      isLoading.value = true;
      String? token = await TokenManager.getToken();
      String? kj = await TokenManager.getSupervisorId();
      print(kj);

      var url = Uri.parse('http://104.251.218.102:8080/api/setoverspeed/$kj');

      var response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'speedLimit': speedLimit,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var putSpeedModel =
            PutSpeedModel.fromJson(data); // Store parsed response
        message.value =
            putSpeedModel.message ?? 'Speed limit updated successfully';
        // print("Updated Speed Data: ${putSpeedModel.toJson()}");
      } else {
        message.value = 'Failed to update speed limit';
      }
    } catch (e) {
      message.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
