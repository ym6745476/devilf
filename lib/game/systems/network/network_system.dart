import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:arabic_mmorpg/game/components/player/player_component.dart';
import 'package:arabic_mmorpg/game/components/player/other_player_component.dart';
import 'package:arabic_mmorpg/game/worlds/game_world.dart';
import 'package:flame/components.dart';

/// System that handles network communication for multiplayer functionality
class NetworkSystem {
  // WebSocket connection
  WebSocketChannel? _channel;
  bool _isConnected = false;
  
  // Player reference
  PlayerComponent? _player;
  
  // Game world reference
  GameWorld? _gameWorld;
  
  // Server URL
  String _serverUrl = 'wss://game-server.example.com/ws';
  
  // Player position update interval
  final double _positionUpdateInterval = 0.1; // seconds
  double _timeSinceLastPositionUpdate = 0.0;
  
  // Authentication token
  String? _authToken;
  
  // Constructor
  NetworkSystem();
  
  // Connect to the game server
  Future<bool> connect(String serverUrl, String authToken) async {
    _serverUrl = serverUrl;
    _authToken = authToken;
    
    try {
      // Connect to WebSocket server
      _channel = WebSocketChannel.connect(Uri.parse(_serverUrl));
      
      // Set up message handler
      _channel!.stream.listen(
        _handleMessage,
        onError: _handleError,
        onDone: _handleDisconnect,
      );
      
      // Send authentication message
      _sendMessage({
        'type': 'auth',
        'token': _authToken,
      });
      
      _isConnected = true;
      return true;
    } catch (e) {
      print('Failed to connect to server: $e');
      _isConnected = false;
      return false;
    }
  }
  
  // Disconnect from the game server
  void disconnect() {
    if (_channel != null) {
      _sendMessage({
        'type': 'logout',
      });
      
      _channel!.sink.close();
      _channel = null;
    }
    
    _isConnected = false;
  }
  
  // Set player reference
  void setPlayer(PlayerComponent player) {
    _player = player;
  }
  
  // Set game world reference
  void setGameWorld(GameWorld gameWorld) {
    _gameWorld = gameWorld;
  }
  
  // Update method called every frame
  void update(double dt) {
    if (!_isConnected || _player == null) return;
    
    // Update position send timer
    _timeSinceLastPositionUpdate += dt;
    
    // Send player position update at regular intervals
    if (_timeSinceLastPositionUpdate >= _positionUpdateInterval) {
      _sendPlayerPosition();
      _timeSinceLastPositionUpdate = 0.0;
    }
  }
  
  // Send player position to server
  void _sendPlayerPosition() {
    if (!_isConnected || _player == null) return;
    
    _sendMessage({
      'type': 'position',
      'x': _player!.position.x,
      'y': _player!.position.y,
      'state': _player!.current.toString(),
    });
  }
  
  // Send chat message to server
  void sendChatMessage(String message, String channel) {
    if (!_isConnected) return;
    
    _sendMessage({
      'type': 'chat',
      'message': message,
      'channel': channel,
    });
  }
  
  // Send attack action to server
  void sendAttackAction(String targetId, String attackType) {
    if (!_isConnected) return;
    
    _sendMessage({
      'type': 'attack',
      'targetId': targetId,
      'attackType': attackType,
    });
  }
  
  // Send spell cast action to server
  void sendSpellCastAction(String spellId, String targetId) {
    if (!_isConnected) return;
    
    _sendMessage({
      'type': 'cast',
      'spellId': spellId,
      'targetId': targetId,
    });
  }
  
  // Send item use action to server
  void sendItemUseAction(String itemId, String? targetId) {
    if (!_isConnected) return;
    
    final message = {
      'type': 'useItem',
      'itemId': itemId,
    };
    
    if (targetId != null) {
      message['targetId'] = targetId;
    }
    
    _sendMessage(message);
  }
  
  // Send message to server
  void _sendMessage(Map<String, dynamic> message) {
    if (!_isConnected || _channel == null) return;
    
    final jsonMessage = jsonEncode(message);
    _channel!.sink.add(jsonMessage);
  }
  
