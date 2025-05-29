import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../combat/combat_system.dart';

/// Difficulty levels for AI
enum AIDifficulty {
  easy,
  normal,
  hard,
  expert,
}

/// AI behavior types
enum AIBehaviorType {
  passive,    // NPCs, non-combat entities
  defensive,  // Only attacks when attacked
  aggressive, // Attacks on sight
  support,    // Companions, healing/buff focused
  tactical,   // Uses advanced combat strategies
}

/// Base class for AI behavior
abstract class AIBehavior {
  void update(double deltaTime);
  void onPlayerDetected(Offset playerPosition);
  void onPlayerLost();
  bool canAttack() => false;
  
  // New methods for advanced AI
  void onTakeDamage(double damage, dynamic source) {}
  void onAllyNeedsHelp(Offset allyPosition, double allyHealth) {}
  void onEnvironmentChange(Map<String, dynamic> conditions) {}
}

/// AI behavior for static NPCs (quest givers, merchants, etc.)
class StaticNPCBehavior extends AIBehavior {
  final Offset position;
  final double interactionRange;
  bool isPlayerInRange = false;
  final Map<String, dynamic> dialogues;
  final Map<String, dynamic> shopInventory;
  
  StaticNPCBehavior({
    required this.position,
    this.interactionRange = 2.0,
    this.dialogues = const {},
    this.shopInventory = const {},
  });
  
  @override
  void update(double deltaTime) {
    // Static NPCs don't move but can update their state
    // e.g., rotating to face player, updating shop inventory
  }
  
  @override
  void onPlayerDetected(Offset playerPosition) {
    double dx = playerPosition.dx - position.dx;
    double dy = playerPosition.dy - position.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    
    isPlayerInRange = distance <= interactionRange;
  }
  
  @override
  void onPlayerLost() {
    isPlayerInRange = false;
  }
  
  String getDialogue(String key) => dialogues[key] ?? '';
  
  bool hasItem(String itemId) => shopInventory.containsKey(itemId);
}

/// AI behavior for combat companions
class CompanionBehavior extends AIBehavior {
  Offset currentPosition;
  final double moveSpeed;
  final double supportRange;
  final double combatRange;
  final List<Skill> supportSkills;
  final List<Skill> combatSkills;
  
  bool isInCombat = false;
  Offset? targetPosition;
  dynamic currentTarget;
  
  CompanionBehavior({
    required this.currentPosition,
    required this.moveSpeed,
    this.supportRange = 8.0,
    this.combatRange = 5.0,
    required this.supportSkills,
    required this.combatSkills,
  });

  @override
  void onPlayerDetected(Offset playerPosition) {
    // Update companion behavior when player is detected
    if (!isInCombat) {
      // Follow player if not in combat
      targetPosition = playerPosition;
    }
  }

  @override
  void onPlayerLost() {
    // Return to default behavior when player is lost
    if (!isInCombat) {
      targetPosition = null;
    }
  }
  
  @override
  void update(double deltaTime) {
    _updateSkillCooldowns(deltaTime);
    
    if (isInCombat && targetPosition != null) {
      _moveTowardsTarget(targetPosition!, deltaTime);
      _useCombatSkills();
    }
  }
  
  void _updateSkillCooldowns(double deltaTime) {
    for (var skill in [...supportSkills, ...combatSkills]) {
      skill.updateCooldown(deltaTime);
    }
  }
  
  void _moveTowardsTarget(Offset target, double deltaTime) {
    double dx = target.dx - currentPosition.dx;
    double dy = target.dy - currentPosition.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    
    if (distance > 0.1) {
      double moveX = (dx / distance) * moveSpeed * deltaTime;
      double moveY = (dy / distance) * moveSpeed * deltaTime;
      currentPosition = Offset(
        currentPosition.dx + moveX,
        currentPosition.dy + moveY,
      );
    }
  }
  
  void _useCombatSkills() {
    // Use support skills when allies need help
    for (var skill in supportSkills) {
      if (skill.isReady) {
        // Logic to determine when to use support skills
      }
    }
    
    // Use combat skills when in range
    for (var skill in combatSkills) {
      if (skill.isReady) {
        // Logic to determine when to use combat skills
      }
    }
  }
  
  @override
  void onAllyNeedsHelp(Offset allyPosition, double allyHealth) {
    // Prioritize helping allies with low health
    if (allyHealth < 0.3) { // 30% health threshold
      targetPosition = allyPosition;
      isInCombat = false;
    }
  }
}

/// AI behavior for tactical combat enemies
class TacticalCombatBehavior extends AIBehavior {
  Offset currentPosition;
  final double moveSpeed;
  final double aggroRange;
  final double combatRange;
  final AIDifficulty difficulty;
  final List<Skill> skills;
  
