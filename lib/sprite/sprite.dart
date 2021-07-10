
import 'dart:math';
import 'dart:ui';
import 'package:devilf/base/position.dart';
import 'package:flutter/cupertino.dart';

/// 基础精灵类
class Sprite {

  /// 相对坐标
  Sprite? parent;

  /// 坐标  左上角是0点
  Position position;

  /// 尺寸
  Size size;

  /// 角度
  double angle = 0;

  /// 子精灵
  List<Sprite> children = [];

  /// 被绑定状态
  bool isBind = false;

  Sprite(
    {
        required this.position,
        required this.size,
    }
  );

  /// 增加子精灵
  void addChild(Sprite child){
    child.parent = this;
    children.add(child);
  }

  /// 更新数据
  void update(double dt){

  }

  /// 重绘界面
  void render(Canvas canvas){

  }

}
