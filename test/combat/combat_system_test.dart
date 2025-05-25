import 'package:flutter_test/flutter_test.dart';
import '../../lib/scripts/combat/combat_system.dart';

// Mock combat entity for testing
class MockCombatEntity extends CombatEntity {
  MockCombatEntity({
    required double maxHealth,
    required double maxMana,
    required double attackPower,
    required double defense,
    required Offset position,
  }) : super(
    maxHealth: maxHealth,
    maxMana: maxMana,
    attackPower: attackPower,
    defense: defense,
    position: position,
    skills: [],
  );
}

void main() {
  group('CombatSystem Tests', () {
    late CombatSystem combatSystem;
    late MockCombatEntity attacker;
    late MockCombatEntity target;

    setUp(() {
      combatSystem = CombatSystem(autoAttackInterval: 1.0);
      attacker = MockCombatEntity(
        maxHealth: 100,
        maxMana: 100,
        attackPower: 10,
        defense: 5,
        position: const Offset(0, 0),
      );
      target = MockCombatEntity(
        maxHealth: 100,
        maxMana: 100,
        attackPower: 8,
        defense: 3,
        position: const Offset(1, 0), // 1 unit away from attacker
      );
    });

    test('Auto attack within range', () {
      combatSystem.setAttacker(attacker);
      combatSystem.setTarget(target);
      combatSystem.toggleAutoMode(); // Enable auto mode

      // Simulate one auto attack interval
      combatSystem.update(1.0);
      
      // Target should have taken damage
      expect(target.health, lessThan(target.maxHealth));
    });

    test('Auto attack out of range', () {
      target = MockCombatEntity(
        maxHealth: 100,
        maxMana: 100,
        attackPower: 8,
        defense: 3,
        position: const Offset(5, 0), // 5 units away, out of range
      );

      combatSystem.setAttacker(attacker);
      combatSystem.setTarget(target);
      combatSystem.toggleAutoMode();

      // Simulate one auto attack interval
      combatSystem.update(1.0);
      
      // Target should not have taken damage
      expect(target.health, equals(target.maxHealth));
    });

    test('Combat skill usage', () {
      var skill = Skill(
        id: 'test_skill',
        name: 'Test Skill',
        damage: 20,
        cooldown: 2.0,
        range: 3.0,
        manaCost: 10,
        effectId: 'test_effect',
      );

      attacker.skills.add(skill);
      target.position = const Offset(2, 0); // Within skill range

      combatSystem.setAttacker(attacker);
      combatSystem.setTarget(target);
      
      // Use skill
      combatSystem.useSkill(skill);
      
      // Check effects
      expect(attacker.mana, equals(90)); // Spent 10 mana
      expect(target.health, lessThan(100)); // Took damage
      expect(skill.isReady, isFalse); // On cooldown
    });

    test('Combat entity death', () {
      combatSystem.setAttacker(attacker);
      combatSystem.setTarget(target);

      // Deal fatal damage
      target.takeDamage(target.maxHealth);

      expect(target.isAlive, isFalse);
      expect(target.health, equals(0));
    });

    test('Auto mode toggle', () {
      expect(combatSystem.autoModeEnabled, isFalse);
      
      combatSystem.toggleAutoMode();
      expect(combatSystem.autoModeEnabled, isTrue);
      
      combatSystem.toggleAutoMode();
      expect(combatSystem.autoModeEnabled, isFalse);
    });
  });

  group('Skill Tests', () {
    test('Skill cooldown', () {
      var skill = Skill(
        id: 'test_skill',
        name: 'Test Skill',
        damage: 20,
        cooldown: 2.0,
        range: 3.0,
        manaCost: 10,
        effectId: 'test_effect',
      );

      expect(skill.isReady, isTrue);
      
      skill.trigger();
      expect(skill.isReady, isFalse);
      
      // Update cooldown
      skill.updateCooldown(1.0);
      expect(skill.isReady, isFalse);
      
      skill.updateCooldown(1.0);
      expect(skill.isReady, isTrue);
    });
  });
}
