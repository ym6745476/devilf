import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/components/environment/day_night_cycle_component.dart';
import 'package:arabic_mmorpg/game/components/effects/light_component.dart';

enum PlayerState {
  idle,
  walking,
  running,
  attacking,
  casting,
  hit,
  dying,
  dead,
}

enum PlayerClass {
  warrior,
  mage,
  archer,
  assassin,
}

/// Player character component
class PlayerComponent extends SpriteAnimationGroupComponent with HasGameRef {
  // Player properties
  final String id;
  final String name;
  final String characterClass;
  final bool isLocalPlayer;
  
  // Player stats
  int level = 1;
  int experience = 0;
  int health = 100;
  int maxHealth = 100;
  int mana = 50;
  int maxMana = 50;
  int stamina = 100;
  int maxStamina = 100;
  
  // Player attributes
  int strength = 10;
  int intelligence = 10;
  int agility = 10;
  int vitality = 10;
  
  // Movement properties
  double moveSpeed = 150.0;
  Vector2 velocity = Vector2.zero();
  Vector2 targetPosition = Vector2.zero();
  bool isMoving = false;
  
  // Combat properties
  bool isAttacking = false;
  bool isCasting = false;
  double attackCooldown = 0.0;
  double castCooldown = 0.0;
  
  // Visual effects
  late LightComponent _lightEffect;
  bool _hasLightEffect = false;
  
  // Current state
  PlayerState _currentState = PlayerState.idle;
  
  // Animations
  late final Map<PlayerState, SpriteAnimation> _animations;
  
  // Constructor
  PlayerComponent({
    required this.name,
    required this.characterClass,
    required Vector2 position,
    this.id = '',
    this.isLocalPlayer = true,
  }) : super(position: position, size: Vector2(64, 64));
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load animations
    await _loadAnimations();
    
    // Set initial animation
    current = PlayerState.idle;
    
    // Add light effect
    _lightEffect = LightComponent(
      radius: 150,
      color: Colors.amber.withOpacity(0.5),
      intensity: 0.7,
    );
    await add(_lightEffect);
    _hasLightEffect = true;
    
