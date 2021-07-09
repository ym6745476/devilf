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
      Size size = const Size(100,30),
    }
  ):super(position:position,size:size);

  @override
  void update(double dt) {
    this.text = Game.fps;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    ui.ParagraphBuilder pb = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          fontStyle: FontStyle.normal,
          fontSize: 14,
        )
    )
    ..pushStyle(ui.TextStyle(color: Colors.white))
    ..addText(this.text);

    ui.ParagraphConstraints pc = ui.ParagraphConstraints(width: size.width);
    ui.Paragraph paragraph = pb.build()..layout(pc);
    canvas.drawParagraph(paragraph, Offset(5,5));

    /// 精灵矩形边界
    var paint = new Paint()..color =  Color(0x20ED1941);
    canvas.drawRect(Rect.fromLTWH(position.x - size.width/2,position.y - size.height/2, size.width, size.height), paint);

    canvas.restore();
  }

}
