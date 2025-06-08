import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../environment/day_night_cycle_component.dart';
import '../environment/weather_component.dart';

enum MonsterActivityState {
  idle,
  patrolling,
  hunting,
  sleeping,
  fleeing,
}

enum MonsterType {
  normal,
  elite,
  boss,
  worldBoss,
}

enum MonsterBehavior {
  passive,      // Only attacks when attacked
  aggressive,   // Attacks players on sight
  territorial,  // Attacks when players enter its territory
  nocturnal,    // More active at night
  diurnal,      // More active during day
}

class MonsterComponent extends SpriteAnimationComponent with HasGameRef {
  // Monster properties
  final String monsterId;
  final String name;
  final MonsterType type;
  final List<MonsterBehavior> behaviors;
  
  // Monster state
  MonsterActivityState _currentActivity = MonsterActivityState.idle;
  double _aggressionLevel = 0.5; // 0.0 to 1.0
  double _movementSpeed = 50.0; // pixels per second
  double _detectionRange = 200.0; // pixels
  
  // Time-based properties
  final bool _isNocturnal;
  
  // Weather-based properties
  double _weatherSpeedModifier = 1.0;
  double _weatherDetectionModifier = 1.0;
  
  // Lighting properties for time-of-day effects
  Color _currentLightColor = Colors.white;
  double _currentLightIntensity = 1.0;
  
  // Glow effect for special monsters
  bool _hasGlowEffect = false;
  Color _glowColor = Colors.transparent;
  double _glowIntensity = 0.0;
  
  // Animations for different states
  late final Map<MonsterActivityState, SpriteAnimation> _animations;
  
  MonsterComponent({
    required this.monsterId,
    required this.name,
    required Sprite sprite,
    Vector2? position,
    Vector2? size,
    this.type = MonsterType.normal,
    this.behaviors = const [MonsterBehavior.aggressive],
    bool isNocturnal = false,
  }) : 
    _isNocturnal = isNocturnal,
    super(
      position: position,
      size: size,
    ) {
    // Set up glow effect based on monster type
    switch (type) {
      case MonsterType.normal:
        _hasGlowEffect = false;
        break;
      case MonsterType.elite:
        _hasGlowEffect = true;
        _glowColor = Colors.blue;
        _glowIntensity = 0.3;
        break;
      case MonsterType.boss:
        _hasGlowEffect = true;
        _glowColor = Colors.purple;
        _glowIntensity = 0.5;
        break;
      case MonsterType.worldBoss:
        _hasGlowEffect = true;
        _glowColor = Colors.red;
        _glowIntensity = 0.7;
        break;
    }
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load animations for different states
    // This would load different animations for each activity state
    _animations = {
      MonsterActivityState.idle: SpriteAnimation.spriteList(
        [await Sprite.load('monster/idle.png')], // Placeholder
        stepTime: 0.1,
      ),
      MonsterActivityState.patrolling: SpriteAnimation.spriteList(
        [await Sprite.load('monster/patrol.png')], // Placeholder
        stepTime: 0.1,
      ),
      MonsterActivityState.hunting: SpriteAnimation.spriteList(
        [await Sprite.load('monster/hunt.png')], // Placeholder
        stepTime: 0.1,
      ),
      MonsterActivityState.sleeping: SpriteAnimation.spriteList(
        [await Sprite.load('monster/sleep.png')], // Placeholder
        stepTime: 0.1,
      ),
      MonsterActivityState.fleeing: SpriteAnimation.spriteList(
        [await Sprite.load('monster/flee.png')], // Placeholder
        stepTime: 0.1,
      ),
    };
    
    // Set initial animation
    animation = _animations[_currentActivity];
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Apply weather speed modifier to movement
    final effectiveSpeed = _movementSpeed * _weatherSpeedModifier;
    
    // Handle different activities
    switch (_currentActivity) {
      case MonsterActivityState.idle:
        // Idle behavior - occasionally look around or make small movements
        break;
      case MonsterActivityState.patrolling:
        // Patrolling behavior - move along a predefined path
        break;
      case MonsterActivityState.hunting:
        // Hunting behavior - actively pursue target
        break;
      case MonsterActivityState.sleeping:
        // Sleeping behavior - don't move, reduced detection
        break;
      case MonsterActivityState.fleeing:
        // Fleeing behavior - run away from threat
        break;
    }
    
    // Check for nearby players if not sleeping
    if (_currentActivity != MonsterActivityState.sleeping) {
      _checkForPlayers();
    }
  }
  
