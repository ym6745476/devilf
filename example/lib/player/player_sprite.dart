import 'dart:math';
import 'dart:ui' as ui;
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:example/player/player.dart';
import 'package:flutter/cupertino.dart';

/// 玩家精灵类
class PlayerSprite extends DFSprite {
  /// 玩家
  Player player;

  /// 身体
  DFSpriteAnimation? bodySprite;

  /// 武器
  DFSpriteAnimation? weaponSprite;

  /// 当前移动方向弧度
  double radians = 0;

  /// 创建玩家精灵
  PlayerSprite(
    this.player, {
    DFSize size = const DFSize(100, 100),
  }) : super(position: DFPosition(0, 0), size: size);

  /// 播放动画
  void play(String animation, {radians = 0.0}) {
    this.radians = radians;
    if (bodySprite != null) {
      if (animation != bodySprite!.currentAnimation) {
        /// 5方向转换为8方向
        bool flippedX = false;
        if (animation.contains("LEFT")) {
          flippedX = true;
        }
        bodySprite?.currentAnimationFlippedX = flippedX;
        bodySprite?.play(animation);
      }
    }
  }

  /// 设置身体
  void setBodySprite(DFSpriteAnimation sprite) {
    this.bodySprite = sprite;
    this.bodySprite!.position = DFPosition(size.width / 2, size.height / 2);
    this.bodySprite!.size = DFSize(160, 160);

    /// 调用add产生层级关系进行坐标转换
    addChild(this.bodySprite!);

    ///自动播放玩家第一个动画
    this.play(DFAnimation.IDLE + DFAnimation.DOWN);
  }

  /// 设置武器
  void setWeaponSprite(DFSpriteAnimation sprite) {
    this.weaponSprite = sprite;

    /// 绑定动画同步
    this.weaponSprite!.position = DFPosition(this.bodySprite!.size.width / 2, this.bodySprite!.size.height / 2);
    this.weaponSprite!.size = DFSize(120, 120);
    this.bodySprite?.bindChild(this.weaponSprite!);
  }

  /// 更新
  @override
  void update(double dt) {

    if(bodySprite!.currentAnimation == DFAnimation.RUN){
      /// 换算角度
      double angle = 180 / pi * this.radians;
      if (angle < 0) {
        angle = angle + 360;
      }
      this.position.x = this.position.x + this.player.moveSpeed * acos(angle);
      this.position.y = this.position.y + this.player.moveSpeed * asin(angle);
    }
    this.bodySprite?.update(dt);
  }

  /// 渲染
  @override
  void render(Canvas canvas) {

    /// 画布暂存
    canvas.save();

    canvas.translate(position.x, position.y);

    /// 渲染身体精灵
    this.bodySprite?.render(canvas);

    ///恢复画布
    canvas.restore();
  }
}
