
import 'dart:ui' as ui;
import 'package:devilf/base/animation_name.dart';
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:devilf/sprite/sprite_animation.dart';
import 'package:flutter/cupertino.dart';

import 'image_sprite.dart';

/// 玩家精灵类
class PlayerSprite extends Sprite{

  ImageSprite? logoSprite;
  SpriteAnimation? bodySprite;

  PlayerSprite(
    {
      Position position = const Position(0,0),
      Size size = const Size(128,128),
    }
  ):super(position:position,size:size);

  ///
  void play(AnimationName animation) {
    bodySprite?.play(animation);
  }

  @override
  void onChildChange(Sprite child){
    if(this.children.length > 0){
      logoSprite = this.children[0] as ImageSprite;
    }
    if(this.children.length > 1){
      bodySprite = this.children[1] as SpriteAnimation;
    }

  }


  @override
  void update(double dt){

    logoSprite?.angle += 1;
    logoSprite?.update(dt);

    //动画精灵在父精灵的中间
    bodySprite?.position = Position(size.width/2, size.height/2);
    bodySprite?.update(dt);

  }

  @override
  void render(Canvas canvas){

    logoSprite?.render(canvas);
    bodySprite?.render(canvas);

    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x20ED1941);
    //canvas.drawRect(Rect.fromLTWH(position.x - size.width/2,position.y - size.height/2, size.width, size.height), paint);

  }

}
