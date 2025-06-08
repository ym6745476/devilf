import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:arabic_mmorpg/game/components/player/player_component.dart';
import 'package:arabic_mmorpg/game/components/monster/monster_component.dart';
import 'package:arabic_mmorpg/game/components/effects/damage_text_component.dart';

/// System that handles combat mechanics and calculations
class CombatSystem {
  // Random number generator for combat calculations
  final _random = math.Random();
  
  // Combat settings
  final double criticalHitChance = 0.1; // 10% chance
  final double criticalHitMultiplier = 2.0; // 2x damage
  final double missChance = 0.05; // 5% chance
  
  // Constructor
  CombatSystem();
  
  // Update method called every frame
  void update(double dt) {
    // This would handle ongoing combat effects, cooldowns, etc.
  }
  
  // Calculate damage for a player attack against a monster
  int calculatePlayerDamage(PlayerComponent player, MonsterComponent monster) {
    // Base damage calculation based on player stats and weapon
    int baseDamage = 0;
    
    switch (player.characterClass) {
      case 'warrior':
        baseDamage = 5 + (player.strength * 2);
        break;
      case 'mage':
        baseDamage = 3 + (player.intelligence * 2);
        break;
      case 'archer':
        baseDamage = 4 + (player.agility * 2);
        break;
      case 'assassin':
        baseDamage = 4 + (player.agility * 1) + (player.strength * 1);
        break;
      default:
        baseDamage = 5 + player.level;
    }
    
    // Apply level difference modifier
    final levelDifference = player.level - monster.level;
    double levelModifier = 1.0;
    
    if (levelDifference > 0) {
      // Player has higher level, increase damage
      levelModifier = 1.0 + (levelDifference * 0.1);
    } else if (levelDifference < 0) {
      // Monster has higher level, decrease damage
      levelModifier = 1.0 / (1.0 + (levelDifference.abs() * 0.1));
    }
    
    baseDamage = (baseDamage * levelModifier).round();
    
    // Check for miss
    if (_random.nextDouble() < missChance) {
      return 0; // Miss
    }
    
    // Check for critical hit
    bool isCritical = _random.nextDouble() < criticalHitChance;
    if (isCritical) {
      baseDamage = (baseDamage * criticalHitMultiplier).round();
    }
    
    // Apply monster defense
    final damageReduction = monster.defense / (monster.defense + 50);
    int finalDamage = (baseDamage * (1 - damageReduction)).round();
    
    // Ensure minimum damage of 1
    if (finalDamage < 1) finalDamage = 1;
    
    return finalDamage;
  }
  
  // Calculate damage for a monster attack against a player
  int calculateMonsterDamage(MonsterComponent monster, PlayerComponent player) {
    // Base damage calculation based on monster stats
    int baseDamage = monster.attackPower + (monster.level * 2);
    
    // Apply level difference modifier
    final levelDifference = monster.level - player.level;
    double levelModifier = 1.0;
    
    if (levelDifference > 0) {
      // Monster has higher level, increase damage
      levelModifier = 1.0 + (levelDifference * 0.1);
    } else if (levelDifference < 0) {
      // Player has higher level, decrease damage
      levelModifier = 1.0 / (1.0 + (levelDifference.abs() * 0.1));
    }
    
    baseDamage = (baseDamage * levelModifier).round();
    
    // Check for miss
    if (_random.nextDouble() < missChance) {
      return 0; // Miss
    }
    
    // Check for critical hit
    bool isCritical = _random.nextDouble() < criticalHitChance;
    if (isCritical) {
      baseDamage = (baseDamage * criticalHitMultiplier).round();
    }
    
    // Calculate player defense based on class
    int playerDefense = 0;
    switch (player.characterClass) {
      case 'warrior':
        playerDefense = 5 + (player.vitality * 2);
        break;
      case 'mage':
        playerDefense = 2 + player.vitality;
        break;
      case 'archer':
        playerDefense = 3 + (player.vitality * 1.5).round();
        break;
      case 'assassin':
        playerDefense = 3 + player.vitality;
        break;
      default:
        playerDefense = 3 + player.level;
    }
    
    // Apply player defense
    final damageReduction = playerDefense / (playerDefense + 50);
    int finalDamage = (baseDamage * (1 - damageReduction)).round();
    
    // Ensure minimum damage of 1
    if (finalDamage < 1) finalDamage = 1;
    
    return finalDamage;
  }
  
