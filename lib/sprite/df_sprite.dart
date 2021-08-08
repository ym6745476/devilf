import 'dart:ui';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:flutter/cupertino.dart';

import '../game/df_math_size.dart';

/// 基础精灵类
class DFSprite {

  /// 唯一标识
  String? key;

  /// 相对坐标
  DFSprite? parent;

  /// 坐标  左上角是0点
  DFPosition position;

  /// 尺寸
  DFSize size;

  /// 角度
  double angle = 0;

  /// 缩放比例
  double scale = 1;

  /// 子精灵
  List<DFSprite> children = [];

  /// 固定到屏幕
  bool fixed = false;

  /// 显示
  bool visible = true;

  /// 未使用的
  bool isUsed = true;

  /// 未使用时是否回收
  bool recyclable = true;

  /// 创建精灵
  DFSprite({required this.position, required this.size});

  /// 增加子精灵
  void addChild(DFSprite sprite) {
    /// 绑定父和子的关系
    sprite.parent = this;
    children.add(sprite);
  }

  /// 增加精灵 增加进来精灵才能被绘制
  void addChildren(List<DFSprite> sprites) {
    sprites.forEach((sprite) {
      /// 绑定父和子的关系
      sprite.parent = this;
    });
    children.addAll(sprites);
  }

  /// 碰撞矩形
  DFShape getCollisionShape() {
    /// 子类覆盖
    return DFRect(this.position.x - this.size.width / 2, this.position.y - this.size.height / 2, this.size.width,
        this.size.height);
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
