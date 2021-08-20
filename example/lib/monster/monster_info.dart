import 'package:devilf_engine/core/df_living.dart';
import 'package:example/effect/effect_info.dart';
import 'package:example/model/item_info.dart';

/// 怪物类
class MonsterInfo extends DFLiving {
  /// 衣服
  ItemInfo? clothes;

  /// 武器
  ItemInfo? weapon;

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

  /// 领悟技能
  List<EffectInfo> effects;

  /// 模板
  String template;

  /// 创建怪物
  MonsterInfo(id,name,{
    this.clothes,
    this.weapon,
    this.level = 1,
    this.battle = 1,
    this.hp = 100,
    this.maxHp = 100,
    this.mp = 100,
    this.maxMp = 100,
    this.exp = 10,
    this.minAt = 0,
    this.maxAt = 5,
    this.minMt = 0,
    this.maxMt = 5,
    this.minDf = 0,
    this.maxDf = 5,
    this.minMf = 0,
    this.maxMf = 5,
    this.moveSpeed = 1,
    this.vision = 200,
    this.rebornTime = 5000,
    this.runAudio = const [],
    this.attackAudio = const [],
    this.hurtAudio = const [],
    this.deathAudio = const [],
    this.effects = const [],
    this.template = "",
  }) : super(id, name){
    this.hp = this.maxHp;
    this.mp = this.maxMp;
  }

}