  bool isAggro = false;
  Offset? targetPosition;
  List<Offset> patrolPoints = [];
  Map<String, double> combatStats = {};
  
  // Learning parameters
  Map<String, double> skillEffectiveness = {};
  Map<String, int> skillUsageCount = {};
  
  TacticalCombatBehavior({
    required this.currentPosition,
    required this.moveSpeed,
    required this.difficulty,
    this.aggroRange = 7.0,
    this.combatRange = 5.0,
    required this.skills,
  }) {
    _initializeLearningParameters();
  }

  @override
  void onPlayerDetected(Offset playerPosition) {
    double distance = _getDistanceTo(playerPosition);
    
    if (distance <= aggroRange) {
      isAggro = true;
      targetPosition = playerPosition;
    }
  }

  @override
  void onPlayerLost() {
    isAggro = false;
    targetPosition = null;
  }
  
  void _initializeLearningParameters() {
    for (var skill in skills) {
      skillEffectiveness[skill.id] = 0.5; // Initial 50% effectiveness
      skillUsageCount[skill.id] = 0;
    }
  }
  
  @override
  void update(double deltaTime) {
    if (isAggro && targetPosition != null) {
      _updateCombat(deltaTime);
    } else {
      _updatePatrol(deltaTime);
    }
    
    // Update skill cooldowns
    for (var skill in skills) {
      skill.updateCooldown(deltaTime);
    }
  }
  
  void _updateCombat(double deltaTime) {
    // Different strategies based on difficulty
    switch (difficulty) {
      case AIDifficulty.easy:
        _basicCombatBehavior(deltaTime);
        break;
      case AIDifficulty.normal:
        _normalCombatBehavior(deltaTime);
        break;
      case AIDifficulty.hard:
        _advancedCombatBehavior(deltaTime);
        break;
      case AIDifficulty.expert:
        _expertCombatBehavior(deltaTime);
        break;
    }
  }
  
  void _basicCombatBehavior(double deltaTime) {
    // Simple direct approach and basic skill usage
    if (targetPosition != null) {
      _moveTowardsTarget(targetPosition!, deltaTime);
      _useRandomAvailableSkill();
    }
  }
  
  void _normalCombatBehavior(double deltaTime) {
    // Maintains some distance and uses skills more thoughtfully
    if (targetPosition != null) {
      double distance = _getDistanceToTarget();
      if (distance < combatRange * 0.5) {
        _moveAwayFromTarget(deltaTime);
      } else if (distance > combatRange * 0.8) {
        _moveTowardsTarget(targetPosition!, deltaTime);
      }
      _useSkillBasedOnDistance();
    }
  }
  
  void _advancedCombatBehavior(double deltaTime) {
    // Uses positioning and skill combinations
    if (targetPosition != null) {
      _tacticalPositioning(deltaTime);
      _useOptimalSkillCombination();
    }
  }
  
  void _expertCombatBehavior(double deltaTime) {
    // Uses learned patterns and advanced tactics
    if (targetPosition != null) {
      _adaptivePositioning(deltaTime);
      _useLearnedStrategy();
    }
  }
  
  void _moveTowardsTarget(Offset target, double deltaTime) {
    double dx = target.dx - currentPosition.dx;
    double dy = target.dy - currentPosition.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    
    if (distance > 0.1) {
      double moveX = (dx / distance) * moveSpeed * deltaTime;
      double moveY = (dy / distance) * moveSpeed * deltaTime;
      currentPosition = Offset(
        currentPosition.dx + moveX,
        currentPosition.dy + moveY,
      );
    }
  }
  
  void _moveAwayFromTarget(double deltaTime) {
    if (targetPosition == null) return;
    
    double dx = currentPosition.dx - targetPosition!.dx;
    double dy = currentPosition.dy - targetPosition!.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    
    if (distance > 0.1) {
      double moveX = (dx / distance) * moveSpeed * deltaTime;
      double moveY = (dy / distance) * moveSpeed * deltaTime;
      currentPosition = Offset(
        currentPosition.dx + moveX,
        currentPosition.dy + moveY,
      );
    }
  }
  
