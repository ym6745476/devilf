import 'package:example/data/item_data.dart';
import 'package:example/player/player_info.dart';

/// 玩家数据
class PlayerData {
  /// 默认前缀 assets/audio/
  static String audioPath = "player/";

  /// 数据
  static List<PlayerInfo> items = [
    PlayerInfo(0, "玩家男",
        template: "1100",
        clothes: ItemData.newItemInfo(0,template:"1100"),
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_man"],
        hurtAudio: ["hurt_man"],
        deathAudio: ["death_man"],
        collectAudio: ["collect"]),
    PlayerInfo(0, "玩家女",
        template: "1200",
        clothes: ItemData.newItemInfo(0,template: "1200"),
        runAudio: ["run_1", "run_2", "run_3", "run_4", "run_5", "run_6"],
        attackAudio: ["attack_woman"],
        hurtAudio: ["hurt_woman"],
        deathAudio: ["death_woman"],
        collectAudio: ["collect"]),
  ];

  /// 创建玩家
  static PlayerInfo newPlayer(int id,String name,{required String template}) {
    PlayerInfo? playerInfo;
    for (PlayerInfo item in items) {
      if (item.template == template) {
        playerInfo = PlayerInfo(
          id,
          name,
          clothes: item.clothes,
          runAudio: List.generate(item.runAudio.length, (index) => getAudio(item.runAudio[index])),
          attackAudio: List.generate(item.attackAudio.length, (index) => getAudio(item.attackAudio[index])),
          hurtAudio: List.generate(item.hurtAudio.length, (index) => getAudio(item.hurtAudio[index])),
          deathAudio: List.generate(item.deathAudio.length, (index) => getAudio(item.deathAudio[index])),
          collectAudio: List.generate(item.collectAudio.length, (index) => getAudio(item.collectAudio[index])),
          template: template,
        );
      }
    }
    if(playerInfo == null){
      print("获取玩家错误，检查模板ID是否正确: " + template.toString());
    }
    return playerInfo!;
  }

  static String getAudio(String name) {
    return audioPath + name + ".mp3";
  }
}
