import 'dart:math';
import 'package:devilf_engine/core/df_circle.dart';
import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_rect.dart';
import 'package:devilf_engine/core/df_shape.dart';
import 'package:devilf_engine/core/df_size.dart';
import 'package:devilf_engine/devilf_engine.dart';
import 'package:devilf_engine/game/df_animation.dart';
import 'package:devilf_engine/game/df_assets_loader.dart';
import 'package:devilf_engine/sprite/df_animation_sprite.dart';
import 'package:devilf_engine/sprite/df_image_sprite.dart';
import 'package:devilf_engine/sprite/df_progress_sprite.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:devilf_engine/sprite/df_text_sprite.dart';
import 'package:devilf_engine/util/df_astar.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:example/effect/effect_info.dart';
import 'package:example/effect/effect_sprite.dart';
import 'package:example/monster/monster_sprite.dart';
import 'package:example/player/player_info.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import '../game_manager.dart';

/// 玩家精灵类
class PlayerSprite extends DFSprite {
  /// 玩家
  PlayerInfo player;

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

  /// 当前动作
  String action = DFAction.NONE;

  /// 下一个动作
  String nextAction = DFAction.NONE;

  /// 当前方向
  String direction = DFDirection.NONE;

  /// 当前移动方向弧度
  double radians = 0;

  /// 动作特效
  EffectInfo? effect;

  /// 碰撞检测时钟
  int collideClock = 0;

  /// 自动寻路
  bool movePathStart = false;

  /// 寻路坐标
  DFPosition? movePathPosition;

  /// 自动战斗
  bool autoFight = false;

  /// 自动战斗时钟
  int autoFightClock = 0;

  /// 重生时钟
  int rebornClock = 0;

  /// 路径规划
  DFAStar aStar = DFAStar();

  /// 初始化完成
  bool initOk = false;

