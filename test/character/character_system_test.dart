import 'package:flutter_test/flutter_test.dart';
import '../../lib/scripts/character/character_system.dart';

void main() {
  group('Character Creation Tests', () {
    late CharacterSystem characterSystem;

    setUp(() {
      characterSystem = CharacterSystem();
    });

    test('Create warrior character', () {
      final warrior = characterSystem.createCharacter(
        name: 'TestWarrior',
        characterClass: CharacterClass.warrior,
        gender: 'male',
      );

      expect(warrior.name, equals('TestWarrior'));
      expect(warrior.characterClass, equals(CharacterClass.warrior));
      expect(warrior.level, equals(1));
      expect(warrior.experience, equals(0));
      expect(warrior.skills.length, equals(2)); // Basic warrior skills
    });

    test('Create mage character', () {
      final mage = characterSystem.createCharacter(
        name: 'TestMage',
        characterClass: CharacterClass.mage,
        gender: 'female',
      );

      expect(mage.name, equals('TestMage'));
      expect(mage.characterClass, equals(CharacterClass.mage));
      expect(mage.attributes.intelligence, equals(10)); // Base intelligence
      expect(mage.skills.length, equals(2)); // Basic mage skills
    });
  });

  group('Character Leveling Tests', () {
    late Character character;

    setUp(() {
      CharacterSystem characterSystem = CharacterSystem();
      character = characterSystem.createCharacter(
        name: 'TestCharacter',
        characterClass: CharacterClass.warrior,
        gender: 'male',
      );
    });

    test('Experience gain and level up', () {
      double initialHealth = character.maxHealth;
      int initialLevel = character.level;

      // Add enough experience to level up
      character.addExperience(150); // More than required for level 1

      expect(character.level, equals(initialLevel + 1));
      expect(character.maxHealth, greaterThan(initialHealth));
      expect(character.health, equals(character.maxHealth)); // Full health after level up
    });

    test('Attribute increase on level up', () {
      int initialStrength = character.attributes.strength;
      int initialVitality = character.attributes.vitality;

      character.addExperience(150);

      // Warrior should gain more strength and vitality
      expect(character.attributes.strength, greaterThan(initialStrength));
      expect(character.attributes.vitality, greaterThan(initialVitality));
    });
  });

  group('Character Attributes Tests', () {
    test('Calculate derived stats', () {
      final attributes = CharacterAttributes(
        strength: 20,
        intelligence: 15,
        vitality: 18,
        agility: 12,
      );

      expect(attributes.physicalDamage, equals(20 * 2.5));
      expect(attributes.magicDamage, equals(15 * 2.0));
      expect(attributes.maxHealth, equals(18 * 10.0));
      expect(attributes.maxMana, equals(15 * 5.0));
      expect(attributes.defense, equals(18 * 1.5));
      expect(attributes.criticalChance, equals(12 * 0.5));
      expect(attributes.moveSpeed, equals(5.0 + (12 * 0.1)));
    });

    test('Add star points', () {
      final attributes = CharacterAttributes();
      int initialStrength = attributes.strength;

      attributes.addStarPoint('strength', 5);
      expect(attributes.strength, equals(initialStrength + 5));
    });
  });

  group('Character Ranks and Titles Tests', () {
    late CharacterSystem characterSystem;
    late Character character;

    setUp(() {
      characterSystem = CharacterSystem();
      character = characterSystem.createCharacter(
        name: 'TestCharacter',
        characterClass: CharacterClass.warrior,
        gender: 'male',
      );
    });

    test('Add title to character', () {
      character.addTitle('Brave Warrior');
      expect(character.titles, contains('Brave Warrior'));

      // Adding same title again shouldn't duplicate
      character.addTitle('Brave Warrior');
      expect(character.titles.where((title) => title == 'Brave Warrior').length, equals(1));
    });

    test('Set character rank with bonuses', () {
      final rank = CharacterRank(
        name: 'Elite Warrior',
        level: 10,
        bonuses: {
          'damage': 0.2, // 20% damage bonus
          'defense': 0.1, // 10% defense bonus
        },
      );

      double initialDamage = character.attackPower;
      double initialDefense = character.defense;

      character.setRank(rank);

      expect(character.rank?.name, equals('Elite Warrior'));
      expect(character.attackPower, equals(initialDamage * 1.2));
      expect(character.defense, equals(initialDefense * 1.1));
    });
  });

  group('Character Serialization Tests', () {
    test('Convert character to and from JSON', () {
      final characterSystem = CharacterSystem();
      final original = characterSystem.createCharacter(
        name: 'TestCharacter',
        characterClass: CharacterClass.warrior,
        gender: 'male',
        appearance: {
          'hair': 'style1',
          'face': 'face2',
          'color': 'brown',
        },
      );

      // Convert to JSON
      final json = original.toJson();

      // Create new character from JSON
      final loaded = Character.fromJson(json);

      // Verify data
      expect(loaded.name, equals(original.name));
      expect(loaded.characterClass, equals(original.characterClass));
      expect(loaded.gender, equals(original.gender));
      expect(loaded.level, equals(original.level));
      expect(loaded.attributes.strength, equals(original.attributes.strength));
      expect(loaded.appearance['hair'], equals(original.appearance['hair']));
    });
  });
}