  // Handle incoming message from server
  void _handleMessage(dynamic message) {
    if (_gameWorld == null) return;
    
    try {
      final data = jsonDecode(message);
      final messageType = data['type'];
      
      switch (messageType) {
        case 'auth_response':
          _handleAuthResponse(data);
          break;
        case 'player_joined':
          _handlePlayerJoined(data);
          break;
        case 'player_left':
          _handlePlayerLeft(data);
          break;
        case 'player_position':
          _handlePlayerPosition(data);
          break;
        case 'chat_message':
          _handleChatMessage(data);
          break;
        case 'attack':
          _handleAttack(data);
          break;
        case 'damage':
          _handleDamage(data);
          break;
        case 'monster_spawn':
          _handleMonsterSpawn(data);
          break;
        case 'monster_despawn':
          _handleMonsterDespawn(data);
          break;
        case 'item_drop':
          _handleItemDrop(data);
          break;
        case 'error':
          _handleError(data['message']);
          break;
        default:
          print('Unknown message type: $messageType');
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }
  
  // Handle authentication response
  void _handleAuthResponse(Map<String, dynamic> data) {
    final success = data['success'];
    
    if (success) {
      print('Authentication successful');
      
      // Request initial game state
      _sendMessage({
        'type': 'request_game_state',
      });
    } else {
      print('Authentication failed: ${data['message']}');
      disconnect();
    }
  }
  
  // Handle player joined event
  void _handlePlayerJoined(Map<String, dynamic> data) {
    if (_gameWorld == null) return;
    
    final playerId = data['playerId'];
    final playerName = data['playerName'];
    final playerClass = data['playerClass'];
    final x = data['x'].toDouble();
    final y = data['y'].toDouble();
    
    // Create other player component
    final otherPlayer = OtherPlayerComponent(
      playerId: playerId,
      name: playerName,
      characterClass: playerClass,
      position: Vector2(x, y),
    );
    
    // Add to game world
    _gameWorld!.addOtherPlayer(otherPlayer);
  }
  
  // Handle player left event
  void _handlePlayerLeft(Map<String, dynamic> data) {
    if (_gameWorld == null) return;
    
    final playerId = data['playerId'];
    
    // Remove from game world
    _gameWorld!.removeOtherPlayer(playerId);
  }
  
  // Handle player position update
  void _handlePlayerPosition(Map<String, dynamic> data) {
    if (_gameWorld == null) return;
    
    final playerId = data['playerId'];
    final x = data['x'].toDouble();
    final y = data['y'].toDouble();
    final state = data['state'];
    
    // Find player in game world
    final players = _gameWorld!.otherPlayers;
    final player = players.firstWhere(
      (p) => p.playerId == playerId,
      orElse: () => null as OtherPlayerComponent,
    );
    
    if (player != null) {
      // Update position
      player.position = Vector2(x, y);
      
      // Update state if provided
      if (state != null) {
        player.setState(state);
      }
    }
  }
  
  // Handle chat message
  void _handleChatMessage(Map<String, dynamic> data) {
    final senderId = data['senderId'];
    final senderName = data['senderName'];
    final message = data['message'];
    final channel = data['channel'];
    
    // TODO: Display chat message in UI
    print('[$channel] $senderName: $message');
  }
  
  // Handle attack event
  void _handleAttack(Map<String, dynamic> data) {
    // TODO: Implement attack visualization
  }
  
  // Handle damage event
  void _handleDamage(Map<String, dynamic> data) {
    // TODO: Implement damage visualization
  }
  
  // Handle monster spawn event
  void _handleMonsterSpawn(Map<String, dynamic> data) {
    // TODO: Implement monster spawning
  }
  
  // Handle monster despawn event
  void _handleMonsterDespawn(Map<String, dynamic> data) {
    // TODO: Implement monster despawning
  }
  
  // Handle item drop event
  void _handleItemDrop(Map<String, dynamic> data) {
    // TODO: Implement item drop visualization
  }
  
  // Handle WebSocket error
  void _handleError(dynamic error) {
    print('WebSocket error: $error');
  }
  
  // Handle WebSocket disconnect
  void _handleDisconnect() {
    print('Disconnected from server');
    _isConnected = false;
    _channel = null;
    
    // TODO: Show reconnect dialog
  }
  
  // Check if connected to server
  bool get isConnected => _isConnected;
}