  double _getDistanceToTarget() {
    if (targetPosition == null) return double.infinity;
    
    double dx = targetPosition!.dx - currentPosition.dx;
    double dy = targetPosition!.dy - currentPosition.dy;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  void _updatePatrol(double deltaTime) {
    if (patrolPoints.isEmpty) return;
    
    // Simple patrol behavior
    Offset target = patrolPoints[0];
    _moveTowardsTarget(target, deltaTime);
    
    // If reached patrol point, move to next
    if (_getDistanceTo(target) < 0.5) {
      patrolPoints.add(patrolPoints.removeAt(0));
    }
  }
  
  double _getDistanceTo(Offset target) {
    double dx = target.dx - currentPosition.dx;
    double dy = target.dy - currentPosition.dy;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  void _useRandomAvailableSkill() {
    var availableSkills = skills.where((s) => s.isReady).toList();
    if (availableSkills.isNotEmpty) {
      var skill = availableSkills[math.Random().nextInt(availableSkills.length)];
      _useSkill(skill);
    }
  }
  
  void _useSkillBasedOnDistance() {
    double distance = _getDistanceToTarget();
    var availableSkills = skills.where((s) => s.isReady && s.range >= distance).toList();
    if (availableSkills.isNotEmpty) {
      availableSkills.sort((a, b) => 
        skillEffectiveness[b.id]!.compareTo(skillEffectiveness[a.id]!));
      _useSkill(availableSkills.first);
    }
  }
  
  void _tacticalPositioning(double deltaTime) {
    // Implement tactical movement based on terrain and target position
  }
  
  void _adaptivePositioning(double deltaTime) {
    // Implement adaptive movement based on learned patterns
  }
  
  void _useOptimalSkillCombination() {
    // Implementation of skill combinations based on learned effectiveness
  }
  
  void _useLearnedStrategy() {
    // Implementation of adaptive strategy based on past encounters
  }
  
  void _useSkill(Skill skill) {
    skill.trigger();
    skillUsageCount[skill.id] = (skillUsageCount[skill.id] ?? 0) + 1;
  }
  
  void updateSkillEffectiveness(String skillId, double effectiveness) {
    if (skillEffectiveness.containsKey(skillId)) {
      // Update effectiveness using weighted average
      double currentEffect = skillEffectiveness[skillId]!;
      int usageCount = skillUsageCount[skillId] ?? 1;
      skillEffectiveness[skillId] = 
        (currentEffect * usageCount + effectiveness) / (usageCount + 1);
    }
  }
  
  @override
  void onTakeDamage(double damage, dynamic source) {
    // Update combat stats and adjust strategy
    combatStats['lastDamageTaken'] = damage;
    combatStats['totalDamageTaken'] = 
      (combatStats['totalDamageTaken'] ?? 0.0) + damage;
  }
  
  @override
  bool canAttack() {
    return isAggro && targetPosition != null && 
           _getDistanceToTarget() <= combatRange;
  }
}

/// Main AI controller that manages all AI entities
class AIController {
  final Map<String, AIBehavior> _npcs = {};
  final Map<String, AIBehavior> _monsters = {};
  final Map<String, AIBehavior> _companions = {};
  final CombatSystem _combatSystem;
  
  AIController(this._combatSystem);
  
  void addNPC(String id, AIBehavior behavior) {
    _npcs[id] = behavior;
  }
  
  void addMonster(String id, AIBehavior behavior) {
    _monsters[id] = behavior;
  }
  
  void addCompanion(String id, AIBehavior behavior) {
    _companions[id] = behavior;
  }
  
  void update(double deltaTime, Offset playerPosition) {
    // Update NPCs
    for (var npc in _npcs.values) {
      npc.onPlayerDetected(playerPosition);
      npc.update(deltaTime);
    }
    
    // Update monsters with different strategies based on difficulty
    for (var monster in _monsters.values) {
      monster.onPlayerDetected(playerPosition);
      monster.update(deltaTime);
      
      if (monster.canAttack()) {
        _combatSystem.toggleAutoMode();
      }
    }
    
    // Update companions
    for (var companion in _companions.values) {
      companion.update(deltaTime);
    }
  }
  
  void handleCombatEvent(String entityId, String eventType, Map<String, dynamic> data) {
    final entity = _monsters[entityId] ?? _companions[entityId];
    if (entity == null) return;
    
    switch (eventType) {
      case 'damage_taken':
        entity.onTakeDamage(data['amount'], data['source']);
        break;
      case 'ally_needs_help':
        entity.onAllyNeedsHelp(data['position'], data['health']);
        break;
      case 'environment_changed':
        entity.onEnvironmentChange(data);
        break;
    }
  }
  
  bool isPlayerInRangeOfNPC(String npcId) {
    var npc = _npcs[npcId];
    return npc is StaticNPCBehavior && npc.isPlayerInRange;
  }
  
  Set<String> getAggroMonsters() {
    return _monsters.entries
        .where((entry) => entry.value.canAttack())
        .map((entry) => entry.key)
        .toSet();
  }
}
