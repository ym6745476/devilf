import 'dart:ui' as ui;
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 文本精灵类
class DFTextSprite extends DFSprite {
  /// 文本内容
  String text;

  /// 文字大小
  double fontSize;

  /// 文字大小
  Color color;

  /// 更新监听函数
  void Function(double dt)? onUpdate;

  /// 创建文本精灵
  DFTextSprite(this.text,
      {this.fontSize = 14, this.color = const Color(0xFFFFFFFF), DFSize size = const DFSize(100, 20)})
      : super(position: DFPosition(0, 0), size: size);

  /// 更新文本
  @override
  void update(double dt) {
    if (onUpdate != null) {
      onUpdate!(dt);
    }
  }

  /// 设置更新函数
  void setOnUpdate(Function(double dt) onUpdate) {
    this.onUpdate = onUpdate;
  }

  /// 渲染精灵
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 将子精灵转换为相对坐标
    if (parent == null) {
      canvas.translate(position.x, position.y);
    } else {
      canvas.translate(position.x - parent!.size.width / 2, position.y - parent!.size.height / 2);
    }

    /// 文本内容
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontStyle: FontStyle.normal,
      fontSize: this.fontSize,
    ))
      ..pushStyle(ui.TextStyle(color: this.color))
      ..addText(this.text);

    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size.width);
    ui.Paragraph paragraph = pb.build()..layout(pc);

    canvas.drawParagraph(paragraph, Offset(-paragraph.width/2,-paragraph.height/2));

    /// 精灵矩形边界
    ///var paint = new Paint()..color =  Color(0x60000000);
    ///canvas.drawRect(Rect.fromLTWH(-paragraph.width/2,-paragraph.height/2, paragraph.width, paragraph.height), paint);

    ///恢复画布
    canvas.restore();
  }
}
