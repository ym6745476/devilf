import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'components/environment/day_night_cycle_component.dart';
import 'components/environment/weather_component.dart';
import 'systems/audio_system.dart';

class GameEngine extends FlameGame {
  // Game systems
  late final AudioSystem audioSystem;
  
  // Environment components
  late final DayNightCycleComponent dayNightCycle;
  late final WeatherComponent weather;
  
  // Game state
  bool _isPaused = false;
  bool _isDebugMode = false;
  
  // Constructor
  GameEngine({bool debugMode = false}) {
    _isDebugMode = debugMode;
    audioSystem = AudioSystem();
  }
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Initialize audio system
    await audioSystem.initialize();
    
    // Initialize environment components
    dayNightCycle = DayNightCycleComponent(startHour: 12.0);
    dayNightCycle.onTimeOfDayChanged = _onTimeOfDayChanged;
    await add(dayNightCycle);
    
    weather = WeatherComponent(initialWeather: WeatherType.clear, intensity: 0.5);
    await add(weather);
    
    // Play initial music
    await audioSystem.playMusic('music/main_theme.mp3');
    
    // Set up initial ambient audio based on time of day
    await audioSystem.updateTimeOfDayAudio(dayNightCycle.currentTimeOfDay);
  }
  
  @override
  void update(double dt) {
    if (!_isPaused) {
      super.update(dt);
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Render debug information if debug mode is enabled
    if (_isDebugMode) {
      _renderDebugInfo(canvas);
    }
  }
  
  void _renderDebugInfo(Canvas canvas) {
    final textStyle = TextStyle(color: Colors.white, fontSize: 12);
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Time: ${dayNightCycle.formattedTime}\n'
            'Weather: ${weather.currentWeather.toString().split('.').last}\n'
            'FPS: ${fps(120).toStringAsFixed(1)}',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    textPainter.paint(canvas, Vector2(10, 10).toOffset());
  }
  
  // Environment control methods
  
  void setTimeOfDay(double hour, {double minute = 0.0}) {
    dayNightCycle.setTime(hour, minute: minute);
  }
  
  void setWeather(WeatherType weatherType, {double? intensity}) {
    weather.changeWeather(weatherType, newIntensity: intensity);
    audioSystem.updateWeatherAudio(weatherType, intensity ?? weather.intensity);
  }
  
  // Handle time of day changes
  void _onTimeOfDayChanged(TimeOfDay newTimeOfDay) {
    // Update ambient audio
    audioSystem.updateTimeOfDayAudio(newTimeOfDay);
    
    // Notify game world and entities about time change
    // This would update lighting, NPC behaviors, etc.
    notifyTimeOfDayChanged(newTimeOfDay);
  }
  
  // Method to notify all relevant components about time of day changes
  void notifyTimeOfDayChanged(TimeOfDay newTimeOfDay) {
    // This would be implemented to notify all components that care about time changes
    // For example, NPCs might change their behavior, monsters might become more aggressive at night, etc.
    
    // Example implementation:
    // for (final component in components) {
    //   if (component is TimeAwareComponent) {
    //     component.onTimeOfDayChanged(newTimeOfDay);
    //   }
    // }
  }
  
  // Game state control
  
  void pauseGame() {
    _isPaused = true;
    audioSystem.pauseMusic();
  }
  
  void resumeGame() {
    _isPaused = false;
    audioSystem.resumeMusic();
  }
  
  void toggleDebugMode() {
    _isDebugMode = !_isDebugMode;
  }
  
  @override
  void onRemove() {
    audioSystem.stopMusic();
    audioSystem.stopAmbient();
    super.onRemove();
  }
}