import 'package:flame/components.dart';
import '../../domain/entities/character.dart';
import '../combat/skill.dart';

enum CharacterClass {
  warrior,
  mage,
  archer,
  priest,
}

enum Gender {
  male,
  female,
}


class CharacterAppearance {
  int hairStyle;
  int hairColor;
  int faceStyle;
  int skinColor;

  CharacterAppearance({
    this.hairStyle = 0,
    this.hairColor = 0,
    this.faceStyle = 0,
    this.skinColor = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'hairStyle': hairStyle,
      'hairColor': hairColor,
      'faceStyle': faceStyle,
      'skinColor': skinColor,
    };
  }

  factory CharacterAppearance.fromJson(Map<String, dynamic> json) {
    return CharacterAppearance(
      hairStyle: json['hairStyle'] ?? 0,
      hairColor: json['hairColor'] ?? 0,
      faceStyle: json['faceStyle'] ?? 0,
      skinColor: json['skinColor'] ?? 0,
    );
  }
}

enum CharacterRank {
  novice,
  intermediate,
  expert,
  master,
  grandmaster,
}

class CharacterSystem {
  final Map<String, Character> _characters = {};
  final Map<CharacterClass, List<Skill>> _classSkills = {
    CharacterClass.warrior: [
      Skill.basicAttack(),
      Skill(
        id: 'slash',
        name: 'Slash',
        description: 'A powerful slashing attack',
        type: SkillType.attack,
        damage: 20,
        range: 2,
        manaCost: 10,
        cooldown: 3,
      ),
    ],
    CharacterClass.mage: [
      Skill.basicAttack(),
      Skill.fireball(),
    ],
    CharacterClass.archer: [
      Skill.basicAttack(),
      Skill(
        id: 'rapid_shot',
        name: 'Rapid Shot',
        description: 'Fires multiple arrows quickly',
        type: SkillType.attack,
        damage: 15,
        range: 8,
        manaCost: 15,
        cooldown: 4,
      ),
    ],
    CharacterClass.priest: [
      Skill.basicAttack(),
      Skill.heal(),
    ],
  };

  Character createCharacter({
    required String name,
    required CharacterClass characterClass,
    required Gender gender,
    Map<String, double>? attributes,
    CharacterAppearance? appearance,
  }) {
    final baseAttributes = attributes ?? _getBaseAttributes(characterClass);
    final baseAppearance = appearance ?? CharacterAppearance();
    
    final character = Character(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      characterClass: characterClass,
      gender: gender,
      level: 1,
      experience: 0,
      health: 100 + (baseAttributes['vitality']! * 10).toInt(),
      mana: 50 + (baseAttributes['wisdom']! * 5).toInt(),
      attributes: baseAttributes,
      appearance: baseAppearance,
      position: Vector2.zero(),
      skills: _classSkills[characterClass]?.toList() ?? [],
      titles: [],
      rank: CharacterRank.novice,
    );

    _characters[character.id] = character;
    return character;
  }

  Map<String, double> _getBaseAttributes(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return {
          'strength': 15.0,
          'vitality': 13.0,
          'dexterity': 10.0,
          'intelligence': 8.0,
          'wisdom': 8.0,
        };
      case CharacterClass.mage:
        return {
          'strength': 8.0,
          'vitality': 8.0,
          'dexterity': 10.0,
          'intelligence': 15.0,
          'wisdom': 13.0,
        };
      case CharacterClass.archer:
        return {
          'strength': 10.0,
          'vitality': 10.0,
          'dexterity': 15.0,
          'intelligence': 10.0,
          'wisdom': 9.0,
        };
      case CharacterClass.priest:
        return {
          'strength': 8.0,
          'vitality': 10.0,
          'dexterity': 9.0,
          'intelligence': 12.0,
          'wisdom': 15.0,
        };
    }
  }

  void addExperience(Character character, int amount) {
    final expToNextLevel = _getExperienceForNextLevel(character.level);
    character = character.copyWith(
      experience: character.experience + amount,
    );

    while (character.experience >= expToNextLevel) {
      character = _levelUp(character);
    }

    _characters[character.id] = character;
  }

  Character _levelUp(Character character) {
    final attributes = _getAttributeIncrease(character.characterClass);
    final newAttributes = Map<String, double>.from(character.attributes);
    attributes.forEach((key, value) {
      newAttributes[key] = (newAttributes[key] ?? 0) + value;
    });
    return character.copyWith(
      level: character.level + 1,
      health: character.health + (attributes['vitality']! * 10).toInt(),
      mana: character.mana + (attributes['wisdom']! * 5).toInt(),
      attributes: newAttributes,
    );
  }

  Map<String, double> _getAttributeIncrease(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return {
          'strength': 3.0,
          'vitality': 2.0,
          'dexterity': 1.0,
          'intelligence': 1.0,
          'wisdom': 1.0,
        };
      case CharacterClass.mage:
        return {
          'strength': 1.0,
          'vitality': 1.0,
          'dexterity': 1.0,
          'intelligence': 3.0,
          'wisdom': 2.0,
        };
      case CharacterClass.archer:
        return {
          'strength': 2.0,
          'vitality': 1.0,
          'dexterity': 3.0,
          'intelligence': 1.0,
          'wisdom': 1.0,
        };
      case CharacterClass.priest:
        return {
          'strength': 1.0,
          'vitality': 2.0,
          'dexterity': 1.0,
          'intelligence': 2.0,
          'wisdom': 3.0,
        };
    }
  }

  int _getExperienceForNextLevel(int currentLevel) {
    return (100 * currentLevel * (currentLevel + 1)).floor();
  }

  void addTitle(Character character, String title) {
    if (!character.titles.contains(title)) {
      character = character.copyWith(
        titles: [...character.titles, title],
      );
      _characters[character.id] = character;
    }
  }

  void setRank(Character character, CharacterRank rank) {
    character = character.copyWith(rank: rank);
    _characters[character.id] = character;
  }

  Character? getCharacter(String id) => _characters[id];
}
