import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  late IO.Socket socket;

  void connect(String userId, String otherUserId) {
    socket = IO.io("${dotenv.env['BASE_URL']}", {
      "transports": ["websocket"],
      "autoConnect": false,
    });

    socket.connect();

    socket.onConnect((_) {
      print("✅ Connected to socket");

      // Join a private room between two users
      socket.emit("joinRoom", {
        "userId": userId,
        "otherUserId": otherUserId,
      });
    });
  }

  void sendMessage(String sender, String receiver, String message) {
    socket.emit("chatMessage", {
      "sender": sender,
      "receiver": receiver,
      "message": message,
    });
  }

  void onMessage(Function(dynamic) callback) {
    socket.on("chatMessage", callback);
  }

  void disconnect() {
    socket.disconnect();
  }
}
