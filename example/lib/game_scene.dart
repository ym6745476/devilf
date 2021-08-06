import 'dart:async';
import 'dart:math';

import 'package:devilf/game/df_camera.dart';
import 'package:devilf/game/df_game_widget.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_image_sprite.dart';
import 'package:devilf/sprite/df_text_sprite.dart';
import 'package:devilf/util/df_util.dart';
import 'package:devilf/widget/df_button.dart';
import 'package:devilf/widget/df_joystick.dart';
import 'package:example/player/player.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'effect/effect.dart';
import 'game_manager.dart';
import 'map/map_sprite.dart';
import 'monster/monster.dart';
import 'monster/monster_sprite.dart';

class GameScene extends StatefulWidget {
  final int map;

  GameScene({this.map = 1});

  @override
  _GameSceneState createState() => _GameSceneState();
}

class _GameSceneState extends State<GameScene> with TickerProviderStateMixin {
  /// 主界面
  DFGameWidget? _gameWidget;

  /// 玩家精灵
  PlayerSprite? _playerSprite;

  /// 加载状态
  bool _loading = true;

  /// 创建主场景
  _GameSceneState();

  /// 初始化状态
  @override
  void initState() {
    super.initState();

    /// 强制横屏
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    /// 加载游戏
    _loadGame();
  }

  /// 开始进入游戏
  void _loadGame() async {
    try {
      await Future.delayed(Duration(seconds: 1), () async {
        /// 摄像机
        DFCamera camera = DFCamera(rect: DFRect(0, 0, GameManager.visibleWidth, GameManager.visibleHeight));

        /// 定义主界面
        this._gameWidget = DFGameWidget(camera: camera);

        /// 地图精灵
        MapSprite mapSprite = MapSprite("落霞岛", map: "assets/images/map/lxd.json", camera: camera);

        /// 保存到管理器里
        GameManager.mapSprite = mapSprite;

        /// 创建玩家精灵
        Player player = Player("玩家1");
        player.maxAt = 120;
        player.moveSpeed = 2;
        player.clothes = "assets/images/player/man_01.json";
        player.weapon = "assets/images/weapon/weapon_01.json";
        _playerSprite = PlayerSprite(player);
        _playerSprite?.position = DFPosition(800, 1200);

        /// 保存到管理器里
        GameManager.playerSprite = _playerSprite;

        /// 怪物精灵
        List<MonsterSprite> _monsterSprites = [];

        for (int i = 0; i < 5; i++) {
          Monster monster = Monster("蜘蛛" + (i + 1).toString());
          monster.moveSpeed = 0.4;
          monster.clothes = "assets/images/monster/spider.json";
          MonsterSprite monsterSprite = MonsterSprite(monster);
          int dirX = Random().nextBool() ? 1 : -1;
          int dirY = Random().nextBool() ? 1 : -1;
          monsterSprite.position = DFPosition(_playerSprite!.position.x + dirX * 100 * Random().nextDouble(),
              _playerSprite!.position.y + dirY * 100 * Random().nextDouble());
          _monsterSprites.add(monsterSprite);
        }

        /// 保存到管理器里
        GameManager.monsterSprites = _monsterSprites;

        /// Logo精灵
        DFImageSprite logoSprite = await DFImageSprite.load("assets/images/sprite.png");
        logoSprite.scale = 0.4;
        logoSprite.size = DFSize(40, 40);
        logoSprite.position =
            DFPosition(MediaQuery.of(context).size.width - 110, MediaQuery.of(context).padding.top + 30);
        logoSprite.fixed = true;

        /// 帧数精灵
        DFTextSprite fpsSprite = DFTextSprite("60 fps");
        fpsSprite.position =
            DFPosition(MediaQuery.of(context).size.width - 70, MediaQuery.of(context).padding.top + 30);
        fpsSprite.fixed = true;
        fpsSprite.setOnUpdate((dt) {
          fpsSprite.text = this._gameWidget!.fps.toStringAsFixed(0) + " fps";
        });

        /// 将地图精灵添加到主界面
        this._gameWidget!.addChild(mapSprite);

        /// 将玩家精灵添加到主界面
        this._gameWidget!.addChild(_playerSprite);

        /// 将怪物精灵添加到主界面
        this._gameWidget!.addChildren(_monsterSprites);

        /// 将Logo精灵添加到主界面
        this._gameWidget!.addChild(logoSprite);

        /// 将帧数精灵添加到主界面
        this._gameWidget!.addChild(fpsSprite);

        /// 设置摄像机跟随
        camera.lookAt(_playerSprite!);

        /// 保存到管理器里
        GameManager.gameWidget = this._gameWidget!;

        /// Loading完成
        setState(() {
          _loading = false;
        });

        print("游戏加载完成...");
      });
    } catch (e) {
      print('(GameScene _loadGame) Error: $e');
    }
  }

