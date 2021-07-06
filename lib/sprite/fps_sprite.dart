import 'dart:ui' as ui;
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 帧数精灵类
class FpsSprite extends Sprite{

  String text;

  FpsSprite(this.text,
  {
    double x = 0,
    double y = 0,
  }
  ):super(x:x,y:y);

  void setText(String text) {
    this.text = text;
  }

  @override
  void update(double dt) {

  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(this.x, this.y);
    var size = 200.0;
    ui.ParagraphBuilder pb = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontStyle: FontStyle.normal,
      fontSize: 14,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(this.text);
    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size);
    ui.Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(5, 5));

    canvas.restore();
  }

}
