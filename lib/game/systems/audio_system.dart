import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';

import '../components/environment/weather_component.dart';
import '../components/environment/day_night_cycle_component.dart';

class AudioSystem {
  // Audio categories
  static const String MUSIC = 'music';
  static const String SFX = 'sfx';
  static const String AMBIENT = 'ambient';
  static const String UI = 'ui';
  
  // Volume settings (0.0 to 1.0)
  double _masterVolume = 1.0;
  double _musicVolume = 0.7;
  double _sfxVolume = 1.0;
  double _ambientVolume = 0.5;
  double _uiVolume = 0.8;
  
  // Currently playing tracks
  String? _currentMusicTrack;
  String? _currentAmbientTrack;
  
  // Cached audio files
  final Map<String, bool> _preloadedAudio = {};
  
  // Initialization
  Future<void> initialize() async {
    await FlameAudio.audioCache.loadAll([
      // Preload common audio files
      'ui/click.mp3',
      'ui/hover.mp3',
      'ambient/day.mp3',
      'ambient/night.mp3',
      'music/main_theme.mp3',
    ]);
    
    for (final audio in ['ui/click.mp3', 'ui/hover.mp3', 'ambient/day.mp3', 'ambient/night.mp3', 'music/main_theme.mp3']) {
      _preloadedAudio[audio] = true;
    }
  }
  
  // Volume control methods
  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
    _applyVolumeSettings();
  }
  
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    _applyVolumeSettings();
  }
  
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
  }
  
  void setAmbientVolume(double volume) {
    _ambientVolume = volume.clamp(0.0, 1.0);
    _applyVolumeSettings();
  }
  
  void setUiVolume(double volume) {
    _uiVolume = volume.clamp(0.0, 1.0);
  }
  
  void _applyVolumeSettings() {
    // Apply volume changes to currently playing audio
    if (_currentMusicTrack != null) {
      FlameAudio.bgm.audioPlayer.setVolume(_masterVolume * _musicVolume);
    }
    
    // Apply to ambient sounds if playing
    // This would require more complex audio management
  }
  
  // Music playback
  Future<void> playMusic(String track, {bool loop = true, double? volume}) async {
    if (_currentMusicTrack == track) return;
    
    await _preloadAudioIfNeeded(track);
    
    // Stop current music if playing
    if (_currentMusicTrack != null) {
      await FlameAudio.bgm.stop();
    }
    
    // Play new track
    await FlameAudio.bgm.play(track, volume: volume ?? (_masterVolume * _musicVolume));
    _currentMusicTrack = track;
  }
  
  Future<void> stopMusic() async {
    if (_currentMusicTrack != null) {
      await FlameAudio.bgm.stop();
      _currentMusicTrack = null;
    }
  }
  
  Future<void> pauseMusic() async {
    if (_currentMusicTrack != null) {
      await FlameAudio.bgm.pause();
    }
  }
  
  Future<void> resumeMusic() async {
    if (_currentMusicTrack != null) {
      await FlameAudio.bgm.resume();
    }
  }
  
  // Sound effects
  Future<void> playSfx(String sound, {double? volume}) async {
    await _preloadAudioIfNeeded(sound);
    await FlameAudio.play(sound, volume: volume ?? (_masterVolume * _sfxVolume));
  }
  
  // UI sounds
  Future<void> playUiSound(String sound, {double? volume}) async {
    await _preloadAudioIfNeeded(sound);
    await FlameAudio.play(sound, volume: volume ?? (_masterVolume * _uiVolume));
  }
  
  // Ambient sounds
  Future<void> playAmbient(String track, {bool loop = true, double? volume}) async {
    if (_currentAmbientTrack == track) return;
    
    await _preloadAudioIfNeeded(track);
    
    // Stop current ambient if playing
    if (_currentAmbientTrack != null) {
      // This would require a separate audio player for ambient sounds
      // For now, we'll use a placeholder implementation
    }
    
    // Play new ambient track
    // This would require a separate audio player for ambient sounds
    _currentAmbientTrack = track;
  }
  
  Future<void> stopAmbient() async {
    if (_currentAmbientTrack != null) {
      // Stop ambient sound
      // This would require a separate audio player for ambient sounds
      _currentAmbientTrack = null;
    }
  }
  
  // Helper method to preload audio if needed
  Future<void> _preloadAudioIfNeeded(String audio) async {
    if (!_preloadedAudio.containsKey(audio) || _preloadedAudio[audio] != true) {
      try {
        await FlameAudio.audioCache.load(audio);
        _preloadedAudio[audio] = true;
      } catch (e) {
        if (kDebugMode) {
          print('Failed to load audio: $audio - $e');
        }
        _preloadedAudio[audio] = false;
      }
    }
  }
  
  // Environment-specific audio methods
  
  // Update ambient sounds based on time of day
  Future<void> updateTimeOfDayAudio(TimeOfDay timeOfDay) async {
    String ambientTrack;
    
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        ambientTrack = 'ambient/dawn.mp3';
        break;
      case TimeOfDay.morning:
      case TimeOfDay.noon:
      case TimeOfDay.afternoon:
        ambientTrack = 'ambient/day.mp3';
        break;
      case TimeOfDay.evening:
      case TimeOfDay.dusk:
        ambientTrack = 'ambient/evening.mp3';
        break;
      case TimeOfDay.night:
      case TimeOfDay.midnight:
        ambientTrack = 'ambient/night.mp3';
        break;
    }
    
    await playAmbient(ambientTrack);
  }
  
  // Update ambient sounds based on weather
  Future<void> updateWeatherAudio(WeatherType weatherType, double intensity) async {
    String? weatherTrack;
    
    switch (weatherType) {
      case WeatherType.clear:
        // No specific weather track for clear weather
        return;
      case WeatherType.rain:
        weatherTrack = 'ambient/rain.mp3';
        break;
      case WeatherType.snow:
        weatherTrack = 'ambient/snow.mp3';
        break;
      case WeatherType.fog:
        weatherTrack = 'ambient/fog.mp3';
        break;
      case WeatherType.thunderstorm:
        weatherTrack = 'ambient/thunder.mp3';
        break;
      case WeatherType.sandstorm:
        weatherTrack = 'ambient/sandstorm.mp3';
        break;
    }
    
    if (weatherTrack != null) {
      // Play weather track with volume based on intensity
      double volume = _masterVolume * _ambientVolume * intensity;
      // This would require a separate audio player for weather sounds
      // For now, we'll use a placeholder implementation
    }
  }
  
  // Play a random thunder sound (for thunderstorms)
  Future<void> playRandomThunderSound() async {
    final thunderSounds = [
      'ambient/thunder1.mp3',
      'ambient/thunder2.mp3',
      'ambient/thunder3.mp3',
    ];
    
    final randomIndex = (DateTime.now().millisecondsSinceEpoch % thunderSounds.length);
    await playSfx(thunderSounds[randomIndex], volume: _masterVolume * _sfxVolume * 0.8);
  }
}