import 'dart:math';

import 'package:devilf/game/df_animation.dart';

/// 工具类
class DFUtil {
  /// 获取方向
  static String getDirection(double radians) {
    /// 判断8方向
    String direction = DFAnimation.NONE;

    /// 换算角度
    double angle = 180 / pi * radians;
    if (angle < 0) {
      angle = angle + 360;
    }

    /// 顺时针 0~360
    /// print("angle:" + angle.toString());

    /// 右边
    if ((angle >= 0 && angle < 22.5) || (angle >= 337.5 && angle <= 360)) {
      direction = DFAnimation.RIGHT;
    }

    /// 右下
    if (angle >= 22.5 && angle < 67.5) {
      direction = DFAnimation.DOWN_RIGHT;
    }

    /// 下
    if (angle >= 67.5 && angle < 112.5) {
      direction = DFAnimation.DOWN;
    }

    /// 左下
    if (angle >= 112.5 && angle < 157.5) {
      direction = DFAnimation.DOWN_LEFT;
    }

    /// 左
    if (angle >= 157.5 && angle < 202.5) {
      direction = DFAnimation.LEFT;
    }

    /// 左上
    if (angle >= 202.5 && angle < 247.5) {
      direction = DFAnimation.UP_LEFT;
    }

    /// 上
    if (angle >= 247.5 && angle < 292.5) {
      direction = DFAnimation.UP;
    }

    /// 右上
    if (angle >= 292.5 && angle < 337.5) {
      direction = DFAnimation.UP_RIGHT;
    }

    /// 返回结果
    return direction;
  }

  /// 获取弧度
  static double getRadians(String direction) {
    double radians = 0;

    if (direction == DFAnimation.DOWN_RIGHT) {
      radians = 45 * pi / 180.0;
    } else if (direction == DFAnimation.UP_LEFT) {
      radians = 225 * pi / 180.0;
    } else if (direction == DFAnimation.UP_RIGHT) {
      radians = 315 * pi / 180.0;
    } else if (direction == DFAnimation.DOWN_LEFT) {
      radians = 135 * pi / 180.0;
    } else if (direction == DFAnimation.RIGHT) {
      radians = 0;
    } else if (direction == DFAnimation.LEFT) {
      radians = 180 * pi / 180.0;
    } else if (direction == DFAnimation.DOWN) {
      radians = 90 * pi / 180.0;
    } else if (direction == DFAnimation.UP) {
      radians = 270 * pi / 180.0;
    }

    /// 返回结果
    return radians;
  }
}
