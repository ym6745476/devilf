import 'package:devilf/sprite/fps_sprite.dart';
import 'package:devilf/sprite/map_sprite.dart';
import 'package:devilf/sprite/monster_sprite.dart';
import 'package:devilf/sprite/player_sprite.dart';
import 'package:flutter/material.dart';
import 'game.dart';

/// 管理Game类的Widget
/// Listener手势监听
class GameWidget extends StatelessWidget {

  // 界面尺寸
  final Size size;

  // 游戏主循环
  late  Game? game;

  // 地图精灵
  final MapSprite? mapSprite;

  // 玩家精灵
  final PlayerSprite? playerSprite;

  // FPS精灵
  final FpsSprite? fpsSprite;

  // 怪物精灵列表
  final List<MonsterSprite>? monsterSprites;

  GameWidget({
    this.size = const Size(300,300),
    this.mapSprite,
    this.playerSprite,
    this.fpsSprite,
    this.monsterSprites,
  }){
    initGame();
  }

  /// 初始化游戏
  void initGame(){
    this.game = Game();
    this.game!.addSprite(mapSprite);
    this.game!.addSprite(playerSprite);
    this.game!.addSprite(fpsSprite);
    if(monsterSprites!=null){
      this.game!.addAllSprite(monsterSprites!);
    }
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

  /// 鼠标取消
  void _pointerCancel(PointerCancelEvent event){
    print("鼠标取消：" + event.localPosition.toString());

  }

  /// 玩家位置更新
  void _updatePlayerPosition(Offset position){
    playerSprite!.setPosition(position.dx, position.dy);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
        onPointerDown: (event)=> _pointerDown(event),
        onPointerMove: (event)=> _pointerMove(event),
        onPointerUp: (event) => _pointerUp(event),
        onPointerCancel: (event) => _pointerCancel(event),
        child: Container(
          width: size.width,
          height: size.height,
          child: game,
        )
    );
  }
}
