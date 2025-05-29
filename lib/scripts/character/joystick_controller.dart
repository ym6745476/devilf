import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flame/components.dart';
import 'character_controller.dart';

class JoystickController extends StatelessWidget {
  final CharacterController characterController;

  const JoystickController({
    Key? key,
    required this.characterController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 40,
      child: Joystick(
        mode: JoystickMode.all,
        onStickDragEnd: () {
          characterController.velocity = Vector2.zero();
        },
        listener: (details) {
          characterController.controlMode = ControlMode.joystick;
          characterController.velocity = Vector2(
            details.x,
            -details.y, // Invert Y since game coordinates are different from screen coordinates
          );
          characterController.velocity.normalize();
        },
      ),
    );
  }
}

class JoystickArea extends PositionComponent {
  final CharacterController characterController;
  bool isJoystickActive = false;
  Vector2 joystickPosition = Vector2.zero();

  JoystickArea(this.characterController);

  @override
  void update(double dt) {
    super.update(dt);
    if (isJoystickActive) {
      characterController.playerComponent.position += characterController.velocity * 100 * dt;
    }
  }

  void onJoystickMove(Vector2 delta) {
    characterController.velocity = delta;
    isJoystickActive = true;
  }

  void onJoystickRelease() {
    characterController.velocity = Vector2.zero();
    isJoystickActive = false;
  }
}
