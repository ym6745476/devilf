import 'package:devilf_engine/core/df_living.dart';
import 'package:example/item/item_info.dart';

/// 玩家类
class PlayerInfo extends DFLiving {
  /// 衣服
  ItemInfo? clothes;

  /// 武器
  ItemInfo? weapon;

  /// 性别
  int gender;

  /// 职业
  int job;

  /// 等级
  int level;

  /// 战斗力
  int battle;

  /// 生命值
  int hp;

  /// 最大生命值
  int maxHp;

  /// 魔法值
  int mp;

  /// 最大魔法值
  int maxMp;

  /// 经验值
  int exp;

  /// 最小攻击力
  int minAt;

  /// 最大攻击力
  int maxAt;

  /// 最小魔法攻击力
  int minMt;

  /// 最大魔法攻击力
  int maxMt;

  /// 最小物理防御
  int minDf;

  /// 最大物理防御
  int maxDf;

  /// 最小魔法防御
  int minMf;

  /// 最大魔法防御
  int maxMf;

  /// 移动速度
  double moveSpeed;

  /// 警戒范围
  double vision;

  /// 复活间隔
  double rebornTime;

  /// 跑音效
  List<String> runAudio;

  /// 攻击音效
  List<String> attackAudio;

  /// 受伤音效
  List<String> hurtAudio;

  /// 死亡音效
  List<String> deathAudio;

  /// 采集音效
  List<String> collectAudio;

  /// 模板
  String template;

  /// 创建玩家
  PlayerInfo(
    id,
    name, {
    this.clothes,
    this.weapon,
    this.gender = 1,
    this.job = 1,
    this.level = 1,
    this.battle = 1,
    this.hp = 100,
    this.maxHp = 100,
    this.mp = 100,
    this.maxMp = 100,
    this.exp = 1000,
    this.minAt = 0,
    this.maxAt = 5,
    this.minMt = 0,
    this.maxMt = 5,
    this.minDf = 0,
    this.maxDf = 5,
    this.minMf = 0,
    this.maxMf = 5,
    this.moveSpeed = 2,
    this.vision = 800,
    this.rebornTime = 5000,
    this.runAudio = const [],
    this.attackAudio = const [],
    this.hurtAudio = const [],
    this.deathAudio = const [],
    this.collectAudio = const [],
    this.template = "",
  }) : super(id, name) {
    this.hp = this.maxHp;
    this.mp = this.maxMp;
  }

}

/// 职业类型
class JobType {
  static const int NONE = 0;
  static const int ZANSHI = 1;
  static const int FASHI = 2;
  static const int DAOSHI = 3;

  static const List<String> NAMES = ["无","战士","法师","道士"];

  /// 职业名称
  static String getName(int type) {
    return NAMES[type];
  }
}