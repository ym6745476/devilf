import 'dart:ui';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/material.dart';
import 'df_game_render_box.dart';

/// 游戏主循环
/// 继承LeafRenderObjectWidget实现RenderBox可以使用canvas实现Widget
class DFGameWidget extends LeafRenderObjectWidget {
  /// 游戏里的所有精灵
  final List<DFSprite> children = [];

  /// 当前帧数
  static String fps = "60 fps";

  /// 创建游戏控件
  DFGameWidget();

  /// 增加精灵 增加进来精灵才能被绘制
  void addChild(DFSprite? sprite) {
    if (sprite != null) {
      children.add(sprite);
    }
  }

  /// 增加精灵 增加进来精灵才能被绘制
  void addChildren(List<DFSprite> sprites) {
    children.addAll(sprites);
  }

  /// 删除精灵
  void removeChild(DFSprite sprite,{recyclable = true}) {
    /// 不能直接remove会并发修改错误
    sprite.isUsed = false;
    sprite.recyclable = recyclable;
  }

  /// 创建GameRenderBox
  @override
  RenderBox createRenderObject(BuildContext context) {
    return DFGameRenderBox(context, this);
  }

  /// 设置Game到GameRenderBox
  @override
  void updateRenderObject(BuildContext context, DFGameRenderBox renderObject) {
    renderObject.gameWidget = this;
  }

  /// 更新界面
  void update(double dt) {
    children.forEach((sprite) {
      if (!sprite.isUsed && sprite.recyclable) {
        /// 将要回收的精灵
      }else{
        sprite.update(dt);
      }
    });

    /// 清楚无用的精灵
    children.removeWhere((sprite) => (sprite.isUsed == false && sprite.recyclable));
  }

  /// 绘制界面
  void render(Canvas canvas) {
    children.forEach((sprite) {
      if (sprite.isUsed && sprite.visible) {
        sprite.render(canvas);
      }
    });
  }

  /// 显示FPS
  void onTimingsCallback(List<FrameTiming> timings) {
    DFGameWidget.fps = (1 / (timings[0].totalSpan.inMilliseconds / 1000.0)).toStringAsFixed(0) + " fps";
    //print(Game.fps);
  }

  /// 生命周期发生变化
  void lifecycleStateChange(AppLifecycleState state) {
    //
  }
}
