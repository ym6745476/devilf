/// Base class for all items that can be stored in inventory
class InventoryItem {
  final String id;
  final String name;
  final String description;
  final bool isStackable;
  final int maxStack;
  int quantity;
  final String icon;
  final int value; // Gold value
  
  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    this.isStackable = false,
    this.maxStack = 1,
    this.quantity = 1,
    required this.icon,
    required this.value,
  });
  
  bool canStackWith(InventoryItem other) {
    return isStackable && other.isStackable && id == other.id && 
           quantity < maxStack && other.quantity < maxStack;
  }
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'isStackable': isStackable,
    'maxStack': maxStack,
    'quantity': quantity,
    'icon': icon,
    'value': value,
  };
}
