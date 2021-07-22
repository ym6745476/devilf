import 'package:devilf/game/df_game_widget.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/sprite/df_sprite_animation.dart';
import 'package:devilf/sprite/df_sprite_image.dart';
import 'package:devilf/sprite/df_text_sprite.dart';
import 'package:devilf/widget/df_joystick.dart';
import 'package:example/player/player.dart';
import 'package:example/player/player_sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'map/map_sprite.dart';
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

  /// 玩家
  late Player _player;

  /// 创建主场景
  _GameSceneState();

  /// 初始化状态
  @override
  void initState() {
    super.initState();

    /// 强制横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    /// 加载游戏
    _loadGame();
  }

  /// 开始进入游戏
  void _loadGame() async {
    /// 创建玩家类
    _player = Player();

    /// 定义主界面
    this._gameWidget = DFGameWidget();
    try {
      await Future.delayed(Duration(seconds: 1), () async {
        /// 地图精灵
        MapSprite mapSprite = MapSprite();

        /// 玩家精灵动画
        DFSpriteAnimation bodySprite = await DFSpriteAnimation.load(
            "assets/images/role/man_01.png", "assets/images/role/man_01.json");
        DFSpriteAnimation weaponSprite = await DFSpriteAnimation.load(
            "assets/images/weapon/weapon_01.png", "assets/images/weapon/weapon_01.json");

        /// 创建玩家精灵
        _playerSprite = PlayerSprite(_player);
        _playerSprite?.position = DFPosition(
            MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);

        _playerSprite?.setBodySprite(bodySprite);
        _playerSprite?.setWeaponSprite(weaponSprite);

        /// 怪物精灵
        List<MonsterSprite> _monsterSprites = [];
        MonsterSprite monsterSprite = MonsterSprite();
        monsterSprite.position = DFPosition(
            MediaQuery.of(context).size.width * 0.8, MediaQuery.of(context).padding.top + 120);
        _monsterSprites.add(monsterSprite);

        /// Logo精灵
        DFImageSprite logoSprite = await DFImageSprite.load("assets/images/sprite.png");
        logoSprite.scale = 0.6;
        logoSprite.position = DFPosition(
            MediaQuery.of(context).size.width / 2, MediaQuery.of(context).padding.top + 60);

        /// 帧数精灵
        DFTextSprite fpsSprite = DFTextSprite("60 fps");
        fpsSprite.position = DFPosition(MediaQuery.of(context).size.width - 100, MediaQuery.of(context).padding.top + 12);
        fpsSprite.setOnUpdate((dt) {
          fpsSprite.text = DFGameWidget.fps;
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
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            "Devilf",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),

        /// 摇杆
        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 30,
          left: 30,
          child: DFJoyStick(
            //backgroundImage: "assets/images/ui/joystick.png",
            //handleImage: "assets/images/ui/joystick_btn.png",
            onChange: (double radians, String direction) {
              _playerSprite?.play(action: DFAnimation.RUN, direction: direction, radians: radians);
            },
            onCancel: (direction) {
              _playerSprite?.play(action: DFAnimation.IDLE, direction: direction);
            },
          ),
        ),

        Positioned(
          bottom: MediaQuery.of(context).padding.bottom + 10,
          right: 20,
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              ElevatedButton(
                child: new Text('攻击'),
                onPressed: () {
                  _playerSprite?.play(action: DFAnimation.ATTACK);
                },
              ),
              ElevatedButton(
                child: new Text('施法'),
                onPressed: () {
                  _playerSprite?.play(action: DFAnimation.CASTING);
                },
              ),
              ElevatedButton(
                child: new Text('挖'),
                onPressed: () {
                  _playerSprite?.play(action: DFAnimation.DIG);
                },
              ),
            ],
          ),
        ),
      ]);
    });
  }
}
