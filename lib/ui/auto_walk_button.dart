import 'package:flutter/material.dart';

class AutoWalkButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const AutoWalkButton({
    Key? key,
    required this.onPressed,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(isActive ? Icons.pause : Icons.play_arrow),
      label: Text(isActive ? 'Stop Auto-Walk' : 'Start Auto-Walk'),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.red : Colors.green,
      ),
    );
  }
}
