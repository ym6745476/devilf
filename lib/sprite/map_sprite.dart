
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

    canvas.save();
    /// 子类调用super可以自动移动画布到相对坐标
    if(parent!=null){
      Position parentPosition = Position(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
      canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
    }else{
      canvas.translate(position.x, position.y);
    }

    canvas.drawPaint(new Paint()..color = const Color(0xFF694D9F));
    canvas.translate(this.position.x, this.position.y);
    canvas.restore();
  }

}
