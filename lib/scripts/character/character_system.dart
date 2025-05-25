import 'package:flutter/material.dart';
import '../combat/combat_system.dart';
import 'dart:math' as math;

/// Character classes available in the game
enum CharacterClass {
  warrior,
  mage,
  archer,
  assassin,
}

/// Character attributes that affect gameplay
class CharacterAttributes {
  int strength;     // Affects physical damage and carrying capacity
  int intelligence; // Affects magic damage and mana pool
  int vitality;     // Affects health points and defense
  int agility;      // Affects speed and critical chance
  
  CharacterAttributes({
    this.strength = 10,
    this.intelligence = 10,
    this.vitality = 10,
    this.agility = 10,
  });
  
  // Calculate derived stats
  double get physicalDamage => strength * 2.5;
  double get magicDamage => intelligence * 2.0;
  double get maxHealth => vitality * 10.0;
  double get maxMana => intelligence * 5.0;
  double get defense => vitality * 1.5;
  double get criticalChance => agility * 0.5;
  double get moveSpeed => 5.0 + (agility * 0.1);
  
  void addStarPoint(String attribute, int amount) {
    switch (attribute.toLowerCase()) {
      case 'strength':
        strength += amount;
        break;
      case 'intelligence':
        intelligence += amount;
        break;
      case 'vitality':
        vitality += amount;
        break;
      case 'agility':
        agility += amount;
        break;
    }
  }
  
  Map<String, dynamic> toJson() => {
    'strength': strength,
    'intelligence': intelligence,
    'vitality': vitality,
    'agility': agility,
  };
  
  factory CharacterAttributes.fromJson(Map<String, dynamic> json) {
    return CharacterAttributes(
      strength: json['strength'] ?? 10,
      intelligence: json['intelligence'] ?? 10,
      vitality: json['vitality'] ?? 10,
      agility: json['agility'] ?? 10,
    );
  }
}

/// Represents a character rank/title
class CharacterRank {
  final String name;
  final int level;
  final Map<String, double> bonuses; // Stat bonuses (damage, defense, speed)
  
  const CharacterRank({
    required this.name,
    required this.level,
    required this.bonuses,
  });
}

/// Main character class that extends CombatEntity
class Character extends CombatEntity {
  final String name;
  final CharacterClass characterClass;
  CharacterAttributes attributes;
  int level;
  double experience;
  double requiredExperience;
  CharacterRank? rank;
  List<String> titles;
  
  // Appearance
  String gender;
  Map<String, dynamic> appearance;
  
  Character({
    required this.name,
    required this.characterClass,
    required this.gender,
    CharacterAttributes? attributes,
    this.level = 1,
    this.experience = 0,
    this.rank,
    Map<String, dynamic>? appearance,
    required Offset position,
    required List<Skill> skills,
  }) : attributes = attributes ?? CharacterAttributes(),
       requiredExperience = _calculateRequiredExp(1),
       titles = [],
       appearance = appearance ?? {},
       super(
         maxHealth: attributes?.maxHealth ?? 100,
         maxMana: attributes?.maxMana ?? 100,
         attackPower: attributes?.physicalDamage ?? 10,
         defense: attributes?.defense ?? 5,
         position: position,
         skills: skills,
       );
  
  // Calculate required experience for next level
  static double _calculateRequiredExp(int level) {
    return 100.0 * math.pow(1.5, level - 1).toDouble();
  }
  
  // Add experience and handle level up
  void addExperience(double amount) {
    experience += amount;
    while (experience >= requiredExperience) {
      levelUp();
    }
  }
  
  // Level up character
  void levelUp() {
    level++;
    experience -= requiredExperience;
    requiredExperience = _calculateRequiredExp(level);
    
    // Auto-distribute attributes based on class
    switch (characterClass) {
      case CharacterClass.warrior:
        attributes.addStarPoint('strength', 3);
        attributes.addStarPoint('vitality', 2);
        break;
      case CharacterClass.mage:
        attributes.addStarPoint('intelligence', 4);
        attributes.addStarPoint('vitality', 1);
        break;
      case CharacterClass.archer:
        attributes.addStarPoint('agility', 3);
        attributes.addStarPoint('strength', 2);
        break;
      case CharacterClass.assassin:
        attributes.addStarPoint('agility', 4);
        attributes.addStarPoint('strength', 1);
        break;
    }
    
    // Update combat stats
    maxHealth = attributes.maxHealth;
    maxMana = attributes.maxMana;
    attackPower = attributes.physicalDamage;
    defense = attributes.defense;
    
    // Heal to full on level up
    health = maxHealth;
    mana = maxMana;
  }
  
