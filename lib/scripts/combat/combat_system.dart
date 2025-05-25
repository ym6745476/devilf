import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Represents a combat skill
class Skill {
  final String id;
  final String name;
  final double damage;
  final double cooldown;
  final double range;
  final double manaCost;
  final String effectId;
  
  double _currentCooldown = 0;
  
  Skill({
    required this.id,
    required this.name,
    required this.damage,
    required this.cooldown,
    required this.range,
    required this.manaCost,
    required this.effectId,
  });
  
  bool get isReady => _currentCooldown <= 0;
  
  void updateCooldown(double deltaTime) {
    if (_currentCooldown > 0) {
      _currentCooldown = math.max(0, _currentCooldown - deltaTime);
    }
  }
  
  void trigger() {
    if (isReady) {
      _currentCooldown = cooldown;
    }
  }
}

/// Base class for any entity that can engage in combat
abstract class CombatEntity {
  double health;
  double maxHealth;
  double mana;
  double maxMana;
  double attackPower;
  double defense;
  Offset position;
  bool isAlive;
  List<Skill> skills;
  
  CombatEntity({
    required this.maxHealth,
    required this.maxMana,
    required this.attackPower,
    required this.defense,
    required this.position,
    required this.skills,
  }) : health = maxHealth,
       mana = maxMana,
       isAlive = true;
  
  void takeDamage(double amount) {
    if (!isAlive) return;
    
    double actualDamage = math.max(1, amount - defense);
    health = math.max(0, health - actualDamage);
    
    if (health <= 0) {
      die();
    }
  }
  
  void heal(double amount) {
    if (!isAlive) return;
    health = math.min(maxHealth, health + amount);
  }
  
  void useMana(double amount) {
    mana = math.max(0, mana - amount);
  }
  
  void restoreMana(double amount) {
    mana = math.min(maxMana, mana + amount);
  }
  
  void die() {
    isAlive = false;
    // Trigger death events/animations
  }
  
  bool canUseSkill(Skill skill) {
    return isAlive && skill.isReady && mana >= skill.manaCost;
  }
}

/// Manages auto-attack and combat mechanics
class CombatSystem {
  final double autoAttackInterval;
  double _autoAttackTimer = 0;
  bool autoModeEnabled = false;
  
  CombatEntity? attacker;
  CombatEntity? target;
  
  CombatSystem({
    this.autoAttackInterval = 1.5,
  });
  
  void setAttacker(CombatEntity entity) {
    attacker = entity;
  }
  
  void setTarget(CombatEntity entity) {
    target = entity;
  }
  
  void toggleAutoMode() {
    autoModeEnabled = !autoModeEnabled;
  }
  
  void update(double deltaTime) {
    if (!autoModeEnabled || attacker == null || target == null) {
      return;
    }
    
    // Update skill cooldowns
    for (var skill in attacker!.skills) {
      skill.updateCooldown(deltaTime);
    }
    
    // Auto attack logic
    _autoAttackTimer += deltaTime;
    if (_autoAttackTimer >= autoAttackInterval) {
      _autoAttackTimer = 0;
      performAutoAttack();
    }
    
    // Try to use available skills
    if (autoModeEnabled) {
      tryUseSkills();
    }
  }
  
  void performAutoAttack() {
    if (attacker == null || target == null || !target!.isAlive) {
      return;
    }
    
    double dx = target!.position.dx - attacker!.position.dx;
    double dy = target!.position.dy - attacker!.position.dy;
    double distance = math.sqrt(dx * dx + dy * dy);
    if (distance <= 2.0) { // Basic attack range
      double damage = attacker!.attackPower;
      target!.takeDamage(damage);
    }
  }
  
  void tryUseSkills() {
    if (attacker == null || target == null || !target!.isAlive) {
      return;
    }
    
    for (var skill in attacker!.skills) {
      if (attacker!.canUseSkill(skill)) {
        double dx = target!.position.dx - attacker!.position.dx;
        double dy = target!.position.dy - attacker!.position.dy;
        double distance = math.sqrt(dx * dx + dy * dy);
        if (distance <= skill.range) {
          useSkill(skill);
        }
      }
    }
  }
  
  void useSkill(Skill skill) {
    if (attacker == null || target == null) {
      return;
    }
    
    attacker!.useMana(skill.manaCost);
    target!.takeDamage(skill.damage);
    skill.trigger();
    
    // Trigger skill effects/animations
  }
}
