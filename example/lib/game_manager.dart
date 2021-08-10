import 'package:devilf/game/df_game_widget.dart';
import 'package:devilf/tiled/df_tiled_map.dart';
import 'package:devilf/util/df_astar.dart';
import 'package:example/player/player_sprite.dart';
import 'map/map_sprite.dart';
import 'monster/monster_sprite.dart';

/// 游戏管理器
class GameManager {

  /// 可见区域宽度
  static double visibleWidth = 960;

  /// 可见区域高度
  static double visibleHeight = 640;

  /// 游戏组件
  static DFGameWidget? gameWidget;

  /// 地图精灵
  static MapSprite? mapSprite;

  /// 玩家精灵
  static PlayerSprite? playerSprite;

  /// 怪物精灵
  static List<MonsterSprite>? monsterSprites;

  /// 自动战斗是否开启
  static bool isAutoFight = false;

  /// 规划路径
  static Future<void> planPath(DFAStar aStar,DFNode startNode, DFNode endNode) async {
    DFTiledMap tiledMap = GameManager.mapSprite!.tiledSprite!.tiledMap!;
    List<int> blockData = GameManager.mapSprite!.tiledSprite!.blockLayer!.data!;

    /// 二维数组的地图
    int rowCount = tiledMap.height!;
    int columnCount = tiledMap.width!;

    List<List<int>>? maps = List.filled(rowCount, List.filled(columnCount, 0));
    /// print(maps.length.toString() + "," + maps[0].length.toString());
    for (int i = 0; i < blockData.length; i++) {
      int row = (i / columnCount).floor().toInt();
      int column = (i % columnCount).toInt();

      /// print("row:" + row.toString() + ",column:" + column.toString());
      if (blockData[i] != 0) {
        maps[row][column] = 1;
      } else {
        maps[row][column] = 0;
      }
    }
    print("起点:" + startNode.toString() + "->终点：" + endNode.toString());
    DFMap map = DFMap(maps, maps[0].length, maps.length, startNode, endNode);
    aStar.start(map);
    /// 删掉起点
    aStar.pathList.removeLast();
    /*for (DFCoord point in aStar.pathList) {
      print(point.toString());
    }*/
  }
}
