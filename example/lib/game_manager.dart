import 'dart:math';

import 'package:devilf_engine/core/df_position.dart';
import 'package:devilf_engine/game/df_game_widget.dart';
import 'package:devilf_engine/sprite/df_sprite.dart';
import 'package:example/player/player_sprite.dart';
import 'effect/effect_info.dart';
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

  /// 计算物品掉落点
  static DFTilePosition? findDropPosition(DFTilePosition position, int radius) {
    DFTilePosition? foundPosition;
    int mapX = position.x;
    int mapY = position.y;

    /// 往外圈找位置
    List<DFTilePosition> positions = [
      DFTilePosition(mapX, mapY - radius),
      DFTilePosition(mapX + radius, mapY - radius),
      DFTilePosition(mapX + radius, mapY),
      DFTilePosition(mapX + radius, mapY + radius),
      DFTilePosition(mapX, mapY + radius),
      DFTilePosition(mapX - radius, mapY + radius),
      DFTilePosition(mapX - radius, mapY),
      DFTilePosition(mapX - radius, mapY - radius)
    ];

    if (GameManager.droppedItemSprite != null) {
      for (DFTilePosition position in positions) {
        if (GameManager.droppedItemSprite![position.y][position.x] == null) {
          foundPosition = position;
        }
      }
    }
    if (foundPosition == null && radius < 10) {
      return findDropPosition(position, radius + 3);
    } else {
      return foundPosition;
    }
  }

  /// 计算伤害
  static int damageHp(DFSprite fromSprite, DFSprite toSprite, EffectInfo effect) {
    int hp = 1;

    /// 随机伤害  0.0~1.0
    var random = Random();
    Map<String,int> property = getPropertyIncrease(fromSprite);
    if (fromSprite is PlayerSprite) {
      int newMinAt = fromSprite.player.minAt + property["minAt"]!;
      int newMaxAt = fromSprite.player.maxAt + property["maxAt"]!;

      int newMinMt = fromSprite.player.minMt + property["minMt"]!;
      int newMaxMt = fromSprite.player.maxMt + property["maxMt"]!;

      newMaxAt = (newMaxAt * random.nextDouble()).round();
      newMaxMt = (newMaxMt * random.nextDouble()).round();
      int at = newMinAt > newMaxAt ? newMinAt : newMaxAt;
      int mt = newMinMt > newMaxMt ? newMinMt : newMaxMt;

      if (toSprite is MonsterSprite) {

        Map<String,int> property2 = getPropertyIncrease(fromSprite);

        int newMinDf = toSprite.monster.minDf + property2["minDf"]!;
        int newMaxDf = toSprite.monster.maxDf + property2["maxDf"]!;

        int newMinMf = toSprite.monster.minMf + property2["minMf"]!;
        int newMaxMf = toSprite.monster.maxMf + property2["maxMf"]!;

        newMaxDf = (newMaxDf * random.nextDouble()).round();
        newMaxMf = (newMaxMf * random.nextDouble()).round();

        int df = newMinDf > newMaxDf ? newMinDf : newMaxAt;
        double damageAt = at * effect.at - df;

        int mf = newMinMf > newMaxMf ? newMinMf : newMaxMf;
        double damageMt = mt * effect.mt - mf;

        double totalDamage = damageAt + damageMt;
        if (totalDamage <= 0) {
          totalDamage = 1;
        }

        /// 真实伤害数值 攻击力 - 防御力 * 0.35
        hp = (totalDamage * 0.35 + 0.5).floor();
      }
    } else if (fromSprite is MonsterSprite) {
      int newMinAt = fromSprite.monster.minAt + property["minAt"]!;
      int newMaxAt = fromSprite.monster.maxAt + property["maxAt"]!;

      int newMinMt = fromSprite.monster.minMt + property["minMt"]!;
      int newMaxMt = fromSprite.monster.maxMt + property["maxMt"]!;

      newMaxAt = (newMaxAt * random.nextDouble()).round();
      newMaxMt = (newMaxMt * random.nextDouble()).round();
      int at = newMinAt > newMaxAt ? newMinAt : newMaxAt;
      int mt = newMinMt > newMaxMt ? newMinMt : newMaxMt;

      if (toSprite is PlayerSprite) {
        Map<String,int> property2 = getPropertyIncrease(fromSprite);

        int newMinDf = toSprite.player.minDf + property2["minDf"]!;
        int newMaxDf = toSprite.player.maxDf + property2["maxDf"]!;

        int newMinMf = toSprite.player.minMf + property2["minMf"]!;
        int newMaxMf = toSprite.player.maxMf + property2["maxMf"]!;

        newMaxDf = (newMaxDf * random.nextDouble()).round();
        newMaxMf = (newMaxMf * random.nextDouble()).round();

        int df = newMinDf > newMaxDf ? newMinDf : newMaxAt;
        double damageAt = at * effect.at - df;

        int mf = newMinMf > newMaxMf ? newMinMf : newMaxMf;
        double damageMt = mt * effect.mt - mf;

        double totalDamage = damageAt + damageMt;
        if (totalDamage <= 0) {
          totalDamage = 1;
        }

        /// 真实伤害数值 攻击力 - 防御力 * 0.35
        hp = (totalDamage * 0.35 + 0.5).floor();
      }
    }
    return hp;
  }

  /// 获取装备增加的加成
  static Map<String,int> getPropertyIncrease(DFSprite sprite){
    Map<String,int> map = {};
    map["maxHp"] = 0;
    map["maxMp"] = 0;
    map["minAt"] = 0;
    map["maxAt"] = 0;
    map["minMt"] = 0;
    map["maxMt"] = 0;
    map["minDf"] = 0;
    map["maxDf"] = 0;
    map["minMf"] = 0;
    map["maxMf"] = 0;
    if (sprite is PlayerSprite) {

      /// 计算穿戴防御
      if (sprite.player.clothes != null) {
        ItemInfo itemInfo = sprite.player.clothes!;
        map["maxHp"] = map["maxHp"]! + itemInfo.hp;
        map["maxMp"] = map["maxMp"]! + itemInfo.mp;
        map["minAt"] = map["minAt"]! + itemInfo.minAt;
        map["maxAt"] = map["maxAt"]! + itemInfo.maxAt;
        map["minMt"] = map["minMt"]! + itemInfo.minMt;
        map["maxMt"] = map["maxMt"]! + itemInfo.maxMt;
        map["minDf"] = map["minDf"]! + itemInfo.minDf;
        map["maxDf"] = map["maxDf"]! + itemInfo.maxDf;
        map["minMf"] = map["minMf"]! + itemInfo.minMf;
        map["maxMf"] = map["maxMf"]! + itemInfo.maxMf;
      }

      if (sprite.player.weapon != null) {
        ItemInfo itemInfo = sprite.player.weapon!;
        map["maxHp"] = map["maxHp"]! + itemInfo.hp;
        map["maxMp"] = map["maxMp"]! + itemInfo.mp;
        map["minAt"] = map["minAt"]! + itemInfo.minAt;
        map["maxAt"] = map["maxAt"]! + itemInfo.maxAt;
        map["minMt"] = map["minMt"]! + itemInfo.minMt;
        map["maxMt"] = map["maxMt"]! + itemInfo.maxMt;
        map["minDf"] = map["minDf"]! + itemInfo.minDf;
        map["maxDf"] = map["maxDf"]! + itemInfo.maxDf;
        map["minMf"] = map["minMf"]! + itemInfo.minMf;
        map["maxMf"] = map["maxMf"]! + itemInfo.maxMf;
      }
    }else if(sprite is MonsterSprite){
      /// 计算穿戴防御
      if (sprite.monster.clothes != null) {
        ItemInfo itemInfo = sprite.monster.clothes!;
        map["maxHp"] = map["maxHp"]! + itemInfo.hp;
        map["maxMp"] = map["maxMp"]! + itemInfo.mp;
        map["minAt"] = map["minAt"]! + itemInfo.minAt;
        map["maxAt"] = map["maxAt"]! + itemInfo.maxAt;
        map["minMt"] = map["minMt"]! + itemInfo.minMt;
        map["maxMt"] = map["maxMt"]! + itemInfo.maxMt;
        map["minDf"] = map["minDf"]! + itemInfo.minDf;
        map["maxDf"] = map["maxDf"]! + itemInfo.maxDf;
        map["minMf"] = map["minMf"]! + itemInfo.minMf;
        map["maxMf"] = map["maxMf"]! + itemInfo.maxMf;
      }

      if (sprite.monster.weapon != null) {
        ItemInfo itemInfo = sprite.monster.weapon!;
        map["maxHp"] = map["maxHp"]! + itemInfo.hp;
        map["maxMp"] = map["maxMp"]! + itemInfo.mp;
        map["minAt"] = map["minAt"]! + itemInfo.minAt;
        map["maxAt"] = map["maxAt"]! + itemInfo.maxAt;
        map["minMt"] = map["minMt"]! + itemInfo.minMt;
        map["maxMt"] = map["maxMt"]! + itemInfo.maxMt;
        map["minDf"] = map["minDf"]! + itemInfo.minDf;
        map["maxDf"] = map["maxDf"]! + itemInfo.maxDf;
        map["minMf"] = map["minMf"]! + itemInfo.minMf;
        map["maxMf"] = map["maxMf"]! + itemInfo.maxMf;
      }
    }
    return map;


  }
}
