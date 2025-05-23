import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../environment/day_night_cycle_component.dart';

class OtherPlayerComponent extends SpriteAnimationComponent with HasGameRef {
  // Player properties
  final String playerId;
  final String playerName;
  final int level;
  final String guildName;
  
  // Equipment properties
  bool _hasWeaponGlow = false;
  bool _hasArmorGlow = false;
  bool _hasWings = false;
  
  // Glow effects
  Color _weaponGlowColor = Colors.transparent;
  Color _armorGlowColor = Colors.transparent;
  Color _wingsGlowColor = Colors.transparent;
  double _glowIntensity = 0.0;
  
  // Lighting properties for time-of-day effects
  Color _currentLightColor = Colors.white;
  double _currentLightIntensity = 1.0;
  
  // Animations for different states
  late final Map<String, SpriteAnimation> _animations;
  
  // Current animation state
  String _currentAnimationState = 'idle';
  
  OtherPlayerComponent({
    required this.playerId,
    required this.playerName,
    required this.level,
    this.guildName = '',
    required Sprite sprite,
    Vector2? position,
    Vector2? size,
    bool hasWeaponGlow = false,
    bool hasArmorGlow = false,
    bool hasWings = false,
    Color weaponGlowColor = Colors.blue,
    Color armorGlowColor = Colors.purple,
    Color wingsGlowColor = Colors.white,
  }) : 
    _hasWeaponGlow = hasWeaponGlow,
    _hasArmorGlow = hasArmorGlow,
    _hasWings = hasWings,
    _weaponGlowColor = weaponGlowColor,
    _armorGlowColor = armorGlowColor,
    _wingsGlowColor = wingsGlowColor,
    super(
      position: position,
      size: size,
    );
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load animations for different states
    _animations = {
      'idle': SpriteAnimation.spriteList(
        [await Sprite.load('player/idle.png')], // Placeholder
        stepTime: 0.1,
      ),
      'walk': SpriteAnimation.spriteList(
        [await Sprite.load('player/walk.png')], // Placeholder
        stepTime: 0.1,
      ),
      'attack': SpriteAnimation.spriteList(
        [await Sprite.load('player/attack.png')], // Placeholder
        stepTime: 0.1,
      ),
    };
    
    // Set initial animation
    animation = _animations[_currentAnimationState];
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update animation based on current state
    animation = _animations[_currentAnimationState];
  }
  
  @override
  void render(Canvas canvas) {
    // Render wings glow if player has wings
    if (_hasWings) {
      final rect = Rect.fromCenter(
        center: Vector2(size.x / 2, 0).toOffset(),
        width: size.x * 1.5,
        height: size.y * 0.8,
      );
      
      final paint = Paint()
        ..color = _wingsGlowColor.withOpacity(_glowIntensity * 0.7)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);
      
      canvas.drawOval(rect, paint);
    }
    
    // Render weapon glow if player has weapon glow
    if (_hasWeaponGlow) {
      final rect = Rect.fromCenter(
        center: Vector2(size.x * 0.7, size.y * 0.4).toOffset(),
        width: size.x * 0.5,
        height: size.y * 0.5,
      );
      
      final paint = Paint()
        ..color = _weaponGlowColor.withOpacity(_glowIntensity * 0.8)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);
      
      canvas.drawOval(rect, paint);
    }
    
    // Render armor glow if player has armor glow
    if (_hasArmorGlow) {
      final rect = Rect.fromCenter(
        center: Vector2(size.x / 2, size.y * 0.5).toOffset(),
        width: size.x * 0.8,
        height: size.y * 0.8,
      );
      
      final paint = Paint()
        ..color = _armorGlowColor.withOpacity(_glowIntensity * 0.5)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);
      
      canvas.drawOval(rect, paint);
    }
    
    // Apply lighting effects based on time of day
    final paint = Paint()..colorFilter = ColorFilter.mode(
      _currentLightColor.withOpacity(_currentLightIntensity),
      BlendMode.modulate,
    );
    
    // Render with current lighting
    super.renderTree(canvas, paint);
    
    // Draw name and level above player
    _renderNameAndLevel(canvas);
  }
  
  void _renderNameAndLevel(Canvas canvas) {
    // Render player name
    final nameStyle = TextStyle(
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
    
    final namePainter = TextPainter(
      text: TextSpan(text: playerName, style: nameStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    namePainter.layout();
    namePainter.paint(
      canvas,
      Vector2(
        -namePainter.width / 2 + size.x / 2,
        -namePainter.height - 20,
      ).toOffset(),
    );
    
    // Render level
    final levelStyle = TextStyle(
      color: Colors.yellow,
      fontSize: 10,
      shadows: [
        Shadow(
          blurRadius: 2,
          color: Colors.black,
          offset: Offset(1, 1),
        ),
      ],
    );
    
    final levelPainter = TextPainter(
      text: TextSpan(text: 'Lv.$level', style: levelStyle),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    levelPainter.layout();
    levelPainter.paint(
      canvas,
      Vector2(
        -levelPainter.width / 2 + size.x / 2,
        -levelPainter.height - 5,
      ).toOffset(),
    );
    
    // Render guild name if player is in a guild
    if (guildName.isNotEmpty) {
      final guildStyle = TextStyle(
        color: Colors.lightBlue,
        fontSize: 10,
        shadows: [
          Shadow(
            blurRadius: 2,
            color: Colors.black,
            offset: Offset(1, 1),
          ),
        ],
      );
      
      final guildPainter = TextPainter(
        text: TextSpan(text: '<$guildName>', style: guildStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      
      guildPainter.layout();
      guildPainter.paint(
        canvas,
        Vector2(
          -guildPainter.width / 2 + size.x / 2,
          -guildPainter.height - 35,
        ).toOffset(),
      );
    }
  }
  
  // Set animation state
  void setAnimationState(String state) {
    if (_animations.containsKey(state) && _currentAnimationState != state) {
      _currentAnimationState = state;
      animation = _animations[_currentAnimationState];
    }
  }
  
  // Update lighting based on time of day
  void updateLighting(Color lightColor, double lightIntensity) {
    _currentLightColor = lightColor;
    _currentLightIntensity = lightIntensity;
    
    // Update glow intensity based on time of day
    // Glows are more visible at night
    if (lightIntensity < 0.7) {
      _glowIntensity = 0.3 + (0.7 - lightIntensity);
    } else {
      _glowIntensity = 0.3;
    }
  }
  
  // Handle time of day changes
  void onTimeOfDayChanged(TimeOfDay timeOfDay) {
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
}