import 'dart:async';
import '../network/websocket_client.dart';
import '../../domain/repositories/character_repository.dart';
import '../../domain/entities/character.dart';

class GameService {
  final WebSocketClient _webSocket;
  final CharacterRepository _characterRepository;
  Character? currentCharacter;
  final _gameStateController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get gameStateStream => _gameStateController.stream;

  GameService({
    required WebSocketClient webSocket,
    required CharacterRepository characterRepository,
  })  : _webSocket = webSocket,
        _characterRepository = characterRepository {
    _setupWebSocket();
  }

  void _setupWebSocket() {
    _webSocket.onMessage = _handleGameMessage;
    _webSocket.onConnect = () {
      print('Connected to game server');
      if (currentCharacter != null) {
        _sendPlayerState();
      }
    };
    _webSocket.onDisconnect = () {
      print('Disconnected from game server');
      // Attempt to reconnect after a delay
      Future.delayed(const Duration(seconds: 5), () {
        if (!_webSocket.isConnected) {
          _webSocket.connect();
        }
      });
    };
  }

  void _handleGameMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'playerUpdate':
        _handlePlayerUpdate(message['data']);
        break;
      case 'combat':
        _handleCombatUpdate(message['data']);
        break;
      case 'chat':
        _handleChatMessage(message['data']);
        break;
      default:
        print('Unknown message type: ${message['type']}');
    }
    
    // Broadcast the game state update
    _gameStateController.add(message);
  }

  void _handlePlayerUpdate(Map<String, dynamic> data) {
    // Update local player state
    if (currentCharacter?.id == data['id']) {
      // TODO: Update character stats, position, etc.
    }
  }

  void _handleCombatUpdate(Map<String, dynamic> data) {
    // Handle combat events (damage, healing, etc.)
  }

  void _handleChatMessage(Map<String, dynamic> data) {
    // Handle incoming chat messages
  }

  void _sendPlayerState() {
    if (currentCharacter != null) {
      _webSocket.send({
        'type': 'playerState',
        'data': {
          'id': currentCharacter!.id,
          'position': {
            'x': currentCharacter!.position.x,
            'y': currentCharacter!.position.y,
          },
          'stats': {
            'health': currentCharacter!.health,
            'mana': currentCharacter!.mana,
          },
        },
      });
    }
  }

  Future<void> initializeCharacter(String characterId) async {
    final result = await _characterRepository.getCharacter(characterId);
    result.fold(
      (failure) {
        print('Failed to initialize character: $failure');
      },
      (character) {
        currentCharacter = character;
        if (_webSocket.isConnected) {
          _sendPlayerState();
        } else {
          _webSocket.connect();
        }
      },
    );
  }

  void updatePlayerPosition(double x, double y, String map) {
    if (currentCharacter != null) {
      _webSocket.sendPlayerMovement(x, y, map);
    }
  }

  void performCombatAction(String targetId, String? skillId) {
    if (currentCharacter != null) {
      _webSocket.send({
        'type': 'combat',
        'data': {
          'actionType': 'attack',
          'targetId': targetId,
          'skillId': skillId,
        },
      });
    }
  }

  void sendChatMessage(String message, String channel) {
    _webSocket.sendChatMessage(message, channel);
  }

  void dispose() {
    _webSocket.disconnect();
    _gameStateController.close();
  }
}
