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

  /// 更新监听函数
  void Function(double dt)? onUpdate;

  /// 创建文本精灵
  DFTextSprite(this.text, {DFSize size = const DFSize(100, 30)}) : super(position: DFPosition(0, 0), size: size);

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
      fontSize: 14,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(this.text);

    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size.width);
    ui.Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(5, 5));

    /// 精灵矩形边界
    //var paint = new Paint()..color =  Color(0x60000000);
    //canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    ///恢复画布
    canvas.restore();
  }
}
