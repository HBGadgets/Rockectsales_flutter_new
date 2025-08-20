import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
      "https://salestrack.rocketsalestracker.com", // your backend SOCKET URL
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setQuery({'token': token}) // pass token if backend checks auth
          .enableAutoConnect()
          .build(),
    );

    socket.onConnect((_) {
      print("✅ Connected to socket server");
    });

    socket.onDisconnect((_) {
      print("❌ Disconnected from socket server");
    });
  }

  void joinRoom(String room, String username) {
    socket.emit('joinRoom', {
      "room": room,
      "username": username,
    });
  }

  void sendMessage(
      String room, String message, String sender, String receiver) {
    socket.emit('sendMessage', {
      "room": room,
      "message": message,
      "sender": sender,
      "receiver": receiver,
    });
  }

  void onReceiveMessage(Function(Map<String, dynamic>) callback) {
    socket.on("receiveMessage", (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }
}
