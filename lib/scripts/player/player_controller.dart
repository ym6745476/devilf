import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

/// Controls player movement and actions
class PlayerController extends ChangeNotifier {
  // Player position
  double x = 0.0;
  double y = 0.0;
  
  // Movement
  double speed = 5.0;
  double _dx = 0.0;
  double _dy = 0.0;
  bool _isMoving = false;
  
  // Auto-walk
  bool _isAutoWalking = false;
  Offset? _autoWalkTarget;
  
  // Movement state
  bool get isMoving => _isMoving;
  bool get isAutoWalking => _isAutoWalking;
  
  // Direction the player is facing (in radians)
  double _facing = 0.0;
  double get facing => _facing;
  
  // Update player position based on current movement
  void update(double deltaTime) {
    if (_isAutoWalking && _autoWalkTarget != null) {
      _updateAutoWalk(deltaTime);
    } else if (_isMoving) {
      x += _dx * speed * deltaTime;
      y += _dy * speed * deltaTime;
      notifyListeners();
    }
  }
  
  // Handle joystick input
  void handleJoystickUpdate(double dx, double dy) {
    if (dx == 0 && dy == 0) {
      _isMoving = false;
    } else {
      _isMoving = true;
      _dx = dx;
      _dy = dy;
      _facing = math.atan2(dy, dx);
    }
    
    // Cancel auto-walk when manual movement is used
    if (_isAutoWalking) {
      cancelAutoWalk();
    }
    
    notifyListeners();
  }
  
  // Handle keyboard input for WASD controls
  void handleKeyboard(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      _updateKeyboardMovement(event.logicalKey, true);
    } else if (event is RawKeyUpEvent) {
      _updateKeyboardMovement(event.logicalKey, false);
    }
  }
  
  bool _isWPressed = false;
  bool _isSPressed = false;
  bool _isAPressed = false;
  bool _isDPressed = false;
  
  void _updateKeyboardMovement(LogicalKeyboardKey key, bool isPressed) {
    // Update key states
    if (key == LogicalKeyboardKey.keyW) _isWPressed = isPressed;
    if (key == LogicalKeyboardKey.keyS) _isSPressed = isPressed;
    if (key == LogicalKeyboardKey.keyA) _isAPressed = isPressed;
    if (key == LogicalKeyboardKey.keyD) _isDPressed = isPressed;
    
    // Calculate movement direction
    _dx = (_isDPressed ? 1 : 0) + (_isAPressed ? -1 : 0);
    _dy = (_isSPressed ? 1 : 0) + (_isWPressed ? -1 : 0);
    
    // Normalize diagonal movement
    if (_dx != 0 && _dy != 0) {
      _dx *= 0.707; // 1/√2
      _dy *= 0.707;
    }
    
    _isMoving = _dx != 0 || _dy != 0;
    if (_isMoving) {
      _facing = math.atan2(_dy, _dx);
      
      // Cancel auto-walk when manual movement is used
      if (_isAutoWalking) {
        cancelAutoWalk();
      }
    }
    
    notifyListeners();
  }
  
  // Start auto-walking to a target position
  void startAutoWalk(Offset target) {
    _isAutoWalking = true;
    _autoWalkTarget = target;
    notifyListeners();
  }
  
  // Cancel auto-walking
  void cancelAutoWalk() {
    _isAutoWalking = false;
    _autoWalkTarget = null;
    _isMoving = false;
    _dx = 0;
    _dy = 0;
    notifyListeners();
  }
  
  // Update position during auto-walk
  void _updateAutoWalk(double deltaTime) {
    if (_autoWalkTarget == null) return;
    
    // Calculate direction to target
    double targetDx = _autoWalkTarget!.dx - x;
    double targetDy = _autoWalkTarget!.dy - y;
    double distance = math.sqrt(targetDx * targetDx + targetDy * targetDy);
    
    // Check if we've reached the target
    if (distance < speed * deltaTime) {
      x = _autoWalkTarget!.dx;
      y = _autoWalkTarget!.dy;
      cancelAutoWalk();
      return;
    }
    
    // Update movement
    _dx = targetDx / distance;
    _dy = targetDy / distance;
    _facing = math.atan2(_dy, _dx);
    
    x += _dx * speed * deltaTime;
    y += _dy * speed * deltaTime;
    notifyListeners();
  }
  
  // Check if player is within interaction range of a target
  bool isInRange(Offset target, double range) {
    double dx = target.dx - x;
    double dy = target.dy - y;
    return dx * dx + dy * dy <= range * range;
  }
}
