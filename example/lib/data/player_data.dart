import 'package:example/data/item_data.dart';
import 'package:example/player/player_info.dart';

/// 玩家数据
class PlayerData {
  /// 默认前缀 assets/audio/
  static String audioPath = "player/";

  /// 数据
  static Map<String, PlayerInfo> templates = {
    "1": PlayerInfo(1001, "玩家男",
        clothes: ItemData.newItemInfo("1100"),
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_man"],
        hurtAudio: ["hurt_man"],
        deathAudio: ["death_man"],
        collectAudio: ["collect"]),
    "2": PlayerInfo(2001, "玩家女",
        clothes: ItemData.newItemInfo("1200"),
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_woman"],
        hurtAudio: ["hurt_woman"],
        deathAudio: ["death_woman"],
        collectAudio: ["collect"]),
  };

  /// 创建玩家
  static PlayerInfo newPlayer(String template) {
    PlayerInfo playerInfo = templates[template]!;
    return PlayerInfo(
      playerInfo.id,
      playerInfo.name,
      clothes: playerInfo.clothes,
      runAudio: List.generate(playerInfo.runAudio.length, (index) => getAudio(playerInfo.runAudio[index])),
      attackAudio: List.generate(playerInfo.attackAudio.length, (index) => getAudio(playerInfo.attackAudio[index])),
      hurtAudio: List.generate(playerInfo.hurtAudio.length, (index) => getAudio(playerInfo.hurtAudio[index])),
      deathAudio: List.generate(playerInfo.deathAudio.length, (index) => getAudio(playerInfo.deathAudio[index])),
      collectAudio: List.generate(playerInfo.collectAudio.length, (index) => getAudio(playerInfo.collectAudio[index])),
      template: template,
    );
  }

  static String getAudio(String name) {
    return audioPath + name + ".mp3";
  }
}
