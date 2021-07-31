import 'df_group_layer.dart';
import 'df_image_layer.dart';
import 'df_layer_type.dart';
import 'df_map_layer.dart';
import 'df_object_group.dart';
import 'df_tile.dart';
import 'df_tile_layer.dart';
import 'df_tile_set.dart';

/// 瓦片地图
class DFTiledMap {
  String? backgroundColor;
  int? compressionLevel;
  int? height;
  int? hexSideLength;
  bool? infinite;
  List<DFMapLayer>? layers;
  int? nextLayerId;
  int? nextObjectId;
  String? orientation;
  String? renderOrder;
  String? staggerAxis;
  String? staggerIndex;
  String? tiledVersion;
  int? tileHeight;
  List<DFTileSet>? tileSets;
  int? tileWidth;
  String? type;
  double? version;
  int? width;

  DFTiledMap({
    this.compressionLevel,
    this.height,
    this.infinite,
    this.layers,
    this.nextLayerId,
    this.nextObjectId,
    this.orientation,
    this.renderOrder,
    this.tiledVersion,
    this.tileHeight,
    this.tileSets,
    this.tileWidth,
    this.type,
    this.version,
    this.width,
  });

  DFTiledMap.fromJson(Map<String, dynamic> json) {
    compressionLevel = json['compressionlevel'];
    height = json['height'];
    infinite = json['infinite'];
    if (json['layers'] != null) {
      layers = <DFMapLayer>[];
      json['layers'].forEach((v) {
        if (v['type'] == DFLayerType.tileLayer) {
          layers?.add(DFTileLayer.fromJson(v));
        } else if (v['type'] == DFLayerType.objectGroup) {
          layers?.add(DFObjectGroup.fromJson(v));
        } else if (v['type'] == DFLayerType.imageLayer) {
          layers?.add(DFImageLayer.fromJson(v));
        } else if (v['type'] == DFLayerType.group) {
          layers?.add(DFGroupLayer.fromJson(v));
        } else {
          layers?.add(DFMapLayer.fromJson(v));
        }
      });
    }
    nextLayerId = json['nextlayerid'];
    nextObjectId = json['nextobjectid'];
    orientation = json['orientation'];
    renderOrder = json['renderorder'];
    tiledVersion = json['tiledversion'];
    tileHeight = json['tileheight'];
    if (json['tilesets'] != null) {
      tileSets = <DFTileSet>[];
      json['tilesets'].forEach((v) {
        tileSets?.add(DFTileSet.fromJson(v));
      });
    }
    tileWidth = json['tilewidth'];
    type = json['type'];
    version = double.tryParse(json['version'].toString()) ?? 0.0;
    width = json['width'];
    backgroundColor = json['backgroundcolor'];
    hexSideLength = json['hexsidelength'];
    staggerAxis = json['staggeraxis'];
    staggerIndex = json['staggerindex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['compressionlevel'] = this.compressionLevel;
    data['height'] = this.height;
    data['infinite'] = this.infinite;
    if (this.layers != null) {
      data['layers'] = this.layers?.map((v) => v.toJson()).toList();
    }
    data['nextlayerid'] = this.nextLayerId;
    data['nextobjectid'] = this.nextObjectId;
    data['orientation'] = this.orientation;
    data['renderorder'] = this.renderOrder;
    data['tiledversion'] = this.tiledVersion;
    data['tileheight'] = this.tileHeight;
    if (this.tileSets != null) {
      data['tilesets'] = this.tileSets?.map((v) => v.toJson()).toList();
    }
    data['tilewidth'] = this.tileWidth;
    data['type'] = this.type;
    data['version'] = this.version;
    data['width'] = this.width;
    return data;
  }
}
