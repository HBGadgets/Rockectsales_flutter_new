import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../data/api constants/api_constants.dart';
import '../../../utils/token_manager.dart';

class UserListController extends GetxController {
  late IO.Socket socket;

  @override
  void onInit() {
    super.onInit();
    _initSocket();
    IO.Socket socket;
  }

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  var liveData = <Map<String, dynamic>>[].obs;
  var addressMap = <String, String>{}.obs;
  var searchQuery = ''.obs;
  TextEditingController searchController = TextEditingController();

  List get filteredData {
    if (searchQuery.value.isEmpty) return liveData;
    return liveData.where((user) {
      final name = (user['salesmanName'] ?? '').toString().toLowerCase();
      final username = (user['username'] ?? '').toString().toLowerCase();
      return name.contains(searchQuery.value.toLowerCase()) ||
          username.contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void _initSocket() async {
    socket = IO.io(ApiConstants.serverUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) => print('✅ Connected to Socket.IO server'));
    socket.onDisconnect((reason) => print('❌ Disconnected. Reason: $reason'));

    final token = await TokenManager.getToken();
    print("Token: $token"); // Debugging: Check if token is retrieved

    if (token != null && token.isNotEmpty) {
      socket.emit("authenticate", token);
    }

    socket.on('liveSalesmanData', (data) {
      print("Received liveSalesmanData: $data"); // Debugging

      if (data is List) {
        liveData.assignAll(data
            .cast<Map<String, dynamic>>()); // ✅ Correct way to update RxList
        for (var user in data) {
          if (user is Map &&
              user.containsKey('latitude') &&
              user.containsKey('longitude')) {
            double lat = double.tryParse(user['latitude'].toString()) ?? 0.0;
            double lng = double.tryParse(user['longitude'].toString()) ?? 0.0;
            _convertToAddress(lat, lng, user['_id']);
          }
        }
      } else {
        print("❌ Error: Received data is not a list");
      }
    });
  }

  Future<void> _convertToAddress(double lat, double lng, String userId) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        String address =
            "${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].administrativeArea}, ${placemarks[0].country}";
        addressMap[userId] = address;
      }
    } catch (e) {
      addressMap[userId] = "Address not available";
    }
  }

  void refreshData() {
    liveData.clear();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  @override
  void onClose() {
    print("🔌 Disconnecting socket...");
    // socket.disconnect();
    // socket.dispose();
    socket.close();
    searchController.dispose();
    super.onClose();
  }
}
