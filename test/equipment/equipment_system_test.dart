import 'package:flutter_test/flutter_test.dart';
import '../../lib/scripts/equipment/equipment_system.dart';

void main() {
  group('Equipment Tests', () {
    late EquipmentSystem equipmentSystem;

    setUp(() {
      equipmentSystem = EquipmentSystem();
    });

    test('Create basic weapon', () {
      final template = Equipment(
        id: 'sword_1',
        name: 'Iron Sword',
        description: 'A basic iron sword',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {
          'damage': 10.0,
          'attackSpeed': 1.0,
        },
      );

      equipmentSystem.registerTemplate(template);
      final weapon = equipmentSystem.createEquipment('sword_1');

      expect(weapon, isNotNull);
      expect(weapon!.type, equals(EquipmentType.weapon));
      expect(weapon.baseStats['damage'], equals(10.0));
    });

    test('Equipment enhancement', () {
      final weapon = Equipment(
        id: 'sword_2',
        name: 'Steel Sword',
        description: 'A sturdy steel sword',
        type: EquipmentType.weapon,
        rarity: Rarity.uncommon,
        requiredLevel: 5,
        baseStats: {
          'damage': 15.0,
          'attackSpeed': 1.2,
        },
      );

      final initialDamage = weapon.totalStats['damage'];
      weapon.enhancement.tryEnhance();
      
      expect(weapon.totalStats['damage'], greaterThan(initialDamage!));
    });

    test('Socket gem insertion', () {
      final armor = Equipment(
        id: 'armor_1',
        name: 'Leather Armor',
        description: 'Basic leather armor with socket',
        type: EquipmentType.armor,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {
          'defense': 5.0,
        },
        sockets: [Socket(SocketType.defense)],
      );

      final gem = {'defense': 2.0};
      final success = equipmentSystem.insertGem(armor, 0, gem);
      
      expect(success, isTrue);
      expect(armor.totalStats['defense'], equals(7.0));
    });

    test('Equipment slots compatibility', () {
      final slots = EquipmentSlots();
      final helmet = Equipment(
        id: 'helmet_1',
        name: 'Iron Helmet',
        description: 'Basic iron helmet',
        type: EquipmentType.helmet,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {
          'defense': 3.0,
        },
      );

      expect(slots.canEquip(helmet, EquipmentSlot.head), isTrue);
      expect(slots.canEquip(helmet, EquipmentSlot.chest), isFalse);
    });

    test('Equipment serialization', () {
      final ring = Equipment(
        id: 'ring_1',
        name: 'Gold Ring',
        description: 'A simple gold ring',
        type: EquipmentType.ring,
        rarity: Rarity.uncommon,
        requiredLevel: 5,
        baseStats: {
          'magic': 5.0,
        },
      );

      final json = ring.toJson();
      final deserializedRing = Equipment.fromJson(json);

      expect(deserializedRing.id, equals(ring.id));
      expect(deserializedRing.name, equals(ring.name));
      expect(deserializedRing.baseStats['magic'], equals(5.0));
    });

    test('Equipment slot equip/unequip', () {
      final slots = EquipmentSlots();
      final weapon = Equipment(
        id: 'sword_3',
        name: 'Bronze Sword',
        description: 'A basic bronze sword',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {
          'damage': 8.0,
        },
      );

      final previousItem = slots.equip(weapon, EquipmentSlot.mainHand);
      expect(previousItem, isNull);
      expect(slots.slots[EquipmentSlot.mainHand], equals(weapon));

      final unequippedItem = slots.unequip(EquipmentSlot.mainHand);
      expect(unequippedItem, equals(weapon));
      expect(slots.slots[EquipmentSlot.mainHand], isNull);
    });

    test('Equipment rarity effects', () {
      final legendaryWeapon = Equipment(
        id: 'sword_legendary',
        name: 'Dragon Slayer',
        description: 'A legendary dragon slaying sword',
        type: EquipmentType.weapon,
        rarity: Rarity.legendary,
        requiredLevel: 50,
        baseStats: {
          'damage': 100.0,
        },
      );

      expect(legendaryWeapon.effect.glowIntensity, equals(0.7));
      expect(legendaryWeapon.effect.particleEffect, equals('legendary_flames'));
    });
  });
}
