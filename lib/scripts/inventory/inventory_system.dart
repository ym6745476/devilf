import 'dart:math' as math;
import '../equipment/equipment_system.dart';
import 'inventory_item.dart';

/// Basic consumable or material item
class BasicItem extends InventoryItem {
  BasicItem({
    required String id,
    required String name,
    required String description,
    bool isStackable = true,
    int maxStack = 99,
    int quantity = 1,
    required String icon,
    required int value,
  }) : super(
    id: id,
    name: name,
    description: description,
    isStackable: isStackable,
    maxStack: maxStack,
    quantity: quantity,
    icon: icon,
    value: value,
  );
  
  factory BasicItem.fromJson(Map<String, dynamic> json) {
    return BasicItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isStackable: json['isStackable'],
      maxStack: json['maxStack'],
      quantity: json['quantity'],
      icon: json['icon'],
      value: json['value'],
    );
  }
}

/// Represents a slot in the inventory grid
class InventorySlot {
  InventoryItem? item;
  final int index;
  
  InventorySlot(this.index);
  
  bool get isEmpty => item == null;
  
  bool canAcceptItem(InventoryItem newItem) {
    if (isEmpty) return true;
    return item!.canStackWith(newItem);
  }
  
  /// Try to add item to this slot
  /// Returns remaining quantity that couldn't be added
  int addItem(InventoryItem newItem) {
    if (isEmpty) {
      item = newItem;
      return 0;
    }
    
    if (item!.canStackWith(newItem)) {
      int spaceAvailable = item!.maxStack - item!.quantity;
      int amountToAdd = math.min(spaceAvailable, newItem.quantity);
      
      item!.quantity += amountToAdd;
      return newItem.quantity - amountToAdd;
    }
    
    return newItem.quantity;
  }
  
  /// Remove a quantity of items from this slot
  /// Returns the actual amount removed
  int removeItems(int amount) {
    if (isEmpty) return 0;
    
    int amountToRemove = math.min(amount, item!.quantity);
    item!.quantity -= amountToRemove;
    
    if (item!.quantity <= 0) {
      item = null;
    }
    
    return amountToRemove;
  }
  
  Map<String, dynamic> toJson() => {
    'index': index,
    'item': item?.toJson(),
  };
  
  factory InventorySlot.fromJson(Map<String, dynamic> json) {
    final slot = InventorySlot(json['index']);
    if (json['item'] != null) {
      // Check if item is equipment or basic item
      if (json['item']['type'] != null) {
        slot.item = Equipment.fromJson(json['item']);
      } else {
        slot.item = BasicItem.fromJson(json['item']);
      }
    }
    return slot;
  }
}

/// Main inventory system that manages items and equipment
class InventorySystem {
  final List<InventorySlot> slots;
  final EquipmentSlots equipmentSlots;
  final int maxSlots;
  
  InventorySystem({
    required this.maxSlots,
  }) : slots = List.generate(maxSlots, (index) => InventorySlot(index)),
       equipmentSlots = EquipmentSlots();
  
  /// Add item to inventory
  /// Returns true if the item was completely added
  bool addItem(InventoryItem item) {
    int remainingQuantity = item.quantity;
    
    // First try to stack with existing items
    if (item.isStackable) {
      for (var slot in slots) {
        if (!slot.isEmpty && slot.item!.id == item.id) {
          remainingQuantity = slot.addItem(item);
          if (remainingQuantity == 0) return true;
        }
      }
    }
    
    // Then try empty slots
    for (var slot in slots) {
      if (slot.isEmpty) {
        remainingQuantity = slot.addItem(item);
        if (remainingQuantity == 0) return true;
      }
    }
    
    return remainingQuantity == 0;
  }
  
  /// Remove items from inventory
  /// Returns the number of items actually removed
  int removeItems(String itemId, int amount) {
    int remainingToRemove = amount;
    int totalRemoved = 0;
    
    for (var slot in slots) {
      if (!slot.isEmpty && slot.item!.id == itemId) {
        int removed = slot.removeItems(remainingToRemove);
        totalRemoved += removed;
        remainingToRemove -= removed;
        
        if (remainingToRemove <= 0) break;
      }
    }
    
    return totalRemoved;
  }
  
  /// Get total quantity of an item in inventory
  int getItemQuantity(String itemId) {
    return slots
        .where((slot) => !slot.isEmpty && slot.item!.id == itemId)
        .fold(0, (sum, slot) => sum + slot.item!.quantity);
  }
  
  /// Check if there's room for an item
  bool hasRoomForItem(InventoryItem item) {
    if (!item.isStackable) {
      return slots.any((slot) => slot.isEmpty);
    }
    
    int remainingQuantity = item.quantity;
    
    // Check existing stacks
    for (var slot in slots) {
      if (!slot.isEmpty && slot.item!.id == item.id) {
        remainingQuantity -= (slot.item!.maxStack - slot.item!.quantity);
        if (remainingQuantity <= 0) return true;
      }
    }
    
    // Check empty slots
    int emptySlots = slots.where((slot) => slot.isEmpty).length;
    int slotsNeeded = (remainingQuantity / item.maxStack).ceil();
    
    return emptySlots >= slotsNeeded;
  }
  
  /// Equip an item from inventory
  Equipment? equipFromInventory(int slotIndex, EquipmentSlot equipmentSlot) {
    final slot = slots[slotIndex];
    if (slot.isEmpty) return null;
    
    final item = slot.item;
    if (item is! Equipment) return null;
    
    if (!equipmentSlots.canEquip(item, equipmentSlot)) return null;
    
    // Remove from inventory
    slot.removeItems(1);
    
    // Equip and get previously equipped item
    final previousEquipment = equipmentSlots.equip(item, equipmentSlot);
    
    // Add previous equipment to inventory if any
    if (previousEquipment != null) {
      addItem(previousEquipment);
    }
    
    return item;
  }
  
  /// Unequip an item to inventory
  bool unequipToInventory(EquipmentSlot equipmentSlot) {
    final equipment = equipmentSlots.unequip(equipmentSlot);
    if (equipment == null) return true;
    
    if (!hasRoomForItem(equipment)) {
      // Put the equipment back if there's no room
      equipmentSlots.equip(equipment, equipmentSlot);
      return false;
    }
    
    return addItem(equipment);
  }
  
  Map<String, dynamic> toJson() => {
    'slots': slots.map((slot) => slot.toJson()).toList(),
    'equipmentSlots': equipmentSlots.toJson(),
  };
  
  factory InventorySystem.fromJson(Map<String, dynamic> json) {
    final inventory = InventorySystem(maxSlots: json['slots'].length);
    
    // Load inventory slots
    for (int i = 0; i < json['slots'].length; i++) {
      inventory.slots[i] = InventorySlot.fromJson(json['slots'][i]);
    }
    
    // Load equipment slots
    final equipmentSlotsData = EquipmentSlots.fromJson(json['equipmentSlots']);
    equipmentSlotsData.slots.forEach((key, value) {
      inventory.equipmentSlots.slots[key] = value;
    });
    
    return inventory;
  }
}
