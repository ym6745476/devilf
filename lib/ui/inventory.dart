import 'package:flutter/material.dart';

class InventoryItem {
  final String id;
  final String name;
  final int quantity;

  InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
  });
}

class InventoryWidget extends StatelessWidget {
  final List<InventoryItem> items;
  final void Function(String) onItemSelected;

  const InventoryWidget({
    Key? key,
    required this.items,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onItemSelected(item.id),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[800],
              ),
              child: Center(
                child: Text(
                  '${item.name} x${item.quantity}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
