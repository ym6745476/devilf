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

  /// 当前动作
  String action = DFAnimation.NONE;

  /// 当前方向
  String direction = DFAnimation.NONE;

  /// 创建玩家精灵
  PlayerSprite(
    this.player, {
    DFSize size = const DFSize(180, 180),
  }) : super(position: DFPosition(0, 0), size: size);

  /// 播放动画
  void play({action = DFAnimation.IDLE, direction = DFAnimation.NONE, radians = 1.0}) {
    this.action = action;

    /// 不传direction,则使用上一次的方向
    if (direction != DFAnimation.NONE) {
      this.direction = direction;
    }

    this.radians = radians;

    String animation = this.action + this.direction;

    if (bodySprite != null) {
      if (animation != bodySprite!.currentAnimation) {
        /// 5方向转换为8方向
        bool flippedX = false;
        if (animation.contains("LEFT")) {
          flippedX = true;
        }
        bodySprite!.currentAnimationFlippedX = flippedX;
        print("play:" + animation);
        if (this.action == DFAnimation.IDLE) {
          bodySprite!.play(animation, stepTime: 300);
        } else {
          bodySprite!.play(animation, stepTime: 100);
        }
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
    this.play(action: DFAnimation.IDLE, direction: DFAnimation.DOWN);
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
    if (bodySprite!.currentAnimation.contains(DFAnimation.RUN)) {
      if (this.radians != 0) {
        this.position.x = this.position.x + this.player.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.player.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());
      }
    }
    this.bodySprite?.update(dt);
  }

  /// 渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 精灵矩形边界
    //var paint = new Paint()..color =  Color(0x60000000);
    //canvas.drawRect(Rect.fromLTWH(-size.width/2, -size.height/2, size.width, size.height), paint);

    /// 渲染身体精灵
    this.bodySprite?.render(canvas);

    ///恢复画布
    canvas.restore();
  }
}
