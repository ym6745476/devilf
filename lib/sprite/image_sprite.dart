import 'dart:math';

import 'package:devilf/base/assets_loader.dart';
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

/// 图片精灵类
class ImageSprite extends Sprite {

  /// 精灵图片
  ui.Image image;

  /// 图片区域绘制的起点
  Offset offset;

  /// 是否旋转
  bool rotated;

  /// 缩放比例
  double scale;

  ImageSprite(this.image,
      {
        Position position = const Position(0, 0),
        Size size = const Size(64, 64),
        this.offset = const Offset(0, 0),
        this.rotated = false,
        this.scale = 1,
      }) :super(position: position, size: size);


  /// 加载图片资源
  static Future<ImageSprite> load(String src) async {
    ui.Image image = await AssetsLoader.loadImage(src);
    return ImageSprite(image);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {

    /// 这里不应该调用super 因为有rotated的情况，单独实现画布的移动
    canvas.save();

    Rect srcRect;
    Rect dstRect;

    if(rotated){

      /// 将子精灵转换为相对坐标
      if(parent!=null){
        Position parentPosition = Position(parent!.position.y - parent!.size.height/2,parent!.position.x - parent!.size.width/2);
        canvas.translate(parentPosition.y + position.y, parentPosition.x + position.x);
      }else{
        canvas.translate(position.y,position.x);
      }

      /// 针对plist中的图像旋转
      this.angle = -90;
      /// 截取图片区域
      srcRect = Rect.fromLTWH(offset.dx, offset.dy, size.height, size.width);
      /// 目标区域
      dstRect = Rect.fromLTWH(-size.height/2, -size.width/2, size.height, size.width);

    }else{

      /// 将子精灵转换为相对坐标
      if(parent!=null){
        Position parentPosition = Position(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
        canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
      }else{
        canvas.translate(position.x , position.y);
      }

      srcRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
      dstRect = Rect.fromLTWH(-size.width/2, -size.height/2, size.width, size.height);
    }

    canvas.rotate(this.angle * pi / 180);  //弧度

    /// 精灵矩形边界
    Paint paint = Paint()..color = new Color(0x50007947); //绿色
    //canvas.drawRect(dstRect, paint);

    Rect outputRect = Rect.fromCenter(center:dstRect.center, width:dstRect.width * scale,height:dstRect.height * scale);

    Paint imagePaint = Paint()..color = Color(0xFFFFFFFF);
    canvas.drawImageRect(this.image, srcRect, outputRect, imagePaint);
    canvas.restore();
  }
}