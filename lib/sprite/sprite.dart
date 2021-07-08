
import 'dart:math';
import 'dart:ui';
import 'package:devilf/base/position.dart';
import 'package:flutter/cupertino.dart';

/// 基础精灵类
class Sprite {

  /// 坐标
  Position position;

  /// 尺寸
  Size size;

  /// 角度
  double angle = 0;

  Sprite(
    {
        required this.position,
        required this.size,
    }
  );

  // 获取中心坐标
  Position get center {
    return Position(position.x + size.width/2,position.y + size.height/2);
  }

  // 更新数据
  void update(double dt){

  }

  // 重绘界面
  void render(Canvas canvas){
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(pi * 2 * this.angle);
    Paint paint = Paint()..color = new Color(0x20FFEF00);
    canvas.drawRect(Rect.fromLTWH(-size.width / 2, -size.height / 2, size.width, size.height), paint);
    canvas.restore();
  }

}
