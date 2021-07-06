
import 'package:devilf/game/game.dart';
import 'package:devilf/sprite/fps_sprite.dart';
import 'package:devilf/sprite/map_sprite.dart';
import 'package:devilf/sprite/player_sprite.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/material.dart';

class GameScene extends StatelessWidget {

  final int map;
  MapSprite? mapSprite;
  PlayerSprite? playerSprite;
  FpsSprite? fpsSprite;

  GameScene({this.map = 1}){
    init();
  }

  void init(){

  }

  /// 鼠标点击
  void _pointerDown(PointerDownEvent event){
    print("鼠标点击：" + event.localPosition.toString());
    _updatePlayerPosition(event.localPosition);
  }

  /// 鼠标抬起
  void _pointerUp(PointerUpEvent event){
    print("鼠标抬起：" + event.localPosition.toString());
  }

  /// 鼠标移动
  void _pointerMove(PointerMoveEvent event){
    print("鼠标移动：" + event.localPosition.toString());
    _updatePlayerPosition(event.localPosition);

  }

  void _updatePlayerPosition(Offset position){
    if(playerSprite!=null){
      playerSprite!.setPosition(position.dx, position.dy);
    }
  }

  @override
  Widget build(BuildContext context) {

    mapSprite = MapSprite(x:0,y:0);
    playerSprite = PlayerSprite(x:MediaQuery.of(context).size.width/2,y:MediaQuery.of(context).size.height/2);
    fpsSprite = FpsSprite("60 fps",x:0,y:MediaQuery.of(context).size.height - 25);

    return LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
              fit: StackFit.expand,
              children: <Widget>[

                Positioned(
                  top: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child:  Listener(
                    child: Game(
                      children: [
                        mapSprite!,
                        playerSprite!,
                        fpsSprite!
                      ],
                    ),
                    onPointerDown: (event)=> _pointerDown(event),
                    onPointerMove: (event)=> _pointerMove(event),
                    onPointerUp: (event) => _pointerUp(event),
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
                  left: 0,
                  top: 0,
                  child: Listener(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.transparent,
                      ),
                      onPointerDown: (event)=> _pointerDown(event),
                      onPointerMove: (event)=> _pointerMove(event),
                      onPointerUp: (event) => _pointerUp(event),
                  ),
                ),

              ]
          );
        }
    );
  }

}
