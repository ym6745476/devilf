import 'dart:math';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_animation_sprite.dart';
import 'package:devilf/sprite/df_image_sprite.dart';
import 'package:devilf/sprite/df_progress_sprite.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_text_sprite.dart';
import 'package:example/effect/effect.dart';
import 'package:example/effect/effect_sprite.dart';
import 'package:example/monster/monster_sprite.dart';
import 'package:example/player/player.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import '../game_manager.dart';

/// 玩家精灵类
class PlayerSprite extends DFSprite {
  /// 玩家
  Player player;

  /// 衣服
  DFAnimationSprite? clothesSprite;

  /// 武器
  DFAnimationSprite? weaponSprite;

  /// 血条
  DFProgressSprite? hpBarSprite;

  /// 名字
  DFTextSprite? nameSprite;

  /// 选中光圈
  DFAnimationSprite? selectSprite;

  /// 目标精灵
  DFSprite? targetSprite;

  /// 开始自动移动
  bool autoMove = false;

  /// 自动移动时钟
  int autoMoveClock = 0;

  /// 判断碰撞时钟
  int collideClock = 0;

  /// 重复动作
  bool repeat = false;

  /// 当前目标特效
  Effect? targetEffect;

  /// 当前移动方向弧度
  double radians = 0;

  /// 当前动作
  String action = DFAnimation.NONE;

  /// 当前方向
  String direction = DFAnimation.NONE;

  /// 是否初始化
  bool isInit = false;

