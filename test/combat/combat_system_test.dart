import 'package:flutter_test/flutter_test.dart';
import 'package:flame/components.dart';
import '../../lib/scripts/combat/combat_system.dart';

// Simple stub classes to satisfy GameService dependencies
class MockWebSocketClient {
  void send(Map<String, dynamic> data) {}
  void sendChatMessage(String message, String channel) {}
  void disconnect() {}
  bool get isConnected => true;
  void connect() {}
}

class MockCharacterRepository {}

class MockGameService {
  final MockWebSocketClient _webSocket = MockWebSocketClient();
  final MockCharacterRepository _characterRepository = MockCharacterRepository();

  void performCombatAction(String targetId, String? skillId) {
    // Stub method to satisfy CombatSystem calls
  }
}

void main() {
  group('CombatSystem Tests', () {
    late CombatSystem combatSystem;
    late MockGameService mockGameService;

    setUp(() {
      mockGameService = MockGameService();
      combatSystem = CombatSystem(mockGameService);

      // Register two entities: attacker and target
      combatSystem.registerEntity(
        'attacker',
        Vector2(0, 0),
        isPlayer: true,
        health: 100,
        attackPower: 10,
        defense: 5,
      );
      combatSystem.registerEntity(
        'target',
        Vector2(10, 0), // Initially out of attack range (50.0)
        isPlayer: false,
        health: 100,
        attackPower: 8,
        defense: 3,
      );
    });

    test('Entities are registered correctly', () {
      expect(combatSystem.entities.containsKey('attacker'), isTrue);
      expect(combatSystem.entities.containsKey('target'), isTrue);
    });

    test('Attack within range reduces target health', () {
      // Move target within attack range
      combatSystem.updateEntityPosition('target', Vector2(5, 0));

      // Simulate attack event
      combatSystem.handleCombatEvent({
        'actionType': 'attack',
        'sourceId': 'attacker',
        'targetId': 'target',
        'damage': null,
      });

      final target = combatSystem.entities['target']!;
      expect(target.health, lessThan(100));
      expect(target.isAlive, isTrue);
    });

    test('Attack out of range does not reduce target health', () {
      // Target is at 10 units, which is within attack range 50.0, so move it farther
      combatSystem.updateEntityPosition('target', Vector2(100, 0));

      // Simulate attack event
      combatSystem.handleCombatEvent({
        'actionType': 'attack',
        'sourceId': 'attacker',
        'targetId': 'target',
        'damage': null,
      });

      final target = combatSystem.entities['target']!;
      expect(target.health, equals(100));
      expect(target.isAlive, isTrue);
    });

    test('Damage event reduces target health', () {
      combatSystem.handleCombatEvent({
        'actionType': 'damage',
        'sourceId': 'attacker',
        'targetId': 'target',
        'damage': 30,
      });

      final target = combatSystem.entities['target']!;
      expect(target.health, equals(70));
      expect(target.isAlive, isTrue);
    });

    test('Target dies when health reaches zero', () {
      combatSystem.handleCombatEvent({
        'actionType': 'damage',
        'sourceId': 'attacker',
        'targetId': 'target',
        'damage': 100,
      });

      final target = combatSystem.entities['target']!;
      expect(target.health, equals(0));
      expect(target.isAlive, isFalse);
    });

    test('Perform attack resets lastAttackTime', () {
      combatSystem.update(2.0); // Increase lastAttackTime to 2.0
      expect(combatSystem.lastAttackTime, 2.0);

      final attacker = combatSystem.entities['attacker']!;
      final target = combatSystem.entities['target']!;

      combatSystem.performAttack(attacker, target, null);

      expect(combatSystem.lastAttackTime, 0.0);
    });
  });
}
