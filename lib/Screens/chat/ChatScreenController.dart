import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../TokenManager.dart';
import 'chat_service.dart';

class ChatScreenController extends GetxController {
  var salesmanName = ''.obs;
  var adminName = ''.obs;
  var chatRoomName = ''.obs;
  var roomId = ''.obs;
  late IO.Socket socket;
  var messages = <Message>[].obs;
  final isLoading = false.obs;
  late final SocketService socketService;

  @override
  void onInit() {
    socketService = SocketService();
    initSocket();
    getOldChats();
    // TODO: implement onInit
    super.onInit();
  }

  void initSocket() async {
    String? token = await TokenManager.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    adminName.value = decodedToken['chatusername'];
    salesmanName.value = decodedToken['username'];

    socketService.connect(token);

    final sortedUsers = [adminName.value, salesmanName.value]..sort();
    roomId.value = "${sortedUsers[0]}_${sortedUsers[1]}";
    socketService.joinRoom(roomId.value, salesmanName.value);

    socketService.onReceiveMessage((data) {
      // final message = types.TextMessage(
      //   id: const Uuid().v4(),
      //   author: types.User(id: data['sender'], firstName: salesmanName),
      //   createdAt: DateTime.now().millisecondsSinceEpoch,
      //   text: data['message'],
      // );
      // final message = Message.fromJson(data);
      final message = Message(
          text: data['message'],
          isUserMessage: data['receiver'] == salesmanName.value ? false : true,
          reciever: data['receiver']);

      messages.add(message);
      print("recieved message =========>>>>>>> ${data}");
    });
  }

  void getOldChats() async {
    isLoading.value = true;
    try {
      String? token = await TokenManager.getToken();

      final sortedUsers = [adminName.value, salesmanName.value]..sort();
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
        final messagesList = dataList
            .map((item) => Message(
                text: item['Message'],
                isUserMessage:
                    item['receiver'] == salesmanName.value ? false : true,
                reciever: item['receiver']))
            .toList();
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
}

class Message {
  String? text;
  bool? isUserMessage;
  String? reciever;

  Message({this.text, this.isUserMessage, this.reciever});

  Message.fromJson(Map<String, dynamic> json) {
    text = json['Message'];
    reciever = json['receiver'];
  }
}
