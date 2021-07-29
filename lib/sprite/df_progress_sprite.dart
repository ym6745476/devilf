import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// 进度精灵类
class DFProgressSprite extends DFSprite {
  /// 精灵图片
  ui.Image image;

  /// 当前进度
  int progress = 100;

  /// 最大进度
  int maxProgress = 100;

  DFProgressSprite(this.image, {DFSize size = const DFSize(47, 8)}) : super(position: DFPosition(0, 0), size: size);

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.save();

    /// 将子精灵转换为相对坐标
    if (parent == null) {
      canvas.translate(position.x, position.y);
    } else {
      canvas.translate(position.x - parent!.size.width / 2, position.y - parent!.size.height / 2);
    }

    Rect srcRect = Rect.fromLTWH(0, this.size.height + 2, this.size.width, this.size.height);
    Rect dstRect =
        Rect.fromLTWH(-size.width / 2 * scale, -size.height / 2 * scale, size.width * scale, size.height * scale);

    Rect srcRectFill = Rect.fromLTWH(0, 0, this.size.width, this.size.height);
    Rect dstRectFill = Rect.fromLTWH(
        -size.width / 2 * scale, -size.height / 2 * scale, size.width * progress / 100 * scale, size.height * scale);

    /// 绘制图像
    Paint paint = Paint()..color = Color(0xFFFFFFFF);
    canvas.drawImageRect(this.image, srcRect, dstRect, paint);
    canvas.drawImageRect(this.image, srcRectFill, dstRectFill, paint);

    /// 文本内容
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontStyle: FontStyle.normal,
      fontSize: 8,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(progress.toString() + "/" + maxProgress.toString());

    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size.width * scale * 1.5);
    ui.Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(-size.width / 2 * scale * 1.5, -size.height * scale * 2.2));

    canvas.restore();
  }
}
