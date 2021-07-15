import 'dart:math';
import 'dart:ui';

import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/cupertino.dart';

/// 怪物精灵类
class MonsterSprite extends DFSprite {
  late double turn;

  MonsterSprite({
    DFSize size = const DFSize(32, 32),
    this.turn = 0,
  }) : super(position:DFPosition(0, 0), size: size);

  @override
  void update(double dt) {
    this.turn += dt * 0.25;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    /// 子类调用super可以自动移动画布到相对坐标
    if (parent != null) {
      DFPosition parentPosition =
          DFPosition(parent!.position.x - parent!.size.width / 2, parent!.position.y - parent!.size.height / 2);
      canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
    } else {
      canvas.translate(position.x, position.y);
    }

    var tau = pi * 2;
    canvas.rotate(tau * this.turn);
    var paint = new Paint()..color = new Color(0xFFFF0000);
    canvas.drawRect(new Rect.fromLTWH(-size.width / 2, -size.height / 2, size.width, size.height), paint);
    canvas.restore();
  }
}
