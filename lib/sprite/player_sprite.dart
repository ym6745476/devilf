
import 'dart:ui' as ui;
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:devilf/sprite/sprite_animation.dart';
import 'package:flutter/cupertino.dart';

import 'image_sprite.dart';

/// 玩家精灵类
class PlayerSprite extends Sprite{

  ImageSprite bodySprite;



  PlayerSprite(this.bodySprite,
    {
      Position position = const Position(0,0),
      Size size = const Size(128,128),
    }
  ):super(position:position,size:size);


  @override
  void update(double dt){
    super.update(dt);
    bodySprite.angle += dt * 0.25;
    bodySprite.position = this.position;
    bodySprite.update(dt);
  }

  @override
  void render(Canvas canvas){
    super.render(canvas);
    bodySprite.render(canvas);
  }

}
