import 'dart:math';
import 'package:devilf_engine/core/df_circle.dart';
import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_shape.dart';
import 'package:devilf_engine/core/df_size.dart';
import 'package:devilf_engine/devilf_engine.dart';
import 'package:devilf_engine/game/df_animation.dart';
import 'package:devilf_engine/sprite/df_animation_sprite.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:example/monster/monster_sprite.dart';
import 'package:flutter/cupertino.dart';

import '../game_manager.dart';
import 'effect_info.dart';

/// 特效精灵类
class EffectSprite extends DFSprite {
  /// 特效
  EffectInfo? effect;

  /// 纹理精灵
  DFAnimationSprite? textureSprite;

  /// 归属精灵
  DFSprite? ownerSprite;

  /// 目标精灵
  DFSprite? targetSprite;

  /// 当前移动方向弧度
  double radians = 0;

  /// 当前动作
  String action = DFAction.NONE;

  /// 当前方向
  String direction = DFDirection.NONE;

  /// 过期时钟
  int expireClock = 0;

  /// 是否初始化
  bool isInit = false;

  /// 创建怪物精灵
  EffectSprite(
    this.effect, {
    DFSize size = const DFSize(50, 50),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    await Future.delayed(Duration.zero, () async {
      /// 玩家精灵动画
      DFAnimationSprite textureSprite = await DFAnimationSprite.load(this.effect!.texture!, scale: 0.4);
      this.textureSprite = textureSprite;
      this.textureSprite!.position = DFPosition(size.width / 2, size.height / 2);
      this.textureSprite!.size = DFSize(100, 100);

      /// 调用add产生层级关系进行坐标转换
      addChild(this.textureSprite!);

      /// 播放动画
      if (effect!.type == EffectType.ATTACK) {
        this.play(DFAction.ATTACK, direction: this.direction, radians: this.radians);
      } else if (effect!.type == EffectType.TRACK) {
        this.expireClock = DateTime.now().millisecondsSinceEpoch;
        this.play(DFAction.TRACK, direction: this.direction, radians: this.radians);
      }

      /// 初始化完成
      this.isInit = true;
    });
  }

  /// 播放动画
  void play(String action, {direction = DFDirection.NONE, radians = 1.0}) {
    /// 不传action,则使用上一次的动作
    if (action != DFAction.NONE) {
      this.action = action;
    }

    /// 不传direction,则使用上一次的方向
    if (direction != DFDirection.NONE) {
      this.direction = direction;
    }

    /// 方向弧度
    this.radians = radians;

    print("特效方向角度:" + (this.radians * 180 / pi).toString());

    String animation = this.action + this.direction;

    if (textureSprite != null) {
      if (animation != textureSprite!.currentAnimation) {
        if (effect!.type == EffectType.ATTACK) {
          /// 5方向转换为8方向
          bool flippedX = false;
          if (animation.contains(DFDirection.LEFT)) {
            flippedX = true;
          }
          textureSprite!.currentAnimationFlippedX = flippedX;
        }

        bool loop = true;
        if (this.action == DFAction.ATTACK || this.action == DFAction.EXPLODE) {
          loop = false;
        }

        /// 弹道的只有一个上方向的图
        if (action == DFAction.TRACK) {
          animation = action + DFDirection.UP;
        } else if (action == DFAction.EXPLODE) {
          animation = action + DFDirection.UP;
        } else if (action == DFAction.SURROUND) {
          animation = action + DFDirection.UP;
        }

        textureSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
          print("onComplete:" + sprite.currentAnimation);
          if (sprite.currentAnimation.contains(DFAction.EXPLODE) || sprite.currentAnimation.contains(DFAction.ATTACK)) {
            this.damageEnemy(
                found: (sprites) {
                  sprites.forEach((sprite) {
                    if (sprite is MonsterSprite) {
                      if (!sprite.monster.isDeath) {
                        sprite.receiveDamage(ownerSprite!, effect!);
                      }
                    }
                  });
                },
                notFound: () {
                  print("爆炸了没炸到怪物");
                },
                damage: this.effect!.damageRange);
          }

          /// 设置为空
          this.effect = null;
          print("从场景移除这个特效");

          /// 从场景移除
          GameManager.gameWidget!.removeChild(this);
        });
      }
    }
  }

  /// 锁定目标
  void setTargetSprite(DFSprite fromSprite, DFSprite? targetSprite) {
    this.ownerSprite = fromSprite;
    this.targetSprite = targetSprite;
  }

  /// 碰撞矩形
  @override
  DFShape getCollisionShape() {
    return DFCircle(DFPosition(this.position.x, this.position.y), this.size.width / 2);
  }

  /// 更新
  @override
  void update(double dt) {
    if (textureSprite == null) {
      return;
    }

    if (this.effect != null) {
      /// 更新位置
      if (textureSprite!.currentAnimation.contains(DFAction.TRACK)) {
        this.position.x = this.position.x + this.effect!.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.effect!.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());

        if (DateTime.now().millisecondsSinceEpoch - this.expireClock > 200) {
          this.play(DFAction.EXPLODE);
        } else {
          /// 判断碰撞
          this.checkTrackCollision();
        }
      }
      this.textureSprite?.update(dt);
    }
  }

  /// 在伤害范围内找敌人
  void damageEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double damage,
  }) {
    /// 目标列表
    List<DFSprite> foundMonster = [];

    /// 有目标
    if (GameManager.monsterSprites != null) {
      GameManager.monsterSprites!.forEach((monsterSprite) {
        if (!monsterSprite.monster.isDeath) {
          DFShape monsterCollision = monsterSprite.getCollisionShape();
          if (monsterCollision.overlaps(this.getCollisionShape())) {
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

  /// 判断与目标碰撞
  void checkTrackCollision() {
    if (targetSprite != null) {
      if (targetSprite is MonsterSprite) {
        MonsterSprite monsterSprite = targetSprite as MonsterSprite;
        DFShape monsterCollision = monsterSprite.getCollisionShape();
        if (this.getCollisionShape().overlaps(monsterCollision)) {
          this.position.x = monsterSprite.position.x;
          this.position.y = monsterSprite.position.y;
          this.play(DFAction.EXPLODE);
        }
      }
    } else {
      /// 无目标
      if (GameManager.monsterSprites != null) {
        GameManager.monsterSprites!.forEach((monsterSprite) {
          if (!monsterSprite.monster.isDeath) {
            DFShape monsterCollision = monsterSprite.getCollisionShape();
            if (this.getCollisionShape().overlaps(monsterCollision)) {
              this.position.x = monsterSprite.position.x;
              this.position.y = monsterSprite.position.y;
              this.play(DFAction.EXPLODE);
            }
          }
        });
      }
    }
  }

  /// 渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 精灵碰撞区域
    if (DFConfig.debug) {
      /*var paint = new Paint()..color = Color(0x60bb505d);
      DFShape collisionShape = getCollisionShape();
      if (collisionShape is DFCircle) {
        canvas.drawCircle(collisionShape.center.toOffset(), collisionShape.radius, paint);
      } else if (collisionShape is DFRect) {
        canvas.drawRect(collisionShape.toRect(), paint);
      }*/
    }

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 需要根据方向旋转的特效
    if (effect != null && effect!.type == EffectType.TRACK) {
      canvas.rotate(this.radians);
    }

    /// 渲染身体精灵
    this.textureSprite?.render(canvas);

    ///恢复画布
    canvas.restore();
  }
}
