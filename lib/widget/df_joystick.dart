import 'dart:math';

import 'package:devilf/game/df_animation.dart';
import 'package:flutter/material.dart';

/// 摇杆控制
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

  /// 当前方向
  String direction;

  /// 方向更新
  final void Function(double, String) onChange;

  /// 操作取消
  final void Function(String) onCancel;

  /// 创建遥杆
  DFJoyStick({
    this.handleImage,
    this.backgroundImage,
    this.handleColor = const Color(0x60FFFFFF),
    this.backgroundColor = const Color(0x40FFFFFF),
    this.direction = DFAnimation.NONE,
    required this.onChange,
    required this.onCancel,
    this.size = const Size(100, 100),
  });

  @override
  State<StatefulWidget> createState() => DFJoyStickState();
}

class DFJoyStickState extends State<DFJoyStick> {
  /// 偏移量
  Offset handleOffset = Offset.zero;

  /// 更新位置
  void update(Offset offset) {
    setState(() {
      handleOffset = offset;
    });
  }

  /// 更新位置
  void updateDirection(double radians) {
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
    if (direction != widget.direction) {
      widget.direction = direction;
      widget.onChange(radians, widget.direction);
    }
  }

  /// 计算移动距离
  void calculateDelta(Offset offset) {
    Offset offsetMove = offset - Offset(widget.size.width / 2, widget.size.height / 2);

    /// 更新摇杆位置 活动范围控制在Size之内
    update(Offset.fromDirection(offsetMove.direction, min(widget.size.width / 4, offsetMove.distance)));

    /// [-pi,pi]
    updateDirection(offsetMove.direction);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size.width,
      height: widget.size.height,
      child: widget.handleImage == null
          ? Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.size.width / 2)),
              child: GestureDetector(
                /// 摇杆背景
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(widget.size.width / 2),
                  ),
                  child: Center(
                    child: Transform.translate(
                      offset: handleOffset,

                      /// 摇杆
                      child: SizedBox(
                        width: widget.size.width / 2,
                        height: widget.size.height / 2,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.handleColor,
                            borderRadius: BorderRadius.circular(widget.size.width / 4),
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
            )
          : Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.size.width / 2)),
              child: GestureDetector(
                /// 摇杆背景
                child: Stack(
                  children: [
                    Positioned(
                      child: Image.asset(
                        widget.backgroundImage!,
                        width: widget.size.width,
                        height: widget.size.height,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      child: Center(
                        child: Transform.translate(
                          offset: handleOffset,

                          /// 摇杆
                          child: SizedBox(
                            width: widget.size.width / 2,
                            height: widget.size.height / 2,
                            child: Image.asset(
                              widget.handleImage!,
                              width: widget.size.width / 4,
                              height: widget.size.height / 4,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                onPanDown: onDragDown,
                onPanUpdate: onDragUpdate,
                onPanEnd: onDragEnd,
              ),
            ),
    );
  }

  void onDragDown(DragDownDetails details) {
    calculateDelta(details.localPosition);
  }

  void onDragUpdate(DragUpdateDetails details) {
    calculateDelta(details.localPosition);
  }

  void onDragEnd(DragEndDetails details) {
    update(Offset.zero);

    /// 返回结果
    widget.onCancel(widget.direction);
  }
}
