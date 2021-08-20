import 'package:example/data/player_data.dart';
import 'package:example/model/item_info.dart';
import 'package:example/monster/monster_info.dart';

import 'effect_data.dart';
import 'item_data.dart';

/// 怪物数据
class MonsterData {
  static String clothesPath = "assets/images/monster/";

  /// 默认前缀 assets/audio/
  static String audioPath = "monster/";

  /// 数据
  static Map<String, MonsterInfo> templates = {
    "1001": MonsterInfo(
      1001,
      "蜘蛛",
      clothes: ItemInfo(1,texture: getClothes("spider")),
      moveSpeed: 0.4,
      maxAt: 40,
      attackAudio: ["spider/attack_1", "spider/attack_2", "spider/attack_3"],
      hurtAudio: ["spider/hurt"],
      deathAudio: ["spider/death_1", "spider/death_2"],
      effects: [EffectData.items["4001"]!],
    ),
    "1002": MonsterInfo(
      1002,
      "蛇",
      clothes: ItemInfo(1,texture: getClothes("snake")),
      moveSpeed: 0.4,
      maxAt: 40,
      attackAudio: ["snake/attack_1", "snake/attack_2", "snake/attack_3"],
      hurtAudio: ["snake/hurt"],
      deathAudio: ["snake/death_1", "snake/death_2", "snake/death_3"],
      effects: [EffectData.items["4001"]!],
    ),
    "2001": MonsterInfo(
      2001,
      "妖精",
      clothes: ItemData.newItemInfo("1200"),
      weapon: ItemData.newItemInfo("2001"),
      moveSpeed: 1.2,
      maxAt: 40,
      runAudio: ["player/run_1", "player/run_2", "player/run_3", "player/run_4", "player/run_5", "player/run_6"],
      attackAudio: ["player/attack_woman"],
      hurtAudio: ["player/hurt_woman"],
      deathAudio: ["player/death_woman"],
      effects: [EffectData.items["2001"]!],
    )
  };

  /// 创建怪物
  static MonsterInfo newMonster(String template) {
    MonsterInfo monsterInfo = templates[template]!;
    return MonsterInfo(
      monsterInfo.id,
      monsterInfo.name,
      clothes: monsterInfo.clothes,
      weapon: monsterInfo.weapon,
      moveSpeed: monsterInfo.moveSpeed,
      maxAt: monsterInfo.maxAt,
      runAudio: List.generate(monsterInfo.runAudio.length, (index) => getAudio(monsterInfo.runAudio[index])),
      attackAudio: List.generate(monsterInfo.attackAudio.length, (index) => getAudio(monsterInfo.attackAudio[index])),
      hurtAudio: List.generate(monsterInfo.hurtAudio.length, (index) => getAudio(monsterInfo.hurtAudio[index])),
      deathAudio: List.generate(monsterInfo.deathAudio.length, (index) => getAudio(monsterInfo.deathAudio[index])),
      effects: monsterInfo.effects,
      template: template,
    );
  }

  static String getClothes(String name) {
    return clothesPath + name + ".json";
  }

  static String getAudio(String name) {
    if (name.contains("player")) {
      return name + ".mp3";
    }
    return audioPath + name + ".mp3";
  }
}
