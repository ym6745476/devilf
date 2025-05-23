import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

enum WeatherType {
  clear,
  rain,
  snow,
  fog,
  thunderstorm,
  sandstorm,
}

class WeatherComponent extends Component with HasGameRef {
  WeatherType _currentWeather = WeatherType.clear;
  double _intensity = 0.0; // 0.0 to 1.0
  double _transitionProgress = 1.0; // 1.0 means fully transitioned
  WeatherType _targetWeather = WeatherType.clear;
  
  // Particle systems for different weather types
  late final ParticleSystem? _rainParticles;
  late final ParticleSystem? _snowParticles;
  late final ParticleSystem? _fogParticles;
  late final ParticleSystem? _sandParticles;
  
  // Lightning flash effect for thunderstorms
  bool _lightningActive = false;
  double _lightningAlpha = 0.0;
  double _timeSinceLastLightning = 0.0;
  
  // Weather overlay colors
  final Map<WeatherType, Color> _weatherColors = {
    WeatherType.clear: Colors.transparent,
    WeatherType.rain: Colors.blueGrey.withOpacity(0.3),
    WeatherType.snow: Colors.white.withOpacity(0.2),
    WeatherType.fog: Colors.grey.withOpacity(0.5),
    WeatherType.thunderstorm: Colors.indigo.withOpacity(0.4),
    WeatherType.sandstorm: Color(0xFFD2B48C).withOpacity(0.6),
  };
  
  // Weather sound effects
  final Map<WeatherType, String> _weatherSounds = {
    WeatherType.clear: 'ambient/clear.mp3',
    WeatherType.rain: 'ambient/rain.mp3',
    WeatherType.snow: 'ambient/snow.mp3',
    WeatherType.fog: 'ambient/fog.mp3',
    WeatherType.thunderstorm: 'ambient/thunder.mp3',
    WeatherType.sandstorm: 'ambient/sandstorm.mp3',
  };
  
  WeatherComponent({WeatherType initialWeather = WeatherType.clear, double intensity = 0.5}) {
    _currentWeather = initialWeather;
    _targetWeather = initialWeather;
    _intensity = intensity.clamp(0.0, 1.0);
  }
  
  WeatherType get currentWeather => _currentWeather;
  double get intensity => _intensity;
  
  @override
  void onMount() {
    super.onMount();
    _initializeParticleSystems();
    _updateActiveParticles();
    
    // Play initial weather sound
    _playWeatherSound(_currentWeather);
  }
  
  void _initializeParticleSystems() {
    // Initialize particle systems for different weather types
    // These would be implemented with Flame's particle system
    // For now, we'll use placeholder implementations
    _rainParticles = null; // Placeholder
    _snowParticles = null; // Placeholder
    _fogParticles = null; // Placeholder
    _sandParticles = null; // Placeholder
  }
  
  void _updateActiveParticles() {
    // Enable/disable particle systems based on current weather
    // This would control which particle effects are active
  }
  
  void _playWeatherSound(WeatherType weather) {
    // Play the appropriate ambient sound for the weather
    // This would integrate with the game's audio system
    final soundPath = _weatherSounds[weather];
    if (soundPath != null) {
      // Play the sound with appropriate looping and volume based on intensity
      // gameRef.audioSystem.playAmbient(soundPath, volume: _intensity);
    }
  }
  
  void changeWeather(WeatherType newWeather, {double? newIntensity, double transitionDuration = 5.0}) {
    if (newWeather == _currentWeather && (newIntensity == null || newIntensity == _intensity)) {
      return;
    }
    
    _targetWeather = newWeather;
    if (newIntensity != null) {
      _intensity = newIntensity.clamp(0.0, 1.0);
    }
    
    _transitionProgress = 0.0;
    
    // Start transitioning sound effects
    _crossfadeWeatherSounds(_currentWeather, _targetWeather, transitionDuration);
  }
  
  void _crossfadeWeatherSounds(WeatherType fromWeather, WeatherType toWeather, double duration) {
    // Implement crossfade between weather ambient sounds
    // This would gradually reduce volume of current sound and increase volume of new sound
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Handle weather transitions
    if (_transitionProgress < 1.0) {
      _transitionProgress += dt / 5.0; // 5 second transition
      if (_transitionProgress >= 1.0) {
        _transitionProgress = 1.0;
        _currentWeather = _targetWeather;
        _updateActiveParticles();
      }
    }
    
    // Handle thunderstorm lightning effects
    if (_currentWeather == WeatherType.thunderstorm || 
        (_targetWeather == WeatherType.thunderstorm && _transitionProgress < 1.0)) {
      _updateLightningEffect(dt);
    }
    
    // Update particle systems based on current weather and intensity
  }
  
