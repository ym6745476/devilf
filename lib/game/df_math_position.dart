/// 位置
class DFPosition {
  /// x坐标
  double x;

  /// y坐标
  double y;

  /// 创建坐标
  DFPosition(this.x, this.y);

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString();
  }
}