  void _checkForPlayers() {
    // This would check for players within detection range
    // If a player is detected, the monster might change to hunting state
    // The detection range would be modified by weather and time of day
    final effectiveDetectionRange = _detectionRange * _weatherDetectionModifier;
    
    // Example implementation:
    // final nearbyPlayers = gameRef.players.where((player) {
    //   final distance = position.distanceTo(player.position);
    //   return distance <= effectiveDetectionRange;
    // }).toList();
    
    // if (nearbyPlayers.isNotEmpty && _shouldAttackPlayer()) {
    //   _currentActivity = MonsterActivityState.hunting;
    //   animation = _animations[_currentActivity];
    // }
  }
  
  bool _shouldAttackPlayer() {
    // Determine if the monster should attack based on its behavior
    if (behaviors.contains(MonsterBehavior.aggressive)) {
      return true;
    }
    
    if (behaviors.contains(MonsterBehavior.nocturnal) && _isNighttime()) {
      return Random().nextDouble() < _aggressionLevel * 1.5; // More aggressive at night
    }
    
    if (behaviors.contains(MonsterBehavior.diurnal) && !_isNighttime()) {
      return Random().nextDouble() < _aggressionLevel * 1.5; // More aggressive during day
    }
    
    return Random().nextDouble() < _aggressionLevel;
  }
  
  bool _isNighttime() {
    // This would check the current game time to determine if it's night
    // For now, we'll use a placeholder implementation
    return false;
  }
  
  @override
  void render(Canvas canvas) {
    // Render glow effect if monster has one
    if (_hasGlowEffect) {
      final rect = Rect.fromCenter(
        center: size.center().toOffset(),
        width: size.x * 1.5,
        height: size.y * 1.5,
      );
      
      final paint = Paint()
        ..color = _glowColor.withOpacity(_glowIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);
      
      canvas.drawOval(rect, paint);
    }
    
    // Apply lighting effects based on time of day
    final paint = Paint()..colorFilter = ColorFilter.mode(
      _currentLightColor.withOpacity(_currentLightIntensity),
      BlendMode.modulate,
    );
    
    // Render with current lighting
    super.renderTree(canvas, paint);
    
    // Draw name above monster
    _renderName(canvas);
  }
  
