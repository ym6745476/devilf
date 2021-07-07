
import 'package:devilf/game/game.dart';
import 'package:devilf/game/game_widget.dart';
import 'package:devilf/sprite/fps_sprite.dart';
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

  MapSprite? _mapSprite;
  PlayerSprite? _playerSprite;
  List<MonsterSprite> _monsterSprites = [];
  FpsSprite? _fpsSprite;

  bool _loading = true;
  String _tipText = "点击";

  _GameSceneState();


  @override
  void initState() {
    super.initState();
    _loadGame();
    print("GameScene initState  ok ");
  }

  void _loadGame() async {
    try {

      await Future.delayed(Duration(seconds: 2), () {
        _mapSprite = MapSprite(x:0,y:0);
        _playerSprite = PlayerSprite(x:MediaQuery.of(context).size.width/2,y:MediaQuery.of(context).size.height/2);
        _fpsSprite = FpsSprite("60 fps",x:0,y:MediaQuery.of(context).size.height - 25);

        MonsterSprite monsterSprite = MonsterSprite(x:MediaQuery.of(context).size.width-100,y:MediaQuery.of(context).size.height-100);
        _monsterSprites.add(monsterSprite);

        setState(() {
          _loading = false;
        });

      });

    } catch (e) {
      print('(GameScene _loadGame) Error: $e');
    }
  }


  /// Loading
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
    print("GameScene build");
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
                    GameWidget(
                        size: Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
                        fpsSprite:_fpsSprite,
                        playerSprite:_playerSprite,
                        mapSprite:_mapSprite,
                        monsterSprites:_monsterSprites,
                    ),
                  ),
                ),

                Positioned(
                  left: 4,
                  top: 4,
                  child: Text(
                    "devilf",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),

                Positioned(
                  bottom: 30,
                  right: 20,
                  child: GestureDetector(
                    child: Container(
                      child: Text(
                        _tipText,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    onTap: (){
                      setState(() {
                          _tipText = "点到我了";
                      });
                    },
                  ),
                ),
              ]
          );
        }
    );
  }

}