import 'package:flutter/scheduler.dart';

/// 游戏循环
class DFGameLoop {
  Duration previous = Duration.zero;
  late Ticker _ticker;
  void Function(double dt) update;

  /// 创建游戏循环
  DFGameLoop(this.update) {
    _ticker = Ticker(_tick);
  }

  void _tick(Duration timestamp) {
    final dt = _computeDelta(timestamp);
    update(dt);
  }

  double _computeDelta(Duration now) {
    final delta = previous == Duration.zero ? Duration.zero : now - previous;
    previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
  }

  void dispose() {
    _ticker.dispose();
  }

  void pause() {
    _ticker.muted = true;
    previous = Duration.zero;
  }

  void resume() {
    _ticker.muted = false;
  }
}
