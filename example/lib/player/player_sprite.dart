import 'dart:math';
import 'package:devilf/core/df_circle.dart';
import 'package:devilf/core/df_position.dart';
import 'package:devilf/core/df_rect.dart';
import 'package:devilf/core/df_shape.dart';
import 'package:devilf/core/df_size.dart';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/sprite/df_animation_sprite.dart';
import 'package:devilf/sprite/df_image_sprite.dart';
import 'package:devilf/sprite/df_progress_sprite.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_text_sprite.dart';
import 'package:devilf/tiled/df_tiled_map.dart';
import 'package:devilf/util/df_astar.dart';
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

  /// 目标坐标
  DFPosition? targetPosition;

  /// 开始移动
  bool movePathStart = false;

  /// 自动战斗时钟
  int autoFightClock = 0;

  /// 判断碰撞时钟
  int collideClock = 0;

  /// 自动战斗
  bool autoFight = false;

  /// 当前目标特效
  Effect? targetEffect;

  /// 当前移动方向弧度
  double radians = 0;

  /// 当前动作
  String action = DFAnimation.NONE;

  /// 当前方向
  String direction = DFAnimation.NONE;

  /// 路径规划
  DFAStar aStar = DFAStar();

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
            clothesSprite!.play(DFAnimation.IDLE + this.direction, stepTime: 200, loop: false);
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

  /// 在范围内锁定目标
  void lockTargetSprite() {
    double vision = this.player.vision;
    DFCircle visibleShape = DFCircle(DFPosition(this.position.x,this.position.y),vision);

    /// 当前目标是否还在视野内
    if (this.targetSprite != null) {
      if (this.targetSprite is MonsterSprite) {
        MonsterSprite monsterSprite = this.targetSprite as MonsterSprite;
        if (!monsterSprite.monster.isDead) {
          DFShape monsterCollision = monsterSprite.getCollisionShape();
          if (monsterCollision.overlaps(visibleShape)) {
            return;
          }
        }

        /// 放弃目标
        monsterSprite.unSelectThisSprite();

        /// 放弃这个目标
        this.targetSprite = null;
      }
    }

    /// 重新寻找目标
    if (this.targetSprite == null) {
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
          },
          vision: player.vision);
    }else{
      print("目标已存在");
    }
  }

  /// 在可视范围内找敌人
  void findEnemy({
    required Function(List<DFSprite>) found,
    required Function() notFound,
    required double vision,
  }) {
    /// 目标列表
    List<DFSprite> foundMonster = [];

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

    if (foundMonster.length > 0) {
      found(foundMonster);
    } else {
      notFound();
    }
  }

  /// 锁定目标->移动到目标->攻击
  void moveToAttack(Effect effect, {bool autoFight = false}) {

    /// 移动的后一个动作
    this.targetEffect = effect;
    this.autoFight = autoFight;

    /// 锁定目标
    lockTargetSprite();

    if (this.targetSprite != null) {
      DFTiledMap tiledMap = GameManager.mapSprite!.tiledSprite!.tiledMap!;
      double realTiledWidth = tiledMap.tileWidth!* GameManager.mapSprite!.scale;
      double realTiledHeight = tiledMap.tileHeight!* GameManager.mapSprite!.scale;
      int startX = (position.x / realTiledWidth).floor().toInt();
      int startY = (position.y / realTiledHeight).floor().toInt();
      int endX = (this.targetSprite!.position.x / realTiledWidth).floor().toInt();
      int endY = (this.targetSprite!.position.y / realTiledHeight).floor().toInt();
      DFNode startNode = DFNode(startX, startY);
      DFNode endNode = DFNode(endX, endY);
      print("起点坐标：" + startNode.coord.toString() + ",起点位置：" + this.position.toString());
      print("终点坐标：" + endNode.coord.toString() + ",目标位置：" + this.targetSprite!.position.toString());
      if (startNode.coord == endNode.coord || isArrived(this.targetSprite!, this.targetEffect!.vision)) {
        /// 在可攻击范围
        this.attack(effect);
      } else {
        /// 规划路径
        planPath(startNode, endNode);

        if (aStar.pathList.length > 0) {
          DFCoord coord = aStar.pathList.removeLast();
          this.targetPosition = getPosition(coord.x,coord.y);
          this.updateDirection(this.targetPosition!);
          print("寻路坐标：" + coord.toString() + ",目标位置：" + this.targetPosition.toString());

          /// 开始移动
          this.play(action: DFAnimation.RUN, direction: this.direction, radians: this.radians);

          /// 启动寻路
          this.movePathStart = true;

        } else {
          /// 没有路径可到达
          this.cancelAutoFight(idle:true);
        }
      }
    } else {
      if (!this.autoFight) {
        this.attack(effect);
      }
    }
  }

  /// 向目标移动
  void run(DFPosition targetPosition,{Function()? arrived}) {

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
      this.play(action: DFAnimation.RUN, direction: this.direction, radians: this.radians);
    }
  }

  /// 更新方向
  void updateDirection(DFPosition targetPosition){
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

    Offset offset = targetPosition.toOffset() - this.position.toOffset();
    /// print("targetPosition:" + targetPosition.toString());
    /// print("playerPosition:" + this.position.toString());

    this.radians = offset.direction;

    /// 确定方向
    if (translateX > 0 && translateY > 0) {
      this.direction = DFAnimation.DOWN_RIGHT;
      ///this.radians = 45 * pi / 180.0;
    } else if (translateX < 0 && translateY < 0) {
      this.direction = DFAnimation.UP_LEFT;
      ///this.radians = 225 * pi / 180.0;
    } else if (translateX > 0 && translateY < 0) {
      this.direction = DFAnimation.UP_RIGHT;
      ///this.radians = 315 * pi / 180.0;
    } else if (translateX < 0 && translateY > 0) {
      this.direction = DFAnimation.DOWN_LEFT;
      ///this.radians = 135 * pi / 180.0;
    } else {
      if (translateX > 0) {
        this.direction = DFAnimation.RIGHT;
        ///this.radians = 0;
      } else if (translateX < 0) {
        this.direction = DFAnimation.LEFT;
        ///this.radians = 180 * pi / 180.0;
      }
      if (translateY > 0) {
        this.direction = DFAnimation.DOWN;
        ///this.radians = 90 * pi / 180.0;
      } else if (translateY < 0) {
        this.direction = DFAnimation.UP;
        ///this.radians = 270 * pi / 180.0;
      }
    }
  }

  /// 检查是否提前到达攻击范围
  bool isArrived(DFSprite targetSprite,double vision){
    if (vision > 0) {
        DFCircle visibleShape = DFCircle(DFPosition(this.position.x, this.position.y), vision);
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
  void nextAction(){

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
    this.attack(this.targetEffect!);
  }

  /// 规划路径
  Future<void> planPath(DFNode startNode, DFNode endNode) async {
    DFTiledMap tiledMap = GameManager.mapSprite!.tiledSprite!.tiledMap!;
    List<int> blockData = GameManager.mapSprite!.tiledSprite!.blockLayer!.data!;

    /// 二维数组的地图
    int rowCount = tiledMap.height!;
    int columnCount = tiledMap.width!;

    List<List<int>>? maps = List.filled(rowCount, List.filled(columnCount, 0));
    print(maps.length.toString() + "," + maps[0].length.toString());
    for (int i = 0; i < blockData.length; i++) {
      int row = (i / columnCount).floor().toInt();

      /// 上取整
      int column = (i % columnCount).toInt();

      /// print("row:" + row.toString() + ",column:" + column.toString());
      if (blockData[i] != 0) {
        maps[row][column] = 1;
      } else {
        maps[row][column] = 0;
      }
    }
    print("起点:" + startNode.toString() + "->终点：" + endNode.toString());
    DFMap map = DFMap(maps, maps[0].length, maps.length, startNode, endNode);
    aStar.start(map);
    /// 删掉起点
    aStar.pathList.removeLast();
    for (DFCoord point in aStar.pathList) {
      print(point.toString());
    }
  }

  /// 释放技能攻击
  void attack(Effect effect) {

    /// 更新方向
    this.updateDirection(this.targetSprite!.position);

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

  /// 停止自动
  void cancelAutoFight({bool idle = false}) {
    this.movePathStart = false;
    this.autoFight = false;
    if (idle) {
      this.play(action: DFAnimation.IDLE, direction: direction);
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

  /// 获取坐标
  DFPosition getPosition(int tiledX,int tiledY){
    DFTiledMap tiledMap = GameManager.mapSprite!.tiledSprite!.tiledMap!;
    double realTiledWidth = tiledMap.tileWidth!* GameManager.mapSprite!.scale;
    double realTiledHeight = tiledMap.tileHeight!* GameManager.mapSprite!.scale;
    return DFPosition(tiledX * realTiledWidth - realTiledWidth/2, tiledY * realTiledHeight - realTiledHeight/2);
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

      /// 被碰撞
      if (isCollided == 2) {
        //this.autoMoveClock = DateTime.now().millisecondsSinceEpoch + 600;
        //collidedChangeDirection();
      } else {
        this.position.x = this.position.x + this.player.moveSpeed * cos(this.radians);
        this.position.y = this.position.y + this.player.moveSpeed * sin(this.radians);
        //print("move:" + this.position.toString());
      }


      /// 自动寻路
      if (this.movePathStart && this.targetPosition != null) {

          this.run(this.targetPosition!,arrived: () {

            /// 检查是否在攻击范围
            bool arrived = isArrived(this.targetSprite!,this.targetEffect!.vision);
            if(arrived){
              /// 清除路径
              this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
              this.targetPosition = null;
              this.nextAction();
            }else{
              if (aStar.pathList.length > 0) {
                DFCoord coord = aStar.pathList.removeLast();
                this.targetPosition = getPosition(coord.x,coord.y);
                this.updateDirection(this.targetPosition!);
                print("寻路,目标坐标：" + coord.toString() + ",目标位置：" + this.targetPosition.toString());
              }else{
                print("寻路,结束.....................");
                this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
                this.targetPosition = null;
                this.nextAction();
              }
            }

          });
      }
    }

    /// 锁定目标
    if(this.autoFight && this.targetPosition == null){
      if (DateTime.now().millisecondsSinceEpoch - this.autoFightClock > 1200) {
        print("自动战斗 检查目标");
        this.autoFightClock = DateTime.now().millisecondsSinceEpoch;
        this.moveToAttack(this.targetEffect!, autoFight: true);
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
