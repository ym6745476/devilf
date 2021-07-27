import 'dart:math';
import 'dart:ui' as ui;
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:devilf/sprite/df_sprite_image.dart';
import 'package:example/monster/monster_sprite.dart';
import 'package:example/player/player.dart';
import 'package:flutter/cupertino.dart';

import '../game_manager.dart';

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

        bool loop = true;
        if (this.action == DFAnimation.ATTACK ||
            this.action == DFAnimation.CASTING ||
            this.action == DFAnimation.DEATH) {
          loop = false;
        }

        if (this.action == DFAnimation.IDLE) {
          bodySprite!.play(animation, stepTime: 300,loop:loop);
        } else {
          bodySprite!.play(animation, stepTime: 100,loop:loop,onComplete: (DFSpriteAnimation sprite){
            if(sprite.currentAnimation.contains(DFAnimation.ATTACK) || sprite.currentAnimation.contains(DFAnimation.CASTING)){
              /// 动作完成回到IDLE
              bodySprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300,loop:true);
            }
          });
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

  /// 碰撞矩形
  DFRect getCollisionRect() {
    if (bodySprite != null) {
      double scaleW = 0.5;
      double scaleH = 0.5;
      List<DFImageSprite> sprites = bodySprite!.frames[bodySprite!.currentAnimation]!;
      return DFRect(
          this.position.x - sprites[0].size.width / 2 * scaleW,
          this.position.y - sprites[0].size.height / 2 * scaleH,
          sprites[0].size.width * scaleW,
          sprites[0].size.height * scaleH);
    }
    return DFRect(this.position.x - this.size.width / 2, this.position.y - this.size.height / 2, this.size.width,
        this.size.height);
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

    /// 判断给敌人发出伤害
    if (bodySprite!.currentAnimation.contains(DFAnimation.ATTACK) &&
        bodySprite!.currentIndex == bodySprite!.frames[bodySprite!.currentAnimation]!.length - 2) {
      this.findEnemy(
          found: (monsterSprites) {
            monsterSprites.forEach((monsterSprite) {
              if (!monsterSprite.monster.isDead) {
                print("found Enemy");

                /// 随机伤害  0.0~1.0
                var random = new Random();
                double newAt = player.maxAt * random.nextDouble();
                monsterSprite.receiveDamage(player.minAt > newAt ? player.minAt : newAt, this);
              }
            });
          },
          notFound: () {
            print("findEnemy notFound");
          },
          vision: 100);
    }
  }

  /// 找敌人
  void findEnemy({
    required Function(List<MonsterSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    List<MonsterSprite> foundMonster = [];
    if (GameManager.monsterSprites != null) {
      GameManager.monsterSprites!.forEach((monsterSprite) {
        if (!monsterSprite.monster.isDead) {
          /// 玩家的伤害矩形
          Rect visibleRect = Rect.fromLTWH(
            this.position.x - vision / 2,
            this.position.y - vision / 2,
            vision,
            vision,
          );

          Rect monsterCollision = monsterSprite.getCollisionRect().toRect();
          if (visibleRect.overlaps(monsterCollision)) {
            foundMonster.add(monsterSprite);
          }
        }
      });
    }

    if (foundMonster.length > 0) {
      found(foundMonster);
    } else {
      notFound();
    }
  }

  /// 渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 精灵矩形边界
    var paint = new Paint()..color = Color(0x60bb505d);
    canvas.drawRect(getCollisionRect().toRect(), paint);

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 渲染身体精灵
    this.bodySprite?.render(canvas);

    ///恢复画布
    canvas.restore();
  }
}
