import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import '../chat 2/Chat_Screen.dart';

class ChatBotScreen extends StatelessWidget {
  final List<ChatBotUser> users = [
    ChatBotUser(name: 'Karan Sharma', id: 'ID-0001', status: 'On field', isActive: true),
    ChatBotUser(name: 'Karan Sharma', id: 'ID-0001', status: 'On field', isActive: true),
    ChatBotUser(name: 'Karan Sharma', id: 'ID-0001', status: 'Inactive', isActive: false),
    ChatBotUser(name: 'Karan Sharma', id: 'ID-0001', status: 'Inactive', isActive: false),
    // Add more users as needed
  ];

  ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('Chat Bot', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              width: double.infinity, // Full width
              height: 50.0,
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
                  icon: Icon(Icons.search),
                  hintText: 'Search...',
                  border: InputBorder.none, // Remove default border
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ChatUserTile(user: users[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUserTile extends StatelessWidget {
  final ChatBotUser user;

  const ChatUserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      elevation: 5.0,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/person_1.png'),
          radius: 25,
        ),
        title: Text(user.name),
        subtitle: Text(
          'ID: ${user.id}\n'
              'Status: ${user.status}',
          style: const TextStyle(
            fontSize: 14, // Optional: adjust as needed
            color: Colors.grey, // Optional: adjust as needed
          ),
        ),
        // subtitle: Text(
        //   user.status,
        //   style: const TextStyle(
        //     fontSize: 14, // Optional: adjust as needed
        //     color: Colors.grey, // Optional: adjust as needed
        //   ),
        // ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              user.isActive ? Icons.circle : Icons.circle_outlined,
              color: user.isActive ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.message),
              onPressed: () {
                // Navigate to the message screen using GetX
                Get.to(() => ChatScreen());
              },
            ),

          ],
        ),
      ),
    );
  }
}

class ChatBotUser {
  final String name;
  final String id;
  final String status;
  final bool isActive;

  ChatBotUser({
    required this.name,
    required this.id,
    required this.status,
    required this.isActive,
  });
}