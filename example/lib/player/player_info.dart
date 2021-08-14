import 'package:devilf_engine/core/df_living.dart';

/// 玩家类
class PlayerInfo extends DFLiving {
  /// 衣服
  String? clothes;

  /// 武器
  String? weapon;

  /// 性别
  int gender;

  /// 生命值
  double hp;

  /// 最大生命值
  double maxHp;

  /// 魔法值
  double mp;

  /// 最大魔法值
  double maxMp;

  /// 最小攻击力
  double minAt;

  /// 最大攻击力
  double maxAt;

  /// 最小魔法攻击力
  double minMt;

  /// 最大魔法攻击力
  double maxMt;

  /// 物理防御
  double df;

  /// 魔法防御
  double mf;

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

  /// 创建玩家
  PlayerInfo(
    id,
    name, {
    this.clothes,
    this.weapon,
    this.gender = 1,
    this.hp = 100,
    this.maxHp = 100,
    this.mp = 100,
    this.maxMp = 100,
    this.minAt = 5,
    this.maxAt = 10,
    this.minMt = 5,
    this.maxMt = 10,
    this.df = 5,
    this.mf = 5,
    this.moveSpeed = 1,
    this.vision = 800,
    this.rebornTime = 5000,
    this.runAudio = const [],
    this.attackAudio = const [],
    this.hurtAudio = const [],
    this.deathAudio = const [],
    this.collectAudio = const []
  }) : super(id, name) {
    this.hp = this.maxHp;
    this.mp = this.maxMp;
  }
}
