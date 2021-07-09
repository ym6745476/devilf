
 import 'dart:ui';

class Position{

  final double x;
  final double y;

  const Position(this.x, this.y);

  Offset toOffset() => Offset(x, y);

  @override
  String toString() {
    return "x:" + x.toString() + ",y:" + y.toString();
  }
}