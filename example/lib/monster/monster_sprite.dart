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
import 'package:devilf_engine/util/df_audio.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:example/effect/effect_info.dart';
import 'package:example/effect/effect_sprite.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import '../game_manager.dart';
import 'monster_info.dart';

/// 怪物精灵类
class MonsterSprite extends DFSprite {
  /// 怪物
  MonsterInfo monster;

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
  bool autoMove = false;

  /// 当前路径
  List<DFMapPosition> pathList = [];

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

  /// 动作音频
  DFAudio? actionAudio;

  /// 是否被选择
  bool isSelected = false;

  /// 初始化完成
  bool initOk = false;

  /// 创建怪物精灵
  MonsterSprite(
    this.monster, {
    DFSize size = const DFSize(48, 48),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    try {
      await Future.delayed(Duration(seconds: 1), () async {
        /// 选择光圈
        this.selectSprite = await DFAnimationSprite.load("assets/images/effect/select_monster.json",
            scale: 0.6, blendMode: BlendMode.colorDodge);
        this.selectSprite!.position = DFPosition(size.width / 2, size.height / 2);
        addChild(this.selectSprite!);

        /// 玩家精灵动画
        this.clothesSprite = await DFAnimationSprite.load(this.monster.clothes);
        this.clothesSprite!.position = DFPosition(size.width / 2, size.height / 2 - 5);

        /// 调用add产生层级关系进行坐标转换
        addChild(this.clothesSprite!);

        if (this.monster.weapon != "") {
          this.weaponSprite = await DFAnimationSprite.load(this.monster.weapon);

          /// 绑定动画同步
          this.weaponSprite!.position =
              DFPosition(this.clothesSprite!.size.width / 2, this.clothesSprite!.size.height / 2);
          this.clothesSprite?.bindChild(this.weaponSprite!);
        }

        /// 血条
        ui.Image image = await DFAssetsLoader.loadImage("assets/images/ui/hp_bar_monster.png");
        this.hpBarSprite = DFProgressSprite(image, gravity: DFGravity.top, textOffset: 5);
        this.hpBarSprite!.position = DFPosition(size.width / 2, 0);
        this.hpBarSprite!.scale = 0.6;
        addChild(this.hpBarSprite!);

        /// 名字
        this.nameSprite = DFTextSprite(this.monster.name, fontSize: 10);
        this.nameSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.nameSprite!.setOnUpdate((dt) {});
        addChild(this.nameSprite!);

        /// 动作音频
        this.actionAudio = DFAudio();

        /// 初始化完成
        this.initOk = true;

        ///自动播放第一个动画
        this.play(DFAction.IDLE, direction: DFDirection.DOWN, radians: 90 * pi / 180.0);

        /// 启动自动战斗
        this.startAutoFight(DFAction.ATTACK);
      });
    } catch (e) {
      print('(MonsterSprite _init) Error: $e');
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
      effect.vision = 30;
      effect.delayTime = 10;

      /// effect.texture = "assets/images/effect/" + effect.name + ".json";
    }
    this.autoFight = true;
    this.nextAction = action;
    this.effect = effect;
  }

  /// 停止自动
  void cancelAutoFight({String? action}) {
    this.autoMove = false;
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

        /// 停止正在播放的动作音频
        this.actionAudio!.stopPlay();
        if (this.action == DFAction.IDLE) {
          clothesSprite!.play(animation, stepTime: 300, loop: loop);
        } else if (this.action == DFAction.RUN) {
          clothesSprite!.play(animation, stepTime: 100, loop: loop);
        } else if (this.action == DFAction.ATTACK || this.action == DFAction.CASTING) {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {
            /// 动作完成回到IDLE
            clothesSprite!.play(DFAction.IDLE + this.direction, stepTime: 200, loop: false);
          });

          /// 播放音频
          DFAudio.play("monster/spider/attack_" + (Random().nextInt(3) + 1).toString() + ".mp3");
        } else if (this.action == DFAction.DEATH) {
          clothesSprite!.play(animation, stepTime: 200, loop: loop, onComplete: (DFAnimationSprite sprite) {
            print("死亡动作结束隐藏:" + this.monster.name);
            this.visible = false;
          });

          /// 播放音频
          DFAudio.play("monster/spider/death_" + (Random().nextInt(2) + 1).toString() + ".mp3");
        } else {
          clothesSprite!.play(animation, stepTime: 100, loop: loop, onComplete: (DFAnimationSprite sprite) {});
        }
      }
    }
  }

  /// 锁定目标
  void lockTargetSprite() {
    if (inVision()) {
      return;
    }
    this.findEnemy(
        found: (sprites) {
          this.targetSprite = sprites[0];
        },
        notFound: () {
          /// print("没有找到目标");
          this.targetSprite = null;
        },
        vision: monster.vision);
  }

  /// 检查目标
  bool inVision() {
    DFCircle visibleShape = DFCircle(DFPosition(this.position.x, this.position.y), this.monster.vision);
    if (this.targetSprite != null) {
      if (this.targetSprite is PlayerSprite) {
        PlayerSprite playerSprite = this.targetSprite as PlayerSprite;
        if (!playerSprite.player.isDeath) {
          DFShape playerCollision = playerSprite.getCollisionShape();
          if (playerCollision.overlaps(visibleShape)) {
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

    DFCircle visibleShape = DFCircle(DFPosition(this.position.x, this.position.y), vision);
    PlayerSprite playerSprite = GameManager.playerSprite!;
    if (!playerSprite.player.isDeath) {
      DFShape playerCollision = playerSprite.getCollisionShape();
      if (playerCollision.overlaps(visibleShape)) {
        foundEnemy.add(playerSprite);
      }
    }

    if (foundEnemy.length > 0) {
      found(foundEnemy);
    } else {
      notFound();
    }
  }

  /// 锁定目标->移动到目标->动作
  Future<void> moveToAction(String action, {EffectInfo? effect, bool autoFight = false}) async {
    /// 移动后的动作
    this.autoFight = autoFight;
    this.nextAction = action;
    this.effect = effect;

    /// 锁定目标
    lockTargetSprite();

    if (this.targetSprite != null) {
      /// 转换为瓦片坐标
      DFMapPosition startPosition = GameManager.mapSprite!.mapInfo.getMapPosition(position);
      DFMapPosition endPosition = GameManager.mapSprite!.mapInfo.getMapPosition(this.targetSprite!.position);
      DFMapNode startNode = DFMapNode(startPosition.x, startPosition.y);
      DFMapNode endNode = DFMapNode(endPosition.x, endPosition.y);

      /// print("起点瓦片位置：" + startNode.toString() + ",起点位置：" + this.position.toString());
      /// print("终点瓦片位置：" + endNode.toString() + ",目标位置：" + this.targetSprite!.position.toString());
      if (startNode.position == endNode.position || inEffectVision(this.targetSprite!)) {
        /// 在可攻击范围
        this.doNextAction();
      } else {
        /// 规划路径
        this.pathList = await aStar.start(GameManager.mapSprite!.mapInfo.blockMap!, startNode, endNode);

        if (this.pathList.length > 0) {
          DFMapPosition mapPosition = this.pathList.removeLast();
          this.movePathPosition = GameManager.mapSprite!.mapInfo.getPosition(mapPosition);
          this.updateDirection(this.movePathPosition!);

          /// print("寻路坐标：" + tilePosition.toString() + ",目标位置：" + this.movePathPosition.toString());

          /// 开始移动
          this.play(DFAction.RUN, direction: this.direction, radians: this.radians);

          /// 启动寻路
          this.autoMove = true;
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
      /// print("到达位置:" + targetPosition.toString());

      /// 到达位置
      if (arrived != null) {
        arrived();
      }
    } else {
      /// print("向位置移动:" + targetPosition.toString());

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
      if (targetSprite is PlayerSprite) {
        DFShape targetCollision = targetSprite.getCollisionShape();
        if (targetCollision.overlaps(visibleShape)) {
          /// print("已在攻击范围内");
          return true;
        }
      }
    }
    return false;
  }

  /// 下一个动作
  void doNextAction() {
    /// 更新方向
    this.updateDirection(this.targetSprite!.position);

    /// 角色动作
    this.play(this.nextAction, direction: direction, radians: radians);

    /// 显示技能特效
    if (this.effect != null && this.effect!.texture != null) {
      this._addEffect(this.effect!);
    } else {
      /// 没特效直接出伤害
      if (this.targetSprite != null) {
        if (this.targetSprite is PlayerSprite) {
          PlayerSprite playerSprite = this.targetSprite as PlayerSprite;
          playerSprite.receiveDamage(this, effect!);
        }
      }
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
    /// 随机伤害  0.0~1.0
    var random = new Random();
    if (ownerSprite is PlayerSprite) {
      double newMinAt = ownerSprite.player.minAt * random.nextDouble();
      double newMaxAt = ownerSprite.player.maxAt * random.nextDouble();
      double damageAt = newMinAt > newMaxAt ? newMinAt * effect.at : newMaxAt * effect.at - monster.df;

      double newMinMt = ownerSprite.player.minMt * random.nextDouble();
      double newMaxMt = ownerSprite.player.maxMt * random.nextDouble();
      double damageMt = newMinMt > newMaxMt ? newMinMt * effect.at : newMaxMt * effect.mt - monster.mf;

      double totalDamage = damageAt + damageMt;
      if (totalDamage <= 0) {
        totalDamage = 1;
      }

      /// 真实伤害数值 攻击力 - 防御力 * 0.35
      int hp = (totalDamage * 0.35 + 0.5).floor();

      /// print("接收到伤害:" + totalDamage.toStringAsFixed(2));
      /// print("伤害转化血量:" + hp.toString());

      this.monster.hp = this.monster.hp - hp;
      this.hpBarSprite!.progress = (this.monster.hp / this.monster.maxMp * 100).toInt();

      /// 播放音频
      DFAudio.play("monster/spider/hurt.mp3");

      /// 判断死亡
      if (this.monster.hp < 0) {
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
    this.monster.isDeath = true;
    this.targetSprite = null;
    if (ownerSprite is PlayerSprite) {
      ownerSprite.targetSprite = null;
    }
    this.unSelectThisSprite();
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
    this.monster.hp = this.monster.maxMp;
    this.hpBarSprite!.progress = 100;
    this.monster.isDeath = false;
    this.visible = true;

    /// print("重生：" + this.position.toString());
    this.play(DFAction.IDLE, direction: DFDirection.DOWN, radians: 90 * pi / 180.0);
    this.autoFight = true;
  }

  /// 选择
  void selectThisSprite() {
    this.selectSprite?.visible = true;
    this.isSelected = true;
    this.selectSprite?.play(DFAction.SURROUND + DFDirection.UP, stepTime: 100, loop: true);
  }

  /// 取消选择
  void unSelectThisSprite() {
    this.selectSprite?.visible = false;
    this.isSelected = false;
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
    if (initOk && this.clothesSprite!.frames[clothesSprite!.currentAnimation] != null) {
      List<DFImageSprite> sprites = this.clothesSprite!.frames[clothesSprite!.currentAnimation]!;
      return DFCircle(DFPosition(this.position.x, this.position.y), sprites[0].size.width / 4);
    }
    return super.getCollisionShape();
  }

  /// 更新
  @override
  void update(double dt) {
    if (!initOk) {
      return;
    }
    if (this.visible) {
      if (this.clothesSprite == null) {
        return;
      }
      if (this.clothesSprite!.currentAnimation.contains(DFAction.RUN)) {
        /// 判断碰撞
        int isCollided = 0;
        if (DateTime.now().millisecondsSinceEpoch - this.collideClock > 2) {
          this.collideClock = DateTime.now().millisecondsSinceEpoch;
          if (GameManager.mapSprite != null && GameManager.mapSprite!.initOk) {
            double newX = this.position.x + this.monster.moveSpeed * cos(this.radians);
            double newY = this.position.y + this.monster.moveSpeed * sin(this.radians);
            DFCircle circleShape = getPathCollisionShape(DFPosition(newX, newY));
            isCollided = GameManager.mapSprite!.tileMapSprite!.isCollided(circleShape);
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
          /// print("isCollided isCollided isCollided isCollided");
          /// 重新确定目标规划路径
          this.movePathPosition = null;
          this.collidedChangeDirection();
        } else {
          this.position.x = this.position.x + this.monster.moveSpeed * cos(this.radians);
          this.position.y = this.position.y + this.monster.moveSpeed * sin(this.radians);
        }

        /// 自动寻路
        if (this.autoMove && this.movePathPosition != null) {
          this.run(this.movePathPosition!, arrived: () {
            /// 检查是否在攻击范围
            bool arrived = this.inEffectVision(this.targetSprite!);
            if (arrived) {
              /// 清除路径
              this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
              this.movePathPosition = null;
              this.doNextAction();
            } else {
              if (this.pathList.length > 0) {
                DFMapPosition mapPosition = this.pathList.removeLast();
                this.movePathPosition = GameManager.mapSprite!.mapInfo.getPosition(mapPosition);
                this.updateDirection(this.movePathPosition!);

                /// print("寻路,目标坐标：" + tilePosition.toString() + ",目标位置：" + this.movePathPosition.toString());
              } else {
                /// print("寻路,结束.....................");
                this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
                this.movePathPosition = null;
              }
            }
          });
        }
      }

      /// 更新衣服
      this.clothesSprite?.update(dt);

      /// 选择光圈
      if (this.isSelected) {
        this.selectSprite?.update(dt);
      }

      /// 活着的
      if (!this.monster.isDeath) {
        /// 检查目标
        if (!inVision()) {
          this.movePathPosition = null;
          this.play(DFAction.IDLE, direction: this.direction, radians: this.radians);
        }

        /// 自动战斗
        if (this.autoFight && this.movePathPosition == null) {
          if (DateTime.now().millisecondsSinceEpoch - this.autoFightClock > 1200) {
            /// print("自动战斗 检查目标");
            this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
            this.moveToAction(this.nextAction, effect: effect, autoFight: true);
          }
        }
      }
    } else {
      /// 重生
      if (this.monster.isDeath) {
        if (DateTime.now().millisecondsSinceEpoch - this.rebornClock > this.monster.rebornTime) {
          this.reborn();
        }
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
      var paint = new Paint()..color = Color(0x90bb505d);
      DFShape collisionShape = getPathCollisionShape(position);
      if (collisionShape is DFCircle) {
        canvas.drawCircle(collisionShape.center.toOffset(), collisionShape.radius, paint);
      } else if (collisionShape is DFRect) {
        canvas.drawRect(collisionShape.toRect(), paint);
      }

      /// 绘制路径
      var paintPath = new Paint()..color = Color(0x601d953f);
      this.pathList.forEach((element) {
        DFRect rect = GameManager.mapSprite!.mapInfo.getPathRect(element);
        canvas.drawRect(rect.toRect(), paintPath);
      });
    }

    /*var paint = new Paint()..color = Color(0x60bb505d);
    DFRect rect = DFRect(this.position.x - size.width/2,this.position.y - size.height/2,size.width,size.height);
    canvas.drawRect(rect.toRect(), paint);*/

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 绘制子精灵
    if (this.visible) {
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