  // Process a player attack against a monster
  void processPlayerAttack(PlayerComponent player, MonsterComponent monster, Component world) {
    // Calculate damage
    final damage = calculatePlayerDamage(player, monster);
    
    // Apply damage to monster
    if (damage > 0) {
      monster.takeDamage(damage);
      
      // Show damage text
      _showDamageText(damage, monster.position, world, isCritical: damage > 10);
      
      // Check if monster is defeated
      if (monster.health <= 0) {
        _handleMonsterDefeat(player, monster);
      }
    } else {
      // Show miss text
      _showMissText(monster.position, world);
    }
  }
  
  // Process a monster attack against a player
  void processMonsterAttack(MonsterComponent monster, PlayerComponent player, Component world) {
    // Calculate damage
    final damage = calculateMonsterDamage(monster, player);
    
    // Apply damage to player
    if (damage > 0) {
      player.takeDamage(damage);
      
      // Show damage text
      _showDamageText(damage, player.position, world, isCritical: damage > 10, isPlayerDamage: true);
    } else {
      // Show miss text
      _showMissText(player.position, world);
    }
  }
  
  // Handle monster defeat
  void _handleMonsterDefeat(PlayerComponent player, MonsterComponent monster) {
    // Calculate experience gain
    final experienceGain = _calculateExperienceGain(player, monster);
    
    // Award experience to player
    player.gainExperience(experienceGain);
    
    // Calculate gold drop
    final goldDrop = _calculateGoldDrop(monster);
    
    // TODO: Add gold to player inventory
    
    // Calculate item drops
    // TODO: Implement item drop system
  }
  
  // Calculate experience gain from defeating a monster
  int _calculateExperienceGain(PlayerComponent player, MonsterComponent monster) {
    // Base experience from monster
    int baseExperience = monster.experienceValue;
    
    // Apply level difference modifier
    final levelDifference = monster.level - player.level;
    double levelModifier = 1.0;
    
    if (levelDifference > 0) {
      // Monster has higher level, increase experience
      levelModifier = 1.0 + (levelDifference * 0.2);
    } else if (levelDifference < 0) {
      // Monster has lower level, decrease experience
      levelModifier = 1.0 / (1.0 + (levelDifference.abs() * 0.2));
      
      // Minimum 10% experience for much lower level monsters
      if (levelModifier < 0.1) levelModifier = 0.1;
    }
    
    return (baseExperience * levelModifier).round();
  }
  
  // Calculate gold drop from a monster
  int _calculateGoldDrop(MonsterComponent monster) {
    // Base gold drop
    int baseGold = monster.goldValue;
    
    // Add some randomness
    final randomFactor = 0.8 + (_random.nextDouble() * 0.4); // 0.8 to 1.2
    
    return (baseGold * randomFactor).round();
  }
  
  // Show damage text above an entity
  void _showDamageText(int damage, Vector2 position, Component world, {bool isCritical = false, bool isPlayerDamage = false}) {
    // This would create a floating damage text component
    // For now, we'll just define the interface
    
    /*
    final damageText = DamageTextComponent(
      text: damage.toString(),
      position: position + Vector2(0, -20), // Offset above the entity
      isCritical: isCritical,
      isPlayerDamage: isPlayerDamage,
    );
    
    world.add(damageText);
    */
  }
  
  // Show miss text above an entity
  void _showMissText(Vector2 position, Component world) {
    // This would create a floating "Miss" text component
    // For now, we'll just define the interface
    
    /*
    final missText = DamageTextComponent(
      text: "Miss",
      position: position + Vector2(0, -20), // Offset above the entity
      isMiss: true,
    );
    
    world.add(missText);
    */
  }
}