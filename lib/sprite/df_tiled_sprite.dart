import 'dart:collection';
import 'dart:ui';
import 'package:devilf/game/df_animation.dart';
import 'package:devilf/game/df_assets_loader.dart';
import 'package:devilf/game/df_camera.dart';
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

  /// 摄像机位置
  DFPosition? cameraPosition;

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
    tiledSprite.scale = 0.35;
    return tiledSprite;
  }

  /// 更细地图瓦片
  Future<void> updateLayer(DFCamera camera) async {

    if (this.tiledMap == null) return;

    /// 上一下刷新时摄像机的位置
    if(this.cameraPosition != null){
      if((this.cameraPosition!.x - camera.sprite!.position.x).abs() < 240 * scale && (this.cameraPosition!.y - camera.sprite!.position.y).abs() < 256 * scale){
        return;
      }
    }
    /// 保存上一下刷新时摄像机的位置
    this.cameraPosition = DFPosition(camera.sprite!.position.x,camera.sprite!.position.y);
    double drawX = camera.sprite!.position.x - camera.rect.width/2;
    double drawY = camera.sprite!.position.y - camera.rect.height/2;

    /// 可视区域
    DFRect visibleRect = DFRect(drawX,drawY, camera.rect.width, camera.rect.height);
    /// print("visibleRect:" + visibleRect.toString());

    /// 将全部的瓦片设置为不可见
    sprites.forEach((element) {
      element.visible = false;
    });

    /// 遍历图层
    await Future.forEach<DFMapLayer>(this.tiledMap!.layers ?? [], (layer) async {
      if (layer.visible != true) return;

      if (layer is DFTileLayer) {
        if (layer.visible != true) return;

        await Future.forEach<int>(layer.data ?? [], (tile) async {
          if (tile != 0) {

            DFTileSet? findTileSet = tiledMap?.tileSets?.lastWhere((tileSet) {
              return tileSet.firsTgId != null && tile >= tileSet.firsTgId!;
            });
            int firstGid = findTileSet!.firsTgId ?? 0;
            double tileWidth = findTileSet.tileWidth!.toDouble() ;
            double tileHeight = findTileSet.tileHeight!.toDouble();
            int columnCount = (tiledMap!.width! * tiledMap!.tileWidth!) ~/ tileWidth;
            int row = _getY((tile - firstGid), columnCount).toInt();
            int column = _getX((tile - firstGid), columnCount).toInt();
            //print("row:" + row.toString() + ",column:" + column.toString() + ",scale:" + this.scale.toString());
            Rect tileRect = Rect.fromLTWH(column * tileWidth * this.scale, row * tileHeight * this.scale, tileWidth * this.scale, tileHeight * this.scale);
            //print("tileRect:" + tileRect.toString());
            /// 在可视区域的瓦片设置为显示
            if(visibleRect.toRect().overlaps(tileRect)){
              DFImageSprite? imageSprite = existImageSprite(row,column);
              if(imageSprite == null){
                imageSprite = await getTileImageSprite(findTileSet,tile - firstGid,row,column);
                sprites.add(imageSprite);
              }else{
                imageSprite.visible = true;
              }
            }
          }
        });

      }else if (layer is DFObjectGroup) {

      }else if (layer is DFGroupLayer) {

      }

    });

    /// 删除不可见的精灵
    sprites.removeWhere((element) => !element.visible);
  }

  /// 获取存在的精灵
  DFImageSprite? existImageSprite(int row,int column){
    for (DFImageSprite sprite in sprites) {
      if(row.toString() + "," + column.toString() == sprite.key){
        return sprite;
      }
    }
    return null;
  }

  /// 获取瓦片精灵的某个瓦片
  Future<DFImageSprite> getTileImageSprite(DFTileSet tileSet,int tileIndex, int row,int column) async {

    ///print("index:" + index.toString());

    List<DFTile>? tiles = tileSet.tiles;
    DFTile? tile;
    String imagePath = this.path + "/";
    double tileWidth = tileSet.tileWidth!.toDouble() ;
    double tileHeight = tileSet.tileHeight!.toDouble();
    double imageWidth = 0;
    double imageHeight = 0;

    if (tiles != null) {
      tile = tiles[tileIndex];
      imageWidth = tile.imageWidth!.toDouble() ;
      imageHeight = tile.imageHeight!.toDouble();
      imagePath = this.path + "/" + tile.image!;
      print(imagePath);
    }else{
      imageWidth = tileSet.imageWidth!.toDouble() ;
      imageHeight = tileSet.imageHeight!.toDouble();
      imagePath = this.path + "/" + tileSet.image!;
    }

    /// "image":"lxd/1000_5#960_1024_480_512.jpg",
    ui.Image image = await DFAssetsLoader.loadImage(imagePath);
    DFImageSprite sprite = DFImageSprite(
      image,
      rect: DFRect(0, 0, imageWidth, imageHeight),
      rotated: false,
    );
    sprite.scale = scale;
    sprite.position =  DFPosition(column * tileWidth * scale + tileWidth/2 * scale ,row * tileHeight * scale + tileHeight/2 * scale);
    sprite.key = row.toString() + "," + column.toString();
    return sprite;
  }

  /// 获取列
  double _getX(int index, int width) {
    return (index % width).toDouble();
  }

  /// 获取行
  double _getY(int index, int width) {
    return (index / width).floor().toDouble();
  }

  /// 精灵更新
  @override
  void update(double dt) {

  }

  /// 精灵渲染
  @override
  void render(Canvas canvas) {
    /// 画布暂存
    canvas.save();

    /// 将子精灵转换为相对坐标
    canvas.translate(position.x, position.y);

    if (this.sprites.length > 0){
      this.sprites.forEach((sprite) {
        sprite.render(canvas);
      });
    }

    /// 精灵矩形边界
    /*if(this.cameraPosition!=null){
      var paint = new Paint()..color = Color(0x6000FF00);
      DFRect visibleRect = DFRect(this.cameraPosition!.x - 50,this.cameraPosition!.y -50, 100, 100);
      canvas.drawRect(visibleRect.toRect(), paint);
    }*/

    /// 画布恢复
    canvas.restore();
  }
}
