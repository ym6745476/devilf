
import 'dart:ui';

 /// 矩形
class DFRect{

  /// x坐标
  final double x;

  /// y坐标
  final double y;

  /// 宽度
  final double width;

  /// 高度
  final double height;

  /// 创建矩形
  const DFRect(this.x, this.y,this.width, this.height);

  /// 转换为Rect
  Rect toRect() => Rect.fromLTWH(x, y, width, height);

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString() + ",width:" + width.toString() + ",height:" + height.toString();
  }
}