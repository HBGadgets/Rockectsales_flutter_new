import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'chat_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<types.Message> _messages = [];
  late final types.User _user;
  late final ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _user = types.User(id: widget.currentUserId);
    _chatService = ChatService();

    _chatService.connect(widget.currentUserId, widget.otherUserId);

    // Listen for incoming messages
    _chatService.onMessage((data) {
      final message = types.TextMessage(
        id: const Uuid().v4(),
        author: types.User(id: data['sender']),
        text: data['message'],
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      setState(() {
        _messages.insert(0, message);
      });
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      id: const Uuid().v4(),
      author: _user,
      text: message.text,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });

    // Send via socket
    _chatService.sendMessage(
      widget.currentUserId,
      widget.otherUserId,
      message.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
      ),
    );
  }

  @override
  void dispose() {
    _chatService.disconnect();
    super.dispose();
  }
}