  /// Loading显示
  Widget _loadingWidget() {
    return Center(
      child:
          Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            "Loading...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// 获取屏幕尺寸
    GameManager.visibleWidth = MediaQuery.of(context).size.width;
    GameManager.visibleHeight = MediaQuery.of(context).size.height;
    print("获取屏幕尺寸:" + GameManager.visibleWidth.toString() + "," + GameManager.visibleHeight.toString());

    return LayoutBuilder(builder: (context, constraints) {
      return Stack(fit: StackFit.expand, children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black87,
            child: _loading ? _loadingWidget() : _gameWidget,
          ),
        ),
        Positioned(
          left: 20,
          top: MediaQuery.of(context).padding.top + 20,
          child: Text(
            "DevilF",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),

        /// 摇杆
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom,
          left: 0,
          child: DFJoyStick(
            /// backgroundImage: "assets/images/ui/joystick.png",
            /// handleImage: "assets/images/ui/joystick_btn.png",
            handleColor: Color(0x60FFFFFF),
            backgroundColor: Color(0x40FFFFFF),
            onChange: (double radians, String direction) {
              /// 获取8方向的弧度
              radians = DFUtil.getRadians(direction);
              _playerSprite?.startAutoMove = false;
              _playerSprite?.play(action: DFAnimation.RUN, direction: direction, radians: radians);
            },
            onCancel: (direction) {
              _playerSprite?.play(action: DFAnimation.IDLE, direction: direction);
            },
          ),
        ),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ui/skill_primary_bg.png"),
                ),
              ),
              alignment: Alignment.center,
              child: DFButton(
                /// text: "攻击",
                image: "assets/images/skill_icon/1002.png",
                pressedImage: "assets/images/ui/1002.png",
                size: Size(70, 70),
                onPressed: () {
                  Effect effect = Effect();
                  effect.name = "1002";
                  effect.type = EffectType.ATTACK;
                  effect.damageRange = 100;
                  effect.vision = 60;
                  effect.delayTime = 10;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAttack(effect);
                },
              ),
            )),

        Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ui/skill_secondary_bg.png"),
                ),
              ),
              alignment: Alignment.center,
              child: DFButton(
                /// text: "小火球",
                image: "assets/images/skill_icon/2001.png",
                pressedImage: "assets/images/ui/1002.png",
                size: Size(50, 50),
                onPressed: () {
                  Effect effect = Effect();
                  effect.name = "2001";
                  effect.type = EffectType.TRACK;
                  effect.damageRange = 50;
                  effect.vision = 300;
                  effect.delayTime = 300;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAttack(effect);
                },
              ),
            )),

        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 20,
          right: 120,
          child: DFButton(
            /// text: "拾取",
            image: "assets/images/ui/pick.png",
            pressedImage: "assets/images/ui/pick.png",
            size: Size(40, 40),
            onPressed: () {
              _playerSprite?.play(action: DFAnimation.DIG);
            },
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 160,
          right: 20,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ElevatedButton(
                child: new Text('自动1'),
                onPressed: () {
                  Effect effect = Effect();
                  effect.name = "1002";
                  effect.type = EffectType.ATTACK;
                  effect.damageRange = 100;
                  effect.vision = 60;
                  effect.delayTime = 10;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAttack(effect, repeatMoveToAttack: true);
                },
              ),
              ElevatedButton(
                child: new Text('自动2'),
                onPressed: () {
                  Effect effect = Effect();
                  effect.name = "2001";
                  effect.type = EffectType.TRACK;
                  effect.damageRange = 50;
                  effect.vision = 300;
                  effect.delayTime = 300;
                  effect.texture = "assets/images/effect/" + effect.name + ".json";
                  _playerSprite?.moveToAttack(effect, repeatMoveToAttack: true);
                },
              ),
            ],
          ),
        ),
      ]);
    });
  }
}
