import 'package:devilf_engine/game/df_game_widget.dart';
import 'package:example/player/player_sprite.dart';
import 'item/item_sprite.dart';
import 'map/map_sprite.dart';
import 'item/item_info.dart';
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

  /// 已掉落在地上的物品
  static List<List<ItemSprite?>>? droppedItemSprite;

  /// 背包物品
  static List<ItemInfo> items = [];

}
