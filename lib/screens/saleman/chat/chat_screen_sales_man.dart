import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/saleman/Attendance/Attendance_Page.dart';
import 'package:rocketsale_rs/screens/saleman/chat/ChatScreenController.dart';
import 'package:rocketsale_rs/utils/token_manager.dart';
import 'package:uuid/uuid.dart';

import '../../admin/chat bot/chat 2/Chat_Screen.dart';
import 'SocketService.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatScreenController controller = Get.put(ChatScreenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
          ),
          backgroundColor: MyColor.dashbord,
          title: Text(
            'Chat with Admin',
            style: TextStyle(color: Colors.white),
          )),
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
                        messageItem.reciever == controller.salesManName
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
              onSend: (msg) => print(msg),
            ),
          ),
        ],
      ),
    );
  }
}