  /// 创建玩家精灵
  PlayerSprite(
    this.player, {
    DFSize size = const DFSize(120, 120),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    try {
      await Future.delayed(Duration.zero, () async {
        /// 选择光圈
        DFAnimationSprite selectSprite = await DFAnimationSprite.load("assets/images/effect/select_player.json",
            scale: 0.6, blendMode: BlendMode.colorDodge);
        this.selectSprite = selectSprite;
        this.selectSprite!.position = DFPosition(size.width / 2, size.height / 2 * 1.15);
        addChild(this.selectSprite!);
        this.selectSprite?.play(DFAnimation.SURROUND + DFAnimation.UP, stepTime: 100, loop: true);

        /// 玩家精灵动画
        DFAnimationSprite clothesSprite = await DFAnimationSprite.load(this.player.clothes);
        this.clothesSprite = clothesSprite;
        this.clothesSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.clothesSprite!.size = DFSize(160, 160);

        /// 调用add产生层级关系进行坐标转换
        addChild(this.clothesSprite!);

        if (this.player.weapon != "") {
          DFAnimationSprite weaponSprite = await DFAnimationSprite.load(this.player.weapon);
          this.weaponSprite = weaponSprite;

          /// 绑定动画同步
          this.weaponSprite!.position =
              DFPosition(this.clothesSprite!.size.width / 2, this.clothesSprite!.size.height / 2);
          this.weaponSprite!.size = DFSize(120, 120);
          this.clothesSprite?.bindChild(this.weaponSprite!);
        }

        /// 自动播放玩家第一个动画
        this.play(action: DFAnimation.IDLE, direction: DFAnimation.DOWN, radians: 90 * pi / 180.0);

        /// 血条
        ui.Image image = await DFAssetsLoader.loadImage("assets/images/ui/hp_bar_player.png");
        this.hpBarSprite = DFProgressSprite(image, gravity: DFGravity.top, textOffset: 5);
        this.hpBarSprite!.position = DFPosition(size.width / 2, 0);
        this.hpBarSprite!.scale = 0.6;
        addChild(this.hpBarSprite!);

        /// 名字
        this.nameSprite = DFTextSprite(this.player.name, fontSize: 10, background: Color(0x20000000));
        this.nameSprite!.position = DFPosition(size.width / 2, -40);
        this.nameSprite!.setOnUpdate((dt) {});
        addChild(this.nameSprite!);

        /// 初始化完成
        this.isInit = true;
      });
    } catch (e) {
      print('(PlayerSprite _init) Error: $e');
    }
  }

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

    if (clothesSprite != null) {
      if (animation != clothesSprite!.currentAnimation) {
        /// 5方向转换为8方向
        bool flippedX = false;
        if (animation.contains("LEFT")) {
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
          clothesSprite!.play(animation, stepTime: 200, loop: loop);
        } else if (this.action == DFAnimation.RUN) {
          clothesSprite!.play(animation, stepTime: 50, loop: loop);
        } else if (this.action == DFAnimation.ATTACK || this.action == DFAnimation.CASTING) {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            print("Play Attack Finished");

            /// 动作完成回到IDLE
            clothesSprite!.play(DFAnimation.IDLE + this.direction, stepTime: 200, loop: false,
                onComplete: (DFAnimationSprite sprite) {
              if (this.repeat) {
                this.targetEffect!.isDead = false;
                this.moveToAttack(this.targetEffect!, repeat: true);
              }
            });
          });
        } else {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            if (sprite.currentAnimation.contains(DFAnimation.DIG)) {
              /// 动作完成回到IDLE
              clothesSprite!.play(DFAnimation.IDLE + this.direction, stepTime: 300, loop: true);
            }
          });
        }
      }
    }
  }

  /// 锁定目标
  void lockTargetSprite() {
    /// 玩家视野范围内有多个精灵，选取第一个作为目标
    this.findEnemy(
        found: (sprites) {
          print("找到了" + sprites.length.toString() + "个目标");
          this.targetSprite = sprites[0];
          if (this.targetSprite is MonsterSprite) {
            MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
            print("锁定目标：" + monsterSprite.monster.name);
            monsterSprite.selectThisSprite();
          }
        },
        notFound: () {
          print("没有找到目标");
        },
        vision: player.vision);
  }

  /// 检查当前目标
  bool checkTargetSprite(double vision) {
    DFRect visibleRect = DFRect(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );

    /// 是否还在特效视野内
    if (this.targetSprite != null) {
      if (this.targetSprite is MonsterSprite) {
        MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
        if (!monsterSprite.monster.isDead) {
          DFShape monsterCollision = monsterSprite.getCollisionShape();
          if (monsterCollision.overlaps(visibleRect)) {
            return true;
          }
        }

        /// 放弃目标
        monsterSprite.unSelectThisSprite();
      }
    }

    /// 放弃这个目标
    this.targetSprite = null;
    this.autoMove = false;
    return false;
  }

  /// 锁定目标并移动
  void moveToAttack(Effect effect, {bool repeat = false}) {
    /// 检查目标并锁定
    if (!checkTargetSprite(this.player.vision)) {
      lockTargetSprite();
    }
    this.targetEffect = effect;
    if (this.targetSprite == null) {
      if (!repeat) {
        attack(effect);
      }
    } else {
      this.autoMove = true;
      this.autoMoveClock = 0;
      this.repeat = repeat;
      this.play(action: DFAnimation.RUN, direction: direction, radians: radians);
    }
  }

  /// 释放技能攻击
  void attack(Effect effect) {
    if (effect.type == EffectType.ATTACK) {
      this.play(action: DFAnimation.ATTACK, direction: direction, radians: radians, effect: effect);
    } else if (effect.type == EffectType.TRACK) {
      this.play(action: DFAnimation.CASTING, direction: direction, radians: radians, effect: effect);
    }

    /// 显示技能特效
    this._addEffect(effect);
  }

  /// 添加特效
  Future<void> _addEffect(Effect effect) async {
    await Future.delayed(Duration(milliseconds: effect.delayTime), () async {
      EffectSprite effectSprite = EffectSprite(effect);
      effectSprite.position = DFPosition(this.position.x, this.position.y);
      effectSprite.size = DFSize(effect.damageRange, effect.damageRange);
      effectSprite.direction = this.direction;
      effectSprite.radians = this.radians;
      effectSprite.setTargetSprite(this, this.targetSprite);
      GameManager.gameWidget!.addChild(effectSprite);
    });
  }

  /// 在可视范围内找敌人
  void findEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    DFRect visibleRect = DFRect(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );

    /// 目标列表
    List<DFSprite> foundMonster = [];

    /// 优先找到已锁定的目标
    if (this.targetSprite != null) {
      if (this.targetSprite is MonsterSprite) {
        MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
        if (!monsterSprite.monster.isDead) {
          DFShape monsterCollision = monsterSprite.getCollisionShape();
          if (monsterCollision.overlaps(visibleRect)) {
            foundMonster.add(monsterSprite);
          }
        }
      }
    } else {
      /// 获取距离最近的
      double distance = vision * vision;
      MonsterSprite? preSprite;
      if (GameManager.monsterSprites != null) {
        GameManager.monsterSprites!.forEach((monsterSprite) {
          if (!monsterSprite.monster.isDead) {
            /// 距离
            double dx = monsterSprite.position.x - this.position.x;
            double dy = monsterSprite.position.y - this.position.y;
            if (dx * dx + dy * dy <= distance) {
              preSprite = monsterSprite;
              distance = dx * dx + dy * dy;
            }
          }
        });

        if (preSprite != null) {
          foundMonster.add(preSprite!);
        }
      }
    }

    if (foundMonster.length > 0) {
      found(foundMonster);
    } else {
      notFound();
    }
  }

  /// 向目标移动
  void moveToTarget(DFSprite targetSprite,
      {required double vision, required Function(String direction, double radians) arrived}) {
    /// 距离
    double translateX = targetSprite.position.x - this.position.x;
    double translateY = targetSprite.position.y - this.position.y;

    /// 范围防抖
    if ((translateX < 0 && translateX > -10) || (translateX > 0 && translateX < 10)) {
      translateX = 0;
    }

    if ((translateY < 0 && translateY > -10) || (translateY > 0 && translateY < 10)) {
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

    /// 自动走位
    bool needFarAway = false;
    if (repeat && targetEffect != null) {
      if (translateX.abs() < targetEffect!.vision / 4 && translateY.abs() < targetEffect!.vision / 4) {
        print("自动走位与目标保持距离");

        /// 往反方向移动
        if (direction == DFAnimation.UP) {
          direction = DFAnimation.DOWN;
          radians = 90 * pi / 180.0;
        } else if (direction == DFAnimation.DOWN) {
          direction = DFAnimation.UP;
          radians = 270 * pi / 180.0;
        } else if (direction == DFAnimation.LEFT) {
          direction = DFAnimation.RIGHT;
          radians = 0;
        } else if (direction == DFAnimation.RIGHT) {
          direction = DFAnimation.LEFT;
          radians = 180 * pi / 180.0;
        } else if (direction == DFAnimation.DOWN_RIGHT) {
          direction = DFAnimation.UP_LEFT;
          radians = 225 * pi / 180.0;
        } else if (direction == DFAnimation.UP_LEFT) {
          direction = DFAnimation.DOWN_RIGHT;
          radians = 45 * pi / 180.0;
        } else if (direction == DFAnimation.UP_RIGHT) {
          direction = DFAnimation.DOWN_LEFT;
          radians = 135 * pi / 180.0;
        } else if (direction == DFAnimation.DOWN_LEFT) {
          direction = DFAnimation.UP_RIGHT;
          radians = 315 * pi / 180.0;
        }
        needFarAway = true;
      }
    }

    if (needFarAway) {
      /// 继续移动
      this.play(action: DFAnimation.RUN, direction: direction, radians: radians);
      return;
    }

    /// 碰撞
    DFRect visibleRect = DFRect(
      this.position.x - vision / 2,
      this.position.y - vision / 2,
      vision,
      vision,
    );

    if (translateX != 0 || translateY != 0) {
      if (targetSprite is MonsterSprite) {
        DFShape targetCollision = targetSprite.getCollisionShape();
        if (targetCollision.overlaps(visibleRect)) {
          if (translateX == 0 || translateY == 0) {
            translateX = 0;
            translateY = 0;
          } else if ((translateX.abs() - translateY.abs()).abs() < 10) {
            /// 45度 可以战斗
            translateX = 0;
            translateY = 0;
          } else if (translateX < translateY) {
            if (translateX > 0) {
              direction = DFAnimation.RIGHT;
              radians = 0 * pi / 180.0;
            } else if (translateX < 0) {
              direction = DFAnimation.LEFT;
              radians = 180 * pi / 180.0;
            }
          } else if (translateX > translateY) {
            if (translateY > 0) {
              direction = DFAnimation.DOWN;
              radians = 90 * pi / 180.0;
            } else if (translateY < 0) {
              direction = DFAnimation.UP;
              radians = 270 * pi / 180.0;
            }
          }
        }
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

  /// 接收伤害
  void receiveDamage(DFSprite fromSprite, Effect effect) {
    /// 随机伤害  0.0~1.0
    var random = new Random();
    if (fromSprite is MonsterSprite) {
      double newMinAt = fromSprite.monster.minAt * random.nextDouble();
      double newMaxAt = fromSprite.monster.maxAt * random.nextDouble();
      double damageAt = newMinAt > newMaxAt ? newMinAt * effect.at : newMaxAt * effect.at - player.df;

      double newMinMt = fromSprite.monster.minMt * random.nextDouble();
      double newMaxMt = fromSprite.monster.maxMt * random.nextDouble();
      double damageMt = newMinMt > newMaxMt ? newMinMt * effect.at : newMaxMt * effect.mt - player.mf;

      double totalDamage = damageAt + damageMt;
      if (totalDamage <= 0) {
        totalDamage = 1;
      }

      /// 真实伤害数值 攻击力 - 防御力 * 0.35
      int hp = (totalDamage * 0.35 + 0.5).floor();

      print("接收到伤害:" + totalDamage.toStringAsFixed(2));
      print("伤害转化血量:" + hp.toString());

      this.player.hp = this.player.hp - hp;
      this.hpBarSprite!.progress = (this.player.hp / this.player.maxMp * 100).toInt();
      if (this.player.hp < 0) {
        print("玩家死亡");
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

  /// 停止自动
  void cancelAuto({bool idle = false}){
    this.autoMove = false;
    this.repeat = false;
    if(idle){
      this.play(action: DFAnimation.IDLE, direction:direction);
    }

  }

  /// 碰撞后转换方向
  void collidedChangeDirection() {
    if (direction == DFAnimation.UP) {
      direction = DFAnimation.UP_RIGHT;
      radians = 315 * pi / 180.0;
    } else if (direction == DFAnimation.DOWN) {
      direction = DFAnimation.DOWN_LEFT;
      radians = 135 * pi / 180.0;
    } else if (direction == DFAnimation.LEFT) {
      direction = DFAnimation.UP_LEFT;
      radians = 225 * pi / 180.0;
    } else if (direction == DFAnimation.RIGHT) {
      direction = DFAnimation.DOWN_RIGHT;
      radians = 45 * pi / 180.0;
    } else if (direction == DFAnimation.DOWN_RIGHT) {
      direction = DFAnimation.DOWN;
      radians = 90 * pi / 180.0;
    } else if (direction == DFAnimation.UP_LEFT) {
      direction = DFAnimation.UP;
      radians = 270 * pi / 180.0;
    } else if (direction == DFAnimation.UP_RIGHT) {
      direction = DFAnimation.RIGHT;
      radians = 0;
    } else if (direction == DFAnimation.DOWN_LEFT) {
      direction = DFAnimation.LEFT;
      radians = 180 * pi / 180.0;
    }
    this.play(action: DFAnimation.RUN, direction: direction, radians: radians);
  }

  /// 碰撞矩形
  @override
  DFShape getCollisionShape() {
    if (clothesSprite != null && isInit) {
      List<DFImageSprite> sprites = clothesSprite!.frames[clothesSprite!.currentAnimation]!;
      return DFCircle(DFPosition(this.position.x, this.position.y), sprites[0].size.width / 4);
    }
    return super.getCollisionShape();
  }

  /// 更新
  @override
  void update(double dt) {
    if (clothesSprite == null) {
      return;
    }
    if (clothesSprite!.currentAnimation.contains(DFAnimation.RUN)) {
      /// 判断碰撞
      int isCollided = 0;
      if (GameManager.mapSprite != null && GameManager.mapSprite!.tiledSprite != null) {
        if (DateTime.now().millisecondsSinceEpoch - this.collideClock > 10) {
          this.collideClock = DateTime.now().millisecondsSinceEpoch;
          double newX = this.position.x + this.player.moveSpeed * cos(this.radians);
          double newY = this.position.y + this.player.moveSpeed * sin(this.radians);
          DFShape shape = getCollisionShape();
          if (shape is DFRect) {
            DFRect rectNew = DFRect(newX - shape.width / 2, newY - shape.height / 2, shape.width, shape.height);
            isCollided = GameManager.mapSprite!.tiledSprite!.isCollided(rectNew);
          } else if (shape is DFCircle) {
            DFCircle circleNew = DFCircle(DFPosition(newX, newY), shape.radius);
            isCollided = GameManager.mapSprite!.tiledSprite!.isCollided(circleNew);
          }

          if (isCollided == 2) {
            print("isCollided isCollided isCollided isCollided");
          }
        }
      }

      /// 被遮挡
      if (isCollided == 1) {
        this.clothesSprite!.color = Color(0x80FFFFFF);
      } else {
        this.clothesSprite!.color = Color(0xFFFFFFFF);
      }

      if (isCollided == 2) {
        this.autoMoveClock = DateTime.now().millisecondsSinceEpoch + 600;
        collidedChangeDirection();
      } else {
        this.position.x = this.position.x + this.player.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.player.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());
      }

      /// 向目标移动，移动到可释放攻击技能
      if (autoMove) {
        /// 检查目标
        if (!checkTargetSprite(this.player.vision)) {
          return;
        }

        if (DateTime.now().millisecondsSinceEpoch - this.autoMoveClock > 200) {
          this.autoMoveClock = DateTime.now().millisecondsSinceEpoch;
          this.moveToTarget(this.targetSprite!, vision: targetEffect!.vision,
              arrived: (String direction, double radians) {
            /// 停止移动
            this.autoMove = false;
            this.direction = direction;
            this.radians = radians;
            this.attack(targetEffect!);
          });
        }
      }
    }
    this.clothesSprite?.update(dt);
  }

  /// 渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 精灵矩形边界
    var paint = new Paint()..color = Color(0x60bb505d);
    DFShape collisionShape = getCollisionShape();
    if (collisionShape is DFCircle) {
      canvas.drawCircle(collisionShape.center.toOffset(), collisionShape.radius, paint);
    } else if (collisionShape is DFRect) {
      canvas.drawRect(collisionShape.toRect(), paint);
    }

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 活着
    if (!this.player.isDead) {
      /// 绘制子精灵
      this.children.forEach((sprite) {
        if (sprite.visible) {
          sprite.render(canvas);
        }
      });
    }

    ///恢复画布
    canvas.restore();
  }
}
