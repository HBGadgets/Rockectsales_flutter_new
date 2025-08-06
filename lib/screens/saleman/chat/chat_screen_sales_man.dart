import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/token_manager.dart';

class ChatScreenSalesMan extends StatefulWidget {
  const ChatScreenSalesMan({super.key});

  @override
  _ChatScreenSalesManState createState() => _ChatScreenSalesManState();
}

class _ChatScreenSalesManState extends State<ChatScreenSalesMan> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = ['Hii', 'Hello sir', 'gfggddff', 'sssssss'];
  String adminName = 'Admin';

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  Future<void> _loadAdminName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      adminName = prefs.getString('adminName') ?? 'Admin';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAdminName();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Adjust the height as needed
          Container(
            height: screenHeight * 0.1,
            // 10% of the screen height
            width: screenWidth * 0.5,
            // Adjust this multiplier to reduce the width
            padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey, // Change this color to whatever you prefer
                width: 1.2, // Adjust the width of the border as needed
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'adminName',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Makes the text bold
                    fontSize: 20, // Sets the font size of the text
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 24, // Sets the size of the icon
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.circle,
                  color: Colors.green,
                  size: 15,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(_messages[index]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                GestureDetector(
                  onTap: _sendMessage,
                  child: const CircleAvatar(
                    radius: 24.0,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
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
