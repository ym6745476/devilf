import 'dart:math';
import 'package:flutter/material.dart';
import '../inventory/inventory_item.dart';

enum EquipmentType {
  weapon,
  helmet,
  armor,
  pants,
  boots,
  cloak,
  ring,
  necklace,
  earring,
}

enum EquipmentSlot {
  mainHand,
  offHand,
  head,
  chest,
  legs,
  feet,
  back,
  ringLeft,
  ringRight,
  neck,
  earLeft,
  earRight,
}

enum Rarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythical,
}

class Socket {
  final SocketType type;
  Map<String, double>? gem;
  
  Socket(this.type);
  
  bool get isEmpty => gem == null;
  
  void insertGem(Map<String, double> stats) {
    gem = stats;
  }
  
  Map<String, double>? removeGem() {
    final removed = gem;
    gem = null;
    return removed;
  }
  
  Map<String, dynamic> toJson() => {
    'type': type.toString(),
    'gem': gem,
  };
  
  factory Socket.fromJson(Map<String, dynamic> json) {
    final socket = Socket(SocketType.values.firstWhere(
      (e) => e.toString() == json['type']
    ));
    socket.gem = json['gem']?.cast<String, double>();
    return socket;
  }
}

enum SocketType {
  attack,
  defense,
  utility,
  special,
}

class Enhancement {
  int level = 0;
  double damageBonus = 0;
  double defenseBonus = 0;
  double successRate = 1.0; // 100% for first enhancement
  
  Enhancement();
  
  void reset() {
    level = 0;
    damageBonus = 0;
    defenseBonus = 0;
    successRate = 1.0;
  }
  
  bool tryEnhance() {
    if (level >= 20) return false;
    
    if (Random().nextDouble() <= successRate) {
      level++;
      damageBonus += 5.0 * level;
      defenseBonus += 3.0 * level;
      successRate = max(0.1, 1.0 - (level * 0.05));
      return true;
    }
    
    // Enhancement failed
    if (level > 15) {
      level--;
      damageBonus -= 5.0;
      defenseBonus -= 3.0;
    }
    return false;
  }
  
  Map<String, dynamic> toJson() => {
    'level': level,
    'damageBonus': damageBonus,
    'defenseBonus': defenseBonus,
    'successRate': successRate,
  };
  
  factory Enhancement.fromJson(Map<String, dynamic> json) {
    final enhancement = Enhancement()
      ..level = json['level']
      ..damageBonus = json['damageBonus']
      ..defenseBonus = json['defenseBonus']
      ..successRate = json['successRate'];
    return enhancement;
  }
}

class EquipmentEffect {
  final Color glowColor;
  final double glowIntensity;
  final String? particleEffect;
  
  const EquipmentEffect({
    required this.glowColor,
    required this.glowIntensity,
    this.particleEffect,
  });
  
  factory EquipmentEffect.forRarity(Rarity rarity) {
    switch (rarity) {
      case Rarity.common:
        return const EquipmentEffect(
          glowColor: Colors.grey,
          glowIntensity: 0.0,
        );
      case Rarity.uncommon:
        return const EquipmentEffect(
          glowColor: Colors.green,
          glowIntensity: 0.3,
        );
      case Rarity.rare:
        return const EquipmentEffect(
          glowColor: Colors.blue,
          glowIntensity: 0.5,
          particleEffect: 'rare_sparkle',
        );
      case Rarity.epic:
        return const EquipmentEffect(
          glowColor: Colors.purple,
          glowIntensity: 0.6,
          particleEffect: 'epic_aura',
        );
      case Rarity.legendary:
        return const EquipmentEffect(
          glowColor: Colors.orange,
          glowIntensity: 0.7,
          particleEffect: 'legendary_flames',
        );
      case Rarity.mythical:
        return const EquipmentEffect(
          glowColor: Colors.red,
          glowIntensity: 1.0,
          particleEffect: 'mythical_dragon',
        );
    }
  }
}

class Equipment extends InventoryItem {
  final EquipmentType type;
  final Rarity rarity;
  final int requiredLevel;
  final Map<String, double> baseStats;
  final List<Socket> sockets;
  final Enhancement enhancement;
  final EquipmentEffect effect;
  
  Equipment({
    required String id,
    required String name,
    required String description,
    required this.type,
    required this.rarity,
    required this.requiredLevel,
    required this.baseStats,
    this.sockets = const [],
    String? icon,
    int value = 0,
  }) : enhancement = Enhancement(),
       effect = EquipmentEffect.forRarity(rarity),
       super(
         id: id,
         name: name,
         description: description,
         isStackable: false,
         maxStack: 1,
         quantity: 1,
         icon: icon ?? 'assets/equipment/${type.toString().toLowerCase()}.png',
         value: value,
       );
  
