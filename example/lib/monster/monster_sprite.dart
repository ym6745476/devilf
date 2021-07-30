import 'dart:math';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_progress_sprite.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:devilf/sprite/df_sprite_image.dart';
import 'package:devilf/sprite/df_text_sprite.dart';
import 'package:example/effect/effect.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import '../game_manager.dart';
import 'monster.dart';

/// 怪物精灵类
class MonsterSprite extends DFSprite {
  /// 怪物
  Monster monster;

  /// 衣服
  DFSpriteAnimation? clothesSprite;

  /// 武器
  DFSpriteAnimation? weaponSprite;

  /// 血条
  DFProgressSprite? hpBarSprite;

  /// 名字
  DFTextSprite? nameSprite;

  /// 选中光圈
  DFSpriteAnimation? selectSprite;

  /// 目标精灵
  DFSprite? targetSprite;

  /// 当前移动方向弧度
  double radians = 0;

  /// 当前动作
  String action = DFAnimation.NONE;

  /// 当前方向
  String direction = DFAnimation.NONE;

  /// 帧绘制时钟
  int clock = 0;

  /// 是否被选择
  bool isSelected = false;

  /// 是否初始化
  bool isInit = false;

  /// 创建怪物精灵
  MonsterSprite(
    this.monster, {
    DFSize size = const DFSize(60, 60),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    try {
      await Future.delayed(Duration.zero, () async {
        /// 玩家精灵动画
        DFSpriteAnimation clothesSprite = await DFSpriteAnimation.load(this.monster.clothes);
        this.clothesSprite = clothesSprite;
        this.clothesSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.clothesSprite!.size = DFSize(160, 160);

        /// 调用add产生层级关系进行坐标转换
        addChild(this.clothesSprite!);

        if (this.monster.weapon != "") {
          DFSpriteAnimation weaponSprite = await DFSpriteAnimation.load(this.monster.weapon);
          this.weaponSprite = weaponSprite;

          /// 绑定动画同步
          this.weaponSprite!.position =
              DFPosition(this.clothesSprite!.size.width / 2, this.clothesSprite!.size.height / 2);
          this.weaponSprite!.size = DFSize(120, 120);
          this.clothesSprite?.bindChild(this.weaponSprite!);
        }

        ///自动播放玩家第一个动画
        this.play(action: DFAnimation.IDLE, direction: DFAnimation.DOWN, radians: 90 * pi / 180.0);

        /// 血条
        ui.Image image = await DFAssetsLoader.loadImage("assets/images/ui/hp_bar_monster.png");
        this.hpBarSprite = DFProgressSprite(image,gravity: DFGravity.top,textOffset: 5);
        this.hpBarSprite!.position = DFPosition(size.width / 2, 0);
        this.hpBarSprite!.scale = 0.6;
        addChild(this.hpBarSprite!);

        /// 名字
        this.nameSprite = DFTextSprite(this.monster.name,fontSize: 10);
        this.nameSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.nameSprite!.setOnUpdate((dt) {});
        addChild(this.nameSprite!);

        /// 选择光圈
        DFSpriteAnimation selectSprite = await DFSpriteAnimation.load("assets/images/effect/select_monster.json",
            scale: 0.6, blendMode: BlendMode.colorDodge);
        this.selectSprite = selectSprite;
        this.selectSprite!.position = DFPosition(size.width / 2, size.height / 2 * 1.2);
        addChild(this.selectSprite!);

        /// 初始化完成
        this.isInit = true;
      });
    } catch (e) {
      print('(PlayerSprite _init) Error: $e');
    }
  }

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

    if (clothesSprite != null) {
      if (animation != clothesSprite!.currentAnimation) {
        /// 5方向转换为8方向
        bool flippedX = false;
        if (animation.contains(DFAnimation.LEFT)) {
          flippedX = true;
        }
        clothesSprite!.currentAnimationFlippedX = flippedX;

        bool loop = true;
        if (this.action == DFAnimation.ATTACK ||
            this.action == DFAnimation.CASTING ||
            this.action == DFAnimation.DEATH) {
          loop = false;
        }
        if (this.action == DFAnimation.IDLE) {
          clothesSprite!.play(animation, stepTime: 300, loop: loop);
        } else {
          clothesSprite!.play(
            animation,
            stepTime: 100,
            loop: loop,
            onComplete: (DFSpriteAnimation sprite) {
              if (sprite.currentAnimation.contains(DFAnimation.DEATH)) {
                /// 设置死亡状态
                this.monster.isDead = true;
                this.clock = DateTime.now().millisecondsSinceEpoch;

                print("从场景移除吧");

                /// 从场景移除 可重生
                GameManager.gameWidget!.removeChild(this, recyclable: false);
              } else {
                /// 动作完成回到IDLE
                clothesSprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300, loop: true);
              }
            },
          );
        }
      }
    }
  }

  /// 碰撞矩形
  DFRect getCollisionRect() {
    if (clothesSprite != null && isInit) {
      double scaleW = 0.5;
      double scaleH = 0.5;
      List<DFImageSprite> sprites = clothesSprite!.frames[clothesSprite!.currentAnimation]!;
      return DFRect(
          this.position.x - sprites[0].size.width / 2 * scaleW,
          this.position.y - sprites[0].size.height / 2 * scaleH,
          sprites[0].size.width * scaleW,
          sprites[0].size.height * scaleH);
    }
    return DFRect(this.position.x - this.size.width / 2, this.position.y - this.size.height / 2, this.size.width,
        this.size.height);
  }

  /// 接收伤害
  void receiveDamage(DFSprite fromSprite, Effect effect) {
    /// 随机伤害  0.0~1.0
    var random = new Random();
    if (fromSprite is PlayerSprite) {
      double newMinAt = fromSprite.player.minAt * random.nextDouble();
      double newMaxAt = fromSprite.player.maxAt * random.nextDouble();
      double damageAt = newMinAt > newMaxAt ? newMinAt * effect.at : newMaxAt * effect.at - monster.df;

      double newMinMt = fromSprite.player.minMt * random.nextDouble();
      double newMaxMt = fromSprite.player.maxMt * random.nextDouble();
      double damageMt = newMinMt > newMaxMt ? newMinMt * effect.at : newMaxMt * effect.mt - monster.mf;

      double totalDamage = damageAt + damageMt;
      if (totalDamage <= 0) {
        totalDamage = 1;
      }

      /// 真实伤害数值 攻击力 - 防御力 * 0.35
      int hp = (totalDamage * 0.35 + 0.5).floor();

      print("接收到伤害:" + totalDamage.toStringAsFixed(2));
      print("伤害转化血量:" + hp.toString());

      this.monster.hp = this.monster.hp - hp;
      this.hpBarSprite!.progress = (this.monster.hp / this.monster.maxMp * 100).toInt();
      if (this.monster.hp < 0) {
        this.targetSprite = null;
        this.play(action: DFAnimation.DEATH, direction: direction, radians: radians);
      }
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

  /// 锁定目标
  void lockTargetSprite() {
    /// 玩家视野范围内有多个精灵，选取第一个作为目标
    this.findEnemy(
        found: (sprites) {
          ///print("找到了" + sprites.length.toString() + "个目标");
          this.targetSprite = sprites[0];

          /// if (this.targetSprite is PlayerSprite) {
          /// PlayerSprite playerSprite = this.targetSprite as PlayerSprite;
          /// print("锁定目标：" + playerSprite.player.name);
          /// }
        },
        notFound: () {
          ///print("没有找到目标");
        },
        vision: monster.vision);
  }

  /// 在可视范围内找敌人
  void findEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    /// 目标列表
    List<DFSprite> foundMonster = [];

    /// 优先找到已锁定的目标
    if (this.targetSprite != null) {
      if (this.targetSprite is PlayerSprite) {
        /// 有目标2倍的追踪范围
        Rect visibleRect = Rect.fromLTWH(
          this.position.x - vision,
          this.position.y - vision,
          vision * 2,
          vision * 2,
        );
        PlayerSprite playerSprite = this.targetSprite as PlayerSprite;
        if (!playerSprite.player.isDead) {
          Rect playerCollision = playerSprite.getCollisionRect().toRect();
          if (visibleRect.overlaps(playerCollision)) {
            foundMonster.add(playerSprite);
          }
        }
      }
    } else {
      Rect visibleRect = Rect.fromLTWH(
        this.position.x - vision / 2,
        this.position.y - vision / 2,
        vision,
        vision,
      );
      PlayerSprite playerSprite = GameManager.playerSprite!;
      if (!playerSprite.player.isDead) {
        Rect playerCollision = playerSprite.getCollisionRect().toRect();
        if (visibleRect.overlaps(playerCollision)) {
          foundMonster.add(playerSprite);
        }
      }
    }

    if (foundMonster.length > 0) {
      found(foundMonster);
    } else {
      notFound();
    }
  }

  /// 查看锁定目标
  bool checkTargetSprite(double vision) {
    Rect visibleRect = Rect.fromLTWH(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );

    /// 是否还在特效视野内
    if (this.targetSprite != null) {
      if (this.targetSprite is PlayerSprite) {
        PlayerSprite playerSprite = this.targetSprite as PlayerSprite;
        if (!playerSprite.player.isDead) {
          Rect playerCollision = playerSprite.getCollisionRect().toRect();
          if (visibleRect.overlaps(playerCollision)) {
            return true;
          }
        }
      }
    }

    /// 放弃这个目标
    this.targetSprite = null;
    return false;
  }

  /// 向目标移动并攻击
  void moveToTarget(DFSprite targetSprite, {required Function(String direction, double radians) arrived}) {
    double translateX = targetSprite.position.x - this.position.x;
    double translateY = targetSprite.position.y - this.position.y;

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
    if (targetSprite is PlayerSprite) {
      Rect playerCollision = targetSprite.getCollisionRect().toRect();
      if (this.getCollisionRect().toRect().overlaps(playerCollision)) {
        translateX = 0;
        translateY = 0;
      }
    }

    if (translateX == 0 && translateY == 0) {
      /// 到达位置
      arrived(direction, radians);
    } else {
      /// 继续移动
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
    this.action = DFAnimation.IDLE;
    this.clothesSprite!.currentAnimation = DFAnimation.IDLE + DFAnimation.DOWN;
    this.monster.isDead = false;
    this.monster.hp = this.monster.maxMp;
    this.hpBarSprite!.progress = 100;
    this.isUsed = true;
    print("重生：" + this.position.toString());
  }

  /// 选择
  void selectThisSprite() {
    this.isSelected = true;
    this.selectSprite?.play(DFAnimation.SURROUND + DFAnimation.UP, stepTime: 100, loop: true);
  }

  /// 取消选择
  void unSelectThisSprite() {
    this.isSelected = false;
  }

  /// 更新
  @override
  void update(double dt) {

    /// 找敌人
    if (!this.monster.isDead) {

      if (this.clothesSprite == null) {
        return;
      }

      /// 更新位置
      if (clothesSprite!.currentAnimation.contains(DFAnimation.RUN)) {
        this.position.x = this.position.x + this.monster.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.monster.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());
      }
      this.clothesSprite?.update(dt);

      /// 选择光圈
      if (this.isSelected) {
        this.selectSprite?.update(dt);
      }


      /// 准备死亡
      if (this.action == DFAnimation.DEATH) {
        return;
      }

      /// 锁定目标
      lockTargetSprite();

      /// 检查目标
      if (!checkTargetSprite(2 * this.monster.vision)) {
        this.play(action: DFAnimation.IDLE, direction: this.direction, radians: this.radians);
        return;
      }

      /// 找到敌人
      this.moveToTarget(this.targetSprite!, arrived: (String direction, double radians) {
        /// 攻击间隔时间 控制动画帧按照stepTime进行更新
        if (DateTime.now().millisecondsSinceEpoch - this.clock > this.monster.actionStepTime) {
          this.clock = DateTime.now().millisecondsSinceEpoch;
          this.play(action: DFAnimation.ATTACK, direction: direction, radians: radians);
        }
      });
    } else {
      /// 重生
      /// print("重生计时：" + (DateTime.now().millisecondsSinceEpoch - this.clock).toStringAsFixed(0));
      if (DateTime.now().millisecondsSinceEpoch - this.clock > this.monster.rebornTime) {
        this.clock = DateTime.now().millisecondsSinceEpoch;
        this.reborn();
      }
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

    if (!this.monster.isDead) {
      /// 选择光圈
      if (this.isSelected) {
        this.selectSprite?.render(canvas);
      }

      /// 渲染身体精灵
      this.clothesSprite?.render(canvas);

      /// 血条精灵
      this.hpBarSprite?.render(canvas);

      /// 名字
      this.nameSprite?.render(canvas);
    }

    ///恢复画布
    canvas.restore();
  }
}
