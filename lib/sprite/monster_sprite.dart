
import 'dart:math';
import 'dart:ui';

import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';

/// 怪物精灵类
class MonsterSprite extends Sprite{

  late double turn;

  MonsterSprite(
    {
      double x = 0,
      double y = 0,
      this.turn = 0,
    }
  ):super(x:x,y:y);


  @override
  void update(double dt) {
    this.turn += dt * 0.25;
  }

  @override
  void render(Canvas canvas) {
    var tau = pi * 2;
    canvas.save();
    canvas.translate(this.x, this.y);
    canvas.rotate(tau * this.turn);
    var white = new Paint()..color = new Color(0xFFFF0000);
    var size = 100.0;
    canvas.drawRect(new Rect.fromLTWH(-size / 2, -size / 2, size, size), white);
    canvas.restore();
  }

}