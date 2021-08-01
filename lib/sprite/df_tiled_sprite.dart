import 'dart:collection';
import 'dart:ui';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_math_offset.dart';
import 'package:devilf/game/df_math_position.dart';
import 'package:devilf/game/df_math_rect.dart';
import 'package:devilf/game/df_math_size.dart';
import 'package:devilf/sprite/df_sprite.dart';
import 'package:devilf/tiled/df_group_layer.dart';
import 'package:devilf/tiled/df_map_layer.dart';
import 'package:devilf/tiled/df_object_group.dart';
import 'package:devilf/tiled/df_tile.dart';
import 'package:devilf/tiled/df_tile_layer.dart';
import 'package:devilf/tiled/df_tile_set.dart';
import 'package:devilf/tiled/df_tiled_map.dart';
import 'dart:ui' as ui;

import 'df_image_sprite.dart';

/// 瓦片精灵
class DFTiledSprite extends DFSprite {
  /// 资源路径
  String path = "";

  /// 地图数据
  DFTiledMap? tiledMap;

  /// 需要绘制的瓦片
  List<DFImageSprite> sprites = [];

  /// 创建瓦片精灵
  DFTiledSprite({
    DFSize size = const DFSize(100, 100),
  }) : super(position: DFPosition(0, 0), size: size);

  /// 读取tiled导出的json文件
  static Future<DFTiledSprite> load(String json) async {
    DFTiledSprite tiledSprite = DFTiledSprite();
    Map<String, dynamic> jsonMap = await DFAssetsLoader.loadJson(json);
    tiledSprite.tiledMap = DFTiledMap.fromJson(jsonMap);
    tiledSprite.path = json.substring(0, json.lastIndexOf("/"));
    if (tiledSprite.tiledMap != null) {
      await Future.forEach<DFMapLayer>(tiledSprite.tiledMap!.layers ?? [], (layer) async {
        await tiledSprite.loadLayer(layer);
      });
    }

    return tiledSprite;
  }

  Future<void> loadLayer(DFMapLayer layer) async {
    if (layer.visible != true) return;

    if (layer is DFTileLayer) {
      if (layer.visible != true) return;

      await Future.forEach<int>(layer.data ?? [], (tile) async {
        if (tile != 0) {
            DFImageSprite imageSprite = await getTileImageSprite(tile);
            sprites.add(imageSprite);
        }
      });
    }

    if (layer is DFObjectGroup) {
      //_addObjects(layer);
    }

    if (layer is DFGroupLayer) {
      await Future.forEach<DFMapLayer>(layer.layers ?? [], (subLayer) async {
        await loadLayer(subLayer);
      });
    }
  }

  Future<DFImageSprite> getTileImageSprite(int index) async {
    String _pathTileset = '';

    DFTileSet? findTileSet = tiledMap?.tileSets?.lastWhere((tileSet) {
      return tileSet.tiles != null &&
          tileSet.firsTgId != null &&
          index >= tileSet.firsTgId!;
    });

    List<DFTile>? tiles = findTileSet!.tiles;
    DFTile? tile;
    double tileWidth = 480;
    double tileHeight = 512;
    int firstGid = 0;
    int row = 0;
    int column = 0;
    String imagePath = this.path + "/" + _pathTileset + "";
    double scale = 0.3;

    if (tiles != null) {
      firstGid = findTileSet.firsTgId ?? 0;
      tile = tiles[index - firstGid];
      tileWidth = findTileSet.tileWidth!.toDouble() ;
      tileHeight = findTileSet.tileHeight!.toDouble();

      int columnCount = (tiledMap!.width! * tiledMap!.tileWidth!) ~/ tileWidth;
      print("columnCount:" + columnCount.toString());

      /// 行列
      row = _getY((index - firstGid), columnCount).toInt();
      column = _getX((index - firstGid), columnCount).toInt();
      ///print("index:" + index.toString());
      ///print("row:" + row.toString() + ",column:" + column.toString());

      imagePath = this.path + "/" + _pathTileset + tile.image!;
      ///print(imagePath);
    }

    /// "image":"lxd/1000_5#960_1024_480_512.jpg",
    ui.Image image = await DFAssetsLoader.loadImage(imagePath);
    DFImageSprite sprite = DFImageSprite(
      image,
      rect: DFRect(0, 0, tile!.imageWidth!.toDouble(), tile.imageHeight!.toDouble()),
      rotated: false,
    );
    sprite.scale = scale;
    sprite.position =  DFPosition(column * tileWidth * scale + tileWidth/2 * scale ,row * tileHeight * scale + tileHeight/2 * scale);
    return sprite;
  }


  double _getX(int index, int width) {
    return (index % width).toDouble();
  }

  double _getY(int index, int width) {
    return (index / width).floor().toDouble();
  }

  /// 精灵更新
  @override
  void update(double dt) {
    /// 控制动画帧切换
  }

  /// 精灵渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 将子精灵转换为相对坐标
    canvas.translate(position.x, position.y);

    /// 精灵矩形边界
    //var paint = new Paint()..color = Color(0x6000FF00);
    //canvas.drawRect(Rect.fromLTWH(- size.width/2,- size.height/2, size.width, size.height), paint);

    if (this.sprites.length > 0){
      this.sprites.forEach((sprite) {
        sprite.render(canvas);
      });
    }
    /// 画布恢复
    canvas.restore();
  }
}
