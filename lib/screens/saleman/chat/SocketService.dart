import 'dart:async';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  SocketService._private();

  static final SocketService instance = SocketService._private();

  IO.Socket? _socket;
  final StreamController<Map<String, dynamic>> _msgController =
      StreamController.broadcast();

  Stream<Map<String, dynamic>> get messages => _msgController.stream;

  /// Connect to socket.io server
  void connect(String url,
      {Map<String, dynamic>? query, Map<String, String>? extraHeaders}) {
    // Example options; use websocket transport
    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': query ?? {},
      'extraHeaders': extraHeaders ?? {},
      // you may add 'path' or other options if your server uses a custom path
    });

    _socket!.on('connect', (_) {
      print('socket connected: ${_socket!.id}');
    });
    _socket!.on('disconnect', (_) {
      print('socket disconnected');
    });
    _socket!.on('connect_error', (err) {
      print('connect_error: $err');
    });

    // Listen for the named event (server should emit 'receiveMessage')
    _socket!.on('receiveMessage', _handleIncoming);

    // Also add a fallback generic listener in case server uses raw packets or arrays:
    _socket!.on('message', (data) => print('generic message: $data'));

    _socket!.connect();
  }

  /// Join a room
  void joinRoom({required String room, required String username}) {
    if (_socket == null) return;
    final payload = {'room': room, 'username': username};
    _socket!.emit('joinRoom', payload);
    print('emit joinRoom -> $payload');
  }

  /// Send message to server
  void sendMessage({
    required String room,
    required String message,
    required String sender,
    required String receiver,
    String? id,
  }) {
    print("trying sending");
    if (_socket == null) {
      print('socket is null');
    }
    ;
    final payload = {
      'Message': message,
      'sender': sender,
      'receiver': receiver,
      'room': room,
      if (id != null) '_id': id,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    };
    _socket!.emit('sendMessage', payload);
    print('emit sendMessage -> $payload');
  }

  void _handleIncoming(dynamic data) {
    // Handle server sending either:
    // 1) ["receiveMessage", { ... }]  (raw array)
    // 2) { ... }                      (object directly)
    try {
      Map<String, dynamic> payload;

      if (data is List && data.length >= 2) {
        // raw socket.io transport array: ["eventName", { payload }]
        final maybeMap = data[1];
        if (maybeMap is Map) {
          payload = Map<String, dynamic>.from(maybeMap);
        } else if (maybeMap is String) {
          payload = Map<String, dynamic>.from(json.decode(maybeMap));
        } else {
          print('unknown payload type in array: ${maybeMap.runtimeType}');
          return;
        }
      } else if (data is Map) {
        payload = Map<String, dynamic>.from(data);
      } else if (data is String) {
        // maybe JSON string
        final decoded = json.decode(data);
        if (decoded is List && decoded.length >= 2) {
          payload = Map<String, dynamic>.from(decoded[1]);
        } else if (decoded is Map) {
          payload = Map<String, dynamic>.from(decoded);
        } else {
          print('unknown decoded payload: $decoded');
          return;
        }
      } else {
        print('Unhandled incoming message type: ${data.runtimeType}');
        return;
      }

      // Normalize keys: server might use "Message" or "message"
      final normalized = <String, dynamic>{};
      normalized.addAll(payload);
      if (payload.containsKey('Message') && !payload.containsKey('message')) {
        normalized['message'] = payload['Message'];
      }

      // Push to stream for UI
      _msgController.add(normalized);
    } catch (e, st) {
      print('Error parsing incoming socket data: $e\n$st');
    }
  }

  void dispose() {
    _msgController.close();
    _socket?.disconnect();
    _socket = null;
  }
}
