
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';

/// 基础精灵类
class Sprite {

  double x;
  double y;
  Size size;

  Sprite(
    {
        this.x = 0,
        this.y = 0,
        this.size = const Size(64,64),
    }
  );

  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }

  void update(double dt){}

  void render(Canvas canvas){}

}
