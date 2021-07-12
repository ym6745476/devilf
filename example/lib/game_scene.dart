
import 'package:devilf/game/df_game_widget.dart';
import 'package:devilf/game/df_sprite_image.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_sprite_animation.dart';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_text_sprite.dart';
import 'package:devilf/sprite/map_sprite.dart';
import 'package:devilf/sprite/monster_sprite.dart';
import 'package:devilf/sprite/player_sprite.dart';
import 'package:flutter/material.dart';

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

  /// 当前主角的动画
  int  _currentAnimationIndex = 0;

  /// 创建主场景
  _GameSceneState();


  /// 初始化状态
  @override
  void initState() {
    super.initState();
    _loadGame();
    print("GameScene initState  ok ");
  }

  /// 鼠标点击
  void _pointerDown(PointerDownEvent event){
    print("鼠标点击：" + event.localPosition.toString());
    _updatePlayerPosition(DFPosition(event.localPosition.dx,event.localPosition.dy));
  }

  /// 鼠标抬起
  void _pointerUp(PointerUpEvent event){
    print("鼠标抬起：" + event.localPosition.toString());
  }

  /// 鼠标移动
  void _pointerMove(PointerMoveEvent event){
    print("鼠标移动：" + event.localPosition.toString());
    _updatePlayerPosition(DFPosition(event.localPosition.dx,event.localPosition.dy));
  }

  /// 鼠标取消
  void _pointerCancel(PointerCancelEvent event){
    print("鼠标取消：" + event.localPosition.toString());
  }

  /// 玩家位置更新
  void _updatePlayerPosition(DFPosition position){
    _playerSprite!.position = position;
  }

  /// 开始进入游戏
  void _loadGame() async {

    try {

      await Future.delayed(Duration(seconds: 2), () async {

        /// 定义主界面
        this._gameWidget = DFGameWidget();

        /// 地图精灵
        MapSprite mapSprite = MapSprite();
        /// 将地图精灵添加到主界面
        this._gameWidget!.addChild(mapSprite);

        /// 玩家精灵
        DFSpriteAnimation bodySprite = await DFSpriteAnimation.load("assets/images/role/man_01.png","assets/images/role/man_01.json");
        DFSpriteAnimation weaponSprite = await DFSpriteAnimation.load("assets/images/weapon/weapon_01.png","assets/images/weapon/weapon_01.json");
        //DFSpriteAnimation hairSprite = await DFSpriteAnimation.load("assets/images/role/man_hair_01.png","assets/images/role/man_hair_01.json");

        _playerSprite = PlayerSprite();
        _playerSprite?.position = DFPosition(MediaQuery.of(context).size.width/2,MediaQuery.of(context).size.height/2);

        _playerSprite?.setBodySprite(bodySprite);
        _playerSprite?.setWeaponSprite(weaponSprite);
        //_playerSprite?.setHairSprite(hairSprite);

        /// 将玩家精灵添加到主界面
        this._gameWidget!.addChild(_playerSprite);

        /// 怪物精灵
        List<MonsterSprite> _monsterSprites = [];
        MonsterSprite monsterSprite = MonsterSprite(position:DFPosition(MediaQuery.of(context).size.width/2,MediaQuery.of(context).padding.top + 60));
        _monsterSprites.add(monsterSprite);
        /// 将怪物精灵添加到主界面
        this._gameWidget!.addChildren(_monsterSprites);

        /// Logo精灵
        DFImageSprite logoSprite = await DFImageSprite.load("assets/images/sprite.png");
        logoSprite.scale = 0.6;
        logoSprite.position = DFPosition(MediaQuery.of(context).size.width/2, MediaQuery.of(context).padding.top + 60);
        /// 将Logo精灵添加到主界面
        this._gameWidget!.addChild(logoSprite);

        /// 帧数精灵
        DFTextSprite fpsSprite = DFTextSprite("60 fps",position:DFPosition(MediaQuery.of(context).size.width - 100,25));
        fpsSprite.setOnUpdate((dt){
          fpsSprite.text = DFGameWidget.fps;
        });

        /// 将帧数精灵添加到主界面
        this._gameWidget!.addChild(fpsSprite);

        /// Loading完成
        setState(() {
          _loading = false;
        });

        ///自动播放玩家第一个动画
        _currentAnimationIndex = 0;
        _playerSprite?.play(DFAnimation.sequence[_currentAnimationIndex]);

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
              padding: EdgeInsets.only(top:16),
              child: Text(
                "Loading...",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
              fit: StackFit.expand,
              children: <Widget>[

                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black87,
                    child:  _loading ? _loadingWidget():

                    Listener(
                        onPointerDown: (event)=> _pointerDown(event),
                        onPointerMove: (event)=> _pointerMove(event),
                        onPointerUp: (event) => _pointerUp(event),
                        onPointerCancel: (event) => _pointerCancel(event),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: _gameWidget,
                        )
                    ),
                  ),
                ),

                Positioned(
                  left: 10,
                  top: MediaQuery.of(context).padding.top+ 10,
                  child: Text(
                    "Devilf",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),

                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  right: 20,
                  child:Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      ElevatedButton(
                        child: new Text('方向'),
                        onPressed: () {

                          if(_currentAnimationIndex == 7){
                              _currentAnimationIndex = 0;
                          }else if(_currentAnimationIndex == 15){
                              _currentAnimationIndex = 8;
                          }else{
                            _currentAnimationIndex += 1 ;
                          }
                          _playerSprite?.play(DFAnimation.sequence[_currentAnimationIndex]);

                        },
                      ),

                      ElevatedButton(
                        child: new Text('动作'),
                        onPressed: () {
                          if(_currentAnimationIndex + 8 > 15){
                            _currentAnimationIndex -= 8 ;
                            _playerSprite?.play(DFAnimation.sequence[_currentAnimationIndex]);
                          }else{
                            _currentAnimationIndex += 8 ;
                            _playerSprite?.play(DFAnimation.sequence[_currentAnimationIndex]);
                          }
                        },
                      ),
                    ],
                  ),
                ),

              ]
          );
        }
    );
  }

}