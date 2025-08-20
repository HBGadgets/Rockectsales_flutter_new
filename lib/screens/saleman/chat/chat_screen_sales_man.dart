import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/chat/ChatScreenController.dart';
import '../../../utils/token_manager.dart';
import 'chat_service.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final List<types.Message> _messages = [];
  late SocketService socketService;
  late String roomId;
  late String salesmanName;
  late String adminName;

  final ChatScreenController controller =
      Get.put(ChatScreenController(), permanent: false);

  @override
  void initState() {
    super.initState();
    socketService = SocketService();
    getToken().then((token) {
      print(token);
      socketService.connect(token ?? '');

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      setState(() {
        adminName = decodedToken['chatusername'];
        salesmanName = decodedToken['username'];
      });
      final sortedUsers = [adminName, salesmanName]..sort();
      roomId = "${sortedUsers[0]}_${sortedUsers[1]}";
      socketService.joinRoom(roomId, salesmanName);

      socketService.onReceiveMessage((data) {
        final message = types.TextMessage(
          id: const Uuid().v4(),
          author: types.User(id: data['sender'], firstName: salesmanName),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          text: data['message'],
        );
        setState(() {
          controller.messages.insert(0, message);
        });
      });
    });
  }

  Future<String?> getToken() async {
    String? token = await TokenManager.getToken();
    return token;
  }

  void _handleSendPressed(String message) {
    socketService.sendMessage(roomId, message, salesmanName, adminName);

    final textMessage = types.TextMessage(
      id: const Uuid().v4(),
      author: types.User(id: salesmanName),
      createdAt: DateTime.now().millisecondsSinceEpoch,
      text: message,
    );

    setState(() {
      controller.messages.insert(0, textMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat with Admin",
          style: TextStyle(color: Colors.white),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.messages.isEmpty) {
                return const Center(child: Text("No messages found."));
              } else {
                return ListView.builder(
                  reverse: true, // so newest messages appear at the bottom
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final messageItem = controller.messages[index];
                    final isSender =
                        messageItem.author.firstName == salesmanName
                            ? true
                            : false;
                    final reversedIndex =
                        controller.messages.length - 1 - index;
                    final message = controller.messages[reversedIndex];
                    return BubbleSpecialThree(
                      text: message.text ?? '',
                      isSender: isSender,
                      color: isSender ? Color(0xFF1B97F3) : Color(0xFFE8E8EE),
                      tail: true,
                      textStyle: isSender
                          ? TextStyle(color: Colors.white, fontSize: 16)
                          : TextStyle(fontSize: 16),
                    );
                  },
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: MessageBar(
              onSend: (msg) => _handleSendPressed(msg),
            ),
          ),
        ],
      ),
      // body: Chat(
      //   messages: controller.messages,
      //   onSendPressed: _handleSendPressed,
      //   user: types.User(id: salesmanName),
      // ),
    );
  }
}
