
import 'dart:math';
import 'dart:ui';

import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';

/// 怪物精灵类
class MonsterSprite extends Sprite{

  late double turn;

  MonsterSprite(
      {
        Position position = const Position(0,0),
        Size size = const Size(64,64),
        this.turn = 0,
      }
  ):super(position:position,size:size);


  @override
  void update(double dt) {
    this.turn += dt * 0.25;
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

    var tau = pi * 2;
    canvas.rotate(tau * this.turn);
    var white = new Paint()..color = new Color(0xFFFF0000);
    var size = 50.0;
    canvas.drawRect(new Rect.fromLTWH(-size / 2, -size / 2, size, size), white);
    canvas.restore();
  }

}
