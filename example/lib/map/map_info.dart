import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/core/df_rect.dart';
import 'package:devilf_engine/util/df_astar.dart';

/// 地图信息类
class MapInfo {
  /// 名字
  String name = "";

  /// 地图
  String texture = "";

  /// 宽度
  double width = 10;

  /// 高度
  double height = 10;

  /// tile宽度
  double tileWidth = 10;

  /// tile高度
  double tileHeight = 10;

  /// 缩放
  double scale = 1;

  /// 碰撞数据二维数组
  List<List<int>>? blockMap;

  /// 创建地图
  MapInfo(this.name);

  /// 根据瓦片位置获取地图上坐标
  DFPosition getPosition(DFMapPosition mapPosition) {
    return DFPosition(mapPosition.x * tileWidth + tileWidth / 2, mapPosition.y * tileHeight + tileHeight / 2);
  }

  /// 根据地图上坐标获取瓦片位置
  DFMapPosition getMapPosition(DFPosition position) {
    int x = (position.x / tileWidth).floor();
    int y = (position.y / tileHeight).floor();
    return DFMapPosition(x, y);
  }

  /// 获取路径矩形
  DFRect getPathRect(DFMapPosition mapPosition) {
    return DFRect(mapPosition.x * tileWidth, mapPosition.y * tileHeight,tileWidth,tileHeight);
  }
}