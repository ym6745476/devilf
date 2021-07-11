
import 'dart:ui';

/// 偏移量
class DFOffset{

  /// x坐标偏移
  final double dx;

  /// y坐标偏移
  final double dy;

  /// 创建坐标偏移
  const DFOffset(this.dx, this.dy);

  /// 转换为Offset
  Offset toOffset() => Offset(dx, dy);

  @override
  String toString() {
    return "dx:" + dx.toString() + ",dy:" + dy.toString();
  }
}