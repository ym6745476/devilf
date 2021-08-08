import 'dart:ui';

/// 位置
class DFPosition {
  /// x坐标
  double x;

  /// y坐标
  double y;

  /// 创建坐标
  DFPosition(this.x, this.y);

  /// 转换为Offset
  Offset toOffset() => Offset(x, y);

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString();
  }
}

/// 方位
enum DFGravity {
  /// 左
  left,

  /// 右
  right,

  /// 上
  top,

  /// 中
  center,

  /// 下
  bottom
}
