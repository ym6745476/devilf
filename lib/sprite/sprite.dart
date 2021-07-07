
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

  // 设置位置
  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
  }

  // 更新数据
  void update(double dt){}

  // 重绘界面
  void render(Canvas canvas){}

}
