import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../resources/my_colors.dart';
import 'ChatScreenController.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatScreenController controller =
      Get.put(ChatScreenController(), permanent: false);

  void _handleSendPressed(String message) {
    controller.socketService.sendMessage(controller.roomId.value, message,
        controller.salesmanName.value, controller.adminName.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat with Admin",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
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
                    final reversedIndex =
                        controller.messages.length - 1 - index;
                    final message = controller.messages[reversedIndex];
                    final isSender = message.isUserMessage!;
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
    );
  }
}
