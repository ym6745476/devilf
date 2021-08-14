import 'package:example/monster/monster_info.dart';
import 'package:example/player/player_info.dart';

/// 玩家数据
class PlayerData {
  static String clothesPath = "assets/images/player/";
  static String weaponPath = "assets/images/weapon/";

  /// 默认前缀 assets/audio/
  static String audioPath = "player/";

  /// 基本配置
  static Map<String, PlayerInfo> items = {
    "1001": PlayerInfo(1001, "玩家男",
        clothes: "man_01",
        moveSpeed: 0.4,
        maxAt: 100,
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_man"],
        hurtAudio: ["hurt_man"],
        deathAudio: ["death_man"],
        collectAudio: ["collect"]),
    "2001": PlayerInfo(2001, "玩家女",
        clothes: "woman_01",
        moveSpeed: 0.4,
        maxAt: 100,
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_woman"],
        hurtAudio: ["hurt_woman"],
        deathAudio: ["death_woman"],
        collectAudio: ["collect"]),
  };

  /// 创建玩家
  static PlayerInfo newPlayer(String id) {
    PlayerInfo template = items[id]!;
    return PlayerInfo(
      template.id,
      template.name,
      clothes: getClothes(template.clothes!),
      moveSpeed: template.moveSpeed,
      maxAt: template.maxAt,
      runAudio: List.generate(template.runAudio.length, (index) => getAudio(template.runAudio[index])),
      attackAudio: List.generate(template.attackAudio.length, (index) => getAudio(template.attackAudio[index])),
      hurtAudio: List.generate(template.hurtAudio.length, (index) => getAudio(template.hurtAudio[index])),
      deathAudio: List.generate(template.deathAudio.length, (index) => getAudio(template.deathAudio[index])),
      collectAudio: List.generate(template.collectAudio.length, (index) => getAudio(template.collectAudio[index])),
    );
  }

  static String getClothes(String name) {
    return clothesPath + name + ".json";
  }

  static String getWeapon(String name) {
    return weaponPath + name + ".json";
  }

  static String getAudio(String name) {
    return audioPath + name + ".mp3";
  }
}