  void _renderName(Canvas canvas) {
    // Only render name for elite, boss, or world boss monsters
    if (type == MonsterType.normal) return;
    
    final textStyle = TextStyle(
      color: _getNameColor(),
      fontSize: 12,
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.black,
          offset: Offset(1, 1),
        ),
      ],
    );
    
    final textPainter = TextPainter(
      text: TextSpan(text: name, style: textStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout();
    textPainter.paint(
      canvas,
      Vector2(
        -textPainter.width / 2 + size.x / 2,
        -textPainter.height - 5,
      ).toOffset(),
    );
  }
  
  Color _getNameColor() {
    switch (type) {
      case MonsterType.normal:
        return Colors.white;
      case MonsterType.elite:
        return Colors.blue;
      case MonsterType.boss:
        return Colors.purple;
      case MonsterType.worldBoss:
        return Colors.red;
    }
  }
  
  // Set monster activity state
  void setActivity(MonsterActivityState activity) {
    if (_currentActivity == activity) return;
    
    _currentActivity = activity;
    animation = _animations[_currentActivity];
  }
  
  // Update lighting based on time of day
  void updateLighting(Color lightColor, double lightIntensity) {
    _currentLightColor = lightColor;
    _currentLightIntensity = lightIntensity;
    
    // Nocturnal monsters are less affected by darkness
    if (_isNocturnal && lightIntensity < 0.5) {
      _currentLightIntensity = max(0.5, lightIntensity);
    }
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay) {
    // Update monster behavior based on time of day
    if (_isNocturnal) {
      // Nocturnal monsters are more active at night
      switch (timeOfDay) {
        case TimeOfDay.dawn:
          // Going to sleep as dawn approaches
          _aggressionLevel = 0.3;
          if (_currentActivity != MonsterActivityState.hunting) {
            setActivity(MonsterActivityState.idle);
          }
          break;
        case TimeOfDay.morning:
        case TimeOfDay.noon:
        case TimeOfDay.afternoon:
          // Sleeping or less active during day
          _aggressionLevel = 0.1;
          if (_currentActivity != MonsterActivityState.hunting) {
            setActivity(MonsterActivityState.sleeping);
          }
          break;
        case TimeOfDay.evening:
        case TimeOfDay.dusk:
          // Waking up as evening approaches
          _aggressionLevel = 0.6;
          if (_currentActivity == MonsterActivityState.sleeping) {
            setActivity(MonsterActivityState.idle);
          }
          break;
        case TimeOfDay.night:
        case TimeOfDay.midnight:
          // Most active at night
          _aggressionLevel = 0.9;
          if (_currentActivity == MonsterActivityState.sleeping) {
            setActivity(MonsterActivityState.patrolling);
          }
          break;
      }
    } else {
      // Diurnal monsters are more active during day
      switch (timeOfDay) {
        case TimeOfDay.dawn:
          // Waking up at dawn
          _aggressionLevel = 0.6;
          if (_currentActivity == MonsterActivityState.sleeping) {
            setActivity(MonsterActivityState.idle);
          }
          break;
        case TimeOfDay.morning:
        case TimeOfDay.noon:
        case TimeOfDay.afternoon:
          // Most active during day
          _aggressionLevel = 0.8;
          if (_currentActivity == MonsterActivityState.sleeping) {
            setActivity(MonsterActivityState.patrolling);
          }
          break;
        case TimeOfDay.evening:
        case TimeOfDay.dusk:
          // Becoming less active as evening approaches
          _aggressionLevel = 0.4;
          if (_currentActivity != MonsterActivityState.hunting) {
            setActivity(MonsterActivityState.idle);
          }
          break;
        case TimeOfDay.night:
        case TimeOfDay.midnight:
          // Sleeping or less active at night
          _aggressionLevel = 0.2;
          if (_currentActivity != MonsterActivityState.hunting) {
            setActivity(MonsterActivityState.sleeping);
          }
          break;
      }
    }
    
    // Update lighting based on time of day
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        updateLighting(Color(0xFFF0E6D2), 0.7);
        break;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        updateLighting(Colors.white, 1.0);
        break;
      case TimeOfDay.evening:
        updateLighting(Color(0xFFFFE0B2), 0.8);
        break;
      case TimeOfDay.dusk:
        updateLighting(Color(0xFFFFB74D), 0.6);
        break;
      case TimeOfDay.night:
        updateLighting(Color(0xFF3F51B5), 0.4);
        break;
      case TimeOfDay.midnight:
        updateLighting(Color(0xFF1A237E), 0.25);
        break;
    }
  }
  
  // Handle weather changes
  void onWeatherChanged(WeatherType weatherType, double intensity) {
    // Update monster behavior based on weather
    switch (weatherType) {
      case WeatherType.clear:
        _weatherSpeedModifier = 1.0;
        _weatherDetectionModifier = 1.0;
        break;
      case WeatherType.rain:
        _weatherSpeedModifier = 1.0 - (intensity * 0.1);
        _weatherDetectionModifier = 1.0 - (intensity * 0.2);
        break;
      case WeatherType.snow:
        _weatherSpeedModifier = 1.0 - (intensity * 0.3);
        _weatherDetectionModifier = 1.0 - (intensity * 0.3);
        break;
      case WeatherType.fog:
        _weatherSpeedModifier = 1.0 - (intensity * 0.1);
        _weatherDetectionModifier = 1.0 - (intensity * 0.5);
        break;
      case WeatherType.thunderstorm:
        _weatherSpeedModifier = 1.0 - (intensity * 0.2);
        _weatherDetectionModifier = 1.0 - (intensity * 0.4);
        
        // Some monsters might become more aggressive during thunderstorms
        if (behaviors.contains(MonsterBehavior.aggressive)) {
          _aggressionLevel = min(1.0, _aggressionLevel + (intensity * 0.2));
        }
        break;
      case WeatherType.sandstorm:
        _weatherSpeedModifier = 1.0 - (intensity * 0.4);
        _weatherDetectionModifier = 1.0 - (intensity * 0.6);
        break;
    }
  }
}