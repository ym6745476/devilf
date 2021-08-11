import 'dart:ui';
import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_size.dart';
import 'package:devilf_engine/game/df_camera.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:devilf_engine/sprite/df_tile_map_sprite.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:flutter/cupertino.dart';
import 'map_info.dart';

/// 地图精灵类
class MapSprite extends DFSprite {
  /// 地图
  MapInfo mapInfo;

  /// 地图精灵
  DFTileMapSprite? tileMapSprite;

  /// 摄像机
  DFCamera camera;

  /// 是否初始化
  bool isInit = false;

  MapSprite(
    this.mapInfo, {
    required this.camera,
    DFSize size = const DFSize(48, 32),
  }) : super(position: DFPosition(0, 0), size: size) {
    _init();
  }

  /// 初始化
  Future<void> _init() async {
    await Future.delayed(Duration.zero, () async {
      print("读取地图：" + this.mapInfo.texture);
      this.tileMapSprite = await DFTileMapSprite.load(this.mapInfo.texture, this.mapInfo.scale);
      /// 保存缩放后的tile宽度个高度
      this.mapInfo.tileWidth = this.tileMapSprite!.tileMap!.tileWidth! * this.mapInfo.scale;
      this.mapInfo.tileHeight = this.tileMapSprite!.tileMap!.tileHeight! * this.mapInfo.scale;
      /// 将block转化为二维数组
      this.mapInfo.blockMap = DFUtil.to2dList(this.tileMapSprite!.blockLayer!.data!, this.tileMapSprite!.tileMap!.width!, 1);

      /// 调用add产生层级关系进行坐标转换
      addChild(this.tileMapSprite!);

      /// 初始化完成
      this.isInit = true;
    });
  }

  @override
  void update(double dt) {
    this.tileMapSprite?.updateLayer(camera);
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
