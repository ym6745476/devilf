import 'package:flame/components.dart';
import '../../core/services/game_service.dart';

class CombatSystem {
  final GameService gameService;
  final Map<String, CombatEntity> _entities = {};
  final double _attackRange = 50.0;
  final double _attackCooldown = 1.5; // seconds
  double _lastAttackTime = 0.0;

  Map<String, CombatEntity> get entities => _entities;
  double get attackRange => _attackRange;
  double get attackCooldown => _attackCooldown;
  double get lastAttackTime => _lastAttackTime;

  CombatSystem(this.gameService);

  void update(double dt) {
    _lastAttackTime += dt;
    // Update combat effects, animations, etc.
  }

  void handleCombatEvent(Map<String, dynamic> data) {
    final actionType = data['actionType'] as String;
    final sourceId = data['sourceId'] as String;
    final targetId = data['targetId'] as String;
    final damage = data['damage'] as int?;

    switch (actionType) {
      case 'attack':
        _handleAttack(sourceId, targetId, damage);
        break;
      case 'skill':
        _handleSkill(sourceId, targetId, data['skillId'] as String);
        break;
      case 'damage':
        _handleDamage(targetId, damage ?? 0);
        break;
    }
  }

  void _handleAttack(String sourceId, String targetId, int? damage) {
    final source = _entities[sourceId];
    final target = _entities[targetId];

    if (source == null || target == null) return;

    if (_canAttack(source, target)) {
      performAttack(source, target, damage);
    }
  }

  void _handleSkill(String sourceId, String targetId, String skillId) {
    // TODO: Implement skill effects
  }

  void _handleDamage(String targetId, int amount) {
    final target = _entities[targetId];
    if (target != null) {
      target.takeDamage(amount);
    }
  }

  bool _canAttack(CombatEntity source, CombatEntity target) {
    if (!source.canAttack || !target.isAlive) return false;
    
    final distance = source.position.distanceTo(target.position);
    return distance <= _attackRange && _lastAttackTime >= _attackCooldown;
  }

  void performAttack(CombatEntity source, CombatEntity target, int? damage) {
    _lastAttackTime = 0.0;
    
    final actualDamage = damage ?? _calculateDamage(source, target);
    target.takeDamage(actualDamage);

    // Notify server about the attack
    gameService.performCombatAction(target.id, null);
  }

  int _calculateDamage(CombatEntity attacker, CombatEntity defender) {
    final baseDamage = attacker.attackPower;
    final defense = defender.defense;
    return (baseDamage * (100 / (100 + defense))).round();
  }

  void registerEntity(String id, Vector2 position, {
    required bool isPlayer,
    required int health,
    required int attackPower,
    required int defense,
  }) {
    _entities[id] = CombatEntity(
      id: id,
      position: position,
      isPlayer: isPlayer,
      health: health,
      attackPower: attackPower,
      defense: defense,
    );
  }

  void removeEntity(String id) {
    _entities.remove(id);
  }

  void updateEntityPosition(String id, Vector2 position) {
    final entity = _entities[id];
    if (entity != null) {
      entity.position = position;
    }
  }
}

class CombatEntity {
  final String id;
  Vector2 position;
  final bool isPlayer;
  int health;
  final int attackPower;
  final int defense;
  bool canAttack = true;

  CombatEntity({
    required this.id,
    required this.position,
    required this.isPlayer,
    required this.health,
    required this.attackPower,
    required this.defense,
  });

  bool get isAlive => health > 0;

  void takeDamage(int amount) {
    health = (health - amount).clamp(0, health);
  }
}
