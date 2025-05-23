import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum TimeOfDay {
  dawn,    // 5:00 - 7:00
  morning, // 7:00 - 11:00
  noon,    // 11:00 - 14:00
  afternoon, // 14:00 - 17:00
  evening, // 17:00 - 19:00
  dusk,    // 19:00 - 21:00
  night,   // 21:00 - 0:00
  midnight, // 0:00 - 5:00
}

class DayNightCycleComponent extends Component with HasGameRef {
  // Game time settings
  static const double GAME_SECONDS_PER_REAL_SECOND = 60.0; // 1 minute of game time per real second
  static const double HOURS_PER_DAY = 24.0;
  static const double MINUTES_PER_HOUR = 60.0;
  
  // Current game time
  double _gameHour = 12.0; // Start at noon
  double _gameMinute = 0.0;
  
  // Current time of day
  TimeOfDay _currentTimeOfDay = TimeOfDay.noon;
  
  // Lighting settings
  Color _currentAmbientColor = Colors.white;
  double _currentAmbientIntensity = 1.0;
  
  // Callbacks
  Function(TimeOfDay)? onTimeOfDayChanged;
  
  // Time-based colors for ambient lighting
  final Map<TimeOfDay, Color> _timeColors = {
    TimeOfDay.dawn: Color(0xFFF0E6D2),      // Warm orange-yellow
    TimeOfDay.morning: Color(0xFFFFF8E1),   // Bright yellow-white
    TimeOfDay.noon: Colors.white,           // Pure white
    TimeOfDay.afternoon: Color(0xFFFFFDE7), // Slightly yellow-white
    TimeOfDay.evening: Color(0xFFFFE0B2),   // Orange
    TimeOfDay.dusk: Color(0xFFFFB74D),      // Deep orange
    TimeOfDay.night: Color(0xFF3F51B5),     // Indigo blue
    TimeOfDay.midnight: Color(0xFF1A237E),  // Deep blue
  };
  
  // Time-based intensity for ambient lighting
  final Map<TimeOfDay, double> _timeIntensity = {
    TimeOfDay.dawn: 0.7,
    TimeOfDay.morning: 0.9,
    TimeOfDay.noon: 1.0,
    TimeOfDay.afternoon: 0.95,
    TimeOfDay.evening: 0.8,
    TimeOfDay.dusk: 0.6,
    TimeOfDay.night: 0.4,
    TimeOfDay.midnight: 0.25,
  };
  
  DayNightCycleComponent({double startHour = 12.0}) {
    _gameHour = startHour.clamp(0.0, 23.99);
    _updateTimeOfDay();
  }
  
  double get gameHour => _gameHour;
  double get gameMinute => _gameMinute;
  TimeOfDay get currentTimeOfDay => _currentTimeOfDay;
  Color get ambientColor => _currentAmbientColor;
  double get ambientIntensity => _currentAmbientIntensity;
  