  /// 创建玩家精灵
  PlayerSprite(
    this.player, {
    DFSize size = const DFSize(48, 48),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    try {
      await Future.delayed(Duration.zero, () async {
        /// 选择光圈
        this.selectSprite = await DFAnimationSprite.load("assets/images/effect/select_player.json",
            scale: 0.6, blendMode: BlendMode.colorDodge);
        this.selectSprite!.position = DFPosition(size.width / 2, size.height / 2);
        addChild(this.selectSprite!);
        this.selectSprite?.play(DFAction.SURROUND + DFDirection.UP, stepTime: 100, loop: true);

        /// 玩家精灵动画
        this.clothesSprite = await DFAnimationSprite.load(this.player.clothes);
        this.clothesSprite!.position = DFPosition(size.width / 2, size.height / 2 - 10);

        /// 调用add产生层级关系进行坐标转换
        addChild(this.clothesSprite!);

        if (this.player.weapon != "") {
          this.weaponSprite = await DFAnimationSprite.load(this.player.weapon);

          /// 绑定动画同步
          this.weaponSprite!.position =
              DFPosition(this.clothesSprite!.size.width / 2, this.clothesSprite!.size.height / 2);
          this.clothesSprite?.bindChild(this.weaponSprite!);
        }

        /// 自动播放第一个动画
        this.play(DFAction.IDLE, direction: DFDirection.DOWN, radians: 90 * pi / 180.0);

        /// 血条
        ui.Image image = await DFAssetsLoader.loadImage("assets/images/ui/hp_bar_player.png");
        this.hpBarSprite = DFProgressSprite(image, gravity: DFGravity.top, textOffset: 5);
        this.hpBarSprite!.position = DFPosition(size.width / 2, -30);
        this.hpBarSprite!.scale = 0.6;
        addChild(this.hpBarSprite!);

        /// 名字
        this.nameSprite = DFTextSprite(this.player.name, fontSize: 10, background: Color(0x20000000));
        this.nameSprite!.position = DFPosition(size.width / 2, -60);
        this.nameSprite!.setOnUpdate((dt) {});
        addChild(this.nameSprite!);

        /// 初始化完成
        this.initOk = true;
      });
    } catch (e) {
      print('(PlayerSprite _init) Error: $e');
    }
  }

  /// 启动自动战斗
  void startAutoFight(String action, {EffectInfo? effect}) {
    /// 技能
    if (effect == null) {
      effect = EffectInfo();
      effect.name = "1001";
      effect.type = EffectType.ATTACK;
      effect.damageRange = 100;
      effect.vision = 40;
      effect.delayTime = 10;

      /// effect.texture = "assets/images/effect/" + effect.name + ".json";
    }
    this.autoFight = true;
    this.nextAction = action;
    this.effect = effect;
  }

  /// 停止自动
  void cancelAutoFight({String? action}) {
    this.movePathStart = false;
    this.movePathPosition = null;
    this.autoFight = false;
    if (action != null) {
      this.play(action, direction: direction);
    }
  }

  /// 播放动画
  void play(String action, {direction = DFDirection.NONE, radians = 3.15}) {
    this.action = action;

    /// 不传direction,则使用上一次的方向
    if (direction != DFDirection.NONE) {
      this.direction = direction;
    }

    /// 不传弧度，则使用上一次的弧度
    if (radians != 3.15) {
      this.radians = radians;
    }

    /// 死亡只有一个方向的图
    if (this.action == DFAction.DEATH) {
      if (this.direction.contains(DFDirection.RIGHT)) {
        this.direction = DFDirection.DOWN_RIGHT;
      } else {
        this.direction = DFDirection.DOWN_LEFT;
      }
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
        if (this.action == DFAction.ATTACK || this.action == DFAction.CASTING || this.action == DFAction.DEATH) {
          loop = false;
        }

        if (this.action == DFAction.IDLE) {
          clothesSprite!.play(animation, stepTime: 200, loop: loop);
        } else if (this.action == DFAction.RUN) {
          clothesSprite!.play(animation, stepTime: 50, loop: loop);
        } else if (this.action == DFAction.ATTACK || this.action == DFAction.CASTING) {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            print("Play Attack Finished");

            /// 动作完成回到IDLE
            clothesSprite!.play(DFAction.IDLE + this.direction, stepTime: 200, loop: false);
          });
        } else if (this.action == DFAction.DEATH) {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            print("死亡动作结束隐藏:" + this.player.name);
            this.visible = false;
          });
        } else {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            if (sprite.currentAnimation.contains(DFAction.DIG)) {
              /// 动作完成回到IDLE
              clothesSprite!.play(DFAction.IDLE + this.direction, stepTime: 300, loop: true);
            }
          });
        }
      }
    }
  }

  /// 在范围内锁定目标
  void lockTargetSprite() {
    if (inVision()) {
      return;
    } else {
      if (this.targetSprite != null) {
        if (this.targetSprite is MonsterSprite) {
          MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;

          /// 放弃目标
          monsterSprite.unSelectThisSprite();
        }
      }
    }

    /// 重新寻找目标
    /// 玩家视野范围内有多个精灵，选取距离最近的作为目标
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
          this.targetSprite = null;
        },
        vision: player.vision);
  }

  /// 检查目标
  bool inVision() {
    DFCircle visibleShape = DFCircle(DFPosition(this.position.x, this.position.y), this.player.vision);
    if (this.targetSprite != null) {
      if (this.targetSprite is MonsterSprite) {
        MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
        if (!monsterSprite.monster.isDead) {
          DFShape monsterCollision = monsterSprite.getCollisionShape();
          if (monsterCollision.overlaps(visibleShape)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  /// 在可视范围内找敌人
  void findEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    /// 目标列表
    List<DFSprite> foundEnemy = [];

    /// 获取距离最近的
    double distance = vision * vision;
    MonsterSprite? preSprite;
    if (GameManager.monsterSprites != null) {
      GameManager.monsterSprites!.forEach((monsterSprite) {
        if (!monsterSprite.monster.isDead) {
          /// 距离
          Offset offset = monsterSprite.position.toOffset() - this.position.toOffset();
          if (offset.distanceSquared <= distance) {
            preSprite = monsterSprite;
            distance = offset.distanceSquared;
          }
        }
      });

      if (preSprite != null) {
        foundEnemy.add(preSprite!);
      }
    }

    if (foundEnemy.length > 0) {
      found(foundEnemy);
    } else {
      notFound();
    }
  }

  /// 锁定目标->移动到目标->动作
  void moveToAction(String action, {EffectInfo? effect, bool autoFight = false}) {
    /// 移动后的动作
    this.autoFight = autoFight;
    this.nextAction = action;
    this.effect = effect;

    /// 锁定目标
    lockTargetSprite();

    if (this.targetSprite != null) {
      /// 转换为瓦片坐标
      DFPosition startPosition = GameManager.mapSprite!.mapInfo.getTilePosition(position);
      DFPosition endPosition = GameManager.mapSprite!.mapInfo.getTilePosition(this.targetSprite!.position);

      DFNode startNode = DFNode(startPosition.x.toInt(), startPosition.y.toInt());
      DFNode endNode = DFNode(endPosition.x.toInt(), startPosition.y.toInt());
      print("起点瓦片位置：" + startNode.toString() + ",起点位置：" + this.position.toString());
      print("终点瓦片位置：" + endNode.toString() + ",目标位置：" + this.targetSprite!.position.toString());
      if (startNode.coord == endNode.coord || inEffectVision(this.targetSprite!)) {
        /// 在可攻击范围
        this.doNextAction();
      } else {
        /// 规划路径
        aStar.start(GameManager.mapSprite!.mapInfo.blockMap!, startNode, endNode);

        if (aStar.pathList.length > 0) {
          DFPosition tilePosition = aStar.pathList.removeLast();
          this.movePathPosition = GameManager.mapSprite!.mapInfo.getMapPosition(tilePosition);
          this.updateDirection(this.movePathPosition!);
          print("寻路坐标：" + tilePosition.toString() + ",目标位置：" + this.movePathPosition.toString());

          /// 开始移动
          this.play(DFAction.RUN, direction: this.direction, radians: this.radians);

          /// 启动寻路
          this.movePathStart = true;
        }
      }
    } else {
      if (!this.autoFight) {
        this.doNextAction();
      }
    }
  }

  /// 向目标移动
  void run(DFPosition targetPosition, {Function()? arrived}) {
    /// 距离
    double translateX = targetPosition.x - this.position.x;
    double translateY = targetPosition.y - this.position.y;

    /// 范围防抖
    if ((translateX < 0 && translateX > -5) || (translateX > 0 && translateX < 5)) {
      translateX = 0;
    }

    if ((translateY < 0 && translateY > -5) || (translateY > 0 && translateY < 5)) {
      translateY = 0;
    }

    if (translateX == 0 && translateY == 0) {
      print("到达位置:" + targetPosition.toString());

      /// 到达位置
      if (arrived != null) {
        arrived();
      }
    } else {
      print("向位置移动:" + targetPosition.toString());

      /// 开始移动
      this.play(DFAction.RUN, direction: this.direction, radians: this.radians);
    }
  }

  /// 更新方向
  void updateDirection(DFPosition targetPosition) {
    /// 偏移量
    Offset offset = targetPosition.toOffset() - this.position.toOffset();

    /// 真实弧度
    this.radians = offset.direction;

    /// 获得8方向
    this.direction = DFUtil.getDirection(this.radians);
  }

  /// 检查是否提前到达攻击范围
  bool inEffectVision(DFSprite targetSprite) {
    if (this.effect != null && this.effect!.vision > 0) {
      DFCircle visibleShape = DFCircle(DFPosition(this.position.x, this.position.y), this.effect!.vision);
      if (targetSprite is MonsterSprite) {
        DFShape targetCollision = targetSprite.getCollisionShape();
        if (targetCollision.overlaps(visibleShape)) {
          print("已在攻击范围内");
          return true;
        }
      }
    }
    return false;
  }

  /// 下一个动作
  void doNextAction() {
    /// 保持距离
    /*if (translateX.abs() < keepDistance / 2 && translateY.abs() < keepDistance / 2) {
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
    }*/

    /// 更新方向
    this.updateDirection(this.targetSprite!.position);

    /// 角色动作
    this.play(this.nextAction, direction: direction, radians: radians);

    /// 显示技能特效
    if (this.effect != null) {
      this._addEffect(this.effect!);
    }
  }

  /// 添加特效
  Future<void> _addEffect(EffectInfo effect) async {
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

  /// 接收伤害
  void receiveDamage(DFSprite ownerSprite, EffectInfo effect) {
    if(!this.initOk){
      return;
    }
    /// 随机伤害  0.0~1.0
    var random = new Random();
    if (ownerSprite is MonsterSprite) {
      double newMinAt = ownerSprite.monster.minAt * random.nextDouble();
      double newMaxAt = ownerSprite.monster.maxAt * random.nextDouble();
      double damageAt = newMinAt > newMaxAt ? newMinAt * effect.at : newMaxAt * effect.at - player.df;

      double newMinMt = ownerSprite.monster.minMt * random.nextDouble();
      double newMaxMt = ownerSprite.monster.maxMt * random.nextDouble();
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
        this.dead(ownerSprite);
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

  /// 死亡
  void dead(DFSprite ownerSprite) {
    this.cancelAutoFight();
    this.player.isDead = true;
    if (this.targetSprite is MonsterSprite) {
      MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
      monsterSprite.unSelectThisSprite();
    }
    if (ownerSprite is MonsterSprite) {
      ownerSprite.targetSprite = null;
    }
    this.targetSprite = null;
    this.play(DFAction.DEATH, direction: direction, radians: radians);
    this.rebornClock = DateTime.now().millisecondsSinceEpoch;
  }

  /// 重生
  void reborn() {
    /// 随机位置  0.0~1.0
    int dirX = Random().nextBool() ? 1 : -1;
    int dirY = Random().nextBool() ? 1 : -1;
    this.position.x = this.position.x + dirX * 200 * Random().nextDouble();
    this.position.y = this.position.y + dirY * 200 * Random().nextDouble();
    this.player.hp = this.player.maxMp;
    this.hpBarSprite!.progress = 100;
    this.player.isDead = false;
    this.visible = true;
    print("重生：" + this.position.toString());
    this.play(DFAction.IDLE, direction: DFDirection.DOWN, radians: 90 * pi / 180.0);
    this.autoFight = true;
  }

  /// 碰撞后转换方向,避免卡住
  void collidedChangeDirection() {
    if (direction == DFDirection.UP) {
      direction = DFDirection.UP_RIGHT;
      radians = 315 * pi / 180.0;
    } else if (direction == DFDirection.DOWN) {
      direction = DFDirection.DOWN_LEFT;
      radians = 135 * pi / 180.0;
    } else if (direction == DFDirection.LEFT) {
      direction = DFDirection.UP_LEFT;
      radians = 225 * pi / 180.0;
    } else if (direction == DFDirection.RIGHT) {
      direction = DFDirection.DOWN_RIGHT;
      radians = 45 * pi / 180.0;
    } else if (direction == DFDirection.DOWN_RIGHT) {
      direction = DFDirection.DOWN;
      radians = 90 * pi / 180.0;
    } else if (direction == DFDirection.UP_LEFT) {
      direction = DFDirection.UP;
      radians = 270 * pi / 180.0;
    } else if (direction == DFDirection.UP_RIGHT) {
      direction = DFDirection.RIGHT;
      radians = 0;
    } else if (direction == DFDirection.DOWN_LEFT) {
      direction = DFDirection.LEFT;
      radians = 180 * pi / 180.0;
    }
    this.play(DFAction.RUN, direction: direction, radians: radians);
  }

  /// 寻路的碰撞形状
  DFCircle getPathCollisionShape(DFPosition position) {
    double tileWidth = GameManager.mapSprite!.mapInfo.tileWidth;
    double tileHeight = GameManager.mapSprite!.mapInfo.tileHeight;
    return DFCircle(position, (tileWidth > tileHeight ? tileHeight : tileWidth) / 2);
  }

  /// 碰撞形状
  @override
  DFShape getCollisionShape() {
    if (initOk) {
      List<DFImageSprite> sprites = clothesSprite!.frames[clothesSprite!.currentAnimation]!;
      return DFCircle(DFPosition(this.position.x, this.position.y), sprites[0].size.width / 4);
    }
    return super.getCollisionShape();
  }

  /// 更新
  @override
  void update(double dt) {
    if (this.visible) {
      if (clothesSprite == null) {
        return;
      }
      if (clothesSprite!.currentAnimation.contains(DFAction.RUN)) {
        /// 判断碰撞
        int isCollided = 0;
        if(DateTime.now().millisecondsSinceEpoch - this.collideClock > 2){
          this.collideClock = DateTime.now().millisecondsSinceEpoch;
          if (GameManager.mapSprite != null && GameManager.mapSprite!.initOk) {
            double newX = this.position.x + this.player.moveSpeed * cos(this.radians);
            double newY = this.position.y + this.player.moveSpeed * sin(this.radians);
            DFCircle circleShape = getPathCollisionShape(DFPosition(newX, newY));
            isCollided = GameManager.mapSprite!.tileMapSprite!.isCollided(circleShape);
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

        /// 被碰撞
        if (isCollided == 2) {
          /// 重新确定目标规划路径
          this.movePathPosition = null;
          this.collidedChangeDirection();
        } else {
          this.position.x = this.position.x + this.player.moveSpeed * cos(this.radians);
          this.position.y = this.position.y + this.player.moveSpeed * sin(this.radians);
          //print("move:" + this.position.toString());
        }

        /// 自动寻路
        if (this.movePathStart && this.movePathPosition != null) {
          this.run(this.movePathPosition!, arrived: () {
            /// 检查是否在攻击范围
            bool arrived = this.inEffectVision(this.targetSprite!);
            if (arrived) {
              /// 清除路径
              this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
              this.movePathPosition = null;
              this.doNextAction();
            } else {
              if (aStar.pathList.length > 0) {
                DFPosition tilePosition = aStar.pathList.removeLast();
                this.movePathPosition = GameManager.mapSprite!.mapInfo.getMapPosition(tilePosition);
                this.updateDirection(this.movePathPosition!);
                print("寻路,目标坐标：" + tilePosition.toString() + ",目标位置：" + this.movePathPosition.toString());
              } else {
                print("寻路,结束.....................");
                this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
                this.movePathPosition = null;
              }
            }
          });
        }
      }

      /// 更新衣服
      this.clothesSprite?.update(dt);

      /// 自动战斗
      if (this.autoFight && this.movePathPosition == null) {
        if (DateTime.now().millisecondsSinceEpoch - this.autoFightClock > 1200) {
          print("自动战斗 检查目标");
          this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
          this.moveToAction(this.nextAction, effect: effect, autoFight: true);
        }
      }
    } else {
      /// 重生
      if (DateTime.now().millisecondsSinceEpoch - this.rebornClock > this.player.rebornTime) {
        this.rebornClock = DateTime.now().millisecondsSinceEpoch;
        this.reborn();
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
      var paint = new Paint()..color = Color(0x60bb505d);
      DFShape collisionShape = getPathCollisionShape(this.position);
      if (collisionShape is DFCircle) {
        canvas.drawCircle(collisionShape.center.toOffset(), collisionShape.radius, paint);
      } else if (collisionShape is DFRect) {
        canvas.drawRect(collisionShape.toRect(), paint);
      }

      /// 绘制路径
      var paintPath = new Paint()..color = Color(0x601d953f);
      aStar.pathList.forEach((element) {
        DFRect rect = GameManager.mapSprite!.mapInfo.getTileRect(element);
        canvas.drawRect(rect.toRect(), paintPath);
      });
    }

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 活着
    if (this.visible) {
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
