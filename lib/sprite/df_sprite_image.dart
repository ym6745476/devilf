import 'dart:math';

import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import '../game/df_math_offset.dart';
import '../game/df_math_rect.dart';
import '../game/df_math_size.dart';

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
  DFImageSprite(
    this.image, {
    DFSize size = const DFSize(64, 64),
    this.rect = const DFRect(0, 0, 64, 64),
    this.offset = const DFOffset(0, 0),
    this.rotated = false,
    this.flippedX = false,
    this.scale = 1,
  }) : super(position: DFPosition(0, 0), size: size);

  /// 加载图片资源
  static Future<DFImageSprite> load(String src) async {
    ui.Image image = await DFAssetsLoader.loadImage(src);
    return DFImageSprite(image);
  }

  /// 精灵渲染
  /// 代码没几行,坐标计算有点复杂
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 目标位置
    Rect dstRect;

    if (rotated) {
      /// 将子精灵转换为相对坐标
      if (parent == null) {
        canvas.translate(position.y, position.x);
      } else {
        canvas.translate(position.y - parent!.size.height / 2, position.x - parent!.size.width / 2);
      }

      /// 针对json中的图像旋转
      canvas.rotate(-90 * pi / 180); //弧度

      //Paint paint1 = Paint()..color = new Color(0x40FFFFFF); //白色
      //canvas.drawRect(Rect.fromLTWH(0,0, size.width, size.height), paint1);

      dstRect = Rect.fromCenter(
          center: Offset(0, 0), width: rect.width * scale, height: rect.height * scale);

      //Paint paint2 = Paint()..color = Color(0x60444693);
      //canvas.drawRect(outputRect, paint2);

    } else {
      /// 将子精灵转换为相对坐标
      if (parent == null) {
        canvas.translate(position.x, position.y);
      } else {
        canvas.translate(position.x - parent!.size.width / 2, position.y - parent!.size.height / 2);
      }
      canvas.rotate(this.angle * pi / 180); //弧度

      //Paint paint3 = Paint()..color = new Color(0x40FFFFFF); //白色
      //canvas.drawRect(Rect.fromLTWH(0,0, size.width, size.height), paint3);

      dstRect = Rect.fromCenter(
          center: Offset(0, -rect.height / 2),
          width: rect.width * scale,
          height: rect.height * scale);

      //Paint paint4 = Paint()..color = Color(0x60444693);
      //canvas.drawRect(outputRect, paint4);
    }

    /// 水平镜像
    if (flippedX) {
      if (rotated) {
        canvas.scale(1, -1); //左右镜像翻转
      } else {
        canvas.scale(-1, 1); //左右镜像翻转
      }
    }

    /// 目标绘制位置
    if (rotated) {
      dstRect = Rect.fromCenter(
          center: Offset(offset.dx, offset.dy), width: rect.width, height: rect.height);
    } else {
      dstRect = Rect.fromCenter(
          center: Offset(offset.dx, -offset.dy), width: rect.width, height: rect.height);
    }

    /// 处理缩放
    Rect outputRect = Rect.fromCenter(
        center: Offset(dstRect.center.dx * scale, dstRect.center.dy * scale),
        width: dstRect.width * scale,
        height: dstRect.height * scale);

    /// 绘制图像
    Paint paint5 = Paint()..color = Color(0xFFFFFFFF);
    //canvas.drawRect(outputRect, paint5);
    canvas.drawImageRect(this.image, rect.toRect(), outputRect, paint5);

    /// 绘制子精灵
    if (children.length > 0) {
      children.forEach((element) {
        element.render(canvas);
      });
    }

    /// 画布恢复
    canvas.restore();
  }
}
