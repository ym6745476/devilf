
import 'dart:ui';

import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';

/// 地图精灵类
class MapSprite extends Sprite{

  MapSprite(
      {
        Position position = const Position(0,0),
        Size size = const Size(64,64),
      }
  ):super(position:position,size:size);


  @override
  void update(double dt) {

  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawPaint(new Paint()..color = const Color(0xFF694D9F));
    canvas.translate(this.position.x, this.position.y);
    canvas.restore();
  }

}
