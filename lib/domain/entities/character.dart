import 'package:flame/components.dart';
import '../../scripts/combat/skill.dart';
import '../../scripts/character/character_system.dart';

class Character {
  final String id;
  final String name;
  final CharacterClass characterClass;
  final Gender gender;
  final int level;
  final int experience;
  final int health;
  final int mana;
  final Map<String, double> attributes;
  final CharacterAppearance appearance;
  final Vector2 position;
  final List<Skill> skills;
  final List<String> titles;
  final CharacterRank rank;

  Character({
    required this.id,
    required this.name,
    required this.characterClass,
    required this.gender,
    required this.level,
    required this.experience,
    required this.health,
    required this.mana,
    required this.attributes,
    required this.appearance,
    required this.position,
    required this.skills,
    required this.titles,
    required this.rank,
  });

  Character copyWith({
    String? id,
    String? name,
    CharacterClass? characterClass,
    Gender? gender,
    int? level,
    int? experience,
    int? health,
    int? mana,
    Map<String, double>? attributes,
    CharacterAppearance? appearance,
    Vector2? position,
    List<Skill>? skills,
    List<String>? titles,
    CharacterRank? rank,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      characterClass: characterClass ?? this.characterClass,
      gender: gender ?? this.gender,
      level: level ?? this.level,
      experience: experience ?? this.experience,
      health: health ?? this.health,
      mana: mana ?? this.mana,
      attributes: attributes ?? this.attributes,
      appearance: appearance ?? this.appearance,
      position: position ?? this.position,
      skills: skills ?? this.skills,
      titles: titles ?? this.titles,
      rank: rank ?? this.rank,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'characterClass': characterClass.toString(),
      'gender': gender.toString(),
      'level': level,
      'experience': experience,
      'health': health,
      'mana': mana,
      'attributes': attributes,
      'appearance': appearance.toJson(),
      'position': {
        'x': position.x,
        'y': position.y,
      },
      'skills': skills.map((s) => s.toJson()).toList(),
      'titles': titles,
      'rank': rank.toString(),
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      characterClass: CharacterClass.values.firstWhere(
        (e) => e.toString() == json['characterClass'],
      ),
      gender: Gender.values.firstWhere(
        (e) => e.toString() == json['gender'],
      ),
      level: json['level'],
      experience: json['experience'],
      health: json['health'],
      mana: json['mana'],
      attributes: Map<String, double>.from(json['attributes']),
      appearance: CharacterAppearance.fromJson(json['appearance']),
      position: Vector2(
        json['position']['x'].toDouble(),
        json['position']['y'].toDouble(),
      ),
      skills: (json['skills'] as List)
          .map((s) => Skill.fromJson(s as Map<String, dynamic>))
          .toList(),
      titles: List<String>.from(json['titles']),
      rank: CharacterRank.values.firstWhere(
        (e) => e.toString() == json['rank'],
      ),
    );
  }
}
