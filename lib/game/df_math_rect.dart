import 'dart:math';
import 'dart:ui';

import 'package:devilf/util/df_util.dart';

import 'df_math_position.dart';

/// 形状
class DFShape {
  /// 是否重叠
  bool overlaps(DFShape other) {
    print("00000000000000000000000000000000000000");
    return false;
  }
}

/// 矩形
class DFRect extends DFShape {
  /// 左坐标
  final double left;

  /// 上坐标
  final double top;

  /// 右坐标
  double? right;

  /// 下坐标
  double? bottom;

  /// 宽度
  final double width;

  /// 高度
  final double height;

  /// 创建矩形
  DFRect(this.left, this.top, this.width, this.height) {
    right = this.left + this.width;
    bottom = this.top + this.height;
  }

  /// 转换为Rect
  Rect toRect() => Rect.fromLTWH(this.left, this.top, width, height);

  /// 中心坐标
  DFPosition center() {
    return DFPosition(this.left + this.width / 2, this.top + this.height / 2);
  }

  /// 是否重叠
  @override
  bool overlaps(DFShape other) {
    if (other is DFRect) {
      return rectToRect(other);
    } else if (other is DFCircle) {
      return other.circleToRect(this);
    }
    return false;
  }

  /// 矩形碰撞
  bool rectToRect(DFRect other) {
    if (right! <= other.left || other.right! <= left) return false;
    if (bottom! <= other.top || other.bottom! <= top) return false;
    return true;
  }

  @override
  String toString() {
    return "left:" +
        left.toString() +
        ",top:" +
        top.toString() +
        ",width:" +
        width.toString() +
        ",height:" +
        height.toString();
  }
}

/// 圆形
class DFCircle extends DFShape {
  /// 中心坐标
  final DFPosition center;

  /// 半径
  final double radius;

  /// 创建圆形
  DFCircle(this.center, this.radius);

  /// 转换为Rect
  DFRect toRect() => DFRect(this.center.x - radius, this.center.y - radius, radius * 2, radius * 2);

  /// 是否重叠
  @override
  bool overlaps(DFShape other) {
    if (other is DFRect) {
      return circleToRect(other);
    } else if (other is DFCircle) {
      return circleToCircle(other);
    }
    return false;
  }

  /// 圆形和矩形重叠
  bool circleToRect(DFRect other) {
    /// 矩形不重叠，不用判断圆形了
    if (!toRect().overlaps(other)) {
      return false;
    }

    /// 排除矩形包含了圆形
    if (other.right! >= this.center.x + this.radius &&
        other.left <= this.center.x - this.radius &&
        other.top <= this.center.y - this.radius &&
        other.bottom! >= this.center.y + this.radius) {
      return true;
    }

    final points = [
      DFPosition(other.left, other.top),
      DFPosition(other.right!, other.top),
      DFPosition(other.right!, other.bottom!),
      DFPosition(other.left, other.bottom!),
      DFPosition(other.left, other.top),
    ];
    print(other.toString());
    for (var i = 0; i < points.length - 1; i++) {
      final distance = DFUtil.getNearestDistance(points[i], points[i + 1], this.center);
      print((distance).toString());
      if (DFUtil.fixDouble4(distance) <= this.radius) {
        return true;
      }
    }
    return false;
  }

  /// 圆形与圆形重叠
  bool circleToCircle(DFCircle other) {
    if (!this.toRect().rectToRect(other.toRect())) return false;

    final distance = this.radius + other.radius;
    final w = this.center.x - other.center.x;
    final h = this.center.y - other.center.y;

    return sqrt(w * w + h * h) <= distance;
  }

  @override
  String toString() {
    return "center:" + center.toString() + ",radius:" + radius.toString();
  }
}
