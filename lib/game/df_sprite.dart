import 'dart:math';
import 'dart:ui';
import 'package:devilf/game/df_math_position.dart';
import 'package:flutter/cupertino.dart';

import 'df_math_size.dart';

/// 基础精灵类
class DFSprite {
  /// 相对坐标
  DFSprite? parent;

  /// 坐标  左上角是0点
  DFPosition position;

  /// 尺寸
  DFSize size;

  /// 角度
  double angle = 0;

  /// 子精灵
  List<DFSprite> children = [];

  /// 创建精灵
  DFSprite({
    required this.position,
    required this.size,
  });

  /// 增加子精灵
  void addChild(DFSprite child) {
    /// 绑定父和子的关系
    child.parent = this;
    children.add(child);
  }

  /// 精灵更新
  void update(double dt) {
    /// 子类覆盖
  }

  /// 精灵渲染
  void render(Canvas canvas) {
    /// 子类覆盖
  }
}
