import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:arabic_mmorpg/game/components/player/player_component.dart';

/// System that handles player input for controlling the game
class InputSystem {
  // Player reference
  PlayerComponent? _player;
  
  // Input state
  bool _isMovingUp = false;
  bool _isMovingDown = false;
  bool _isMovingLeft = false;
  bool _isMovingRight = false;
  bool _isRunning = false;
  bool _isAttacking = false;
  bool _isCasting = false;
  
  // Touch input
  Vector2? _touchTarget;
  bool _isTouching = false;
  
  // Joystick reference (if using virtual joystick)
  JoystickComponent? _joystick;
  
  // Constructor
  InputSystem();
  
  // Set player reference
  void setPlayer(PlayerComponent player) {
    _player = player;
  }
  
  // Set joystick reference
  void setJoystick(JoystickComponent joystick) {
    _joystick = joystick;
  }
  
  // Update method called every frame
  void update(double dt) {
    if (_player == null) return;
    
    // Handle keyboard movement
    _handleKeyboardMovement(dt);
    
    // Handle touch movement
    _handleTouchMovement(dt);
    
    // Handle joystick movement
    _handleJoystickMovement(dt);
  }
  
  // Handle keyboard input for movement
  void _handleKeyboardMovement(double dt) {
    if (_player == null) return;
    
    // Calculate movement direction
    Vector2 direction = Vector2.zero();
    
    if (_isMovingUp) direction.y -= 1;
    if (_isMovingDown) direction.y += 1;
    if (_isMovingLeft) direction.x -= 1;
    if (_isMovingRight) direction.x += 1;
    
    // Normalize direction if moving diagonally
    if (direction.length > 0) {
      direction = direction.normalized();
      
      // Apply speed modifier if running
      double speedModifier = _isRunning ? 1.5 : 1.0;
      
      // Move player
      _player!.position += direction * _player!.moveSpeed * speedModifier * dt;
      _player!.isMoving = true;
    } else {
      _player!.isMoving = false;
    }
  }
  
  // Handle touch input for movement
  void _handleTouchMovement(double dt) {
    if (_player == null || !_isTouching || _touchTarget == null) return;
    
    // Calculate distance to target
    final distance = _player!.position.distanceTo(_touchTarget!);
    
    // If close enough to target, stop moving
    if (distance < 5) {
      _isTouching = false;
      _touchTarget = null;
      _player!.isMoving = false;
      return;
    }
    
    // Calculate direction to target
    final direction = (_touchTarget! - _player!.position).normalized();
    
    // Apply speed modifier if running
    double speedModifier = _isRunning ? 1.5 : 1.0;
    
    // Move player
    _player!.position += direction * _player!.moveSpeed * speedModifier * dt;
    _player!.isMoving = true;
  }
  
  // Handle joystick input for movement
  void _handleJoystickMovement(double dt) {
    if (_player == null || _joystick == null) return;
    
    // Get joystick direction
    final direction = _joystick!.direction;
    
    // If joystick is active, move player
    if (direction != Vector2.zero()) {
      // Apply speed modifier if running
      double speedModifier = _isRunning ? 1.5 : 1.0;
      
      // Move player
      _player!.position += direction * _player!.moveSpeed * speedModifier * dt;
      _player!.isMoving = true;
    } else if (!_isMovingUp && !_isMovingDown && !_isMovingLeft && !_isMovingRight && !_isTouching) {
      // If no other movement input is active, stop moving
      _player!.isMoving = false;
    }
  }
  
  // Handle keyboard key down event
  void onKeyDown(KeyEvent event) {
    if (_player == null) return;
    
    // Movement keys
    if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.keyW) {
      _isMovingUp = true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.keyS) {
      _isMovingDown = true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
      _isMovingLeft = true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
      _isMovingRight = true;
    }
    
    // Run key
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || event.logicalKey == LogicalKeyboardKey.shiftRight) {
      _isRunning = true;
    }
    
    // Attack key
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _isAttacking = true;
      _player!.attack();
    }
    
    // Cast spell key
    if (event.logicalKey == LogicalKeyboardKey.keyE) {
      _isCasting = true;
      _player!.castSpell();
    }
  }
  
  // Handle keyboard key up event
  void onKeyUp(KeyEvent event) {
    // Movement keys
    if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.keyW) {
      _isMovingUp = false;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.keyS) {
      _isMovingDown = false;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
      _isMovingLeft = false;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
      _isMovingRight = false;
    }
    
    // Run key
    if (event.logicalKey == LogicalKeyboardKey.shiftLeft || event.logicalKey == LogicalKeyboardKey.shiftRight) {
      _isRunning = false;
    }
    
    // Attack key
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _isAttacking = false;
    }
    
    // Cast spell key
    if (event.logicalKey == LogicalKeyboardKey.keyE) {
      _isCasting = false;
    }
  }
  
  // Handle tap down event
  void onTapDown(TapDownInfo info) {
    if (_player == null) return;
    
    _isTouching = true;
    _touchTarget = info.eventPosition.game;
  }
  
  // Handle tap up event
  void onTapUp(TapUpInfo info) {
    _isTouching = false;
    _touchTarget = null;
  }
  
  // Handle tap cancel event
  void onTapCancel() {
    _isTouching = false;
    _touchTarget = null;
  }
  
  // Handle drag update event
  void onDragUpdate(DragUpdateInfo info) {
    if (_player == null) return;
    
    _isTouching = true;
    _touchTarget = info.eventPosition.game;
  }
  
  // Handle drag end event
  void onDragEnd(DragEndInfo info) {
    _isTouching = false;
    _touchTarget = null;
  }
  
  // Handle drag cancel event
  void onDragCancel() {
    _isTouching = false;
    _touchTarget = null;
  }
}