  // Add a title to the character
  void addTitle(String title) {
    if (!titles.contains(title)) {
      titles.add(title);
    }
  }
  
  // Set character rank
  void setRank(CharacterRank newRank) {
    rank = newRank;
    // Apply rank bonuses
    if (rank != null) {
      rank!.bonuses.forEach((stat, bonus) {
        switch (stat) {
          case 'damage':
            attackPower *= (1 + bonus);
            break;
          case 'defense':
            defense *= (1 + bonus);
            break;
          case 'speed':
            // Apply to movement speed calculation
            break;
        }
      });
    }
  }
  
  // Save character data
  Map<String, dynamic> toJson() => {
    'name': name,
    'class': characterClass.toString(),
    'gender': gender,
    'level': level,
    'experience': experience,
    'attributes': attributes.toJson(),
    'appearance': appearance,
    'titles': titles,
    'rank': rank?.name,
  };
  
  // Load character data
  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      characterClass: CharacterClass.values.firstWhere(
        (e) => e.toString() == json['class'],
      ),
      gender: json['gender'],
      level: json['level'],
      attributes: CharacterAttributes.fromJson(json['attributes']),
      appearance: json['appearance'],
      position: const Offset(0, 0), // Load actual position
      skills: [], // Load actual skills
    )
      ..experience = json['experience']
      ..titles = List<String>.from(json['titles']);
  }
}

/// Manages character creation and progression
class CharacterSystem {
  final Map<String, Character> _characters = {};
  final Map<String, CharacterRank> _ranks = {};
  
  void addCharacter(Character character) {
    _characters[character.name] = character;
  }
  
  Character? getCharacter(String name) {
    return _characters[name];
  }
  
  void registerRank(CharacterRank rank) {
    _ranks[rank.name] = rank;
  }
  
  CharacterRank? getRank(String name) {
    return _ranks[name];
  }
  
  // Create a new character
  Character createCharacter({
    required String name,
    required CharacterClass characterClass,
    required String gender,
    Map<String, dynamic>? appearance,
  }) {
    // Basic skills for each class
    final List<Skill> baseSkills = _getBaseSkills(characterClass);
    
    final character = Character(
      name: name,
      characterClass: characterClass,
      gender: gender,
      appearance: appearance,
      position: const Offset(0, 0), // Starting position
      skills: baseSkills,
    );
    
    addCharacter(character);
    return character;
  }
  
  // Get base skills for each class
  List<Skill> _getBaseSkills(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return [
          Skill(
            id: 'slash',
            name: 'Slash',
            damage: 15,
            cooldown: 2.0,
            range: 2.0,
            manaCost: 5,
            effectId: 'slash_effect',
          ),
          Skill(
            id: 'charge',
            name: 'Charge',
            damage: 25,
            cooldown: 5.0,
            range: 5.0,
            manaCost: 15,
            effectId: 'charge_effect',
          ),
        ];
      case CharacterClass.mage:
        return [
          Skill(
            id: 'fireball',
            name: 'Fireball',
            damage: 20,
            cooldown: 3.0,
            range: 8.0,
            manaCost: 10,
            effectId: 'fireball_effect',
          ),
          Skill(
            id: 'frost_nova',
            name: 'Frost Nova',
            damage: 15,
            cooldown: 4.0,
            range: 4.0,
            manaCost: 20,
            effectId: 'frost_effect',
          ),
        ];
      case CharacterClass.archer:
        return [
          Skill(
            id: 'quick_shot',
            name: 'Quick Shot',
            damage: 12,
            cooldown: 1.5,
            range: 10.0,
            manaCost: 5,
            effectId: 'arrow_effect',
          ),
          Skill(
            id: 'multi_shot',
            name: 'Multi Shot',
            damage: 30,
            cooldown: 6.0,
            range: 8.0,
            manaCost: 15,
            effectId: 'multi_arrow_effect',
          ),
        ];
      case CharacterClass.assassin:
        return [
          Skill(
            id: 'backstab',
            name: 'Backstab',
            damage: 25,
            cooldown: 4.0,
            range: 2.0,
            manaCost: 10,
            effectId: 'backstab_effect',
          ),
          Skill(
            id: 'shadow_step',
            name: 'Shadow Step',
            damage: 15,
            cooldown: 3.0,
            range: 6.0,
            manaCost: 15,
            effectId: 'shadow_effect',
          ),
        ];
    }
  }
}
