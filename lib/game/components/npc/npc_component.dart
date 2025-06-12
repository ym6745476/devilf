import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../environment/day_night_cycle_component.dart';

enum NPCActivityState {
  idle,
  working,
  sleeping,
  waking_up,
  closing_shop,
}

class NPCComponent extends SpriteAnimationComponent with HasGameRef {
  // NPC properties
  final String npcId;
  final String name;
  final bool isShopkeeper;
  final bool isQuestGiver;
  
  // NPC state
  NPCActivityState _currentActivity = NPCActivityState.idle;
  bool _isInteractable = true;
  
  // NPC schedule (hours in 24-hour format)
  final double _wakeHour;
  final double _sleepHour;
  final double _workStartHour;
  final double _workEndHour;
  
  // Lighting properties for time-of-day effects
  Color _currentLightColor = Colors.white;
  double _currentLightIntensity = 1.0;
  
  // Animations for different states
  late final Map<NPCActivityState, SpriteAnimation> _animations;
  
  // Interaction indicator
  late final SpriteComponent _interactionIndicator;
  bool _showInteractionIndicator = false;
  
  NPCComponent({
    required this.npcId,
    required this.name,
    required Sprite sprite,
    Vector2? position,
    Vector2? size,
    this.isShopkeeper = false,
    this.isQuestGiver = false,
    double wakeHour = 6.0,
    double sleepHour = 22.0,
    double workStartHour = 8.0,
    double workEndHour = 20.0,
  }) : 
    _wakeHour = wakeHour,
    _sleepHour = sleepHour,
    _workStartHour = workStartHour,
    _workEndHour = workEndHour,
    super(
      position: position,
      size: size,
    );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load animations for different states
    // This would load different animations for each activity state
    _animations = {
      NPCActivityState.idle: SpriteAnimation.spriteList(
        [await Sprite.load('npc/idle.png')], // Placeholder
        stepTime: 0.1,
      ),
      NPCActivityState.working: SpriteAnimation.spriteList(
        [await Sprite.load('npc/working.png')], // Placeholder
        stepTime: 0.1,
      ),
      NPCActivityState.sleeping: SpriteAnimation.spriteList(
        [await Sprite.load('npc/sleeping.png')], // Placeholder
        stepTime: 0.1,
      ),
      NPCActivityState.waking_up: SpriteAnimation.spriteList(
        [await Sprite.load('npc/waking.png')], // Placeholder
        stepTime: 0.1,
      ),
      NPCActivityState.closing_shop: SpriteAnimation.spriteList(
        [await Sprite.load('npc/closing.png')], // Placeholder
        stepTime: 0.1,
      ),
    };
    
    // Set initial animation
    animation = _animations[_currentActivity];
    
    // Load interaction indicator
    _interactionIndicator = SpriteComponent(
      sprite: await Sprite.load('ui/interaction_indicator.png'), // Placeholder
      position: Vector2(0, -size.y / 2 - 10),
      size: Vector2(20, 20),
    );
    await add(_interactionIndicator);
    _interactionIndicator.opacity = 0;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update interaction indicator visibility
    _interactionIndicator.opacity = _showInteractionIndicator ? 1.0 : 0.0;
    
    // Handle different activities
    switch (_currentActivity) {
      case NPCActivityState.idle:
        // Idle behavior
        break;
      case NPCActivityState.working:
        // Working behavior
        break;
      case NPCActivityState.sleeping:
        // Sleeping behavior
        break;
      case NPCActivityState.waking_up:
        // Waking up behavior
        // After a certain time, transition to idle or working
        break;
      case NPCActivityState.closing_shop:
        // Closing shop behavior
        // After a certain time, transition to idle or sleeping
        break;
    }
  }
  
  @override
  void render(Canvas canvas) {
    // Apply lighting effects based on time of day
    final paint = Paint()..colorFilter = ColorFilter.mode(
      _currentLightColor.withOpacity(_currentLightIntensity),
      BlendMode.modulate,
    );
    
    // Render with current lighting
    super.renderTree(canvas, paint);
    
    // Draw name above NPC
    _renderName(canvas);
  }
  
  void _renderName(Canvas canvas) {
    final textStyle = TextStyle(
      color: Colors.white,
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
  
  // Set NPC activity based on current state
  void setActivity(NPCActivityState activity) {
    if (_currentActivity == activity) return;
    
    _currentActivity = activity;
    animation = _animations[_currentActivity];
    
    // Update interactability based on activity
    _isInteractable = activity != NPCActivityState.sleeping;
  }
  
  // Update lighting based on time of day
  void updateLighting(Color lightColor, double lightIntensity) {
    _currentLightColor = lightColor;
    _currentLightIntensity = lightIntensity;
    
    // If sleeping, make even darker
    if (_currentActivity == NPCActivityState.sleeping) {
      _currentLightIntensity *= 0.7;
    }
  }
  
  // Check if NPC should be active at the given game hour
  bool isActiveAtHour(double gameHour) {
    return gameHour >= _wakeHour && gameHour < _sleepHour;
  }
  
  // Check if NPC should be working at the given game hour
  bool isWorkingAtHour(double gameHour) {
    return gameHour >= _workStartHour && gameHour < _workEndHour;
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay, double gameHour) {
    // Update NPC activity based on time of day
    if (gameHour >= _sleepHour || gameHour < _wakeHour) {
      // Sleeping time
      setActivity(NPCActivityState.sleeping);
    } else if (gameHour >= _workStartHour && gameHour < _workEndHour) {
      // Working time
      setActivity(NPCActivityState.working);
    } else if (gameHour >= _wakeHour && gameHour < _workStartHour) {
      // Just woke up
      setActivity(NPCActivityState.waking_up);
    } else if (gameHour >= _workEndHour && gameHour < _sleepHour) {
      // Closing shop or transitioning to evening activities
      if (isShopkeeper) {
        setActivity(NPCActivityState.closing_shop);
      } else {
        setActivity(NPCActivityState.idle);
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
  
  // Interaction methods
  
  void showInteractionIndicator() {
    if (_isInteractable) {
      _showInteractionIndicator = true;
    }
  }
  
  void hideInteractionIndicator() {
    _showInteractionIndicator = false;
  }
  
  bool interact() {
    if (!_isInteractable) return false;
    
    // Handle interaction based on NPC type and current activity
    if (isQuestGiver) {
      // Open quest dialog
      return true;
    } else if (isShopkeeper && _currentActivity == NPCActivityState.working) {
      // Open shop interface
      return true;
    } else {
      // General dialog
      return true;
    }
  }
}