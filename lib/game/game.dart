import 'dart:ui';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/material.dart';
import 'game_render_box.dart';

/// 游戏主循环
class Game extends LeafRenderObjectWidget {

  // 游戏里的所有精灵
  final List<Sprite> children = [];

  // 帧数
  static String fps = "60 fps";

  Game();

  /// 增加精灵 增加进来精灵才能被绘制
  void addSprite(Sprite? sprite){
    if(sprite!=null){
      children.add(sprite);
    }
  }

  /// 增加精灵 增加进来精灵才能被绘制
  void addAllSprite(List<Sprite> sprites){
    children.addAll(sprites);
  }

  /// 创建GameRenderBox
  @override
  RenderBox createRenderObject(BuildContext context) {
    return GameRenderBox(context,this);
  }

  /// 设置Game到GameRenderBox
  @override
  void updateRenderObject(BuildContext context, GameRenderBox renderObject) {
    renderObject.game = this;
  }

  /// 更新界面
  void update(double dt) {
    children.forEach((sprite) {
      sprite.update(dt);
    });
  }

  /// 绘制界面
  void render(Canvas canvas) {
    children.forEach((sprite) {
      sprite.render(canvas);
    });
  }

  /// 显示FPS
  void onTimingsCallback(List<FrameTiming> timings) {
    Game.fps = (1/(timings[0].totalSpan.inMilliseconds/1000.0)).toStringAsFixed(0) + " fps";
    //print(Game.fps);
  }

  /// 生命周期发生变化
  void lifecycleStateChange(AppLifecycleState state) {
    //
  }

}
