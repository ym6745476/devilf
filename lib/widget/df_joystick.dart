import 'dart:math';

import 'package:devilf/game/df_animation.dart';
import 'package:flutter/material.dart';

/// 摇杆控制
// ignore: must_be_immutable
class DFJoyStick extends StatefulWidget {
  /// 背景图
  final String? backgroundImage;

  /// 手柄图
  final String? handleImage;

  /// 背景颜色
  final Color backgroundColor;

  /// 手柄颜色
  final Color handleColor;

  /// 遥杆尺寸
  final Size size;

  /// 监听区域
  final Size areaSize;

  /// 当前方向
  String direction;

  /// 方向更新
  final void Function(String,double) onChange;

  /// 操作取消
  final void Function(String) onCancel;

  /// 创建遥杆
  DFJoyStick({
    this.handleImage,
    this.backgroundImage,
    this.handleColor = const Color(0x60FFFFFF),
    this.backgroundColor = const Color(0x40FFFFFF),
    this.direction = DFDirection.NONE,
    required this.onChange,
    required this.onCancel,
    this.size = const Size(100, 100),
    this.areaSize = const Size(240, 240),
  });

  @override
  State<StatefulWidget> createState() => DFJoyStickState();
}

class DFJoyStickState extends State<DFJoyStick> {
  /// 偏移量
  Offset backgroundOffset = Offset.zero;
  Offset handleOffset = Offset.zero;

  /// 更新位置
  void updateDirection(double radians) {
    /// 判断8方向
    String direction = DFDirection.NONE;

    /// 换算角度
    double angle = 180 / pi * radians;
    if (angle < 0) {
      angle = angle + 360;
    }

    /// 顺时针 0~360
    /// print("angle:" + angle.toString());

    /// 右边
    if ((angle >= 0 && angle < 22.5) || (angle >= 337.5 && angle <= 360)) {
      direction = DFDirection.RIGHT;
    }

    /// 右下
    if (angle >= 22.5 && angle < 67.5) {
      direction = DFDirection.DOWN_RIGHT;
    }

    /// 下
    if (angle >= 67.5 && angle < 112.5) {
      direction = DFDirection.DOWN;
    }

    /// 左下
    if (angle >= 112.5 && angle < 157.5) {
      direction = DFDirection.DOWN_LEFT;
    }

    /// 左
    if (angle >= 157.5 && angle < 202.5) {
      direction = DFDirection.LEFT;
    }

    /// 左上
    if (angle >= 202.5 && angle < 247.5) {
      direction = DFDirection.UP_LEFT;
    }

    /// 上
    if (angle >= 247.5 && angle < 292.5) {
      direction = DFDirection.UP;
    }

    /// 右上
    if (angle >= 292.5 && angle < 337.5) {
      direction = DFDirection.UP_RIGHT;
    }

    /// 返回结果
    if (direction != widget.direction) {
      widget.direction = direction;
      widget.onChange(widget.direction,radians);
    }
  }

  /// 计算移动距离
  void calculateMove(Offset localPosition) {
    /// 相对位置
    Offset offset = localPosition - Offset(widget.areaSize.width / 2, widget.areaSize.height / 2) - backgroundOffset;

    /// 更新摇杆位置 活动范围控制在Size之内
    Offset handle = Offset.fromDirection(offset.direction, min(widget.size.width / 2, offset.distance));
    setState(() {
      handleOffset = handle;
    });

    /// [-pi,pi]
    updateDirection(offset.direction);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
          width: widget.areaSize.width,
          height: widget.areaSize.height,
          color: Color(0x00000000),
          child: Center(
            child: Transform.translate(
              offset: backgroundOffset,
              child: Container(
                width: widget.size.width,
                height: widget.size.height,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  image: widget.backgroundImage != null
                      ? DecorationImage(image: AssetImage(widget.backgroundImage!))
                      : null,
                  borderRadius: BorderRadius.circular(widget.size.width / 2),
                ),
                child: Center(
                  child: Transform.translate(
                    offset: handleOffset,
                    child: Container(
                      width: widget.size.width / 2,
                      height: widget.size.height / 2,
                      decoration: BoxDecoration(
                        color: widget.handleColor,
                        image:
                            widget.handleImage != null ? DecorationImage(image: AssetImage(widget.handleImage!)) : null,
                        borderRadius: BorderRadius.circular(widget.size.width / 4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        onPanDown: onDragDown,
        onPanUpdate: onDragUpdate,
        onPanEnd: onDragEnd,
      ),
    );
  }

  void onDragDown(DragDownDetails details) {
    /// 按下
    setState(() {
      backgroundOffset = details.localPosition - Offset(widget.areaSize.width / 2, widget.areaSize.height / 2);
      handleOffset = Offset.zero;
    });
  }

  void onDragUpdate(DragUpdateDetails details) {
    /// 移动
    calculateMove(details.localPosition);
  }

  void onDragEnd(DragEndDetails details) {
    /// 抬起
    setState(() {
      backgroundOffset = Offset.zero;
      handleOffset = Offset.zero;
    });

    /// 返回结果
    widget.onCancel(widget.direction);
  }
}
