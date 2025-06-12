import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../scripts/game_engine.dart';
import 'auto_walk_button.dart';

class GameInterface extends StatefulWidget {
  final GameEngine gameEngine;

  const GameInterface({Key? key, required this.gameEngine}) : super(key: key);

  @override
  _GameInterfaceState createState() => _GameInterfaceState();
}

class _GameInterfaceState extends State<GameInterface> {
  bool isAutoWalking = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Other HUD elements can be added here
        
        AutoWalkButton(
          isActive: isAutoWalking,
          onPressed: () {
            setState(() {
              if (isAutoWalking) {
                widget.gameEngine.characterController.stopAutoWalk();
                isAutoWalking = false;
              } else {
                final currentPos = widget.gameEngine.characterController.playerComponent.position;
                widget.gameEngine.characterController.startAutoWalk(
                  Vector2(currentPos.x + 200, currentPos.y),
                );
                isAutoWalking = true;
              }
            });
          },
        ),
      ],
    );
  }
}
