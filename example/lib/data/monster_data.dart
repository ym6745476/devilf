import 'package:example/data/player_data.dart';
import 'package:example/monster/monster_info.dart';

import 'effect_data.dart';

/// 怪物数据
class MonsterData {
  static String clothesPath = "assets/images/monster/";
  static String weaponPath = "assets/images/weapon/";

  /// 默认前缀 assets/audio/
  static String audioPath = "monster/";

  /// 基本配置
  static Map<String, MonsterInfo> items = {
    "1001": MonsterInfo(
      1001,
      "蜘蛛",
      clothes: "spider",
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
      clothes: "snake",
      moveSpeed: 0.4,
      maxAt: 40,
      attackAudio: ["snake/attack_1", "snake/attack_2", "snake/attack_3"],
      hurtAudio: ["snake/hurt"],
      deathAudio: ["snake/death_1", "snake/death_2", "snake/death_3"],
      effects: [EffectData.items["4001"]!],
    ),
    "3001": MonsterInfo(
      3001,
      "妖精",
      clothes: "woman_01",
      weapon: "2001",
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
  static MonsterInfo newMonster(String id) {
    MonsterInfo template = items[id]!;
    return MonsterInfo(
      template.id,
      template.name,
      clothes: getClothes(template.clothes!),
      weapon: template.weapon != null ? getWeapon(template.weapon!) : template.weapon,
      moveSpeed: template.moveSpeed,
      maxAt: template.maxAt,
      runAudio: List.generate(template.runAudio.length, (index) => getAudio(template.runAudio[index])),
      attackAudio: List.generate(template.attackAudio.length, (index) => getAudio(template.attackAudio[index])),
      hurtAudio: List.generate(template.hurtAudio.length, (index) => getAudio(template.hurtAudio[index])),
      deathAudio: List.generate(template.deathAudio.length, (index) => getAudio(template.deathAudio[index])),
      effects: template.effects,
    );
  }

  static String getClothes(String name) {
    if (name.contains("man_") || name.contains("woman_")) {
      return PlayerData.clothesPath + name + ".json";
    }
    return clothesPath + name + ".json";
  }

  static String getWeapon(String name) {
    return weaponPath + name + ".json";
  }

  static String getAudio(String name) {
    if (name.contains("player")) {
      return name + ".mp3";
    }
    return audioPath + name + ".mp3";
  }
}