import 'dart:math';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:devilf/sprite/df_sprite_image.dart';
import 'package:example/effect/effect.dart';
import 'package:example/effect/effect_sprite.dart';
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

  /// 目标精灵
  DFSprite? targetSprite;

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
  void play({action = DFAnimation.IDLE, direction = DFAnimation.NONE, radians = 3.15, Effect? effect}) {
    this.action = action;

    /// 不传direction,则使用上一次的方向
    if (direction != DFAnimation.NONE) {
      this.direction = direction;
    }

    /// 不传弧度，则使用上一次的弧度
    if (radians != 3.15) {
      this.radians = radians;
    }

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
          bodySprite!.play(animation, stepTime: 300, loop: loop);
        } else if (this.action == DFAnimation.RUN) {
          bodySprite!.play(animation, stepTime: 100, loop: loop);
        } else if (this.action == DFAnimation.ATTACK || this.action == DFAnimation.CASTING) {
          bodySprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFSpriteAnimation sprite) {
            /// 动作完成回到IDLE
            bodySprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300, loop: true);
          });
        } else {
          bodySprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFSpriteAnimation sprite) {
            if (sprite.currentAnimation.contains(DFAnimation.DIG)) {
              /// 动作完成回到IDLE
              bodySprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300, loop: true);
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
    this.play(action: DFAnimation.IDLE, direction: DFAnimation.DOWN, radians: 90 * pi / 180.0);
  }

  /// 设置武器
  void setWeaponSprite(DFSpriteAnimation sprite) {
    this.weaponSprite = sprite;

    /// 绑定动画同步
    this.weaponSprite!.position = DFPosition(this.bodySprite!.size.width / 2, this.bodySprite!.size.height / 2);
    this.weaponSprite!.size = DFSize(120, 120);
    this.bodySprite?.bindChild(this.weaponSprite!);
  }

  /// 锁定目标并移动
  void lockAndMoveSprite(Effect effect) {
    /// 范围内有多个精灵，选取第一个作为目标
    this.findEnemy(
        found: (sprites) {
          print("找到了" + sprites.length.toString() + "个目标");
          this.targetSprite = sprites[0];
          if (this.targetSprite is MonsterSprite) {
            MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
            print("锁定目标：" + monsterSprite.monster.name);
          }

          /// 向目标移动
          this.moveToTarget(this.targetSprite!, arrived: (String direction, double radians) {
            if (effect.type == EffectType.ATTACK) {
              this.play(action: DFAnimation.ATTACK, direction: direction, radians: radians, effect: effect);
            } else if (effect.type == EffectType.TRACK) {
              this.play(action: DFAnimation.CASTING, direction: direction, radians: radians, effect: effect);
            }

            /// 显示技能特效
            this._addEffect(effect);
          });
        },
        notFound: () {
          print("没有找到目标");

          /// 显示技能特效
          this._addEffect(effect);
        },
        vision: effect.vision);
  }

  /// 添加特效
  void _addEffect(Effect effect) async {
    try {
      await Future.delayed(Duration.zero, () async {
        EffectSprite effectSprite = EffectSprite(effect);
        effectSprite.position = DFPosition(this.position.x, this.position.y);
        DFSpriteAnimation effectBodySprite = await DFSpriteAnimation.load(
            "assets/images/effect/" + effect.name + ".png", "assets/images/effect/" + effect.name + ".json",
            scale: 0.4);
        effectSprite.setBodySprite(effectBodySprite);
        effectSprite.setTargetSprite(this, this.targetSprite);
        GameManager.gameWidget!.addChild(effectSprite);

        /// 播放动画
        if (effect.type == EffectType.ATTACK) {
          effectSprite.play(action: DFAnimation.ATTACK, direction: this.direction, radians: this.radians);
        } else if (effect.type == EffectType.TRACK) {
          effectSprite.play(action: DFAnimation.TRACK, direction: this.direction, radians: this.radians);
        }
      });
    } catch (e) {
      print('(GameScene _loadGame) Error: $e');
    }
  }

  /// 在可视范围内找敌人
  void findEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    Rect visibleRect = Rect.fromLTWH(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );

    /// 目标列表
    List<DFSprite> foundMonster = [];

    if (GameManager.monsterSprites != null) {
      GameManager.monsterSprites!.forEach((monsterSprite) {
        if (!monsterSprite.monster.isDead) {
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

  /// 向目标移动
  void moveToTarget(DFSprite sprite, {required Function(String direction, double radians) arrived}) {
    double translateX = sprite.position.x - this.position.x;
    double translateY = sprite.position.y - this.position.y;

    /// 范围防抖
    if ((translateX < 0 && translateX > -0.5) || (translateX > 0 && translateX < 0.5)) {
      translateX = 0;
    }

    if ((translateY < 0 && translateY > -0.5) || (translateY > 0 && translateY < 0.5)) {
      translateY = 0;
    }

    String direction = this.direction;
    double radians = this.radians;
    if (translateX > 0 && translateY > 0) {
      direction = DFAnimation.DOWN_RIGHT;
      radians = 45 * pi / 180.0;
    } else if (translateX < 0 && translateY < 0) {
      direction = DFAnimation.UP_LEFT;
      radians = 225 * pi / 180.0;
    } else if (translateX > 0 && translateY < 0) {
      direction = DFAnimation.UP_RIGHT;
      radians = 315 * pi / 180.0;
    } else if (translateX < 0 && translateY > 0) {
      direction = DFAnimation.DOWN_LEFT;
      radians = 135 * pi / 180.0;
    } else {
      if (translateX > 0) {
        direction = DFAnimation.RIGHT;
        radians = 0;
      } else if (translateX < 0) {
        direction = DFAnimation.LEFT;
        radians = 180 * pi / 180.0;
      }
      if (translateY > 0) {
        direction = DFAnimation.DOWN;
        radians = 90 * pi / 180.0;
      } else if (translateY < 0) {
        direction = DFAnimation.UP;
        radians = 270 * pi / 180.0;
      }
    }

    /// 碰撞
    Rect targetCollision = sprite.getCollisionRect().toRect();
    if (this.getCollisionRect().toRect().overlaps(targetCollision)) {
      translateX = 0;
      translateY = 0;
    }

    if (translateX == 0 && translateY == 0) {
      /// 到达位置
      arrived(direction, radians);
    } else {
      /// 继续移动
      this.play(action: DFAnimation.RUN, direction: direction, radians: radians);
    }
  }

  /// 更新
  @override
  void update(double dt) {
    if (bodySprite!.currentAnimation.contains(DFAnimation.RUN)) {
      this.position.x = this.position.x + this.player.moveSpeed * cos(this.radians);
      this.position.y = this.position.y + this.player.moveSpeed * sin(this.radians);
      //print("move:" + this.position.toString());
    }
    this.bodySprite?.update(dt);
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
