import 'package:flutter_test/flutter_test.dart';
import '../../lib/scripts/ai/ai_controller.dart';
import '../../lib/scripts/combat/combat_system.dart';

void main() {
  group('Static NPC AI Tests', () {
    late StaticNPCBehavior npcBehavior;

    setUp(() {
      npcBehavior = StaticNPCBehavior(
        position: const Offset(10, 10),
        interactionRange: 5.0,
        dialogues: {
          'greeting': 'Hello adventurer!',
          'quest': 'Will you help me?',
        },
        shopInventory: {
          'potion': {'price': 10, 'quantity': 5},
          'sword': {'price': 100, 'quantity': 1},
        },
      );
    });

    test('NPC detects player in range', () {
      npcBehavior.onPlayerDetected(const Offset(12, 12));
      expect(npcBehavior.isPlayerInRange, isTrue);
    });

    test('NPC does not detect player out of range', () {
      npcBehavior.onPlayerDetected(const Offset(20, 20));
      expect(npcBehavior.isPlayerInRange, isFalse);
    });

    test('NPC loses player detection', () {
      npcBehavior.onPlayerDetected(const Offset(12, 12));
      expect(npcBehavior.isPlayerInRange, isTrue);
      
      npcBehavior.onPlayerLost();
      expect(npcBehavior.isPlayerInRange, isFalse);
    });

    test('NPC dialogue system', () {
      expect(npcBehavior.getDialogue('greeting'), equals('Hello adventurer!'));
      expect(npcBehavior.getDialogue('quest'), equals('Will you help me?'));
      expect(npcBehavior.getDialogue('invalid'), equals(''));
    });

    test('NPC shop inventory', () {
      expect(npcBehavior.hasItem('potion'), isTrue);
      expect(npcBehavior.hasItem('sword'), isTrue);
      expect(npcBehavior.hasItem('shield'), isFalse);
    });
  });

  group('Companion AI Tests', () {
    late CompanionBehavior companionBehavior;

    setUp(() {
      companionBehavior = CompanionBehavior(
        currentPosition: const Offset(0, 0),
        moveSpeed: 5.0,
        supportSkills: [],
        combatSkills: [],
      );
    });

    test('Companion follows player when not in combat', () {
      companionBehavior.onPlayerDetected(const Offset(10, 10));
      expect(companionBehavior.targetPosition, equals(const Offset(10, 10)));
      expect(companionBehavior.isInCombat, isFalse);
    });

    test('Companion loses player tracking', () {
      companionBehavior.onPlayerDetected(const Offset(10, 10));
      companionBehavior.onPlayerLost();
      expect(companionBehavior.targetPosition, isNull);
    });

    test('Companion responds to ally needs help', () {
      companionBehavior.isInCombat = true;
      companionBehavior.onAllyNeedsHelp(const Offset(15, 15), 0.2);
      
      expect(companionBehavior.targetPosition, equals(const Offset(15, 15)));
      expect(companionBehavior.isInCombat, isFalse);
    });
  });

  group('Tactical Combat AI Tests', () {
    late TacticalCombatBehavior enemyBehavior;

    setUp(() {
      enemyBehavior = TacticalCombatBehavior(
        currentPosition: const Offset(0, 0),
        moveSpeed: 3.0,
        difficulty: AIDifficulty.normal,
        skills: [],
      );
    });

    test('Enemy aggro range detection', () {
      // Player outside aggro range
      enemyBehavior.onPlayerDetected(const Offset(10, 10));
      expect(enemyBehavior.isAggro, isFalse);
      expect(enemyBehavior.targetPosition, isNull);

      // Player inside aggro range
      enemyBehavior.onPlayerDetected(const Offset(5, 5));
      expect(enemyBehavior.isAggro, isTrue);
      expect(enemyBehavior.targetPosition, equals(const Offset(5, 5)));
    });

    test('Enemy loses aggro', () {
      enemyBehavior.onPlayerDetected(const Offset(5, 5));
      expect(enemyBehavior.isAggro, isTrue);

      enemyBehavior.onPlayerLost();
      expect(enemyBehavior.isAggro, isFalse);
      expect(enemyBehavior.targetPosition, isNull);
    });

    test('Enemy updates combat stats', () {
      enemyBehavior.onTakeDamage(25.0, 'player');
      
      expect(enemyBehavior.combatStats['lastDamageTaken'], equals(25.0));
      expect(enemyBehavior.combatStats['totalDamageTaken'], equals(25.0));
    });
  });

  group('AI Controller System Tests', () {
    late AIController aiController;
    late CombatSystem combatSystem;

    setUp(() {
      combatSystem = CombatSystem();
      aiController = AIController(combatSystem);
    });

    test('Register and track multiple AI entities', () {
      final npc = StaticNPCBehavior(position: const Offset(0, 0));
      final monster = TacticalCombatBehavior(
        currentPosition: const Offset(5, 5),
        moveSpeed: 3.0,
        difficulty: AIDifficulty.normal,
        skills: [],
      );
      final companion = CompanionBehavior(
        currentPosition: const Offset(2, 2),
        moveSpeed: 4.0,
        supportSkills: [],
        combatSkills: [],
      );

      aiController.addNPC('merchant', npc);
      aiController.addMonster('goblin', monster);
      aiController.addCompanion('pet', companion);

      expect(aiController.isPlayerInRangeOfNPC('merchant'), isFalse);
      expect(aiController.getAggroMonsters().isEmpty, isTrue);

      // Simulate player movement
      aiController.update(0.016, const Offset(5, 5));

      // Check monster aggro
      expect(aiController.getAggroMonsters().contains('goblin'), isTrue);
    });
  });
}
