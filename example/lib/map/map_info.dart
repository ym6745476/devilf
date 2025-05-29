import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_rect.dart';

/// 地图信息类
class MapInfo {
  /// 名字
  String name = "";

  /// 地图
  String texture = "";

  /// 宽度
  double width = 1;

  /// 高度
  double height = 1;

  /// 宽度
  double scaledWidth = 1;

  /// 高度
  double scaledHeight = 1;

  /// tile宽度
  double tileWidth = 48;

  /// tile高度
  double tileHeight = 32;

  /// 宽度
  double scaledTileWidth = 1;

  /// 高度
  double scaledTileHeight = 1;

  /// 缩放
  double scale = 1;

  /// 碰撞数据二维数组
  List<List<int>>? blockMap;

  /// 创建地图
  MapInfo(this.name);

  /// 根据瓦片位置获取地图上坐标
  DFPosition getPosition(DFTilePosition position) {
    return DFPosition(position.x * scaledTileWidth + scaledTileWidth / 2, position.y * scaledTileHeight + scaledTileHeight / 2);
  }

  /// 根据地图上坐标获取瓦片位置
  DFTilePosition getTilePosition(DFPosition position) {
    int x = (position.x / scaledTileWidth).floor();
    int y = (position.y / scaledTileHeight).floor();
    return DFTilePosition(x, y);
  }

  /// 获取路径矩形
  DFRect getPathRect(DFTilePosition position) {
    return DFRect(position.x * scaledTileWidth, position.y * scaledTileHeight,scaledTileWidth,scaledTileHeight);
  }
}