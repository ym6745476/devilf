import 'dart:math';

import 'package:devilf/base/cache.dart';
import 'package:devilf/base/position.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

/// 图片精灵类
class ImageSprite extends Sprite {

  /// 精灵图片
  ui.Image image;

  ImageSprite(this.image,
      {
        Position position = const Position(0, 0),
        Size size = const Size(64, 64),
      }) :super(position: position, size: size);


  /// 加载图片资源
  static Future<ImageSprite> load(String src) async {
    ui.Image image = await Cache.loadImage(src);
    return ImageSprite(image);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.save();
    canvas.translate(position.x, position.y);
    canvas.rotate(pi * 2 * this.angle);

    Size srcSize = Size(image.width.toDouble(), image.height.toDouble());
    Rect dstRect = Rect.fromLTWH(-size.width/2, -size.height/2, size.width, size.height);
    // 根据适配模式，计算适合的缩放尺寸
    FittedSizes fittedSizes = applyBoxFit(BoxFit.cover, srcSize, dstRect.size);
    // 获得一个图片区域中，指定大小的，居中位置处的 Rect
    Rect inputRect = Alignment.center.inscribe(fittedSizes.source, Offset.zero & srcSize);
    // 获得一个绘制区域内，指定大小的，居中位置处的 Rect
    Rect outputRect = Alignment.center.inscribe(fittedSizes.destination, dstRect);
    Paint paint = Paint()..color = Color(0xFFFFFFFF);
    canvas.drawImageRect(this.image, inputRect, outputRect, paint);
    canvas.restore();
  }
}