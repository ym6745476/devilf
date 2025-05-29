import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import '../core/services/game_service.dart';
import 'character/character_controller.dart';
import 'combat/combat_system.dart';
import '../domain/entities/character.dart';

class GameEngine extends FlameGame {
  final GameService gameService;
  late CharacterController characterController;
  late CombatSystem combatSystem;
  late World gameWorld;
  late CameraComponent camera;

  GameEngine({required this.gameService}) {
    characterController = CharacterController(gameService);
    combatSystem = CombatSystem(gameService);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Initialize game world
    gameWorld = World();
    camera = CameraComponent(world: gameWorld)
      ..viewfinder.anchor = Anchor.center;

    // Add base systems
    addAll([gameWorld, camera]);

    // Load map and assets
    await loadMap('starting_zone');

    // Initialize character if available
    if (gameService.currentCharacter != null) {
      await spawnCharacter(gameService.currentCharacter!);
    }

    // Set up game state listeners
    gameService.gameStateStream.listen(_handleGameState);
  }

  Future<void> loadMap(String mapName) async {
    // TODO: Load map data from assets
    // For now, create a simple ground
    final ground = RectangleComponent(
      size: Vector2(1000, 1000),
      paint: BasicPalette.white.paint(),
    );
    gameWorld.add(ground);
  }

  Future<void> spawnCharacter(Character character) async {
    final playerSprite = await loadSprite('characters/${character.characterClass.toString().split('.').last}.png');
    final playerComponent = SpriteComponent(
      sprite: playerSprite,
      size: Vector2(32, 32),
      position: character.position,
    );
    
    characterController.initialize(playerComponent, character);
    gameWorld.add(playerComponent);
    camera.follow(playerComponent);
  }

  void _handleGameState(Map<String, dynamic> state) {
    switch (state['type']) {
      case 'playerUpdate':
        _handlePlayerUpdate(state['data']);
        break;
      case 'combat':
        _handleCombatUpdate(state['data']);
        break;
      case 'worldUpdate':
        _handleWorldUpdate(state['data']);
        break;
    }
  }

  void _handlePlayerUpdate(Map<String, dynamic> data) {
    // Update other players' positions and states
    final playerId = data['id'];
    if (playerId != gameService.currentCharacter?.id) {
      // TODO: Update other player positions
    }
  }

  void _handleCombatUpdate(Map<String, dynamic> data) {
    combatSystem.handleCombatEvent(data);
  }

  void _handleWorldUpdate(Map<String, dynamic> data) {
    // Update world state (NPCs, monsters, items, etc.)
  }

  @override
  void update(double dt) {
    super.update(dt);
    characterController.update(dt);
    combatSystem.update(dt);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    camera.viewport.size = size;
  }
}
