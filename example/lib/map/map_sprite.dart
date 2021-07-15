import 'dart:ui';

import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/cupertino.dart';

/// 地图精灵类
class MapSprite extends DFSprite {
  MapSprite({
    DFSize size = const DFSize(64, 64),
  }) : super(position: DFPosition(0, 0), size: size);

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.save();

    /// 将子精灵转换为相对坐标
    if (parent == null) {
      canvas.translate(position.x, position.y);
    } else {
      canvas.translate(position.x - parent!.size.width / 2, position.y - parent!.size.height / 2);
    }

    canvas.drawPaint(new Paint()..color = const Color(0xFF4f5555));
    canvas.translate(this.position.x, this.position.y);
    canvas.restore();
  }
}