  Map<String, double> get totalStats {
    final stats = Map<String, double>.from(baseStats);
    
    // Add socket bonuses
    for (var socket in sockets) {
      if (!socket.isEmpty) {
        socket.gem!.forEach((stat, value) {
          stats[stat] = (stats[stat] ?? 0.0) + value;
        });
      }
    }
    
    // Add enhancement bonuses
    if (enhancement.damageBonus > 0) {
      stats['damage'] = (stats['damage'] ?? 0.0) + enhancement.damageBonus;
    }
    if (enhancement.defenseBonus > 0) {
      stats['defense'] = (stats['defense'] ?? 0.0) + enhancement.defenseBonus;
    }
    
    return stats;
  }
  
  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'type': type.toString(),
    'rarity': rarity.toString(),
    'requiredLevel': requiredLevel,
    'baseStats': baseStats,
    'sockets': sockets.map((s) => s.toJson()).toList(),
    'enhancement': enhancement.toJson(),
  };
  
  factory Equipment.fromJson(Map<String, dynamic> json) {
    final equipment = Equipment(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: EquipmentType.values.firstWhere(
        (e) => e.toString() == json['type']
      ),
      rarity: Rarity.values.firstWhere(
        (r) => r.toString() == json['rarity']
      ),
      requiredLevel: json['requiredLevel'],
      baseStats: (json['baseStats'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as double)),
      sockets: (json['sockets'] as List)
        .map((s) => Socket.fromJson(s))
        .toList(),
      icon: json['icon'],
      value: json['value'],
    );
    
    equipment.enhancement.level = json['enhancement']['level'];
    equipment.enhancement.damageBonus = json['enhancement']['damageBonus'];
    equipment.enhancement.defenseBonus = json['enhancement']['defenseBonus'];
    equipment.enhancement.successRate = json['enhancement']['successRate'];
    
    return equipment;
  }
}

class EquipmentSlots {
  final Map<EquipmentSlot, Equipment?> slots = {};
  
  EquipmentSlots() {
    // Initialize all slots as empty
    for (var slot in EquipmentSlot.values) {
      slots[slot] = null;
    }
  }
  
  bool canEquip(Equipment equipment, EquipmentSlot slot) {
    // Check if the equipment type matches the slot
    switch (slot) {
      case EquipmentSlot.mainHand:
      case EquipmentSlot.offHand:
        return equipment.type == EquipmentType.weapon;
      case EquipmentSlot.head:
        return equipment.type == EquipmentType.helmet;
      case EquipmentSlot.chest:
        return equipment.type == EquipmentType.armor;
      case EquipmentSlot.legs:
        return equipment.type == EquipmentType.pants;
      case EquipmentSlot.feet:
        return equipment.type == EquipmentType.boots;
      case EquipmentSlot.back:
        return equipment.type == EquipmentType.cloak;
      case EquipmentSlot.ringLeft:
      case EquipmentSlot.ringRight:
        return equipment.type == EquipmentType.ring;
      case EquipmentSlot.neck:
        return equipment.type == EquipmentType.necklace;
      case EquipmentSlot.earLeft:
      case EquipmentSlot.earRight:
        return equipment.type == EquipmentType.earring;
    }
  }
  
  Equipment? equip(Equipment equipment, EquipmentSlot slot) {
    if (!canEquip(equipment, slot)) return null;
    
    // Store currently equipped item to return
    Equipment? previous = slots[slot];
    
    // Equip new item
    slots[slot] = equipment;
    
    return previous;
  }
  
  Equipment? unequip(EquipmentSlot slot) {
    Equipment? item = slots[slot];
    slots[slot] = null;
    return item;
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    slots.forEach((slot, equipment) {
      json[slot.toString()] = equipment?.toJson();
    });
    return json;
  }
  
  factory EquipmentSlots.fromJson(Map<String, dynamic> json) {
    final slots = EquipmentSlots();
    json.forEach((key, value) {
      if (value != null) {
        final slot = EquipmentSlot.values.firstWhere(
          (e) => e.toString() == key
        );
        slots.slots[slot] = Equipment.fromJson(value);
      }
    });
    return slots;
  }
}

class EquipmentSystem {
  final Map<String, Equipment> _templates = {};
  
  void registerTemplate(Equipment template) {
    _templates[template.id] = template;
  }
  
  Equipment? createEquipment(String templateId) {
    final template = _templates[templateId];
    if (template == null) return null;
    
    return Equipment(
      id: template.id,
      name: template.name,
      description: template.description,
      type: template.type,
      rarity: template.rarity,
      requiredLevel: template.requiredLevel,
      baseStats: Map<String, double>.from(template.baseStats),
      sockets: template.sockets.map((s) => Socket(s.type)).toList(),
      icon: template.icon,
      value: template.value,
    );
  }
  
  bool insertGem(Equipment equipment, int socketIndex, Map<String, double> stats) {
    if (socketIndex >= equipment.sockets.length) return false;
    
    final socket = equipment.sockets[socketIndex];
    if (!socket.isEmpty) return false;
    
    socket.insertGem(stats);
    return true;
  }
  
  Map<String, double>? removeGem(Equipment equipment, int socketIndex) {
    if (socketIndex >= equipment.sockets.length) return null;
    return equipment.sockets[socketIndex].removeGem();
  }
}
