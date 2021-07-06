import 'dart:ui';

import 'package:devilf/sprite/fps_sprite.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/material.dart';
import 'game_render_box.dart';

/// 游戏主界面
class Game extends LeafRenderObjectWidget {

  // 游戏里的所有精灵
  final List<Sprite> children;

  // 帧数
  static String fps = "60 fps";

  Game({
    required this.children,
  });

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
      if(sprite is FpsSprite){
        sprite.setText(Game.fps);
      }else{
        sprite.update(dt);
      }
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
    //print(timings[0].totalSpan.inMilliseconds.toString());
    Game.fps = (1/(timings[0].totalSpan.inMilliseconds/1000)).toStringAsFixed(0) + " fps";
  }

  void lifecycleStateChange(AppLifecycleState state) {
    //
  }

}
