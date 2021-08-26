import 'dart:math';
import 'dart:ui';
import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_size.dart';
import 'package:devilf_engine/sprite/df_image_sprite.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:devilf_engine/sprite/df_text_sprite.dart';
import 'package:flutter/cupertino.dart';

import 'item_info.dart';

/// 物品精灵类
class ItemSprite extends DFSprite {
  /// 物品
  ItemInfo item;

  /// 图像
  DFImageSprite? imageSprite;

  /// 名字
  DFTextSprite? nameSprite;

  /// 初始化完成
  bool initOk = false;

  /// 创建物品精灵
  ItemSprite(
    this.item, {
    DFSize size = const DFSize(30, 30),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    try {
      await Future.delayed(Duration.zero, () async {
        /// 图像
        this.imageSprite = await DFImageSprite.load(this.item.icon!);
        this.imageSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.imageSprite!.scale = 0.4;
        addChild(this.imageSprite!);

        /// 名字
        this.nameSprite = DFTextSprite(this.item.name, fontSize: 10);
        this.nameSprite!.position = DFPosition(size.width / 2, size.height / 2);
        this.nameSprite!.setOnUpdate((dt) {});
        addChild(this.nameSprite!);

        /// 初始化完成
        this.initOk = true;
      });
    } catch (e) {
      print('(ItemSprite _init) Error: $e');
    }
  }

  @override
  void update(double dt) {}

  @override
  void render(Canvas canvas) {
    canvas.save();

    /// 移动画布
    canvas.translate(position.x, position.y);

    /// 绘制子精灵
    if (this.visible) {
      this.children.forEach((sprite) {
        if (sprite.visible) {
          sprite.render(canvas);
        }
      });
    }

    canvas.restore();
  }
}
