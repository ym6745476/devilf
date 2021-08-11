import 'package:devilf_engine/core/df_living.dart';

/// 怪物类
class MonsterInfo extends DFLiving {
  /// 衣服
  String clothes = "";

  /// 武器
  String weapon = "";

  /// 魔法值
  double mp = 100;

  /// 最大魔法值
  double maxMp = 100;

  /// 最小攻击力
  double minAt = 5;

  /// 最大攻击力
  double maxAt = 10;

  /// 最小魔法攻击力
  double minMt = 5;

  /// 最大魔法攻击力
  double maxMt = 10;

  /// 物理防御
  double df = 5;

  /// 魔法防御
  double mf = 5;

  /// 警戒范围
  double vision = 200;

  /// 复活间隔
  double rebornTime = 5000;

  /// 创建怪物
  MonsterInfo(name) : super(name);
}