  // Format current time as HH:MM
  String get formattedTime {
    final hour = _gameHour.floor();
    final minute = _gameMinute.floor();
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
  
  // Set game time directly
  void setTime(double hour, {double minute = 0.0}) {
    _gameHour = hour.clamp(0.0, 23.99);
    _gameMinute = minute.clamp(0.0, 59.99);
    _updateTimeOfDay();
  }
  
  // Set game time speed multiplier
  void setTimeSpeed(double multiplier) {
    // Adjust GAME_SECONDS_PER_REAL_SECOND based on multiplier
    // Implementation would depend on how the constant is used
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update game time
    final secondsElapsed = dt * GAME_SECONDS_PER_REAL_SECOND;
    final minutesElapsed = secondsElapsed / 60.0;
    
    _gameMinute += minutesElapsed;
    while (_gameMinute >= MINUTES_PER_HOUR) {
      _gameMinute -= MINUTES_PER_HOUR;
      _gameHour += 1.0;
      if (_gameHour >= HOURS_PER_DAY) {
        _gameHour = 0.0;
      }
    }
    
    // Check if time of day has changed
    final previousTimeOfDay = _currentTimeOfDay;
    _updateTimeOfDay();
    
    if (previousTimeOfDay != _currentTimeOfDay) {
      // Time of day has changed, notify listeners
      if (onTimeOfDayChanged != null) {
        onTimeOfDayChanged!(_currentTimeOfDay);
      }
    }
    
    // Smoothly interpolate ambient lighting based on time
    _updateAmbientLighting(dt);
  }
  
  void _updateTimeOfDay() {
    // Determine current time of day based on game hour
    if (_gameHour >= 5.0 && _gameHour < 7.0) {
      _currentTimeOfDay = TimeOfDay.dawn;
    } else if (_gameHour >= 7.0 && _gameHour < 11.0) {
      _currentTimeOfDay = TimeOfDay.morning;
    } else if (_gameHour >= 11.0 && _gameHour < 14.0) {
      _currentTimeOfDay = TimeOfDay.noon;
    } else if (_gameHour >= 14.0 && _gameHour < 17.0) {
      _currentTimeOfDay = TimeOfDay.afternoon;
    } else if (_gameHour >= 17.0 && _gameHour < 19.0) {
      _currentTimeOfDay = TimeOfDay.evening;
    } else if (_gameHour >= 19.0 && _gameHour < 21.0) {
      _currentTimeOfDay = TimeOfDay.dusk;
    } else if (_gameHour >= 21.0 && _gameHour < 24.0) {
      _currentTimeOfDay = TimeOfDay.night;
    } else {
      _currentTimeOfDay = TimeOfDay.midnight;
    }
  }
  
  void _updateAmbientLighting(double dt) {
    // Get target color and intensity for current time of day
    final targetColor = _timeColors[_currentTimeOfDay] ?? Colors.white;
    final targetIntensity = _timeIntensity[_currentTimeOfDay] ?? 1.0;
    
    // Smoothly interpolate current values toward target values
    _currentAmbientColor = Color.lerp(
      _currentAmbientColor, 
      targetColor, 
      min(1.0, dt * 0.5)
    )!;
    
    _currentAmbientIntensity = lerpDouble(
      _currentAmbientIntensity, 
      targetIntensity, 
      min(1.0, dt * 0.5)
    );
  }
  
  // Helper function for double linear interpolation
  double lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Apply ambient lighting overlay to the entire screen
    if (gameRef.size != null) {
      final size = gameRef.size;
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      
      // Create a gradient overlay based on time of day
      // This creates a subtle lighting effect that varies with time
      final paint = Paint()
        ..shader = RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            _currentAmbientColor.withOpacity(0.0),
            _currentAmbientColor.withOpacity(0.3 * (1.0 - _currentAmbientIntensity))
          ],
        ).createShader(rect);
      
      canvas.drawRect(rect, paint);
    }
  }
  
  // Method to check if it's currently daytime
  bool isDaytime() {
    return _currentTimeOfDay == TimeOfDay.dawn ||
           _currentTimeOfDay == TimeOfDay.morning ||
           _currentTimeOfDay == TimeOfDay.noon ||
           _currentTimeOfDay == TimeOfDay.afternoon;
  }
  
  // Method to check if it's currently nighttime
  bool isNighttime() {
    return _currentTimeOfDay == TimeOfDay.night ||
           _currentTimeOfDay == TimeOfDay.midnight;
  }
  
  // Method to check if it's currently a transition period (dawn/dusk)
  bool isTransitionPeriod() {
    return _currentTimeOfDay == TimeOfDay.dawn ||
           _currentTimeOfDay == TimeOfDay.dusk;
  }
  
  // Get a visibility modifier based on time of day
  double getVisibilityModifier() {
    switch (_currentTimeOfDay) {
      case TimeOfDay.dawn:
        return 0.8;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        return 1.0;
      case TimeOfDay.evening:
        return 0.9;
      case TimeOfDay.dusk:
        return 0.7;
      case TimeOfDay.night:
        return 0.5;
      case TimeOfDay.midnight:
        return 0.3;
    }
  }
}