
import 'dart:ui';

import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';

/// 地图精灵类
class MapSprite extends Sprite{

  MapSprite(
  {
    double x = 0,
    double y = 0,
  }
  ):super(x:x,y:y);


  @override
  void update(double dt) {

  }

  @override
  void render(Canvas canvas) {
    canvas.drawPaint(new Paint()..color = const Color(0xFF333333));
    canvas.save();
    canvas.translate(this.x, this.y);
    canvas.restore();
  }

}
