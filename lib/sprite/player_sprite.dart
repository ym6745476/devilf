
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
  SpriteAnimation? hairSprite;
  SpriteAnimation? weaponSprite;

  PlayerSprite(
    {
      Position position = const Position(0,0),
      Size size = const Size(128,128),
    }
  ):super(position:position,size:size);

  /// 播放动画
  void play(AnimationName animation) {
    bodySprite?.play(animation);
  }

  void setLogoSprite(ImageSprite sprite){
    this.logoSprite = sprite;

    //必须调用add产生层级关系进行坐标转换
    addChild(sprite);
  }

  void setBodySprite(SpriteAnimation sprite){
    this.bodySprite = sprite;
    addChild(sprite);
  }

  void setHairSprite(SpriteAnimation sprite){
    this.hairSprite = sprite;
    /// 绑定动画同步
    sprite.position = Position(this.bodySprite!.size.width/2, this.bodySprite!.size.height/2);
    this.bodySprite?.bindChild(sprite);
  }

  void setWeaponSprite(SpriteAnimation sprite){
    this.weaponSprite = sprite;
    /// 绑定动画同步
    sprite.position = Position(this.bodySprite!.size.width/2, this.bodySprite!.size.height/2);
    this.bodySprite?.bindChild(sprite);
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
    canvas.drawRect(Rect.fromLTWH(position.x - size.width/2,position.y - size.height/2, size.width, size.height), paint);

  }

}
