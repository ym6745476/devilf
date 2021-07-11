
import 'dart:ui' as ui;
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/game/df_sprite.dart';
import 'package:devilf/game/df_sprite_animation.dart';
import 'package:devilf/game/df_animation.dart';
import 'package:flutter/cupertino.dart';

import '../game/df_sprite_image.dart';

/// 玩家精灵类
class PlayerSprite extends DFSprite{

  DFImageSprite? logoSprite;
  DFSpriteAnimation? bodySprite;
  DFSpriteAnimation? hairSprite;
  DFSpriteAnimation? weaponSprite;

  PlayerSprite(
    {
      DFPosition position = const DFPosition(0,0),
      DFSize size = const DFSize(200,200),
    }
  ):super(position:position,size:size);

  /// 播放动画
  void play(String animation) {

    //5方向转换为8方向
    bool flippedX = false;
    if(animation.contains("LEFT")){
      flippedX = true;
    }
    bodySprite?.currentAnimationFlippedX = flippedX;
    bodySprite?.play(animation);
  }

  void setLogoSprite(DFImageSprite sprite){
    this.logoSprite = sprite;

    //必须调用add产生层级关系进行坐标转换
    addChild(sprite);
  }

  void setBodySprite(DFSpriteAnimation sprite){
    this.bodySprite = sprite;
    sprite.position = DFPosition(size.width/2, size.height/2);
    sprite.size = DFSize(160,160);
    addChild(sprite);
  }

  void setHairSprite(DFSpriteAnimation sprite){
    this.hairSprite = sprite;
    /// 绑定动画同步
    sprite.position = DFPosition(this.bodySprite!.size.width/2, this.bodySprite!.size.height/2);
    this.bodySprite?.bindChild(sprite);
  }

  void setWeaponSprite(DFSpriteAnimation sprite){
    this.weaponSprite = sprite;
    /// 绑定动画同步
    sprite.position = DFPosition(this.bodySprite!.size.width/2, this.bodySprite!.size.height/2);
    sprite.size = DFSize(120,120);
    //sprite.anchorPoint = DFPosition(0, 0);
    this.bodySprite?.bindChild(sprite);
  }


  @override
  void update(double dt){

    logoSprite?.angle += 1;
    logoSprite?.update(dt);
    bodySprite?.update(dt);

  }

  @override
  void render(Canvas canvas){

    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x20FFFC00);
    canvas.drawRect(Rect.fromLTWH(position.x - size.width/2,position.y - size.height/2, size.width, size.height), paint);

    logoSprite?.render(canvas);
    bodySprite?.render(canvas);

  }

}
