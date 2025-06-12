import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Component that creates a light effect around entities
class LightComponent extends Component with HasPaint {
  // Light properties
  double radius;
  Color color;
  double intensity;
  
  // Position offset from parent
  Vector2 offset;
  
  // Flicker effect
  bool enableFlicker;
  double flickerSpeed;
  double flickerIntensity;
  double _flickerValue = 0.0;
  
  // Pulse effect
  bool enablePulse;
  double pulseSpeed;
  double pulseRange;
  double _pulseValue = 0.0;
  
  // Constructor
  LightComponent({
    required this.radius,
    required this.color,
    required this.intensity,
    this.offset = Vector2.zero(),
    this.enableFlicker = false,
    this.flickerSpeed = 5.0,
    this.flickerIntensity = 0.2,
    this.enablePulse = false,
    this.pulseSpeed = 2.0,
    this.pulseRange = 0.2,
  });
  
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (intensity <= 0 || radius <= 0) return;
    
    // Get parent position
    final parentPosition = (parent as PositionComponent).position;
    final position = parentPosition + offset;
    
    // Apply effects
    double currentIntensity = intensity;
    double currentRadius = radius;
    
    if (enableFlicker) {
      currentIntensity *= (1.0 + (flickerIntensity * _flickerValue));
    }
    
    if (enablePulse) {
      currentRadius *= (1.0 + (pulseRange * _pulseValue));
    }
    
    // Create radial gradient
    final gradient = ui.Gradient.radial(
      position.toOffset(),
      currentRadius,
      [
        color.withOpacity(currentIntensity),
        color.withOpacity(0),
      ],
      [0.0, 1.0],
    );
    
    // Draw light
    canvas.drawCircle(
      position.toOffset(),
      currentRadius,
      Paint()..shader = gradient,
    );
  }
  
  @override
  void update(double dt) {
    super.update(dt);
    
    // Update flicker effect
    if (enableFlicker) {
      _flickerValue = (math.sin(_flickerValue + dt * flickerSpeed) + 1) / 2;
    }
    
    // Update pulse effect
    if (enablePulse) {
      _pulseValue = (math.sin(_pulseValue + dt * pulseSpeed) + 1) / 2;
    }
  }
  
  void setIntensity(double newIntensity) {
    intensity = newIntensity.clamp(0.0, 1.0);
  }
  
  void setRadius(double newRadius) {
    radius = newRadius.clamp(0.0, 500.0);
  }
  
  void setColor(Color newColor) {
    color = newColor;
  }
  
  void enableFlickerEffect({double? speed, double? intensityValue}) {
    enableFlicker = true;
    if (speed != null) flickerSpeed = speed;
    if (intensityValue != null) flickerIntensity = intensityValue;
  }
  
  void disableFlickerEffect() {
    enableFlicker = false;
  }
  
  void enablePulseEffect({double? speed, double? rangeValue}) {
    enablePulse = true;
    if (speed != null) pulseSpeed = speed;
    if (rangeValue != null) pulseRange = rangeValue;
  }
  
  void disablePulseEffect() {
    enablePulse = false;
  }
}