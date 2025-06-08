import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../environment/day_night_cycle_component.dart';
import '../environment/weather_component.dart';

class MapComponent extends PositionComponent with HasGameRef {
  // Map properties
  final String mapId;
  final String mapName;
  final bool isPvpEnabled;
  final bool isSafeZone;
  
  // Map layers
  late final SpriteComponent _baseLayer;
  late final SpriteComponent _objectsLayer;
  late final SpriteComponent _foregroundLayer;
  
  // Lighting overlay for time-of-day effects
  late final RectangleComponent _lightingOverlay;
  
  // Weather overlay
  late final RectangleComponent _weatherOverlay;
  
  // Map boundaries
  late final Rect _mapBounds;
  
  // Current lighting properties
  Color _currentLightColor = Colors.white;
  double _currentLightIntensity = 1.0;
  
  // Current weather properties
  WeatherType _currentWeather = WeatherType.clear;
  double _weatherIntensity = 0.0;
  
  // Map-specific ambient sounds
  String? _dayAmbientSound;
  String? _nightAmbientSound;
  
  MapComponent({
    required this.mapId,
    required this.mapName,
    required Sprite baseLayerSprite,
    required Sprite objectsLayerSprite,
    Sprite? foregroundLayerSprite,
    Vector2? position,
    Vector2? size,
    this.isPvpEnabled = false,
    this.isSafeZone = false,
    String? dayAmbientSound,
    String? nightAmbientSound,
  }) : 
    _dayAmbientSound = dayAmbientSound,
    _nightAmbientSound = nightAmbientSound,
    super(
      position: position ?? Vector2.zero(),
      size: size ?? baseLayerSprite.originalSize,
    ) {
    _mapBounds = Rect.fromLTWH(0, 0, size?.x ?? baseLayerSprite.originalSize.x, size?.y ?? baseLayerSprite.originalSize.y);
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load map layers
    _baseLayer = SpriteComponent(
      sprite: await Sprite.load('maps/$mapId/base.png'),
      size: size,
    );
    await add(_baseLayer);
    
    _objectsLayer = SpriteComponent(
      sprite: await Sprite.load('maps/$mapId/objects.png'),
      size: size,
    );
    await add(_objectsLayer);
    
    // Load foreground layer if available
    try {
      _foregroundLayer = SpriteComponent(
        sprite: await Sprite.load('maps/$mapId/foreground.png'),
        size: size,
      );
      await add(_foregroundLayer);
    } catch (e) {
      // Foreground layer is optional
    }
    
    // Create lighting overlay for time-of-day effects
    _lightingOverlay = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.transparent,
    );
    await add(_lightingOverlay);
    
    // Create weather overlay
    _weatherOverlay = RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.transparent,
    );
    await add(_weatherOverlay);
  }
  
  @override
  void render(Canvas canvas) {
    // Base rendering is handled by child components
    super.render(canvas);
  }
  
  // Update lighting based on time of day
  void updateLighting(TimeOfDay timeOfDay, Color lightColor, double lightIntensity) {
    _currentLightColor = lightColor;
    _currentLightIntensity = lightIntensity;
    
    // Update lighting overlay
    _updateLightingOverlay();
  }
  
  void _updateLightingOverlay() {
    // Create gradient based on time of day
    final Paint lightingPaint = Paint();
    
    // Different maps might have different lighting effects
    if (mapId.contains('dungeon') || mapId.contains('cave')) {
      // Dungeons and caves are always dark
      lightingPaint.color = Colors.black.withOpacity(0.7 - (_currentLightIntensity * 0.3));
    } else {
      // Outdoor maps use the current light color
      lightingPaint.color = _currentLightColor.withOpacity(1.0 - _currentLightIntensity);
    }
    
    _lightingOverlay.paint = lightingPaint;
  }
  
  // Update weather overlay
  void updateWeather(WeatherType weatherType, double intensity) {
    _currentWeather = weatherType;
    _weatherIntensity = intensity;
    
    // Update weather overlay
    _updateWeatherOverlay();
  }
  
  void _updateWeatherOverlay() {
    // Create overlay based on weather type
    final Paint weatherPaint = Paint();
    
    switch (_currentWeather) {
      case WeatherType.clear:
        weatherPaint.color = Colors.transparent;
        break;
      case WeatherType.rain:
        weatherPaint.color = Colors.blueGrey.withOpacity(_weatherIntensity * 0.3);
        break;
      case WeatherType.snow:
        weatherPaint.color = Colors.white.withOpacity(_weatherIntensity * 0.2);
        break;
      case WeatherType.fog:
        weatherPaint.color = Colors.grey.withOpacity(_weatherIntensity * 0.5);
        break;
      case WeatherType.thunderstorm:
        weatherPaint.color = Colors.indigo.withOpacity(_weatherIntensity * 0.4);
        break;
      case WeatherType.sandstorm:
        weatherPaint.color = Color(0xFFD2B48C).withOpacity(_weatherIntensity * 0.6);
        break;
    }
    
    _weatherOverlay.paint = weatherPaint;
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay) {
    // Update ambient sounds based on time of day
    if (_dayAmbientSound != null && _nightAmbientSound != null) {
      final isNight = timeOfDay == TimeOfDay.night || timeOfDay == TimeOfDay.midnight;
      final ambientSound = isNight ? _nightAmbientSound! : _dayAmbientSound!;
      
      // Play appropriate ambient sound
      // This would integrate with the game's audio system
      // gameRef.audioSystem.playAmbient(ambientSound);
    }
    
    // Update lighting based on time of day
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        updateLighting(timeOfDay, Color(0xFFF0E6D2), 0.7);
        break;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        updateLighting(timeOfDay, Colors.white, 1.0);
        break;
      case TimeOfDay.evening:
        updateLighting(timeOfDay, Color(0xFFFFE0B2), 0.8);
        break;
      case TimeOfDay.dusk:
        updateLighting(timeOfDay, Color(0xFFFFB74D), 0.6);
        break;
      case TimeOfDay.night:
        updateLighting(timeOfDay, Color(0xFF3F51B5), 0.4);
        break;
      case TimeOfDay.midnight:
        updateLighting(timeOfDay, Color(0xFF1A237E), 0.25);
        break;
    }
  }
  
  // Check if a point is within the map boundaries
  bool isPointInBounds(Vector2 point) {
    return _mapBounds.contains(point.toOffset());
  }
  
  // Get map bounds
  Rect get bounds => _mapBounds;
  
  // Check if the map is currently in daylight
  bool isDaylight() {
    return _currentLightIntensity > 0.7;
  }
}