import 'dart:math';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:devilf/sprite/df_sprite_image.dart';
import 'package:example/player/player.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/cupertino.dart';

import '../game_manager.dart';
import 'monster.dart';

/// 怪物精灵类
class MonsterSprite extends DFSprite {
  /// 怪物
  Monster monster;

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

  /// 帧绘制时钟
  int clock = 0;

  /// 创建怪物精灵
  MonsterSprite(
    this.monster, {
    DFSize size = const DFSize(100, 100),
  }) : super(position: DFPosition(0, 0), size: size);

  /// 播放动画
  void play({action = DFAnimation.IDLE, direction = DFAnimation.NONE, radians = 1.0}) {
    /// 不传action,则使用上一次的动作
    if (action != DFAnimation.NONE) {
      this.action = action;
    }

    /// 不传direction,则使用上一次的方向
    if (direction != DFAnimation.NONE) {
      this.direction = direction;
    }

    /// 死亡只有一个方向的图
    if (this.action == DFAnimation.DEATH) {
      if (this.direction.contains(DFAnimation.RIGHT)) {
        this.direction = DFAnimation.DOWN_RIGHT;
      } else {
        this.direction = DFAnimation.DOWN_LEFT;
      }
    }

    /// 方向弧度
    this.radians = radians;

    String animation = this.action + this.direction;

    if (bodySprite != null) {
      if (animation != bodySprite!.currentAnimation) {
        /// 5方向转换为8方向
        bool flippedX = false;
        if (animation.contains(DFAnimation.LEFT)) {
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
        } else {
          bodySprite!.play(
            animation,
            stepTime: 100,
            loop: loop,
            onComplete: (DFSpriteAnimation sprite) {
              if (sprite.currentAnimation.contains(DFAnimation.DEATH)) {
                /// 设置死亡状态
                this.monster.isDead = true;
                this.clock = DateTime.now().millisecondsSinceEpoch;

                print("从场景移除吧");

                /// 从场景移除
                GameManager.gameWidget!.removeChild(this);
              } else {
                /// 动作完成回到IDLE
                bodySprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300, loop: true);
              }
            },
          );
        }
      }
    }
  }

  /// 设置身体
  void setBodySprite(DFSpriteAnimation sprite) {
    this.bodySprite = sprite;
    this.bodySprite!.position = DFPosition(size.width / 2, size.height / 2);
    this.bodySprite!.size = DFSize(100, 100);

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
    this.weaponSprite!.size = DFSize(80, 80);
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

  /// 找敌人
  void findEnemy({
    required Function(PlayerSprite) found,
    required Function() notFound,
    required double vision,
  }) {
    Player? player = GameManager.playerSprite!.player;

    if (player.isDead) {
      return;
    }

    Rect visibleRect = Rect.fromLTWH(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );
    Rect playerCollision = GameManager.playerSprite!.getCollisionRect().toRect();
    if (visibleRect.overlaps(playerCollision)) {
      found(GameManager.playerSprite!);
    } else {
      notFound();
    }
  }

  /// 接收伤害
  void receiveDamage(double damage, DFSprite from) {
    print("接收到伤害:" + damage.toStringAsFixed(2));

    /// 受击动作
    /// this.play(action: DFAnimation.IDLE, direction: direction, radians: radians);

    this.monster.hp = this.monster.hp - damage;
    if (this.monster.hp < 0) {
      this.play(action: DFAnimation.DEATH, direction: direction, radians: radians);
    }
    /*this.showDamage(
      damage,
      config: TextPaintConfig(
        fontSize: width / 3,
        color: Colors.white,
      ),
    );
    super.receiveDamage(damage, from);*/
  }

  /// 更新
  @override
  void update(double dt) {
    /// 找敌人
    if (!this.monster.isDead) {
      /// 更新位置
      if (bodySprite!.currentAnimation.contains(DFAnimation.RUN)) {
        this.position.x = this.position.x + this.monster.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.monster.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());
      }
      this.bodySprite?.update(dt);

      this.findEnemy(
          found: (playerSprite) {
            /// 找到敌人
            this.moveToTarget(playerSprite);
          },
          notFound: () {
            this.play(action: DFAnimation.IDLE, direction: this.direction, radians: this.radians);
          },
          vision: this.monster.vision);
    } else {
      /// 重生
      print("重生计时：" + (DateTime.now().millisecondsSinceEpoch - this.clock).toStringAsFixed(0));
      if (DateTime.now().millisecondsSinceEpoch - this.clock > this.monster.rebornTime) {
        this.clock = DateTime.now().millisecondsSinceEpoch;
        this.reborn();
      }
    }
  }

  /// 向目标移动
  void moveToTarget(DFSprite sprite) {
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
    Rect playerCollision = GameManager.playerSprite!.getCollisionRect().toRect();
    if (this.getCollisionRect().toRect().overlaps(playerCollision)) {
      translateX = 0;
      translateY = 0;
    }

    if (translateX == 0 && translateY == 0) {
      /// 攻击间隔时间 控制动画帧按照stepTime进行更新
      if (DateTime.now().millisecondsSinceEpoch - this.clock > this.monster.actionStepTime) {
        this.clock = DateTime.now().millisecondsSinceEpoch;
        this.play(action: DFAnimation.ATTACK, direction: direction, radians: radians);
      }
    } else {
      this.play(action: DFAnimation.RUN, direction: direction, radians: radians);
    }
  }

  /// 重生
  void reborn() {
    /// 随机位置  0.0~1.0
    var random = new Random();
    double newX = GameManager.visibleWidth * random.nextDouble();
    double newY = GameManager.visibleHeight * random.nextDouble();
    this.position.x = newX;
    this.position.y = newY;
    this.bodySprite!.currentAnimation = DFAnimation.IDLE + DFAnimation.DOWN;
    this.monster.isDead = false;
    this.isUsed = true;
    print("重生：" + this.position.toString());
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
