import 'dart:ui';

/// 位置
class DFPosition {
  /// x坐标
  final double x;

  /// y坐标
  final double y;

  /// 创建坐标
  const DFPosition(this.x, this.y);

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString();
  }
}
