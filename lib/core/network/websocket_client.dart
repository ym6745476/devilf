import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class WebSocketClient {
  WebSocketChannel? _channel;
  final String baseUrl;
  
  // Callback handlers
  void Function(Map<String, dynamic>)? _messageHandler;
  void Function()? _connectHandler;
  void Function()? _disconnectHandler;

  WebSocketClient({
    required this.baseUrl,
  });

  bool get isConnected => _channel != null;

  // Callback setters
  set onMessage(void Function(Map<String, dynamic>)? handler) {
    _messageHandler = handler;
  }

  set onConnect(void Function()? handler) {
    _connectHandler = handler;
  }

  set onDisconnect(void Function()? handler) {
    _disconnectHandler = handler;
  }

  Future<void> connect() async {
    try {
      final wsUrl = baseUrl.replaceFirst('http', 'ws');
      _channel = WebSocketChannel.connect(Uri.parse('$wsUrl/game'));
      
      _channel?.stream.listen(
        (message) {
          final data = json.decode(message as String) as Map<String, dynamic>;
          _messageHandler?.call(data);
        },
        onDone: () {
          _disconnectHandler?.call();
          _channel = null;
        },
        onError: (error) {
          print('WebSocket Error: $error');
          _disconnectHandler?.call();
          _channel = null;
        },
      );

      _connectHandler?.call();
    } catch (e) {
      print('WebSocket Connection Error: $e');
      _disconnectHandler?.call();
      _channel = null;
      rethrow;
    }
  }

  void send(Map<String, dynamic> data) {
    if (_channel != null) {
      _channel!.sink.add(json.encode(data));
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _disconnectHandler?.call();
  }

  // Game-specific message handlers
  void sendPlayerMovement(double x, double y, String map) {
    send({
      'type': 'game_action',
      'data': {
        'action': 'move',
        'actionData': {
          'position': {'x': x, 'y': y, 'map': map},
        },
      },
    });
  }

  void sendCombatAction(String actionType, String targetId, String? skillId) {
    send({
      'type': 'game_action',
      'data': {
        'action': 'attack',
        'actionData': {
          'targetId': targetId,
          'skillId': skillId,
        },
      },
    });
  }

  void sendChatMessage(String message, String channel) {
    send({
      'type': 'chat',
      'data': {
        'message': message,
        'channel': channel,
      },
    });
  }
}
