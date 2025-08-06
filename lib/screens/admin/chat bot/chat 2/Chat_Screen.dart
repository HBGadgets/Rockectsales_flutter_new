import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatelessWidget {
  final List<Message> messages = [
    Message(text: 'Hii Karan', isUserMessage: true),
    Message(text: 'Hello sir', isUserMessage: false),
  ];

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
      ),

      body: Column(
        children: [
          // Profile header
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/person_1.png'),
                  radius: 28,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Karan Sharma',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )),
                    Row(
                      children: [
                        Text('Active',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        SizedBox(width: 5),
                        Icon(Icons.circle, size: 10, color: Colors.green),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Chat messages
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: messages[index]);
              },
            ),
          ),
          // Message input
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  width: 270,
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      // icon: Icon(Icons.),
                      hintText: 'Message...',
                      border: InputBorder.none, // Remove default border
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                ),
                // const Expanded(
                //   child: TextField(
                //     decoration: InputDecoration(
                //       hintText: 'Message...',
                //       border: OutlineInputBorder(),
                //       contentPadding:
                //           EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 5),
                ClipOval(
                  child: Container(
                    width: 40.0, // Size of the button
                    height: 40.0, // Size of the button
                    decoration: BoxDecoration(
                      color: Colors.white70, // Background color
                      border: Border.all(
                        color: Colors.grey.shade200, // Border color
                        width: 2.0, // Border width
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      splashColor: Colors.white, // Splash color
                      onTap: () {
                        // Handle sending message
                      },
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.green, // Icon color
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
      message.isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color:
          message.isUserMessage ? Colors.lightGreen[100] : Colors.blue[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUserMessage;

  Message({required this.text, required this.isUserMessage});
}




