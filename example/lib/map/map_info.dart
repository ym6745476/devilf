
/// 地图信息类
class MapInfo {
  /// 名字
  String name = "";

  /// 地图
  String texture = "";

  /// 宽度
  int width = 10;

  /// 高度
  int height = 10;

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
}