  void _updateLightningEffect(double dt) {
    if (_lightningActive) {
      // Lightning flash is active, fade it out
      _lightningAlpha = max(0.0, _lightningAlpha - dt * 4.0);
      if (_lightningAlpha <= 0.0) {
        _lightningActive = false;
      }
    } else {
      // Check if it's time for a new lightning flash
      _timeSinceLastLightning += dt;
      
      // Random lightning timing based on intensity
      double lightningChance = _intensity * 0.1; // Higher intensity = more frequent lightning
      if (_timeSinceLastLightning > 3.0 && Random().nextDouble() < lightningChance * dt) {
        _lightningActive = true;
        _lightningAlpha = 0.7 + (Random().nextDouble() * 0.3); // Random intensity
        _timeSinceLastLightning = 0.0;
        
        // Play thunder sound with random delay after lightning
        double thunderDelay = 0.5 + (Random().nextDouble() * 2.0);
        // Delayed thunder sound would be implemented here
      }
    }
  }
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Render weather overlay
    if (gameRef.size != null) {
      final size = gameRef.size;
      final rect = Rect.fromLTWH(0, 0, size.x, size.y);
      
      // Blend between current and target weather colors during transition
      final currentColor = _weatherColors[_currentWeather] ?? Colors.transparent;
      final targetColor = _weatherColors[_targetWeather] ?? Colors.transparent;
      
      final blendedColor = Color.lerp(
        currentColor, 
        targetColor, 
        _transitionProgress
      )!.withOpacity(_intensity);
      
      // Draw weather overlay
      final paint = Paint()..color = blendedColor;
      canvas.drawRect(rect, paint);
      
      // Draw lightning flash if active
      if (_lightningActive && _currentWeather == WeatherType.thunderstorm) {
        final lightningPaint = Paint()
          ..color = Colors.white.withOpacity(_lightningAlpha * 0.7);
        canvas.drawRect(rect, lightningPaint);
      }
    }
  }
  
  // Method to get current visibility factor (used by other systems)
  double getVisibilityFactor() {
    // Return a value between 0.0 (poor visibility) and 1.0 (perfect visibility)
    switch (_currentWeather) {
      case WeatherType.clear:
        return 1.0;
      case WeatherType.rain:
        return 1.0 - (_intensity * 0.3);
      case WeatherType.snow:
        return 1.0 - (_intensity * 0.4);
      case WeatherType.fog:
        return 1.0 - (_intensity * 0.7);
      case WeatherType.thunderstorm:
        return 1.0 - (_intensity * 0.5);
      case WeatherType.sandstorm:
        return 1.0 - (_intensity * 0.8);
    }
  }
  
  // Method to get current movement speed modifier (used by player and NPCs)
  double getMovementSpeedModifier() {
    // Return a value that modifies movement speed based on weather
    switch (_currentWeather) {
      case WeatherType.clear:
        return 1.0;
      case WeatherType.rain:
        return 1.0 - (_intensity * 0.1);
      case WeatherType.snow:
        return 1.0 - (_intensity * 0.25);
      case WeatherType.fog:
        return 1.0 - (_intensity * 0.05);
      case WeatherType.thunderstorm:
        return 1.0 - (_intensity * 0.15);
      case WeatherType.sandstorm:
        return 1.0 - (_intensity * 0.3);
    }
  }
  
  // Method to get current attack accuracy modifier (used in combat)
  double getAccuracyModifier() {
    // Return a value that modifies attack accuracy based on weather
    switch (_currentWeather) {
      case WeatherType.clear:
        return 1.0;
      case WeatherType.rain:
        return 1.0 - (_intensity * 0.05);
      case WeatherType.snow:
        return 1.0 - (_intensity * 0.1);
      case WeatherType.fog:
        return 1.0 - (_intensity * 0.2);
      case WeatherType.thunderstorm:
        return 1.0 - (_intensity * 0.15);
      case WeatherType.sandstorm:
        return 1.0 - (_intensity * 0.25);
    }
  }
}

// Placeholder for particle system implementation
class ParticleSystem {
  void start() {}
  void stop() {}
  void update(double dt) {}
  void render(Canvas canvas) {}
}