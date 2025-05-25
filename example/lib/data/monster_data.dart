import 'package:example/item/item_info.dart';
import 'package:example/monster/monster_info.dart';

import 'effect_data.dart';
import 'item_data.dart';

/// 怪物数据
class MonsterData {
  static String clothesPath = "assets/images/monster/";

  /// 默认前缀 assets/audio/
  static String audioPath = "monster/";

  /// 数据
  static List<MonsterInfo> items = [
    MonsterInfo(
      0,
      "蜘蛛",
      template: "spider",
      clothes: ItemInfo(0, texture: getClothes("spider")),
      moveSpeed: 0.4,
      maxAt: 40,
      attackAudio: ["spider/attack_1", "spider/attack_2", "spider/attack_3"],
      hurtAudio: ["spider/hurt"],
      deathAudio: ["spider/death_1", "spider/death_2"],
      effects: [EffectData.newEffectInfo(template: "4001")],
    ),
    MonsterInfo(
      0,
      "蛇",
      template: "snake",
      clothes: ItemInfo(0, texture: getClothes("snake")),
      moveSpeed: 0.4,
      maxAt: 40,
      attackAudio: ["snake/attack_1", "snake/attack_2", "snake/attack_3"],
      hurtAudio: ["snake/hurt"],
      deathAudio: ["snake/death_1", "snake/death_2", "snake/death_3"],
      effects: [EffectData.newEffectInfo(template: "4001")],
    ),
    MonsterInfo(
      0,
      "妖精",
      template: "1200",
      clothes: ItemData.newItemInfo(0, template:"1200"),
      weapon: ItemData.newItemInfo(0, template:"2001"),
      moveSpeed: 1.2,
      maxAt: 40,
      runAudio: ["player/run_1", "player/run_2", "player/run_3", "player/run_4", "player/run_5", "player/run_6"],
      attackAudio: ["player/attack_woman"],
      hurtAudio: ["player/hurt_woman"],
      deathAudio: ["player/death_woman"],
      effects: [EffectData.newEffectInfo(template: "2001")],
    )
  ];

  /// 创建怪物
  static MonsterInfo newMonster(int id, {required String template}) {
    MonsterInfo? monsterInfo;

    for (MonsterInfo item in items) {
      if (item.template == template) {
        monsterInfo = MonsterInfo(
          id,
          item.name,
          clothes: item.clothes,
          weapon: item.weapon,
          moveSpeed: item.moveSpeed,
          maxAt: item.maxAt,
          runAudio: List.generate(item.runAudio.length, (index) => getAudio(item.runAudio[index])),
          attackAudio: List.generate(item.attackAudio.length, (index) => getAudio(item.attackAudio[index])),
          hurtAudio: List.generate(item.hurtAudio.length, (index) => getAudio(item.hurtAudio[index])),
          deathAudio: List.generate(item.deathAudio.length, (index) => getAudio(item.deathAudio[index])),
          effects: item.effects,
          template: template,
        );
      }
    }
    if(monsterInfo == null){
      print("获取怪物错误，检查模板ID是否正确: " + template.toString());
    }
    return monsterInfo!;
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
