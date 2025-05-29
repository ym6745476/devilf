import 'package:flame/extensions.dart';
import 'character_controller.dart';

class AutoWalkController {
  final CharacterController characterController;
  Vector2? destination;
  bool isAutoWalking = false;

  AutoWalkController(this.characterController);

  void startAutoWalk(Vector2 targetPosition) {
    destination = targetPosition;
    isAutoWalking = true;
    characterController.moveTo(targetPosition);
  }

  void stopAutoWalk() {
    isAutoWalking = false;
    destination = null;
    characterController.stopAutoWalk();
  }

  void update(double dt) {
    if (!isAutoWalking || destination == null) return;

    final currentPosition = characterController.playerComponent.position;
    final distance = (destination! - currentPosition).length;

    if (distance < 1.0) {
      stopAutoWalk();
    } else {
      characterController.moveTo(destination!);
    }
  }
}
