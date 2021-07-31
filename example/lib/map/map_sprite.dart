import 'dart:ui';

import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/sprite/df_tiled_sprite.dart';
import 'package:flutter/cupertino.dart';

/// 地图精灵类
class MapSprite extends DFSprite {
  /// 名字
  String name = "";

  /// 地图文件
  String map = "";

  DFTiledSprite? tiledSprite;

  /// 是否初始化
  bool isInit = false;

  MapSprite(
    this.name, {
    this.map = "",
    DFSize size = const DFSize(48, 32),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    await Future.delayed(Duration.zero, () async {

      print("读取地图：" + map);
      this.tiledSprite = await DFTiledSprite.load(map);

      /// 调用add产生层级关系进行坐标转换
      addChild(this.tiledSprite!);

      /// 初始化完成
      this.isInit = true;
    });
  }

  @override
  void update(double dt) {
    if (this.tiledSprite == null) {
      return;
    }
    this.tiledSprite?.update(dt);
  }

  @override
  void render(Canvas canvas) {
    canvas.save();

    /// 移动位置
    canvas.translate(position.x, position.y);

    /// 绘制子精灵
    this.children.forEach((sprite) {
      if (sprite.visible) {
        sprite.render(canvas);
      }
    });
    canvas.restore();
  }
}
