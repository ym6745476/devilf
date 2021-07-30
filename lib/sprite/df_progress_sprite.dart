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

  /// 显示进度文本
  bool showText;

  /// 文本位置
  DFGravity gravity;

  /// 文本位置偏移
  double textOffset;

  /// 创建
  DFProgressSprite(this.image,
      {this.showText = true, this.gravity = DFGravity.center, this.textOffset = 0, DFSize size = const DFSize(47, 8)})
      : super(position: DFPosition(0, 0), size: size);

  /// 精灵更新
  @override
  void update(double dt) {}

  /// 精灵渲染
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

    /// 精灵矩形边界
    ///var paint5 = new Paint()..color =  Color(0x60000000);
    ///canvas.drawRect(Rect.fromLTWH(-paragraph.width/2,-paragraph.height/2, paragraph.width, paragraph.height), paint5);

    if (this.gravity == DFGravity.top) {
      canvas.drawParagraph(paragraph, Offset(-paragraph.width / 2, -paragraph.height - textOffset));
    } else if (this.gravity == DFGravity.center) {
      canvas.drawParagraph(paragraph, Offset(-paragraph.width / 2, -paragraph.height / 2));
    }

    canvas.restore();
  }
}
