import 'package:flame/components.dart';
import '../../core/services/game_service.dart';
import '../../domain/entities/character.dart';

class CharacterController {
  final GameService gameService;
  late SpriteComponent playerComponent;
  late Character character;
  Vector2 targetPosition = Vector2.zero();
  bool isMoving = false;
  final double moveSpeed = 100.0; // pixels per second

  // Added properties for joystick control
  Vector2 velocity = Vector2.zero();
  ControlMode controlMode = ControlMode.none;

  CharacterController(this.gameService);

  void initialize(SpriteComponent component, Character char) {
    playerComponent = component;
    character = char;
    targetPosition = char.position;
    playerComponent.position = char.position;
  }

  void update(double dt) {
    if (controlMode == ControlMode.joystick) {
      _updateJoystickMovement(dt);
    } else if (isMoving) {
      _updateMovement(dt);
    }
  }

  void _updateJoystickMovement(double dt) {
    if (velocity != Vector2.zero()) {
      final newPosition = playerComponent.position + velocity * moveSpeed * dt;
      playerComponent.position = newPosition;
      _syncPositionWithServer();
    }
  }

  void _updateMovement(double dt) {
    final Vector2 direction = targetPosition - playerComponent.position;
    if (direction.length < moveSpeed * dt) {
      // Reached target position
      playerComponent.position = targetPosition;
      isMoving = false;
      _onMovementComplete();
    } else {
      direction.normalize();
      playerComponent.position += direction * moveSpeed * dt;
      _syncPositionWithServer();
    }
  }

  void moveTo(Vector2 position) {
    targetPosition = position;
    isMoving = true;
    controlMode = ControlMode.none;
  }

  void _onMovementComplete() {
    // Update character position in game state
    character = character.copyWith(position: playerComponent.position);
    _syncPositionWithServer();
  }

  void _syncPositionWithServer() {
    gameService.updatePlayerPosition(
      playerComponent.position.x,
      playerComponent.position.y,
      'current_map', // TODO: Track current map
    );
  }

  void handleInput(Vector2 direction) {
    if (direction != Vector2.zero()) {
      final newPosition = playerComponent.position + direction * moveSpeed;
      moveTo(newPosition);
    }
  }

  void startAutoWalk(Vector2 destination) {
    moveTo(destination);
  }

  void stopAutoWalk() {
    isMoving = false;
    controlMode = ControlMode.none;
    velocity = Vector2.zero();
  }
}

enum ControlMode {
  none,
  joystick,
}
