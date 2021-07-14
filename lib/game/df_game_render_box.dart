import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' hide WidgetBuilder;
import 'df_game_widget.dart';
import 'df_game_loop.dart';

/// 游戏RenderBox
class DFGameRenderBox extends RenderBox with WidgetsBindingObserver {
  /// 上下文
  BuildContext context;

  /// 游戏控件
  DFGameWidget gameWidget;

  /// 游戏循环
  DFGameLoop? gameLoop;

  /// 创建渲染盒
  DFGameRenderBox(this.context, this.gameWidget) {
    WidgetsBinding.instance!.addTimingsCallback(gameWidget.onTimingsCallback);
  }

  /// 附加
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);

    ///启动游戏循环
    this.gameLoop = DFGameLoop(gameUpdate);
    this.gameLoop?.start();

    ///绑定生命周期监听
    bindLifecycleListener();
  }

  /// 取消附加
  @override
  void detach() {
    super.detach();
    gameLoop?.dispose();
    gameLoop = null;
    unbindLifecycleListener();
  }

  /// 游戏循环更新
  void gameUpdate(double dt) {
    if (!attached) {
      return;
    }
    gameWidget.update(dt);
    markNeedsPaint();
  }

  /// 绘制界面
  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(offset.dx, offset.dy);
    gameWidget.render(context.canvas);
    context.canvas.restore();
  }

  /// 重绘
  @override
  bool get isRepaintBoundary => true;

  /// 计算尺寸
  @override
  void performLayout() {
    size = constraints.biggest;
  }

  /// 计算布局
  @override
  Size computeDryLayout(BoxConstraints constraints) => constraints.biggest;

  /// 状态改变
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    gameWidget.lifecycleStateChange(state);
  }

  /// 监听Widget状态
  void bindLifecycleListener() {
    WidgetsBinding.instance!.addObserver(this);
  }

  /// 不监听Widget状态
  void unbindLifecycleListener() {
    WidgetsBinding.instance!.removeObserver(this);
  }
}
