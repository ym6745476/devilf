import 'dart:ui';
import 'package:devilf_engine/core/df_offset.dart';
import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_size.dart';
import 'package:devilf_engine/game/df_camera.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:devilf_engine/sprite/df_tile_map_sprite.dart';
import 'package:devilf_engine/tiled/df_tile_map.dart';
import 'package:devilf_engine/util/df_audio.dart';
import 'package:devilf_engine/util/df_util.dart';
import 'package:example/item/item_sprite.dart';
import 'package:flutter/cupertino.dart';
import '../game_manager.dart';
import 'map_info.dart';

/// 地图精灵类
class MapSprite extends DFSprite {
  /// 地图
  MapInfo mapInfo;

  /// 地图精灵
  DFTileMapSprite? tileMapSprite;

  /// 摄像机
  DFCamera camera;

  /// 初始化完成
  bool initOk = false;

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
      DFTileMap tileMap = this.tileMapSprite!.tileMap!;

      /// 保存缩放后的tile宽度和高度
      this.mapInfo.scaledWidth = this.mapInfo.width * this.mapInfo.scale;
      this.mapInfo.scaledHeight = this.mapInfo.height * this.mapInfo.scale;
      this.mapInfo.scaledTileWidth = tileMap.tileWidth! * this.mapInfo.scale;
      this.mapInfo.scaledTileHeight = tileMap.tileHeight! * this.mapInfo.scale;

      /// 将block转化为二维数组
      this.mapInfo.blockMap = DFUtil.to2dList(this.tileMapSprite!.blockLayer!.data!, tileMap.width!, 1);

      /// 填充这个列表 后面掉落要用
      GameManager.droppedItemSprite = List.generate(tileMap.height!,(index)=> List.generate(tileMap.width!, (index) => null));

      /// 调用add产生层级关系进行坐标转换
      addChild(this.tileMapSprite!);

      /// 设置跟随限制
      camera.setLimit(DFOffset(this.mapInfo.scaledWidth,this.mapInfo.scaledHeight));

      /// 初始化完成
      this.initOk = true;
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
