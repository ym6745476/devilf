
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
    onChildChange(child);
  }

  /// 更新数据
  void update(double dt){

  }

  /// 重绘界面
  void render(Canvas canvas){

    canvas.save();
    /// 子类调用super可以自动移动画布到相对坐标
    if(parent!=null){
      Position parentPosition = Position(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
      canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
    }else{
      canvas.translate(position.x, position.y);
    }

  }

  /// 节点发生变化
  void onChildChange(Sprite child){

  }

}
