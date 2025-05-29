import 'combat_system.dart';
import '../character/character_controller.dart';

class AutoAttackController {
  final CombatSystem combatSystem;
  final CharacterController characterController;
  bool isAutoAttackEnabled = false;
  String? currentTargetId;

  AutoAttackController({
    required this.combatSystem,
    required this.characterController,
  });

  void toggleAutoAttack() {
    isAutoAttackEnabled = !isAutoAttackEnabled;
    if (!isAutoAttackEnabled) {
      currentTargetId = null;
    }
  }

  void update(double dt) {
    if (!isAutoAttackEnabled) return;

    final playerPos = characterController.playerComponent.position;

    // Find nearest target within attack range
    String? nearestTargetId;
    double nearestDistance = double.infinity;

    // Use public getters or methods to access entities and attack parameters
    final entities = combatSystem.entities;
    final attackRange = combatSystem.attackRange;
    final lastAttackTime = combatSystem.lastAttackTime;
    final attackCooldown = combatSystem.attackCooldown;

    entities.forEach((id, entity) {
      if (entity.isPlayer || !entity.isAlive) return;

      final distance = playerPos.distanceTo(entity.position);
      if (distance < nearestDistance && distance <= attackRange) {
        nearestDistance = distance;
        nearestTargetId = id;
      }
    });

    if (nearestTargetId != null) {
      if (lastAttackTime >= attackCooldown) {
        combatSystem.performAttack(
          entities[characterController.character.id]!,
          entities[nearestTargetId]!,
          null,
        );
      }
      currentTargetId = nearestTargetId;
    } else {
      currentTargetId = null;
    }
  }
}
