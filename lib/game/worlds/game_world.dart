import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../components/environment/day_night_cycle_component.dart';
import '../components/environment/weather_component.dart';
import '../components/map/map_component.dart';
import '../components/monster/monster_component.dart';
import '../components/npc/npc_component.dart';
import '../components/player/other_player_component.dart';

class GameWorld extends Component with HasGameRef {
  // Current map
  late MapComponent _currentMap;
  
  // Lists of entities in the world
  final List<NPCComponent> _npcs = [];
  final List<MonsterComponent> _monsters = [];
  final List<OtherPlayerComponent> _otherPlayers = [];
  
  // Camera
  late final CameraComponent _camera;
  
  // World state
  bool _isLoaded = false;
  
  GameWorld({
    required MapComponent initialMap,
  }) {
    _currentMap = initialMap;
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add current map
    await add(_currentMap);
    
    // Set up camera
    _camera = CameraComponent(world: this);
    await gameRef.add(_camera);
    
    // Load NPCs, monsters, and other entities for the current map
    await _loadMapEntities();
    
    _isLoaded = true;
  }
  
  Future<void> _loadMapEntities() async {
    // This would load NPCs, monsters, and other entities for the current map
    // For now, we'll use placeholder implementations
    
    // Load NPCs
    // Example:
    // final npcData = await _loadNpcData(_currentMap.mapId);
    // for (final data in npcData) {
    //   final npc = NPCComponent(
    //     npcId: data.id,
    //     name: data.name,
    //     sprite: await Sprite.load(data.spritePath),
    //     position: Vector2(data.x, data.y),
    //     size: Vector2(data.width, data.height),
    //     isShopkeeper: data.isShopkeeper,
    //     isQuestGiver: data.isQuestGiver,
    //   );
    //   _npcs.add(npc);
    //   await add(npc);
    // }
    
    // Load monsters
    // Example:
    // final monsterData = await _loadMonsterData(_currentMap.mapId);
    // for (final data in monsterData) {
    //   final monster = MonsterComponent(
    //     monsterId: data.id,
    //     name: data.name,
    //     sprite: await Sprite.load(data.spritePath),
    //     position: Vector2(data.x, data.y),
    //     size: Vector2(data.width, data.height),
    //     type: data.type,
    //     behaviors: data.behaviors,
    //     isNocturnal: data.isNocturnal,
    //   );
    //   _monsters.add(monster);
    //   await add(monster);
    // }
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    if (!_isLoaded) return;
    
    // Update entities based on player position, time of day, weather, etc.
  }
  
  // Change the current map
  Future<void> changeMap(MapComponent newMap) async {
    // Remove current map and entities
    _currentMap.removeFromParent();
    for (final npc in _npcs) {
      npc.removeFromParent();
    }
    for (final monster in _monsters) {
      monster.removeFromParent();
    }
    
    // Clear entity lists
    _npcs.clear();
    _monsters.clear();
    
    // Set new map
    _currentMap = newMap;
    await add(_currentMap);
    
    // Load entities for the new map
    await _loadMapEntities();
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay, double gameHour) {
    // Update map lighting
    _currentMap.onTimeOfDayChanged(timeOfDay);
    
    // Update NPCs
    for (final npc in _npcs) {
      npc.onTimeOfDayChanged(timeOfDay, gameHour);
    }
    
    // Update monsters
    for (final monster in _monsters) {
      monster.onTimeOfDayChanged(timeOfDay);
    }
    
    // Update other players
    for (final player in _otherPlayers) {
      player.onTimeOfDayChanged(timeOfDay);
    }
  }
  
  // Handle weather changes
  void onWeatherChanged(WeatherType weatherType, double intensity) {
    // Update map weather effects
    _currentMap.updateWeather(weatherType, intensity);
    
    // Update monsters (some monsters might behave differently in different weather)
    for (final monster in _monsters) {
      monster.onWeatherChanged(weatherType, intensity);
    }
  }
  
  // Add a new NPC to the world
  Future<void> addNpc(NPCComponent npc) async {
    _npcs.add(npc);
    await add(npc);
  }
  
  // Add a new monster to the world
  Future<void> addMonster(MonsterComponent monster) async {
    _monsters.add(monster);
    await add(monster);
  }
  
  // Add another player to the world
  Future<void> addOtherPlayer(OtherPlayerComponent player) async {
    _otherPlayers.add(player);
    await add(player);
  }
  
  // Remove an NPC from the world
  void removeNpc(String npcId) {
    final npc = _npcs.firstWhere((npc) => npc.npcId == npcId);
    _npcs.remove(npc);
    npc.removeFromParent();
  }
  
  // Remove a monster from the world
  void removeMonster(String monsterId) {
    final monster = _monsters.firstWhere((monster) => monster.monsterId == monsterId);
    _monsters.remove(monster);
    monster.removeFromParent();
  }
  
  // Remove another player from the world
  void removeOtherPlayer(String playerId) {
    final player = _otherPlayers.firstWhere((player) => player.playerId == playerId);
    _otherPlayers.remove(player);
    player.removeFromParent();
  }
  
  // Get the current map
  MapComponent get currentMap => _currentMap;
  
  // Get all NPCs in the world
  List<NPCComponent> get npcs => _npcs;
  
  // Get all monsters in the world
  List<MonsterComponent> get monsters => _monsters;
  
  // Get all other players in the world
  List<OtherPlayerComponent> get otherPlayers => _otherPlayers;
}