    // Adjust light based on time of day
    final dayNightCycle = gameRef.findByType<DayNightCycleComponent>().first;
    _adjustLightForTimeOfDay(dayNightCycle.currentTimeOfDay);
  }
  
  Future<void> _loadAnimations() async {
    // This would load actual sprite sheets in a real implementation
    // For now, we'll create placeholder animations
    
    final spriteSheet = await gameRef.images.load('characters/$characterClass.png');
    final spriteSize = Vector2(64, 64);
    
    // Create a sprite sheet
    final sheet = SpriteSheet(
      image: spriteSheet,
      srcSize: spriteSize,
    );
    
    // Create animations for each state
    _animations = {
      PlayerState.idle: sheet.createAnimation(row: 0, stepTime: 0.2, to: 4),
      PlayerState.walking: sheet.createAnimation(row: 1, stepTime: 0.1, to: 8),
      PlayerState.running: sheet.createAnimation(row: 2, stepTime: 0.08, to: 8),
      PlayerState.attacking: sheet.createAnimation(row: 3, stepTime: 0.05, to: 6),
      PlayerState.casting: sheet.createAnimation(row: 4, stepTime: 0.1, to: 6),
      PlayerState.hit: sheet.createAnimation(row: 5, stepTime: 0.1, to: 3),
      PlayerState.dying: sheet.createAnimation(row: 6, stepTime: 0.2, to: 6),
      PlayerState.dead: sheet.createAnimation(row: 6, stepTime: 1.0, from: 5, to: 6),
    };
    
    animations = _animations;
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update cooldowns
    if (attackCooldown > 0) {
      attackCooldown -= dt;
    }
    
    if (castCooldown > 0) {
      castCooldown -= dt;
    }
    
    // Update movement
    if (isMoving) {
      _updateMovement(dt);
    }
    
    // Update state
    _updateState();
  }
  
  void _updateMovement(double dt) {
    if (position.distanceTo(targetPosition) < 5) {
      // Reached target position
      isMoving = false;
      velocity = Vector2.zero();
      return;
    }
    
    // Calculate direction to target
    final direction = (targetPosition - position).normalized();
    
    // Apply velocity
    velocity = direction * moveSpeed;
    position += velocity * dt;
  }
  
  void _updateState() {
    if (health <= 0) {
      _changeState(PlayerState.dead);
      return;
    }
    
    if (isAttacking) {
      _changeState(PlayerState.attacking);
      return;
    }
    
    if (isCasting) {
      _changeState(PlayerState.casting);
      return;
    }
    
    if (isMoving) {
      if (velocity.length > moveSpeed * 0.7) {
        _changeState(PlayerState.running);
      } else {
        _changeState(PlayerState.walking);
      }
      return;
    }
    
    _changeState(PlayerState.idle);
  }
  
  void _changeState(PlayerState newState) {
    if (_currentState != newState) {
      _currentState = newState;
      current = newState;
    }
  }
  
  void moveTo(Vector2 target) {
    targetPosition = target;
    isMoving = true;
  }
  
  void attack() {
    if (attackCooldown <= 0 && !isAttacking) {
      isAttacking = true;
      attackCooldown = 1.0; // 1 second cooldown
      
      // Reset after animation completes
      Future.delayed(const Duration(milliseconds: 500), () {
        isAttacking = false;
      });
    }
  }
  
  void castSpell() {
    if (castCooldown <= 0 && !isCasting) {
      isCasting = true;
      castCooldown = 2.0; // 2 second cooldown
      
      // Reset after animation completes
      Future.delayed(const Duration(milliseconds: 1000), () {
        isCasting = false;
      });
    }
  }
  
  void takeDamage(int amount) {
    health -= amount;
    if (health < 0) health = 0;
    
    // Play hit animation
    _changeState(PlayerState.hit);
    
    // Reset state after animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (health > 0) {
        _changeState(PlayerState.idle);
      } else {
        _changeState(PlayerState.dying);
        Future.delayed(const Duration(milliseconds: 1200), () {
          _changeState(PlayerState.dead);
        });
      }
    });
  }
  
  void heal(int amount) {
    health += amount;
    if (health > maxHealth) health = maxHealth;
  }
  
  void gainExperience(int amount) {
    experience += amount;
    
    // Check for level up
    final experienceNeeded = _calculateExperienceForNextLevel();
    if (experience >= experienceNeeded) {
      levelUp();
    }
  }
  
  int _calculateExperienceForNextLevel() {
    // Simple formula: 100 * current level
    return 100 * level;
  }
  
  void levelUp() {
    level++;
    
    // Increase stats
    maxHealth += 10;
    health = maxHealth;
    maxMana += 5;
    mana = maxMana;
    maxStamina += 5;
    stamina = maxStamina;
    
    // Reset experience for next level
    experience = 0;
  }
  
  void onTimeOfDayChanged(TimeOfDay timeOfDay) {
    _adjustLightForTimeOfDay(timeOfDay);
  }
  
  void _adjustLightForTimeOfDay(TimeOfDay timeOfDay) {
    if (!_hasLightEffect) return;
    
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        _lightEffect.setIntensity(0.3);
        _lightEffect.setRadius(100);
        break;
      case TimeOfDay.day:
        _lightEffect.setIntensity(0.0);
        _lightEffect.setRadius(0);
        break;
      case TimeOfDay.dusk:
        _lightEffect.setIntensity(0.5);
        _lightEffect.setRadius(120);
        break;
      case TimeOfDay.night:
        _lightEffect.setIntensity(1.0);
        _lightEffect.setRadius(200);
        break;
      case TimeOfDay.evening:
        _lightEffect.setIntensity(0.4);
        _lightEffect.setRadius(100);
        break;
    }
  }
}