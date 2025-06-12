import 'package:flutter_test/flutter_test.dart';
import '../../lib/scripts/inventory/inventory_system.dart';
import '../../lib/scripts/equipment/equipment_system.dart';

void main() {
  group('Inventory-Equipment Integration Tests', () {
    late InventorySystem inventory;
    late EquipmentSystem equipmentSystem;

    setUp(() {
      inventory = InventorySystem(maxSlots: 20);
      equipmentSystem = EquipmentSystem();
    });

    test('Add equipment to inventory', () {
      final weapon = Equipment(
        id: 'test_sword',
        name: 'Test Sword',
        description: 'A sword for testing',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'damage': 10.0},
      );

      final success = inventory.addItem(weapon);
      expect(success, isTrue);
      expect(inventory.getItemQuantity('test_sword'), equals(1));
    });

    test('Equip item from inventory', () {
      final weapon = Equipment(
        id: 'equip_sword',
        name: 'Equip Test Sword',
        description: 'A sword for equip testing',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'damage': 10.0},
      );

      // Add to inventory first
      inventory.addItem(weapon);
      
      // Find the slot with our weapon
      final slotIndex = inventory.slots.indexWhere(
        (slot) => slot.item?.id == 'equip_sword'
      );
      expect(slotIndex, isNot(-1));

      // Try to equip it
      final equipped = inventory.equipFromInventory(slotIndex, EquipmentSlot.mainHand);
      expect(equipped, isNotNull);
      expect(equipped!.id, equals('equip_sword'));
      
      // Verify it's no longer in inventory
      expect(inventory.getItemQuantity('equip_sword'), equals(0));
      
      // Verify it's in equipment slot
      expect(inventory.equipmentSlots.slots[EquipmentSlot.mainHand]?.id, 
             equals('equip_sword'));
    });

    test('Unequip item to inventory', () {
      final weapon = Equipment(
        id: 'unequip_sword',
        name: 'Unequip Test Sword',
        description: 'A sword for unequip testing',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'damage': 10.0},
      );

      // Add and equip
      inventory.addItem(weapon);
      final slotIndex = inventory.slots.indexWhere(
        (slot) => slot.item?.id == 'unequip_sword'
      );
      inventory.equipFromInventory(slotIndex, EquipmentSlot.mainHand);

      // Try to unequip
      final success = inventory.unequipToInventory(EquipmentSlot.mainHand);
      expect(success, isTrue);
      
      // Verify it's back in inventory
      expect(inventory.getItemQuantity('unequip_sword'), equals(1));
      
      // Verify equipment slot is empty
      expect(inventory.equipmentSlots.slots[EquipmentSlot.mainHand], isNull);
    });

    test('Equipment stacking prevention', () {
      final ring1 = Equipment(
        id: 'stack_ring',
        name: 'Stack Test Ring',
        description: 'A ring for stack testing',
        type: EquipmentType.ring,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'magic': 5.0},
      );

      final ring2 = Equipment(
        id: 'stack_ring',
        name: 'Stack Test Ring',
        description: 'A ring for stack testing',
        type: EquipmentType.ring,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'magic': 5.0},
      );

      // Add both rings
      inventory.addItem(ring1);
      inventory.addItem(ring2);

      // Verify they take up separate slots
      final ringSlots = inventory.slots.where(
        (slot) => slot.item?.id == 'stack_ring'
      );
      expect(ringSlots.length, equals(2));
      expect(ringSlots.every((slot) => slot.item!.quantity == 1), isTrue);
    });

    test('Full equipment cycle', () {
      // Create multiple equipment pieces
      final weapon = Equipment(
        id: 'cycle_sword',
        name: 'Cycle Test Sword',
        description: 'A sword for cycle testing',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'damage': 10.0},
      );

      final armor = Equipment(
        id: 'cycle_armor',
        name: 'Cycle Test Armor',
        description: 'Armor for cycle testing',
        type: EquipmentType.armor,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'defense': 10.0},
      );

      // Add both to inventory
      inventory.addItem(weapon);
      inventory.addItem(armor);

      // Equip both
      final weaponIndex = inventory.slots.indexWhere(
        (slot) => slot.item?.id == 'cycle_sword'
      );
      final armorIndex = inventory.slots.indexWhere(
        (slot) => slot.item?.id == 'cycle_armor'
      );

      inventory.equipFromInventory(weaponIndex, EquipmentSlot.mainHand);
      inventory.equipFromInventory(armorIndex, EquipmentSlot.chest);

      // Verify equipment slots
      expect(inventory.equipmentSlots.slots[EquipmentSlot.mainHand]?.id, 
             equals('cycle_sword'));
      expect(inventory.equipmentSlots.slots[EquipmentSlot.chest]?.id, 
             equals('cycle_armor'));

      // Unequip both
      inventory.unequipToInventory(EquipmentSlot.mainHand);
      inventory.unequipToInventory(EquipmentSlot.chest);

      // Verify back in inventory
      expect(inventory.getItemQuantity('cycle_sword'), equals(1));
      expect(inventory.getItemQuantity('cycle_armor'), equals(1));

      // Verify equipment slots empty
      expect(inventory.equipmentSlots.slots[EquipmentSlot.mainHand], isNull);
      expect(inventory.equipmentSlots.slots[EquipmentSlot.chest], isNull);
    });

    test('Equipment slot type restrictions', () {
      final weapon = Equipment(
        id: 'restrict_sword',
        name: 'Restriction Test Sword',
        description: 'A sword for restriction testing',
        type: EquipmentType.weapon,
        rarity: Rarity.common,
        requiredLevel: 1,
        baseStats: {'damage': 10.0},
      );

      inventory.addItem(weapon);
      final slotIndex = inventory.slots.indexWhere(
        (slot) => slot.item?.id == 'restrict_sword'
      );

      // Try to equip weapon in invalid slots
      final invalidSlots = [
        EquipmentSlot.head,
        EquipmentSlot.chest,
        EquipmentSlot.legs,
        EquipmentSlot.feet,
        EquipmentSlot.ringLeft,
        EquipmentSlot.neck,
      ];

      for (final slot in invalidSlots) {
        final equipped = inventory.equipFromInventory(slotIndex, slot);
        expect(equipped, isNull);
        expect(inventory.equipmentSlots.slots[slot], isNull);
      }

      // Verify weapon still in inventory
      expect(inventory.getItemQuantity('restrict_sword'), equals(1));
    });
  });
}
