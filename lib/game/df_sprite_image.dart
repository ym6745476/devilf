import 'dart:math';

import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'df_math_offset.dart';
import 'df_math_rect.dart';
import 'df_math_size.dart';

/// 图片精灵类
class DFImageSprite extends DFSprite {

  /// 精灵图片
  ui.Image image;

  /// 截取图片区域
  DFRect rect;

  /// 坐标偏移
  DFOffset offset;

  /// 是否旋转
  bool rotated;

  /// x轴镜像
  bool flippedX;

  /// 缩放比例
  double scale;

  /// 创建图片精灵
  DFImageSprite(this.image,
      {
        DFPosition position = const DFPosition(0, 0),
        DFSize size = const DFSize(64, 64),
        this.rect = const DFRect(0, 0, 64, 64),
        this.offset = const DFOffset(0, 0),
        this.rotated = false,
        this.flippedX = false,
        this.scale = 1,
      }) :super(position: position, size: size);


  /// 加载图片资源
  static Future<DFImageSprite> load(String src) async {
    ui.Image image = await DFAssetsLoader.loadImage(src);
    return DFImageSprite(image);
  }

  /// 精灵渲染
  @override
  void render(Canvas canvas) {

    /// 画布暂存
    canvas.save();

    Rect dstRect;

    if(rotated){

      /// 将子精灵转换为相对坐标
      if(parent!=null){
        DFPosition parentPosition = DFPosition(parent!.position.y - parent!.size.height/2,parent!.position.x - parent!.size.width/2);
        canvas.translate(parentPosition.y + position.y, parentPosition.x + position.x + rect.height/2);
      }else{
        canvas.translate(position.y,position.x + rect.height/2);
      }

      /// 针对json中的图像旋转
      this.angle = -90;

    }else{

      /// 将子精灵转换为相对坐标
      if(parent!=null){
        DFPosition parentPosition = DFPosition(parent!.position.x - parent!.size.width/2,parent!.position.y - parent!.size.height/2);
        canvas.translate(parentPosition.x + position.x, parentPosition.y + position.y);
      }else{
        canvas.translate(position.x , position.y);
      }

    }

    /// 目标区域
    dstRect = Rect.fromLTWH(-rect.width * (1-anchorPoint.x), -rect.height * anchorPoint.y, rect.width, rect.height);

    canvas.rotate(this.angle * pi / 180);  //弧度

    /// 水平镜像
    if(flippedX){
      if(rotated){
        canvas.translate(0, -rect.height/2);
        canvas.scale(1, -1); //左右镜像翻转
        canvas.translate(0, -rect.height/2);
      }else{
        canvas.translate(-rect.width/2, 0);
        canvas.scale(-1, 1); //左右镜像翻转
        canvas.translate(-rect.width/2, 0);
      }
    }

    Rect outputRect = Rect.fromCenter(center:Offset(dstRect.center.dx + offset.dx,dstRect.center.dy + offset.dy), width:dstRect.width * scale,height:dstRect.height * scale);

    /// 精灵矩形边界
    Paint paint = Paint()..color = new Color(0x40FFFFFF); //白色
    //canvas.drawRect(outputRect, paint);

    Paint imagePaint = Paint()..color = Color(0xFFFFFFFF);
    canvas.drawImageRect(this.image, rect.toRect(), outputRect, imagePaint);

    /// 绘制子精灵
    if(children.length > 0){
      children.forEach((element) {
        element.render(canvas);
      });
    }

    /// 画布恢复
    canvas.restore();
  }
}