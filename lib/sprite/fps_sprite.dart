import 'dart:ui' as ui;
import 'package:devilf/base/position.dart';
import 'package:devilf/game/game.dart';
import 'package:devilf/sprite/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 帧数精灵类
class FpsSprite extends Sprite{

  // 文本
  String text;

  FpsSprite(this.text,
    {
      Position position = const Position(0,0),
      Size size = const Size(64,64),
    }
  ):super(position:position,size:size);

  @override
  void update(double dt) {
    this.text = Game.fps;
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    canvas.translate(this.position.x, this.position.y);
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
