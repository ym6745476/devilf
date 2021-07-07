import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide WidgetBuilder;
import 'game.dart';
import 'game_loop.dart';

/// 游戏RenderBox
/// 继承LeafRenderObjectWidget可以将game类变成Widget通过canvas绘制界面
class GameRenderBox extends RenderBox with WidgetsBindingObserver {

  BuildContext context;
  Game game;

  // 游戏循环
  GameLoop? gameLoop;

  GameRenderBox(this.context, this.game) {
    WidgetsBinding.instance!.addTimingsCallback(game.onTimingsCallback);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    //启动游戏循环
    this.gameLoop = GameLoop(gameLoopCallback);
    this.gameLoop?.start();
    //绑定生命周期监听
    _bindLifecycleListener();
  }

  @override
  void detach() {
    super.detach();
    gameLoop?.dispose();
    gameLoop = null;
    _unbindLifecycleListener();
  }

  void gameLoopCallback(double dt) {
    if (!attached) {
      return;
    }
    game.update(dt);
    markNeedsPaint();
  }

  /// 绘制界面
  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    game.render(context.canvas);
    context.canvas.restore();
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    game.lifecycleStateChange(state);
  }

  // 监听Widget状态
  void _bindLifecycleListener() {
    WidgetsBinding.instance!.addObserver(this);
  }

  // 不监听Widget状态
  void _unbindLifecycleListener() {
    WidgetsBinding.instance!.removeObserver(this);
  }

}