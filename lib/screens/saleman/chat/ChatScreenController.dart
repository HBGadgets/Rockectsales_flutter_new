import 'dart:convert';

import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:uuid/uuid.dart';
import '../../../utils/token_manager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreenController extends GetxController {
  // var salesManName = ''.obs;
  // var adminName = ''.obs;
  var chatRoomName = ''.obs;
  late IO.Socket socket;
  var messages = <types.TextMessage>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    getOldChats();
    // TODO: implement onInit
    super.onInit();
  }

  void getOldChats() async {
    isLoading.value = true;
    try {
      String? token = await TokenManager.getToken();
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);

      final adminName = decodedToken['chatusername'];
      final salesmanName = decodedToken['username'];

      final sortedUsers = [adminName, salesmanName]..sort();
      final roomId = "${sortedUsers[0]}_${sortedUsers[1]}";
      print("roomId =========>>>>>>> $roomId");

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/userprechatmessage/$roomId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('messages with admin from room $roomId: =======>>>>>> $jsonData');
        final List<dynamic> dataList = jsonData['data'];
        // final messagesList =
        //     dataList.map((item) => Message.fromJson(item)).toList();
        final messagesList = dataList.map((item) {
          return types.TextMessage(
            id: item['_id'] ?? const Uuid().v4(),
            author: types.User(id: item['sender']),
            createdAt:
                DateTime.tryParse(item['createdAt'])?.millisecondsSinceEpoch ??
                    DateTime.now().millisecondsSinceEpoch,
            text: item['Message'], // ✅ always mapped to .text
          );
        }).toList();
        messages.assignAll(messagesList);
      } else {
        messages.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");
      }
    } catch (e) {
      messages.clear();
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // void getSalesmanAdminName() async {
  //   String? token = await TokenManager.getToken();
  //   Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
  //   print(decodedToken);
  //   adminName.value = decodedToken['chatusername'];
  //   salesManName.value = decodedToken['username'];
  //   final chatRoomName = '${adminName.value}_${salesManName.value}';
  //   print(adminName.value);
  //   getOldChats(chatRoomName);
  //   initSocket(token, chatRoomName, adminName.value);
  // }

  void initSocket(String token, String roomName, String username) {
    print('Connecting to chat socket...');

    socket = IO.io(
      '${dotenv.env['BASE_URL']}',
      <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
        'path': '/socket.io',
        'auth': {
          'token': 'token=$token',
        },
      },
    );
    socket.onConnect((_) {
      // ✅ Send data TO server
      print("Going into onConnect method");

      socket.emit('joinRoom', {
        'room': roomName,
        'username': username,
      });
    });

    // 📩 Listen for messages FROM server
    socket.on('receiveMessage', (data) {
      print('📩 Message from server: $data');
    });

    socket.onAny((event, data) {
      print('📡 Event: $event -> $data');
    });

    socket.connect();
  }
}

// class Message {
//   String? text;
//   bool? isUserMessage;
//   String? reciever;
//
//   Message({this.text, this.isUserMessage, this.reciever});
//
//   Message.fromJson(Map<String, dynamic> json) {
//     text = json['Message'];
//     reciever = json['receiver'];
//   }
// }
