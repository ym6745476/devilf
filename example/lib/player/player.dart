import 'package:example/base/living.dart';

/// 玩家类
class Player extends Living {

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
  double vision = 800;

  /// 创建玩家
  Player(name) : super(name);
}
