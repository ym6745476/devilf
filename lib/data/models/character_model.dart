import 'package:json_annotation/json_annotation.dart';
import 'package:flame/components.dart';
import '../../domain/entities/character.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel extends Character {
  final String playerId;
  final Map<String, double> stats;

  CharacterModel({
    required String id,
    required this.playerId,
    required String name,
    required CharacterClass characterClass,
    required int level,
    required double experience,
    required this.stats,
    required Map<String, dynamic> equipment,
    required List<String> skills,
    required Vector2 position,
  }) : super(
    id: id,
    name: name,
    characterClass: characterClass,
    level: level,
    health: stats['health'] ?? 100,
    mana: stats['mana'] ?? 100,
    experience: experience,
    position: position,
    attributes: {
      'attack': stats['attack'] ?? 10,
      'defense': stats['defense'] ?? 5,
      'speed': stats['speed'] ?? 5,
    },
    skills: skills,
    equipment: equipment,
  );

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as String,
      playerId: json['playerId'] as String,
      name: json['name'] as String,
      characterClass: _parseCharacterClass(json['class'] as String),
      level: json['level'] as int,
      experience: (json['experience'] as num).toDouble(),
      stats: Map<String, double>.from(json['stats'] as Map),
      equipment: json['equipment'] as Map<String, dynamic>,
      skills: (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      position: Vector2(
        (json['position']['x'] as num).toDouble(),
        (json['position']['y'] as num).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'name': name,
      'class': characterClass.toString().split('.').last,
      'level': level,
      'experience': experience,
      'stats': {
        'health': health,
        'maxHealth': health, // Using current health as max health
        'attack': attributes['attack'],
        'defense': attributes['defense'],
        'speed': attributes['speed'],
      },
      'equipment': equipment,
      'skills': skills,
      'position': {
        'x': position.x,
        'y': position.y,
        'map': 'starting_zone', // Default map
      },
    };
  }

  static CharacterClass _parseCharacterClass(String classStr) {
    switch (classStr.toLowerCase()) {
      case 'warrior':
        return CharacterClass.warrior;
      case 'mage':
        return CharacterClass.mage;
      case 'archer':
        return CharacterClass.archer;
      case 'assassin':
        return CharacterClass.assassin;
      default:
        throw ArgumentError('Invalid character class: $classStr');
    }
  }
}
